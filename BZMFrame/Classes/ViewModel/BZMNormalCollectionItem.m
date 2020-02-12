//
//  BZMNormalCollectionItem.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/8.
//

#import "BZMNormalCollectionItem.h"
#import "BZMFunction.h"

@interface BZMNormalCollectionItem ()
@property (nonatomic, strong, readwrite) BZMNormalModel *model;

@end

@implementation BZMNormalCollectionItem
@dynamic model;

- (instancetype)initWithModel:(BZMNormalModel *)model {
    if (self = [super initWithModel:model]) {
        self.cellSize = CGSizeMake(BZMScreenWidth, BZMMetric(50));
    }
    return self;
}

@end
