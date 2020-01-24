//
//  BZMBaseSessionManager.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/24.
//

#import "BZMBaseSessionManager.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "BZMType.h"
#import "BZMFunction.h"
#import "BZMBaseResponse.h"
#import "BZMBaseList.h"
#import "NSError+BZMFrame.h"

typedef RACSignal *(^MapBlock)(BZMBaseResponse *);

@interface BZMBaseSessionManager ()
@property(nonatomic, copy) MapBlock mapBlock;

@end

@implementation BZMBaseSessionManager
- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    if (self = [super initWithBaseURL:url sessionConfiguration:configuration]) {
        NSMutableSet *contentTypes = [self.responseSerializer.acceptableContentTypes mutableCopy];
        [contentTypes addObjectsFromArray:@[
            @"text/html",
            @"application/javascript"
        ]];
        self.responseSerializer.acceptableContentTypes = contentTypes;
        self.mapBlock = ^RACSignal *(BZMBaseResponse *response) {
            if (response.code != BZMErrorCodeSuccess) {
                return [RACSignal error:[NSError bzm_errorWithCode:response.code description:response.message]];
            }
            if ([response.result isKindOfClass:BZMBaseList.class] &&
                [(BZMBaseList *)response.result items].count == 0) {
                return [RACSignal error:[NSError bzm_errorWithCode:BZMErrorCodeEmpty]];
            }
            return [RACSignal return:response.result];
        };
    }
    return self;
}

- (RACSignal *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters {
//    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        [[[self rac_GET:URLString parameters:parameters] flattenMap:self.mapBlock] subscribeNext:^(id responseObject) {
//            [subscriber sendNext:responseObject];
//            [subscriber sendCompleted];
//        } error:^(NSError * _Nullable error) {
//            [[RACScheduler currentScheduler] afterDelay:0.5 schedule:^{
//                [subscriber sendError:error];
//            }];
//        }];
//        return [RACDisposable disposableWithBlock:^{
//        }];
//    }] retry:1];
    
    return [[self rac_GET:URLString parameters:parameters] flattenMap:self.mapBlock];
}

@end
