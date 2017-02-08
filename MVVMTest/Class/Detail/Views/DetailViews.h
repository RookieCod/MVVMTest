//
//  DetailViews.h
//  MVVMTest
//
//  Created by 张松 on 2017/1/17.
//  Copyright © 2017年 张松. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViews : UIView
/*
 userName
 */
@property (nonatomic,strong) UITextField *userNameField;

/*
 password
 */
@property (nonatomic,strong) UITextField *passwordField;

@property (nonatomic, strong) UIButton *loginButton;


- (instancetype)initWithFrame:(CGRect)frame;

@end
