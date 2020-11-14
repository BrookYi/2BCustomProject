//
//  HXNSViewConfigManager.m
//  MVVM+RAC
//
//  Created by Brook on 2020/11/7.
//

#import "HXNSViewConfigManager.h"

@interface HXNSViewConfigManager ()
@property(nonatomic,strong)NSDictionary *viewConfig;
@property (strong, nonatomic) NSBundle *myBundle;

@end


@implementation HXNSViewConfigManager
- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadConfig];
    }
    return self;
}

+ (instancetype)defalut {
    static HXNSViewConfigManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HXNSViewConfigManager alloc] init];
    });
    return manager;
}

- (NSString *)realClassName:(NSString *)name {
    if (self.viewConfig && self.viewConfig.count > 0 && [self.viewConfig.allKeys containsObject:name]) {
        NSString *realName = [self.viewConfig objectForKey:name];
        if (!realName || realName.length == 0) {
            realName = name;
            NSLog(@"未配置页面名称：%@",name);
        }
        return realName;
    }
    return name;
}

- (NSDictionary *)readPlistFromMainBundle:(NSString *)filename {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    return [infoDict copy];
}

///可能是SDK的情况下，获取自身的bundle
- (NSDictionary *)readPlistFromBBBundleWithFileName:(NSString *)filename {
    if (!_myBundle) {
        _myBundle = [self bundleWithBundleName:@"BBBundle" podName:@"BBMainProject"];
    }
    if (!_myBundle) {
        //非SDK情况
        _myBundle = [NSBundle mainBundle];
    }
    NSString *filePath = [_myBundle pathForResource:filename ofType:@"plist"];
    
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    return [infoDict copy];
}

/**
 获取文件所在name，默认情况下podName和bundlename相同，传一个即可
 
 @param bundleName bundle名字，就是在resource_bundles里面的名字
 @param podName pod的名字
 @return bundle
 */
- (NSBundle *)bundleWithBundleName:(NSString *)bundleName podName:(NSString *)podName{
    if (bundleName == nil && podName == nil) {
        @throw @"bundleName和podName不能同时为空";
    }else if (bundleName == nil ) {
        bundleName = podName;
    }else if (podName == nil) {
        podName = bundleName;
    }
    
    
    if ([bundleName containsString:@".bundle"]) {
        bundleName = [bundleName componentsSeparatedByString:@".bundle"].firstObject;
    }
    //没使用framwork的情况下
    NSURL *associateBundleURL = [[NSBundle mainBundle] URLForResource:bundleName withExtension:@"bundle"];
    //使用framework形式
    if (!associateBundleURL) {
        associateBundleURL = [[NSBundle mainBundle] URLForResource:@"Frameworks" withExtension:nil];
        associateBundleURL = [associateBundleURL URLByAppendingPathComponent:podName];
        associateBundleURL = [associateBundleURL URLByAppendingPathExtension:@"framework"];
        NSBundle *associateBunle = [NSBundle bundleWithURL:associateBundleURL];
        associateBundleURL = [associateBunle URLForResource:bundleName withExtension:@"bundle"];
    }
    
//    NSAssert(associateBundleURL, @"取不到关联bundle");
    //生产环境直接返回空
    return associateBundleURL?[NSBundle bundleWithURL:associateBundleURL]:nil;
}

- (void)loadConfig {
    NSDictionary * infoDict = [self readPlistFromMainBundle:@"Info"];//定制版本信息从主工程info读
    if (infoDict) {
        NSString *versionIdentifier = [infoDict objectForKey:@"VersionIdentifier"];
        NSString *configName = @"NeedReplaceViewsNameConfig";
        //先读默认
        self.viewConfig = [self readPlistFromBBBundleWithFileName:configName];//配置等各个版本信息从自身的bundle中读取
        //再读定制
        if (versionIdentifier && versionIdentifier.length > 0) {
            configName = [NSString stringWithFormat:@"%@_%@",configName,versionIdentifier];
            NSDictionary *dzConfig = [self readPlistFromBBBundleWithFileName:configName];
            if (dzConfig) {
                NSMutableDictionary *viewConfig = [NSMutableDictionary dictionaryWithDictionary:self.viewConfig];
                [viewConfig addEntriesFromDictionary:dzConfig];
                self.viewConfig = [viewConfig copy];
            }
        }
    }
}

@end
