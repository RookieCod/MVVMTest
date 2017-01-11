//
//  ListViewModel.h
//  MVVMTest
//
//  Created by 张松 on 2017/1/6.
//  Copyright © 2017年 张松. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListModel.h"
@interface ListViewModel : NSObject

- (instancetype)initListViewModel;

/**
 * 存放数据源
 */
@property (nonatomic, strong) NSMutableArray *dataArray;
@end
