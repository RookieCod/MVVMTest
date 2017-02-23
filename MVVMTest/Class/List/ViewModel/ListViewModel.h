//
//  ListViewModel.h
//  MVVMTest
//
//  Created by 张松 on 2017/1/6.
//  Copyright © 2017年 张松. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListModel.h"//分离model，可以让model复用更加方便
@interface ListViewModel : NSObject

- (instancetype)initListViewModel;

/**
 * 存放数据源
 */
@property (nonatomic, strong) NSMutableArray *dataArray;

/**
 * cellClick
 */
@property (nonatomic, strong) RACSubject *cellClick;


/**
 登陆按钮点击
 */
@property (nonatomic, strong) RACSubject *scrollViewDidScroll;
@end
