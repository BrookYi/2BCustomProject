//
//  HXNSFiveTradeChartViewModel.m
//  MVVM+RAC
//
//  Created by Brook on 2020/11/7.
//

#import "HXNSFiveTradeChartViewModel.h"
//M
#import "HXNSStockModel.h"

@implementation HXNSFiveTradeChartViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self dataInit];
//        [self commandInit];
//        [self subscribeInit];
    }
    return self;
}

/// 不使用init开头命名，以防和系统的冲突。
- (void)dataInit {

}

#pragma mark - property
- (HXNSStockModel *)stockModel {
    if (!_stockModel) {
        _stockModel = [[HXNSStockModel alloc] init];
    }
    return _stockModel;
}
@end
