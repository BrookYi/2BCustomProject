//
//  HXNSYybModel.m
//  MVVM+RAC
//
//  Created by Brook on 2020/11/1.
//

#import "HXNSYybModel.h"
//非视图
#import <YYModel/YYModel.h>

@implementation HXNSYybModel

@end

@implementation HXNSYybResponse

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"data":HXNSYybModel.class};
}

@end
