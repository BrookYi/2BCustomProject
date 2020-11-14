//
//  HXRACBaseViewModel.m
//  MVVM+RAC
//
//  Created by Brook on 2020/11/7.
//

#import "HXRACBaseViewModel.h"
//框架
#import <ReactiveObjC/ReactiveObjC.h>

@implementation HXRACBaseViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _errors = [RACSubject subject];
        _executing = [RACSubject subject];
    }
    return self;
}
@end
