//
//  BZMBaseSessionManager.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/24.
//

#import "BZMBaseSessionManager.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "BZMType.h"
#import "BZMBaseResponse.h"
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
            return [RACSignal return:response.result];
        };
    }
    return self;
}

- (RACSignal *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters {
    return [[self rac_GET:URLString parameters:parameters] flattenMap:self.mapBlock];
}


@end
