//
//  HXNSStockModel.h
//  MVVM+RAC
//
//  Created by Brook on 2020/11/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 股票信息
@interface HXNSStockModel : NSObject
@property (copy, nonatomic) NSString *code;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *marketId;

@end
/// 营业部请求应答类
@interface HXNSStockListResponse : NSObject
@property (assign, nonatomic) NSUInteger code;
@property (copy, nonatomic) NSString *msg;
@property (copy, nonatomic) NSArray<HXNSStockModel *> *data;

@end
NS_ASSUME_NONNULL_END
