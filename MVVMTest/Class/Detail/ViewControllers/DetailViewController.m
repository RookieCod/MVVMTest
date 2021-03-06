//
//  DetailViewController.m
//  MVVMTest
//
//  Created by 张松 on 2017/1/16.
//  Copyright © 2017年 张松. All rights reserved.
//  DetailViewController是一个模拟登录页面，只有输入正确的用户名和密码才能登陆

#import "DetailViewController.h"
#import "DetailViews.h"
#import "DetailViewModel.h"
#import "ListModel.h"
#import "SocketViewController.h"
@interface DetailViewController ()<UITextFieldDelegate>

@property(nonatomic, strong) DetailViews *detailView;
@property (nonatomic, strong) DetailViewModel *detailViewModel;
@end

@implementation DetailViewController

- (void)loadView
{
    [super loadView];
    self.view = self.detailView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    RAC(self.detailViewModel,userName) = self.detailView.userNameField.rac_textSignal;
    RAC(self.detailViewModel,password) = self.detailView.passwordField.rac_textSignal;
    
    RACSignal *validUserNameSignal =
    [self.detailView.userNameField.rac_textSignal
     map:^id(NSString *text) {
         return @([self isValidUserName:text]);
     }];
   
    RACSignal *validPasswordSignal =
    [self.detailView.passwordField.rac_textSignal
     map:^id(NSString *text) {
         return @([self isValidPassword:text]);
     }];
    
    
    RAC(self.detailView.userNameField,backgroundColor) =
    [validUserNameSignal
     map:^id(NSNumber *value) {
         return [value boolValue] ? [UIColor yellowColor] : [UIColor clearColor];
     }];
    
    RAC(self.detailView.passwordField,backgroundColor) =
    [validPasswordSignal
     map:^id(NSNumber *value) {
         return [value boolValue] ? [UIColor yellowColor] : [UIColor clearColor];
     }];
    
    [[RACSignal combineLatest:@[validUserNameSignal,validPasswordSignal]
                       reduce:^id(NSNumber *userNameValid, NSNumber *passwordValid){
                           return @([userNameValid boolValue] && [passwordValid boolValue]);
                       }]
     subscribeNext:^(NSNumber *signalActive) {
         self.detailView.loginButton.enabled = [signalActive boolValue];
     }];
    
    //RACCommond的第一次种用法，不和button绑定，用execute方法触发commond
    [[self.detailViewModel.orderCreateCommand.executing skip:1] subscribeNext:^(id x) {
        if ([x boolValue]) {
            NSLog(@"loading");
        } else {
        
            NSLog(@"success");
        }
    }];
    @weakify(self);
    [[self.detailView.loginButton
     rac_signalForControlEvents:UIControlEventTouchUpInside]
      subscribeNext:^(id x) {
          @strongify(self);
          [[self.detailViewModel.orderCreateCommand execute:@111] subscribeNext:^(id x) {
              NSLog(@"取得结果");
          } error:^(NSError *error) {
              
          }];
      }];
    
    /*
    self.detailView.loginButton.rac_command = self.detailViewModel.orderCreateCommand;
    self.detailView.loginButton.rac_command.allowsConcurrentExecution = NO;
    
    
    [self.detailView.loginButton.rac_command.executionSignals
     subscribeNext:^(id x) {
         //添加菊花转圈的
         NSLog(@"loading");
         [x subscribeNext:^(id x) {
             NSLog(@"success");
         }];
         
     }];
    [self.detailView.loginButton.rac_command.errors subscribeNext:^(id x) {
        NSLog(@"错误处理");
    }];
    */
    
    //rac merge用来处理两个或多个请求需要全部完成后去执行后续操作的情况
    /*
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"request1请求完成");
            [subscriber sendNext:@"1111111"];
            [subscriber sendCompleted];
        });
        return nil;
    }];
    
    RACSignal *request2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"request2请求完成");
            [subscriber sendNext:@"2222222"];
            [subscriber sendCompleted];
        });
        
        return nil;
    }];
    
    [[RACSignal merge:@[request1,request2]] subscribeCompleted:^{
        NSLog(@"两个请求都成功了");
    }];
    
    
    //RAC实现delegate,只能实现返回值为void的代理方法
    [[self rac_signalForSelector:@selector(textFieldShouldBeginEditing:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(id x) {
        
    }];
    
    //RAC实现通知
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"" object:nil]
     subscribeNext:^(NSNotification *notification) {
         NSLog(@"name=%@",notification.name);
     }];
    */
    //RACObserve
    
    
    
    //RAC进阶
    /*
    //  1、concat:按一定顺序拼接信号，当多个信号发出的时候，有顺序的接收信号。。可以用于一个网络请求结束另一个网络请求再开始
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"111111111111");

        [subscriber sendNext:@1];
        
        [subscriber sendCompleted];
        
        return nil;
    }];
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"22222222222");
        [subscriber sendNext:@2];
        [subscriber sendCompleted];
        return nil;
    }];
    
    // 把signalA拼接到signalB后，signalA发送完成，signalB才会被激活。
    RACSignal *concatSignal = [signalA concat:signalB];
    
    // 以后只需要面对拼接信号开发。
    // 订阅拼接的信号，不需要单独订阅signalA，signalB
    // 内部会自动订阅。
    // 注意：第一个信号必须发送完成，第二个信号才会被激活
    [concatSignal subscribeCompleted:^{
        NSLog(@"完成");
    }];
    */
    //  2、then:用于连接两个信号，当第一个信号完成，才会连接then返回的信号。使用场景是什么？没卵用啊感觉
    //     订阅信号只会第二个信号的值
    /*
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@1];
            [subscriber sendCompleted];
        });
        return nil;
    }] then:^RACSignal *{
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@3];
            [subscriber sendCompleted];
            
            return nil;
        }];
    }] subscribeCompleted:^{
        NSLog(@"完成");
    }];
    */
    //  3、ReactiveCocoa操作方法之秩序。
    //    doNext: 执行Next之前，会先执行这个Block
    //  doCompleted: 执行sendCompleted之前，会先执行这个Block
    
    /*
    [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return nil;
    }] doNext:^(id x) {
        // 执行[subscriber sendNext:@1];之前会调用这个Block
        NSLog(@"doNext");;
    }] doCompleted:^{
        // 执行[subscriber sendCompleted];之前会调用这个Block
        NSLog(@"doCompleted");;
        
    }] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    */
    
    
    //combineLatest:将多个信号合并起来（大于等于两个），并且拿到各个信号的最新的值,必须每个合并的signal至少都有过一次sendNext，才会触发合并的信号
    /*
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@2];
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    [[RACSignal combineLatest:@[signalA,signalB]
                      reduce:^id(NSNumber *num1,NSNumber *num2){
                          return [NSString stringWithFormat:@"%@<%@",num1,num2];
                      }] subscribeNext:^(NSString *x) {
                          NSLog(@"%@",x);
                      }];
    */
}

- (DetailViews *)detailView
{
    if (!_detailView) {
        _detailView = [[DetailViews alloc] initWithFrame:self.view.bounds];
        _detailView.backgroundColor = [UIColor clearColor];
    }
    return _detailView;
}

- (DetailViewModel *)detailViewModel
{
    if (!_detailViewModel) {
        _detailViewModel = [[DetailViewModel alloc] init];
    }
    return _detailViewModel;
}

- (BOOL)isValidUserName:(NSString *)text
{
    if (text.length > 3 || text.integerValue != 0) {
        return YES;
    }
    return NO;
}

- (BOOL)isValidPassword:(NSString *)text
{
    if (text.length > 3 || text.integerValue != 0) {
        return YES;
    }
    return NO;
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
