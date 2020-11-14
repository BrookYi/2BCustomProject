//
//  HXUIMiddleConvertView.h
//  MVVM+RAC
//
//  Created by Brook on 2020/11/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HXUICustomProtocol;
/// Xib中使用配置的视图或界面时中转视图。支持配置VC或UIView类名到realViewName。
@interface HXUIMiddleConvertView : UIView<HXUICustomProtocol>

@end

NS_ASSUME_NONNULL_END
