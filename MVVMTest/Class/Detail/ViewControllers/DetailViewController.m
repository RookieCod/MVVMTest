//
//  DetailViewController.m
//  MVVMTest
//
//  Created by 张松 on 2017/1/16.
//  Copyright © 2017年 张松. All rights reserved.
//  DetailViewController是一个模拟登录页面，只有输入正确的用户名和密码才能登陆

#import "DetailViewController.h"

@interface DetailViewController ()
/*
 userName
 */
@property (nonatomic,strong) UITextField *userNameField;

/*
 password
 */
@property (nonatomic,strong) UITextField *passwordField;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
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
