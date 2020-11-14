//
//  HXNSStockModel.m
//  MVVM+RAC
//
//  Created by Brook on 2020/11/8.
//

#import "HXNSStockModel.h"

@implementation HXNSStockModel

@end
@implementation HXNSStockListResponse

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"data":HXNSStockModel.class};
}

@end
