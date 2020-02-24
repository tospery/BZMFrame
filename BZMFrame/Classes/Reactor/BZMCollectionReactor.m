//
//  BZMCollectionReactor.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import "BZMCollectionReactor.h"
#import "BZMFunction.h"

@interface BZMCollectionReactor ()

@end

@implementation BZMCollectionReactor
- (instancetype)initWithModel:(BZMBaseModel *)model {
    if (self = [super initWithModel:model]) {
        self.cellSize = CGSizeMake(BZMScreenWidth, BZMMetric(44));
    }
    return self;
}

- (void)didInitialize {
    [super didInitialize];
}

@end
