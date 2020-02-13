//
//  BZMCollectionItem.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/7.
//

#import "BZMCollectionItem.h"
#import "BZMFunction.h"

@interface BZMCollectionItem ()
@property (nonatomic, strong, readwrite) RACCommand *selectCommand;

@end

@implementation BZMCollectionItem
- (instancetype)initWithModel:(BZMBaseModel *)model {
    if (self = [super initWithModel:model]) {
        self.cellSize = CGSizeMake(BZMScreenWidth, BZMMetric(44));
    }
    return self;
}

- (void)didInitialize {
    [super didInitialize];
    self.selectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal return:input];
    }];
}

@end
