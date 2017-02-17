//
//  DetailViewModel.m
//  MVVMTest
//
//  Created by 张松 on 2017/1/17.
//  Copyright © 2017年 张松. All rights reserved.
//

#import "DetailViewModel.h"

@implementation DetailViewModel

- (RACCommand *)orderCreateCommand
{
    _orderCreateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSLog(@"==%@",input);
            //提交网络请求
            NSLog(@"网络请求");
            [subscriber sendNext:@"33333"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    return _orderCreateCommand;
}

- (RACDisposable *)mergeSignal
{
    if (!_mergeSignal) {
        _mergeSignal = [[RACSignal merge:@[]] subscribeCompleted:^{
            NSLog(@"两个网络请求都已经完成");
        }];
    }
    return _mergeSignal;
}

@end
