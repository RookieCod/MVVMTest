//
//  ListModel.h
//  MVVMTest
//
//  Created by 张松 on 2017/1/3.
//  Copyright © 2017年 张松. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ListModel : NSObject
/**
 * title
 */
@property (nonatomic, strong) NSString *titleName;

/**
 * 描述
 */
@property (nonatomic, strong) NSString *desc;

/**
 * 图片
 */
@property (nonatomic, strong) NSString *imageUrl;
@end
