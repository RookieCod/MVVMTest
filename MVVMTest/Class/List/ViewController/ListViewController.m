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
    self.navigationItem.title = @"MVVM+RAC";
    
    [self bindViewModel];
    
    
    
    RAC(self.tableView,dataArray) = RACObserve(self.listViewModel, dataArray);
    //[self replaySubject];
    
    //[self racSequence];
    
    [self.listViewModel.listCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        
    }];
    
    [self.listViewModel.listCommand execute:@{@"q" : @"财经"}];
    
    
    //[self concatSignal];
    
    //[self thenSignal];
    
    //[self mergeSignal];
    //[self reduceSignal];
    
    [self racListSelector];
}


/**
 RACReplaySubject 可以先发送信号再订阅，并且没订阅一次  都会重复发送之前发送的信号
 */
- (void)replaySubject
{
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    [replaySubject sendNext:@1];
    [replaySubject sendNext:@2];
    
    [replaySubject subscribeNext:^(id x) {
       
        NSLog(@"%@",x);
    }];
    
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}


/**
 RACSequence,集合类的遍历
 */
- (void)racSequence
{
    NSArray *numbers = @[@1,@2,@4,@5];
    [numbers.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}


- (void)concatSignal
{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@123];
        [subscriber sendCompleted];
//        [subscriber sendError:[NSError errorWithDomain:@"signalA" code:103 userInfo:@{@"message" : @"signalA失败"}]];
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@456];
        [subscriber sendCompleted];
        //[subscriber sendError:[NSError errorWithDomain:@"signalB" code:102 userInfo:@{@"message" : @"signalB失败"}]];
        return nil;
    }];
    
    RACSignal *concatSignal = [signalB concat:signalA];
    [concatSignal subscribeNext:^(id x) {
       
        NSLog(@"%@",x);
    } error:^(NSError *error) {
        NSLog(@"%@,%@,%ld",error.domain,error.userInfo,error.code);
    }];
    
}

- (void)thenSignal
{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@123];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@456];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *thenSignal = [signalA then:^RACSignal *{
            return signalB;
    }];
    
    //会忽略之前信号的值   只能接受到第二个信号的值
    [thenSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}


/**
 merge 组合信号，任何一个信号senNext都会触发新值，
 可以配合concat达到先执行一系列信号 在执行某个信号的目的
 
 但是如果一组信号中有任意一个sendError，后续信号都不会执行
 */
- (void)mergeSignal
{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
//                [subscriber sendError:nil];
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [subscriber sendNext:@99];
//            [subscriber sendCompleted];
            
            [subscriber sendError:nil];
        });
        return nil;
    }];
    
    RACSignal *signalF = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@33];
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    RACSignal *signalC = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"C"];
            [subscriber sendCompleted];
            
//            [subscriber sendError:nil];
        });
        
        return nil;
    }];
    
    
    RACSignal *combineSignal = [RACSignal merge:@[signalA,signalB,signalF]];
    [combineSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    } error:^(NSError *error) {
        NSLog(@"有一个信号sendError");
    }];
    
    
    [[combineSignal concat:signalC] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    } error:^(NSError *error) {
        NSLog(@"signalC执行失败");
    }];

}

/**
 先聚合再拼接，功能类似于dispatch_group,可以一组信号先执行完之后再执行一个信号
 
 聚合的信号中，只要有一个信号执行失败，那么这组信号就失败了，后续也不会再执行
 */
- (void)reduceSignal
{
    RACMulticastConnection *connectionA = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"aaaaaaaaaaa");
        [subscriber sendNext:@11];
        [subscriber sendCompleted];
        return nil;
    }] publish];
    RACSignal *signalA = [connectionA signal];
    
    RACMulticastConnection *connectionB = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"bbbbbbbbbbbbbbb");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@99];
            [subscriber sendCompleted];
        });
        return nil;
    }] publish];
    RACSignal *signalB = connectionB.signal;
    
    RACMulticastConnection *connectionF = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"fffffffffffffff");
        [subscriber sendNext:@33];
        [subscriber sendCompleted];
        
        return nil;
    }] publish];
    RACSignal *signalF = connectionF.signal;
    
    RACSignal *signalC = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"C"];
            [subscriber sendCompleted];
            
            //[subscriber sendError:nil];
        });
        
        return nil;
    }];
    
    
    [signalA subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    [signalB subscribeNext:^(id x) {
        NSLog(@"%@",x);

    }];
    
    [signalF subscribeNext:^(id x) {
        NSLog(@"%@",x);

    }];
    
    [[RACSignal combineLatest:@[signalA,signalB,signalF]
                      reduce:^id(NSNumber *a,NSNumber *b,NSNumber *f){
                          return [NSString stringWithFormat:@"%@,%@,%@",a,b,f];
                      }] subscribeNext:^(NSString *x) {
                          NSLog(@"%@",x);
                      }];
    
    [connectionA connect];
    [connectionB connect];
    [connectionF connect];
}

- (void)racListSelector
{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"A"];
            [subscriber sendCompleted];
        });
        //                [subscriber sendError:nil];
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [subscriber sendNext:@"B"];
            [subscriber sendCompleted];
            //[subscriber sendError:nil];
        });
        return nil;
    }];
    
    [signalA subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    [signalB subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    [self rac_liftSelector:@selector(doA:withB:) withSignals:signalA,signalB, nil];
}

- (void)doA:(NSString *)A withB:(NSString *)B
{
    NSLog(@"调用了doA:withB方法");
}
//绑定ViewModel
- (void)bindViewModel
{
    @weakify(self);
    [[self.tableView.cellClick takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self);
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        detailVC.orderId = @"012345";
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
