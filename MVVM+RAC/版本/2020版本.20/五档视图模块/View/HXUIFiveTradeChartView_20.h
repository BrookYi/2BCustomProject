//
//  HXUIFiveTradeChartView_20.h
//  MVVM+RAC
//
//  Created by Brook on 2020/11/6.
//

#import <UIKit/UIKit.h>
#import "HXUICustomProtocol.h"
NS_ASSUME_NONNULL_BEGIN
@class HXNSFiveTradeChartViewModel;

@interface HXUIFiveTradeChartView_20 : UIView<HXUICustomProtocol>
@property (strong, nonatomic) HXNSFiveTradeChartViewModel *viewModel;
@end

NS_ASSUME_NONNULL_END
