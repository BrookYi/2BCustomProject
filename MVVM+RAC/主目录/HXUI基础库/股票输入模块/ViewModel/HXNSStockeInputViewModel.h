//
//  HXNSStockeInputViewModel.h
//  MVVM+RAC
//
//  Created by Brook on 2020/11/11.
//

#import "HXRACBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HXNSStockeInputViewModel : HXRACBaseViewModel
@property (copy, nonatomic) NSString *code;
@property (copy, nonatomic) NSString *price;

@end

NS_ASSUME_NONNULL_END
