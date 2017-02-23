//
//  ListViewController.m
//  MVVMTest
//
//  Created by 张松 on 2017/1/3.
//  Copyright © 2017年 张松. All rights reserved.
//

#import "ListViewController.h"
#import "ListViewModel.h"
#import "ListModel.h"
#import "ListTableView.h"
#import "DetailViewController.h"
@interface ListViewController ()
/**
 * <#注释#>
 */
@property (nonatomic, strong) ListTableView *tableView;
/**
 * <#注释#>
 */
@property (nonatomic, strong) ListViewModel *listViewModel;
@end

@implementation ListViewController

#pragma mark -
#pragma mark lazy load
- (ListTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[ListTableView alloc] initWithListViewModel:self.listViewModel frame:self.view.bounds];
    }
    return _tableView;
}

- (ListViewModel *)listViewModel
{
    if (!_listViewModel) {
        _listViewModel = [[ListViewModel alloc] initListViewModel];
    }
    return _listViewModel;
}
#pragma mark -
#pragma mark lefeCycle
- (void)loadView
{
    [super loadView];
    self.view = self.tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"MVVM测试";
    
    [self bindViewModel];
}

//绑定ViewModel
- (void)bindViewModel
{
    //观察listViewModel属性的变化，如果有变化就去更新cell上的数据
    @weakify(self);
    [[self.listViewModel.cellClick takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self);
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        detailVC.orderId = @"rac可以通过KVC对只读属性赋值";
        NSLog(@"只会执行一次");
        [self.navigationController pushViewController:detailVC animated:YES];
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
