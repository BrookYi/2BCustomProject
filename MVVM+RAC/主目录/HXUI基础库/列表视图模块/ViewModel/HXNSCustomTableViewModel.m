//
//  HXUICustomViewModel.m
//  MVVM+RAC
//
//  Created by Brook on 2020/11/10.
//

#import "HXNSCustomTableViewModel.h"
//M
#import "HXNSStockModel.h"
//工具类
#import <YYModel/YYModel.h>

//框架
#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/RACEXTScope.h>
#import <ReactiveAFNetworking/ReactiveAFNetworking.h>
@interface HXNSCustomTableViewModel ()


@end

@implementation HXNSCustomTableViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        [self dataInit];
        [self commandInit];
        [self subscribeInit];
    }
    return self;
}

/// 不使用init开头命名，以防和系统的冲突。
- (void)dataInit {
    _seletedIndexPathSubject = [RACSubject subject];
}

/// 命令初始化
- (void)commandInit {
    _fetchInfoListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[AFHTTPSessionManager manager] rac_GET:@"file:///Users/brook/Desktop/2B%E6%96%B9%E6%A1%88/mystocksResult.json" parameters:@{}];;
    }];
}

/// 监听
- (void)subscribeInit {
    @weakify(self);
    [[_fetchInfoListCommand.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        RACTupleUnpack(id task,NSDictionary *responce) = x;
        HXNSStockListResponse *resp = [HXNSStockListResponse yy_modelWithDictionary:responce];
        if (resp.code == 1) {
            self.data = resp.data;
        }
        NSLog(@"task:%@-responce:%@",[task description],[responce debugDescription]);
    }];

    //把所有会引发的集中起来,对外保持一个信号
    [[RACSignal merge:@[_fetchInfoListCommand.errors]] subscribe:self.errors];
    [[RACSignal merge:@[_fetchInfoListCommand.executing]] subscribe:self.executing];
}
@end
