//
//  HXNSFiveTradeChartViewModel.h
//  MVVM+RAC
//
//  Created by Brook on 2020/11/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class HXNSStockModel;

@interface HXNSFiveTradeChartViewModel : NSObject
@property (strong, nonatomic) HXNSStockModel *stockModel;//五档视图中的股票信息

@end

NS_ASSUME_NONNULL_END
