//
//  ListViewModel.m
//  MVVMTest
//
//  Created by 张松 on 2017/1/6.
//  Copyright © 2017年 张松. All rights reserved.
//

#import "ListViewModel.h"

@interface ListViewModel ()
{
    ListModel *_listModel;

}

@end

@implementation ListViewModel

#pragma mark -
#pragma mark dataArray
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (instancetype)initListViewModel
{
    if (self = [super init]) {
        
        //此处处理网络请求
        for (int i = 0; i < 8; i++) {
            ListModel *listModel = [[ListModel alloc] init];
            listModel.titleName = @"MVVM初探";
            listModel.desc = @"受MVC或MVP架构的影响，对MVVM最初印象以为这是一个以ViewModel为核心，处理View和Model的开发架构。核心问题就在于对ViewModel角色的定位不清！";
            listModel.imageUrl = @"http://mmbiz.qpic.cn/mmbiz/XxE4icZUMxeFjluqQcibibdvEfUyYBgrQ3k7kdSMEB3vRwvjGecrPUPpHW0qZS21NFdOASOajiawm6vfKEZoyFoUVQ/640?wx_fmt=jpeg&wxfrom=5";
            [self.dataArray addObject:listModel];
        }
    }
    return self;
}

- (RACSubject *)cellClick
{
    if (!_cellClick) {
        _cellClick = [RACSubject subject];
    }
    return _cellClick;
}

@end
