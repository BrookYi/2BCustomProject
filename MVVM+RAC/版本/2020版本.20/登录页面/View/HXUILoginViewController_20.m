//
//  HXUILoginViewController.m
//  MVVM+RAC
//
//  Created by Brook on 2020/11/1.
//

#import "HXUILoginViewController_20.h"
//视图引入
#import <Masonry/Masonry.h>
#import <MBProgressHUD/MBProgressHUD.h>

//非视图
//M
#import "HXNSUserModel.h"
//VM
#import "HXNSLoginViewModel.h"
//框架
#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/RACEXTScope.h>
//路由库
#import <JLRoutes/JLRoutes.h>


@interface HXUILoginViewController_20 ()
@property (strong, nonatomic) HXNSLoginViewModel *viewModel;
@property (strong, nonatomic) UITextField *userNameT;
@property (strong, nonatomic) UITextField *passWordT;
@property (strong, nonatomic) UIButton *loginB;
@end

@implementation HXUILoginViewController_20
- (void)viewDidLoad {
    [super viewDidLoad];

    [self settingUI];
    [self viewModelInit];
    [self bindViewModel];
}

#pragma mark - 自定义方法
- (void)viewModelInit {
    _viewModel = [[HXNSLoginViewModel alloc] init];
}

- (void)bindViewModel {
    RAC(self.navigationItem,title) = RACObserve(self.viewModel, title);//单向绑定
    RACChannelTo(self.userNameT,text) = RACChannelTo(self.viewModel.userModel,username);//双向绑定
    RACChannelTo(self.passWordT,text) = RACChannelTo(self.viewModel.userModel,password);
    
    self.loginB.rac_command = self.viewModel.loginCommand;//处理事件
    @weakify(self);
    ///出现异常问题：当直接点击登录，输入框的数据未更新到VM的数据中，需要先去掉焦点
    [[self.loginB rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.userNameT resignFirstResponder];
        [self.passWordT resignFirstResponder];
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
    self.view.backgroundColor = UIColor.grayColor;
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
    [loginButton setTitle:@"2020版本-登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [self.view addSubview:loginButton];
    self.loginB = loginButton;
    
    //布局界面元素
    [passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.centerY.equalTo(self.view.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@30);
    }];
    [userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.bottom.equalTo(passwordTextField.mas_top).offset(-10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@(30));
    }];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordTextField.mas_left).offset(44);
        make.top.equalTo(passwordTextField.mas_bottom).offset(10);
        make.right.equalTo(passwordTextField.mas_right).offset(-44);
        make.height.equalTo(@(30));
    }];
}


@end
