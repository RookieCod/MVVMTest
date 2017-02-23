//
//  ListTableView.h
//  MVVMTest
//
//  Created by 张松 on 2017/1/3.
//  Copyright © 2017年 张松. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewModel.h"
@interface ListTableView : UIView<UIScrollViewDelegate>
- (instancetype)initWithListViewModel:(ListViewModel *)viewModel frame:(CGRect)frame;
/** <#description#> */
@property (nonatomic, weak) id delegate;
@end
