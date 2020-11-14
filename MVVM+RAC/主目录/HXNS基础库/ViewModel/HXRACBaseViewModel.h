//
//  HXRACBaseViewModel.h
//  MVVM+RAC
//
//  Created by Brook on 2020/11/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class RACSubject;

@interface HXRACBaseViewModel : NSObject
///视图名称
@property (copy, nonatomic) NSString *title;
///是否在运行信号
@property (strong, nonatomic) RACSubject *executing;
///错误信息信号
@property (strong, nonatomic) RACSubject *errors;

@end

NS_ASSUME_NONNULL_END
