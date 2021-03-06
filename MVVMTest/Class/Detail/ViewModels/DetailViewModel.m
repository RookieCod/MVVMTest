//
//  DetailViewModel.m
//  MVVMTest
//
//  Created by 张松 on 2017/1/17.
//  Copyright © 2017年 张松. All rights reserved.
//

#import "DetailViewModel.h"

@interface DetailViewModel ()
/** session */
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

/** <#description#> */
@property (nonatomic, strong) RACSignal *userNameSignal;

/** <#description#> */
@property (nonatomic, strong) RACSignal *passwordSignal;

/** <#description#> */
@property (nonatomic, strong) RACSignal *reduceSignal;

@end
@implementation DetailViewModel

- (RACCommand *)orderCreateCommand
{
    if (!_orderCreateCommand) {
        NSLog(@"=%@==%@",self.userName,self.password);
        RACSignal *userNameSignal =
        [RACObserve(self, userName)
         map:^id(NSString *value) {
             return @([self isValidUserName:value]);
         }];
        
        RACSignal *passwordSignal =
        [RACObserve(self, password)
         map:^id(NSString *value) {
             return @([self isValidPassword:value]);
         }];
        RACSignal *reduceSignal = [RACSignal combineLatest:@[passwordSignal,userNameSignal]
                                          reduce:^id(NSNumber *userName,NSNumber *password){
                                              return @([userName boolValue] && [password boolValue]);
                                          }];
//
        
        _orderCreateCommand = [[RACCommand alloc] initWithEnabled:reduceSignal signalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [subscriber sendNext:@"haha"];
                    [subscriber sendCompleted];
                });
                
                return nil;
            }];
        }];
    }
    return _orderCreateCommand;
}



- (BOOL)isValidUserName:(NSString *)text
{
    if (text.length > 3 || text.integerValue != 0) {
        return YES;
    }
    return NO;
}

- (BOOL)isValidPassword:(NSString *)text
{
    if (text.length > 3 || text.integerValue != 0) {
        return YES;
    }
    return NO;
}

- (BOOL)developRebaseValid
{
    return YES;
}

@end
