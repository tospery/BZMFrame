//
//  BZMProvider.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/4.
//

#import "BZMProvider.h"

@interface BZMProvider ()

@end

@implementation BZMProvider
#pragma mark - Init
- (instancetype)init {
    if (self = [super init]) {
        [self didInitialize];
    }
    return self;
}

#pragma mark - Method
- (void)didInitialize {
    
}

#pragma mark - Class
+ (instancetype)share {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

@end
