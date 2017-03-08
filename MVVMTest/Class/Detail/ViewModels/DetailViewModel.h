//
//  DetailViewModel.h
//  MVVMTest
//
//  Created by 张松 on 2017/1/17.
//  Copyright © 2017年 张松. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailViewModel : NSObject

/** userName */
@property (nonatomic, strong, readonly) NSString *userName;
/** password */
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) RACCommand *orderCreateCommand;


@end
