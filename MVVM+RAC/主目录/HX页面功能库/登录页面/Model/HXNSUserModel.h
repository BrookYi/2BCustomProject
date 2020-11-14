//
//  HXNSUserModel.h
//  MVVM+RAC
//
//  Created by Brook on 2020/11/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 用户信息
@interface HXNSUserModel : NSObject
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *password;
@property (assign, nonatomic, getter=isLogined) BOOL logined;

@end

NS_ASSUME_NONNULL_END
