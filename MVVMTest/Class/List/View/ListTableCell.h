//
//  ListTableCell.h
//  MVVMTest
//
//  Created by 张松 on 2017/1/11.
//  Copyright © 2017年 张松. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListModel.h"
@interface ListTableCell : UITableViewCell

/** <#description#> */
@property (nonatomic, strong) UIButton *loginButton;

- (void)configViewsWithModel:(ListModel *)model;

+ (ListTableCell *)tableView:(UITableView *)tableView cellWithIdentifier:(NSString *)identifier;


@end
