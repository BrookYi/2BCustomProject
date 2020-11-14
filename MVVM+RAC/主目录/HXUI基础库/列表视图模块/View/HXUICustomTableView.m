//
//  HXUICustomView.m
//  MVVM+RAC
//
//  Created by Brook on 2020/11/10.
//

#import "HXUICustomTableView.h"
//视图引入
#import <Masonry/Masonry.h>
#import "HXUICustomProtocol.h"

//非视图
//M
#import "HXNSStockModel.h"
//VM
#import "HXNSCustomTableViewModel.h"
//框架
#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/RACEXTScope.h>

@interface HXUICustomTableView () <UITableViewDelegate,UITableViewDataSource,HXUICustomProtocol>
@property (strong, nonatomic) HXNSCustomTableViewModel *viewModel;

@property(nonatomic,strong)UITableView *table;

@end

@implementation HXUICustomTableView

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
    _viewModel = [[HXNSCustomTableViewModel alloc] init];
}

- (void)bindViewModel {
    @weakify(self);
    [RACObserve(self.viewModel, data) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.table reloadData];
    }];
}

- (void)settingUI {
    //视图这里只能用约束
    self.table = [[UITableView alloc] init];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self addSubview:self.table];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
}

//以下会提取到基类
#pragma mark HXUICustomProtocol

- (UIView *)customView {
    return self;
}

- (HXNSCustomTableViewModel *)customViewModel {
    return _viewModel;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.viewModel.data.count>indexPath.row) {
        HXNSStockModel *model = [self.viewModel.data objectAtIndex:indexPath.row];
        [self.viewModel.seletedIndexPathSubject sendNext:RACTuplePack(indexPath,model)];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"tableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    if (self.viewModel.data.count>indexPath.row) {
        HXNSStockModel *model = [self.viewModel.data objectAtIndex:indexPath.row];
        cell.textLabel.text = model.name;
        cell.detailTextLabel.text = model.code;
    }
    return cell;
}
@end
