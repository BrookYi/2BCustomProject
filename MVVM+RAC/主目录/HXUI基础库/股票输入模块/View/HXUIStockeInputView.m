//
//  HXUIStockeInputView.m
//  MVVM+RAC
//
//  Created by Brook on 2020/11/11.
//

#import "HXUIStockeInputView.h"
//视图引入
#import <Masonry/Masonry.h>
#import "HXUICustomProtocol.h"

//非视图
//M
#import "HXNSStockModel.h"
//VM
#import "HXNSStockeInputViewModel.h"
//框架
#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/RACEXTScope.h>
@interface HXUIStockeInputView ()<HXUICustomProtocol>
@property (strong, nonatomic) HXNSStockeInputViewModel *viewModel;

@property (strong, nonatomic) UITextField *stockField;
@property (strong, nonatomic) UITextField *stockField2;
@end

@implementation HXUIStockeInputView

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
    _viewModel = [[HXNSStockeInputViewModel alloc] init];
}

- (void)bindViewModel {
    RACChannelTo(self.stockField,text) = RACChannelTo(self.viewModel,code);
    RACChannelTo(self.stockField2,text) = RACChannelTo(self.viewModel,price);
}

- (void)settingUI {
    //视图这里只能用约束
    //创建界面元素
    self.stockField = [[UITextField alloc] init];
    self.stockField.borderStyle = UITextBorderStyleRoundedRect;
    self.stockField.placeholder = @"请输入股票";
    
    [self.stockField becomeFirstResponder];
    [self addSubview:self.stockField];
    
    [self.stockField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-10);
        make.height.equalTo(@(30));
    }];
    
    self.stockField2 = [[UITextField alloc] init];
    self.stockField2.borderStyle = UITextBorderStyleRoundedRect;
    self.stockField2.placeholder = @"请输入价格";
    
    [self.stockField2 becomeFirstResponder];
    [self addSubview:self.stockField2];
    [self.stockField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(70);
        make.right.equalTo(self).offset(-10);
        make.height.equalTo(@(30));
    }];
}

//以下会提取到基类
#pragma mark HXUICustomProtocol

- (UIView *)customView {
    return self;
}

- (HXRACBaseViewModel *)customViewModel {
    return _viewModel;
}

@end
