//
//  ListViewModel.m
//  MVVMTest
//
//  Created by 张松 on 2017/1/6.
//  Copyright © 2017年 张松. All rights reserved.
//

#import "ListViewModel.h"

#define LISTBASEURL @"https://api.douban.com/v2/book/search"

@interface ListViewModel ()
{
    ListModel *_listModel;

}
/** <#description#> */
@property (nonatomic, strong) NSMutableArray *dataArray;
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
        
        [self bindData];
    }
    return self;
}

//绑定数据
- (void)bindData
{
    @weakify(self);
    _listCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
       return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
           @strongify(self);
           [[AFHTTPSessionManager manager] GET:LISTBASEURL
                                    parameters:input
                                      progress:nil
                                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                           
                                           self.dataArray = [ListModel mj_objectArrayWithKeyValuesArray:responseObject[@"books"]];
                                           //NSLog(@"%@",self.dataArray);
                                           [subscriber sendNext:self.dataArray];
                                           [subscriber sendCompleted];
                                       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                           //请求失败
                                           [subscriber sendError:error];
                                       }];
           return nil;
       }];
    }];
}



@end
