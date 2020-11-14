//
//  HXUILoginViewController.m
//  MVVM+RAC
//
//  Created by Brook on 2020/11/1.
//

#import "HXUILoginViewController.h"
//视图引入
#import <Masonry/Masonry.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <QMUIKit/QMUIPopupMenuView.h>
#import <QMUIKit/QMUICommonDefines.h>
#import "HXUICustomProtocol.h"

//非视图
//VM
#import "HXNSLoginViewModel.h"
//M
#import "HXNSYybModel.h"
#import "HXNSUserModel.h"
//框架
#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/RACEXTScope.h>
//路由库
#import <JLRoutes/JLRoutes.h>

@interface HXUILoginViewController ()<HXUICustomProtocol>
@property (strong, nonatomic) HXNSLoginViewModel *viewModel;

@property(strong,nonatomic) UIButton *yybSelectButton;
@property (strong, nonatomic) UITextField *userNameT;
@property (strong, nonatomic) UITextField *passWordT;
@property (strong, nonatomic) UIButton *loginB;
@end

@implementation HXUILoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingUI];
    [self viewModelInit];
    [self bindViewModel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel.fetchYybInfoListCommand execute:nil];
}

#pragma mark - 固定的方法暂时不放基类，不过早优化
- (void)viewModelInit {
    _viewModel = [[HXNSLoginViewModel alloc] init];
}

- (void)bindViewModel {
    RAC(self.navigationItem,title) = RACObserve(self.viewModel, title);//单向绑定标题
    RACChannelTo(self.userNameT,text) = RACChannelTo(self.viewModel.userModel,username);//双向绑定用户名
    RACChannelTo(self.passWordT,text) = RACChannelTo(self.viewModel.userModel,password);
    
    //单向绑定，营业部按钮是否可用依赖yybList的数量，由于类型不一致，转换一下。
    RAC(self.yybSelectButton,enabled) = [RACObserve(self.viewModel, yybList) map:^id _Nullable(id  _Nullable value) {
        NSArray *dataArray = value;
        if (dataArray && dataArray.count > 0) {
            return @YES;
        }
        return @NO;
    }];
    
    self.loginB.rac_command = self.viewModel.loginCommand;//处理事件
    @weakify(self);
    ///焦点处理：当直接点击登录，输入框的数据未更新到VM的数据中，需要先去掉焦点
    [[self.loginB rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.userNameT resignFirstResponder];
        [self.passWordT resignFirstResponder];
    }];
    [[self.yybSelectButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        //营业部弹框供选择
        QMUIPopupMenuView *menuView = [[QMUIPopupMenuView alloc] init];
        menuView.automaticallyHidesWhenUserTap = YES;
        menuView.preferLayoutDirection = QMUIPopupContainerViewLayoutDirectionBelow;
        menuView.maximumWidth = 124;
        menuView.safetyMarginsOfSuperview = UIEdgeInsetsSetRight(menuView.safetyMarginsOfSuperview, 6);
        //数据类型转换
        menuView.items = [[self.viewModel.yybList.rac_sequence map:^id _Nullable(HXNSYybModel * _Nullable value) {
            return [QMUIPopupMenuButtonItem itemWithImage:nil title:value.name handler:^(QMUIPopupMenuButtonItem *aItem) {
                [self.yybSelectButton setTitle:aItem.title forState:UIControlStateNormal];
                [aItem.menuView hideWithAnimated:YES];
            }];
        }] array];
        menuView.sourceView = self.yybSelectButton;
        [menuView showWithAnimated:YES];
    }];
    
    //页面请求监控
    [self.viewModel.executing subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        BOOL end = [x boolValue];
        if (end) {
            if (![MBProgressHUD HUDForView:self.view]) {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            }
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
        }
    }];
    //登录按钮点击后
    [[self.viewModel.loginCommand.executionSignals switchToLatest] subscribeNext:^(id  _Nullable x) {
        RACTupleUnpack(id task,NSDictionary *responce) = x;
        //监听登录点击后信号结果
        if ([[responce objectForKey:@"code"] isEqualToString:@"1"]) {
            NSURL *editPost = [NSURL URLWithString:@"hxRouteScheme://trade"];
            [JLRoutes routeURL:editPost];
        }
        NSLog(@"task:%@-responce:%@",[task description],[responce debugDescription]);
    }];
}

- (void)settingUI {
    self.view.backgroundColor = UIColor.whiteColor;
    //营业部
    _yybSelectButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_yybSelectButton setTitle:@"营业部选择" forState:UIControlStateNormal];
    [self.view addSubview:_yybSelectButton];
    
    //创建界面元素
    UITextField *userNameTextField = [[UITextField alloc] init];
    userNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    userNameTextField.placeholder = @"请输入用户名…";
    [userNameTextField becomeFirstResponder];
    [self.view addSubview:userNameTextField];
    self.userNameT = userNameTextField;
    
    UITextField *passwordTextField = [[UITextField alloc] init];
    passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    passwordTextField.placeholder = @"请输入密码…";
    passwordTextField.secureTextEntry =  YES;
    [self.view addSubview:passwordTextField];
    self.passWordT = passwordTextField;
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [loginButton setTitle:@"2016版本-登录" forState:UIControlStateNormal];
    [self.view addSubview:loginButton];
    self.loginB = loginButton;
    //布局界面元素
    [_yybSelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@40);
    }];
    [userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.top.equalTo(self.yybSelectButton.mas_bottom).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@(30));
    }];
    [passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.top.equalTo(self.userNameT.mas_bottom).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@30);
    }];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordTextField.mas_left).offset(44);
        make.top.equalTo(passwordTextField.mas_bottom).offset(10);
        make.right.equalTo(passwordTextField.mas_right).offset(-44);
        make.height.equalTo(@(30));
    }];
}

- (UIView *)customView {
    return self.view;
}

- (HXRACBaseViewModel *)customViewModel {
    return _viewModel;
}
@end
