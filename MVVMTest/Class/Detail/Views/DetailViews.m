//
//  DetailViews.m
//  MVVMTest
//
//  Created by 张松 on 2017/1/17.
//  Copyright © 2017年 张松. All rights reserved.
//

#import "DetailViews.h"

@interface DetailViews ()

@end

@implementation DetailViews

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    [self addSubview:self.userNameField];
    [self addSubview:self.passwordField];
    [self addSubview:self.loginButton];
    [self addConstraints];
}

- (void)bingModel
{
    

}

- (void)addConstraints
{
    [self.userNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self).offset(84);
        make.height.mas_equalTo(40);
    }];

    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.userNameField);
        make.top.equalTo(self.userNameField.mas_bottom).offset(20);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset((self.bounds.size.width - 60)/2);
        make.top.equalTo(self.passwordField.mas_bottom).offset(30);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(60);
    }];
}
- (UITextField *)userNameField
{
    if (!_userNameField) {
        _userNameField = [[UITextField alloc] init];
        _userNameField.borderStyle = UITextBorderStyleRoundedRect;
        _userNameField.textAlignment = NSTextAlignmentLeft;
        _userNameField.backgroundColor = [UIColor clearColor];
    }
    return _userNameField;
}

- (UITextField *)passwordField
{
    if (!_passwordField) {
        _passwordField = [[UITextField alloc] init];
        _passwordField.borderStyle = UITextBorderStyleRoundedRect;
        _passwordField.textAlignment = NSTextAlignmentLeft;
        _passwordField.backgroundColor = [UIColor clearColor];
    }
    return _passwordField;
}

- (UIButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:@"登陆" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
    }
    
    return _loginButton;

}

@end
