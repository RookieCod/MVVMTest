//
//  ListTableView.m
//  MVVMTest
//
//  Created by 张松 on 2017/1/3.
//  Copyright © 2017年 张松. All rights reserved.
//

#import "ListTableView.h"
#import "ListTableCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

static NSString *identifier = @"cellIdentifier";

@interface ListTableView ()<UITableViewDelegate,UITableViewDataSource>
{

}
/**
 * <#注释#>
 */
@property (nonatomic, strong) UITableView *mainTableView;
@end

@implementation ListTableView

- (instancetype)initWithListViewModel:(ListViewModel *)viewModel frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //添加子视图
        [self createViews];
        
        [RACObserve(self, dataArray) subscribeNext:^(id x) {
            [self.mainTableView reloadData];
        }];
    }
    return self;
}

- (void)createViews
{
    [self addSubview:self.mainTableView];
}

- (UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = [UIColor clearColor];
        _mainTableView.estimatedRowHeight = 100;
        [_mainTableView registerClass:[ListTableCell class]
               forCellReuseIdentifier:identifier];
    }
    return _mainTableView;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = self.dataArray.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ListTableCell *cell = [ListTableCell tableView:tableView cellWithIdentifier:identifier];
    
    [cell configViewsWithModel:[self.dataArray objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [tableView fd_heightForCellWithIdentifier:identifier
                                    cacheByIndexPath:indexPath
                                       configuration:^(ListTableCell *cell) {
                                           [cell configViewsWithModel:[self.dataArray objectAtIndex:indexPath.row]];
                                       }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    //如果有跳转逻辑 要放到controller中去做
    [self.cellClick sendNext:nil];
}

- (RACSubject *)cellClick
{
    if (!_cellClick) {
        _cellClick = [RACSubject subject];
    }
    return _cellClick;
}
@end
