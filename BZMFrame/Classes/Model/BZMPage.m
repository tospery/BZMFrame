//
//  BZMPage.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/21.
//

#import "BZMPage.h"

@interface BZMPage ()

@end

@implementation BZMPage
- (instancetype)init {
    if (self = [super init]) {
        self.start = 1;
        self.size = 20;
        self.style = BZMPageStyleGroup;
    }
    return self;
}

- (void)setStart:(NSInteger)start {
    _start = start;
    self.index = start;
}

@end
