//
//  HXNSTradeViewModel.m
//  MVVM+RAC
//
//  Created by Brook on 2020/11/8.
//

#import "HXNSTradeViewModel.h"
//M
#import "HXNSStockModel.h"

@implementation HXNSTradeViewModel
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
    self.title = @"交易";
}

#pragma mark - property
- (HXNSStockModel *)stockModel {
    if (!_stockModel) {
        _stockModel = [[HXNSStockModel alloc] init];
    }
    return _stockModel;
}

@end
