//
//  ViewController.m
//  MVVM+RAC
//
//  Created by Brook on 2020/11/1.
//

#import "ViewController.h"
//视图引入
#import <Masonry/Masonry.h>

//非视图引入
//路由库
#import <JLRoutes/JLRoutes.h>
//框架
#import <ReactiveObjC/ReactiveObjC.h>

@interface ViewController ()
@property (strong, nonatomic) UIButton *gotoLoginPageButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingUI];
    [self bindViewModel];
}

/// 初始化界面UI
- (void)settingUI {
    _gotoLoginPageButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_gotoLoginPageButton setTitle:@"去登录" forState:UIControlStateNormal];
    [self.view addSubview:_gotoLoginPageButton];
    
    [_gotoLoginPageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
        make.height.equalTo(@(30));
        make.width.equalTo(@100);
    }];
}

/// 绑定VM
- (void)bindViewModel {
    [[_gotoLoginPageButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSURL *editPost = [NSURL URLWithString:@"hxRouteScheme://login"];
        [JLRoutes routeURL:editPost];
    }];
}
@end
