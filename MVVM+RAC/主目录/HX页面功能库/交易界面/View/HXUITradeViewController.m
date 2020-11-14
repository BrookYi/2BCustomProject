//
//  HXUITradeViewController.m
//  MVVM+RAC
//
//  Created by Brook on 2020/11/8.
//

#import "HXUITradeViewController.h"
//视图引入
#import <Masonry/Masonry.h>
#import "HXUICustomProtocol.h"

//非视图
//M
#import "HXNSStockModel.h"
//VM
#import "HXNSTradeViewModel.h"
#import "HXNSStockeInputViewModel.h"
#import "HXNSFiveTradeChartViewModel.h"
#import "HXNSCustomTableViewModel.h"
//框架
#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/RACEXTScope.h>
//配置
#import "HXNSViewConfigManager.h"

@interface HXUITradeViewController ()
@property (strong, nonatomic) HXNSTradeViewModel *viewModel;//交易页VM

///难点：可配置视图怎么定义与数据绑定，范围大小
///思考点：V是变化的，唯一不变的是V是同一类的，具体是指使用同一个VM类的视图。
@property (strong, nonatomic) id<HXUICustomProtocol> inputView;
@property (strong, nonatomic) id<HXUICustomProtocol> fiveTradeChartView;
@property (strong, nonatomic) id<HXUICustomProtocol> tableView;
@end

@implementation HXUITradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self settingUI];
    [self viewModelInit];
    [self bindViewModel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //判断类型，改送请求入参
    [((HXNSCustomTableViewModel *)self.tableView.customViewModel).fetchInfoListCommand execute:nil];
}

#pragma mark - 固定的方法暂时不放基类
- (void)viewModelInit {
    _viewModel = [[HXNSTradeViewModel alloc] init];
}

- (void)bindViewModel {
    RAC(self.navigationItem,title) = RACObserve(self.viewModel, title);//单向绑定标题
    RAC(self.viewModel.stockModel,code) = RACObserve(((HXNSStockeInputViewModel *)self.inputView.customViewModel),code);
    
    if ([self.fiveTradeChartView.customViewModel isKindOfClass:HXNSFiveTradeChartViewModel.class]) {
        RAC(((HXNSFiveTradeChartViewModel *)self.fiveTradeChartView.customViewModel).stockModel,code) = RACObserve(self.viewModel.stockModel,code);
    } else {
        //报错，咋使用的VM不一致？？
    }
    
    //列表点击事件和输入框的绑定
    @weakify(self);
    [((HXNSCustomTableViewModel *)self.tableView.customViewModel).seletedIndexPathSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        RACTupleUnpack(NSIndexPath *path,HXNSStockModel *model) = x;
        [((HXNSStockeInputViewModel *)self.inputView.customViewModel) setValue:model.code forKey:@"code"];
    }];
}

- (void)settingUI {
    self.view.backgroundColor = UIColor.whiteColor;
    //输入视图
    NSString *realInputPageName = HXNSViewRealName(StockeInput);
    self.inputView = [[NSClassFromString(realInputPageName) alloc] init];
    [self.view addSubview:self.inputView.customView];
    //买卖五档
    NSString *realPageName = HXNSViewRealName(FiveChart);
    self.fiveTradeChartView = [[NSClassFromString(realPageName) alloc] init];
    [self.view addSubview:self.fiveTradeChartView.customView];
    
    NSString *realTableViewName = HXNSViewRealName(CustomTableView);
    self.tableView = [[NSClassFromString(realTableViewName) alloc] init];
    [self.view addSubview:self.tableView.customView];
    
    [self.inputView.customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
        make.right.equalTo(self.fiveTradeChartView.customView.mas_left).offset(-10);
        make.height.equalTo(@(200));
    }];
    
    [self.fiveTradeChartView.customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(200);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@(200));
    }];
    //    tableView
    [self.tableView.customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(self.fiveTradeChartView.customView.mas_bottom).offset(10);
    }];
}

@end
