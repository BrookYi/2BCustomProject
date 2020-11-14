//
//  HXUICustomProtocol.h
//  MVVM+RAC
//
//  Created by Brook on 2020/11/8.
//

#ifndef HXUICustomProtocol_h
#define HXUICustomProtocol_h

#import <UIKit/UIKit.h>
#import "HXRACBaseViewModel.h"

/// 定制视图(配置页面如不做视图功能不需要实现)如果要做配置化需要实现协议
@protocol HXUICustomProtocol <NSObject>

/// 视图
- (UIView *)customView;

/// 视图对应的VM
- (HXRACBaseViewModel *)customViewModel;

@end

#endif /* HXUICustomProtocol_h */
