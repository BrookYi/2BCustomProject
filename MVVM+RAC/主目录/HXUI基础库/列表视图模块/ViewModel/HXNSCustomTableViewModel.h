//
//  HXUICustomViewModel.h
//  MVVM+RAC
//
//  Created by Brook on 2020/11/10.
//

#import "HXRACBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN
@class HXNSStockModel,RACCommand;

@interface HXNSCustomTableViewModel : HXRACBaseViewModel
@property (strong, nonatomic) NSArray<HXNSStockModel *> *data;
@property (strong, nonatomic) RACCommand *fetchInfoListCommand;
///被选中行
@property (strong, nonatomic) RACSubject *seletedIndexPathSubject;
@end

NS_ASSUME_NONNULL_END
