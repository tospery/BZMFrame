//
//  BZMNormalCollectionReactor.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/25.
//

#import "BZMNormalCollectionReactor.h"
#import "BZMFunction.h"

@interface BZMNormalCollectionReactor ()
@property (nonatomic, strong, readwrite) BZMNormalCollectionModel *model;

@end

@implementation BZMNormalCollectionReactor
@dynamic model;

- (instancetype)initWithModel:(BZMNormalCollectionModel *)model {
    if (self = [super initWithModel:model]) {
        self.cellSize = CGSizeMake(BZMScreenWidth, BZMMetric(50));
    }
    return self;
}

- (void)didInitialize {
    [super didInitialize];
}

@end
