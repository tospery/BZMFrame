//
//  BZMTableItem.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/7.
//

#import "BZMTableItem.h"
#import "BZMFunction.h"

@interface BZMTableItem ()

@end

@implementation BZMTableItem
- (instancetype)initWithModel:(BZMBaseModel *)model {
    if (self = [super initWithModel:model]) {
        self.cellHeight = BZMMetric(44);
    }
    return self;
}

@end
