//
//  HXNSViewConfigManager.h
//  MVVM+RAC
//
//  Created by Brook on 2020/11/7.
//

#import <Foundation/Foundation.h>
#import "HXNSPageIDLocalDef.h"

NS_ASSUME_NONNULL_BEGIN

#define HXNSViewRealName(alias) [[HXNSViewConfigManager defalut] realClassName:alias];

@interface HXNSViewConfigManager : NSObject

/// 单例
+ (instancetype)defalut;

/// 真正要初始化的视图类名
/// @param name 通用视图标识
- (NSString *)realClassName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
