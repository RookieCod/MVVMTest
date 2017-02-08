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

@interface DetailViewController ()

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
    
    RACSignal *signUpSignal =
     [RACSignal combineLatest:@[validUserNameSignal,validPasswordSignal]
                       reduce:^id(NSNumber *userNameValid, NSNumber *passwordValid){
                           return @([userNameValid boolValue] && [passwordValid boolValue]);
                       }];
    
    [signUpSignal subscribeNext:^(NSNumber *signupActive) {
        self.detailView.loginButton.enabled = [signupActive boolValue];
    }];
    
//    [[self.detailView.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        NSLog(@"=====");
//    }];
    
    
    
    //rac遍历数组和字典
//    NSArray *array = @[@1,@2,@5];
//    [array.rac_sequence.signal subscribeNext:^(id x) {
//        NSLog(@"%@===%@",x,[NSThread currentThread]);
//    }];
    @weakify(self);
    [[self.detailView.loginButton
     rac_signalForControlEvents:UIControlEventTouchUpInside]
      subscribeNext:^(id x) {
          @strongify(self);
          //execute:input，参数是传递到commandblock中的参数，可以作为网络请求的入参传递过去
          [[self.detailViewModel.orderCreateCommand execute:@1]
           subscribeNext:^(NSString *x) {
               NSLog(@"拿到数据==%@",x);
           }
           error:^(NSError *error) {
               
           }];
      }];
    
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
    if (text.length > 5) {
        return YES;
    }
    return NO;
}

- (BOOL)isValidPassword:(NSString *)text
{
    if (text.length > 5) {
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
