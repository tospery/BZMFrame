//
//  BZMBaseItem.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/7.
//

#import "BZMBaseItem.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface BZMBaseItem ()
@property (nonatomic, strong, readwrite) BZMBaseModel *model;

@end

@implementation BZMBaseItem
- (instancetype)initWithModel:(BZMBaseModel *)model {
    if (self = [super initWithMid:model.mid]) {
        self.model = model;
    }
    return self;
}

- (void)didInitialize {
    
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    BZMBaseItem *item = [super allocWithZone:zone];
    @weakify(item)
    [[item rac_signalForSelector:@selector(initWithModel:)] subscribeNext:^(id x) {
        @strongify(item)
        [item didInitialize];
    }];
    return item;
}

@end
