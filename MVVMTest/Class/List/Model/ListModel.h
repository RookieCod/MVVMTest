//
//  ListModel.h
//  MVVMTest
//
//  Created by 张松 on 2017/1/3.
//  Copyright © 2017年 张松. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ListModel : NSObject

/** 图书image */
@property (nonatomic, strong) NSString *image;

/** title-书名 */
@property (nonatomic, strong) NSString *title;

/** catalog-图书简介 */
@property (nonatomic, strong) NSString *author_intro;

@end
