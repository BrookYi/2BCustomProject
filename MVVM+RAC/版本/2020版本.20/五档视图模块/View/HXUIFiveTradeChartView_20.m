//
//  HXUIFiveTradeChartView_20.m
//  MVVM+RAC
//
//  Created by Brook on 2020/11/6.
//

#import "HXUIFiveTradeChartView_20.h"
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

@interface HXUIFiveTradeChartView_20 ()
@property(nonatomic,strong)UILabel *label;
@end

@implementation HXUIFiveTradeChartView_20

- (instancetype)init {
    self = [super init];
    if (self) {
        [self settingUI];
        [self viewModelInit];
        [self bindViewModel];
    }
    return self;
}

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
    RAC(self.label,text) = RACObserve(self.viewModel.stockModel, code);//单向绑定标题
}

- (void)settingUI {
    //视图这里职能用约束
    self.backgroundColor = UIColor.grayColor;
    self.label = [[UILabel alloc] init];
    self.label.text = @"300033";
    self.label.numberOfLines = -1;
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
