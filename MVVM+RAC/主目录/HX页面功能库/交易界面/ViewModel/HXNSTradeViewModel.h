//
//  HXNSTradeViewModel.h
//  MVVM+RAC
//
//  Created by Brook on 2020/11/8.
//

#import "HXRACBaseViewModel.h"

@class HXNSStockModel;

NS_ASSUME_NONNULL_BEGIN

@interface HXNSTradeViewModel : HXRACBaseViewModel
//考虑点：是放置数据对象还是视图的VM？比如，这里是放置五档图的Vm还是只放置一个股票对象数据即可？选择的依据是什么？
//需要考虑V的变化性，这里放数据对象更合理。
//无法估计V中会包含那种V对应的VM，所以使用数据源对象更合适，不管V中的视图变化如何，绑定的数据源是不变的。
@property (strong, nonatomic) HXNSStockModel *stockModel;//页面中的股票信息

@end

NS_ASSUME_NONNULL_END
