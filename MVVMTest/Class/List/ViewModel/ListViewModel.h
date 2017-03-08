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
@property (nonatomic, strong, readonly) NSMutableArray *dataArray;

/** RACCommand */
@property (nonatomic, strong, readonly) RACCommand *listCommand;

@end
