//
//  ListTableView.m
//  MVVMTest
//
//  Created by 张松 on 2017/1/3.
//  Copyright © 2017年 张松. All rights reserved.
//

#import "ListTableView.h"
#import "ListTableCell.h"
@interface ListTableView ()<UITableViewDelegate,UITableViewDataSource>
{
    ListViewModel *_viewModel;

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
        _viewModel = viewModel;
        [self createViews];
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
        _mainTableView.backgroundColor = [UIColor clearColor];;
//        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mainTableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = _viewModel.dataArray.count;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"aaaaaaaaa";
    ListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ListTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.listModel = [_viewModel.dataArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [ListTableCell cellHeight:[_viewModel.dataArray objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    //如果有跳转逻辑 要放到controller中去做，如果不用rac，就要用代理，会很麻烦
    [_viewModel.cellClick sendNext:nil];
}

@end
