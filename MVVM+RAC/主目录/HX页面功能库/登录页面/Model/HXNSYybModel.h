//
//  HXNSYybModel.h
//  MVVM+RAC
//
//  Created by Brook on 2020/11/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 营业部信息
@interface HXNSYybModel : NSObject
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *qsId;

@end

/// 营业部请求应答类
@interface HXNSYybResponse : NSObject
@property (assign, nonatomic) NSUInteger code;
@property (copy, nonatomic) NSString *msg;
@property (copy, nonatomic) NSArray<HXNSYybModel *> *data;

@end
NS_ASSUME_NONNULL_END
