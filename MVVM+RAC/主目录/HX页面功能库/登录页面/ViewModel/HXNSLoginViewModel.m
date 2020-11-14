//
//  HXNSLoginViewModel.m
//  MVVM+RAC
//
//  Created by Brook on 2020/11/1.
//

#import "HXNSLoginViewModel.h"

//非视图
//M
#import "HXNSUserModel.h"
#import "HXNSYybModel.h"
//工具类
#import <YYModel/YYModel.h>

//框架
#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/RACEXTScope.h>
#import <ReactiveAFNetworking/ReactiveAFNetworking.h>

@implementation HXNSLoginViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        [self dataInit];
        [self commandInit];
        [self subscribeInit];
    }
    return self;
}

/// 不使用init开头命名，以防和系统的冲突。
- (void)dataInit {
    self.title = @"登录";
    self.userModel.username = @"1800001248";
}

- (HXNSUserModel *)userModel {
    if (!_userModel) {
        _userModel = [[HXNSUserModel alloc] init];
    }
    return _userModel;
}

/// 命令初始化
- (void)commandInit {
    @weakify(self);
    _loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        //登录账号验证
        NSLog(@"%@-%@",self.userModel.username,self.userModel.password);file:
        return [[AFHTTPSessionManager manager] rac_GET:@"file:///Users/brook/Desktop/2B%E6%96%B9%E6%A1%88/loginResult.json" parameters:@{}];
    }];
    _fetchYybInfoListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[AFHTTPSessionManager manager] rac_GET:@"file:///Users/brook/Desktop/2B%E6%96%B9%E6%A1%88/yybResult.json" parameters:@{}];
    }];
}

/// 监听
- (void)subscribeInit {
    @weakify(self);
    ///考虑点：点击后业务逻辑或跳转逻辑放那？按规则业务逻辑应该放VM，但如果是页面跳转则可能涉及到UI
//    [[_loginCommand.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
//        RACTupleUnpack(id task,NSDictionary *responce) = x;
//        //监听登录点击后信号结果
//        if ([[responce objectForKey:@"code"] isEqualToString:@"1"]) {
//            NSURL *editPost = [NSURL URLWithString:@"hxRouteScheme://login"];
//            [JLRoutes routeURL:editPost];
//        }
//        NSLog(@"task:%@-responce:%@",[task description],[responce debugDescription]);
//    }];
    [[_fetchYybInfoListCommand.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        RACTupleUnpack(id task,NSDictionary *responce) = x;
        HXNSYybResponse *resp = [HXNSYybResponse yy_modelWithDictionary:responce];
        if (resp.code == 1) {
            self.yybList = resp.data;
        }
        NSLog(@"task:%@-responce:%@",[task description],[responce debugDescription]);
    }];

    //把所有会引发的集中起来,对外保持一个信号
    [[RACSignal merge:@[_loginCommand.errors,_fetchYybInfoListCommand.errors]] subscribe:self.errors];
    [[RACSignal merge:@[_loginCommand.executing,_fetchYybInfoListCommand.executing]] subscribe:self.executing];
}
@end
