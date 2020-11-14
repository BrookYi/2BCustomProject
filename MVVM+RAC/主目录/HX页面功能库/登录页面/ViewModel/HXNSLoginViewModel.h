//
//  HXNSLoginViewModel.h
//  MVVM+RAC
//
//  Created by Brook on 2020/11/1.
//

#import "HXRACBaseViewModel.h"

@class HXNSUserModel,HXNSYybModel,RACCommand;

NS_ASSUME_NONNULL_BEGIN

/// .h中属性与信号定义，需要谨慎，不能随意删除或弃用。参考系统文件，设置过期宏。
@interface HXNSLoginViewModel : HXRACBaseViewModel
@property (strong, nonatomic) HXNSUserModel *userModel;
@property (strong, nonatomic) NSArray<HXNSYybModel *> *yybList;//营业部数组

@property (strong, nonatomic) RACCommand *loginCommand;
@property (strong, nonatomic) RACCommand *fetchYybInfoListCommand;//营业部获取命令

@end

NS_ASSUME_NONNULL_END
