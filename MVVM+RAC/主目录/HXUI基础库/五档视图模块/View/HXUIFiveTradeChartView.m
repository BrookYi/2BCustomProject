//
//  HXUIFiveTradeChartView.m
//  MVVM+RAC
//
//  Created by Brook on 2020/11/6.
//

#import "HXUIFiveTradeChartView.h"
//视图引入
#import <Masonry/Masonry.h>
//非视图
//M
#import "HXNSStockModel.h"
//VM
#import "HXNSFiveTradeChartViewModel.h"
//框架
#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/RACEXTScope.h>

@interface HXUIFiveTradeChartView ()
@property (strong, nonatomic) HXNSFiveTradeChartViewModel *viewModel;
@property(nonatomic,strong)UILabel *label;

@end

@implementation HXUIFiveTradeChartView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self settingUI];
        [self viewModelInit];
        [self bindViewModel];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        NSAssert(1, @"不能在xib上直接使用");
    }
    return self;
}

- (void)viewModelInit {
    _viewModel = [[HXNSFiveTradeChartViewModel alloc] init];
}

- (void)bindViewModel {
    RAC(self.label,text) = [RACObserve(self.viewModel.stockModel, code) map:^id _Nullable(id  _Nullable value) {
        return [NSString stringWithFormat:@"2016版本:%@",value];
    }];//单向绑定标题
}

- (void)settingUI {
    //视图这里职能用约束
    self.label = [[UILabel alloc] init];
    self.label.text = @"000001";
    self.label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
}

//以下会提取到基类
#pragma mark HXUICustomProtocol

- (UIView *)customView {
    return self;
}

- (HXNSFiveTradeChartViewModel *)customViewModel {
    return _viewModel;
}
@end
