//
//  BZMBaseItem.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/7.
//

#import "BZMObject.h"
#import "BZMBaseModel.h"

@interface BZMBaseItem : BZMObject
@property (nonatomic, strong, readonly) BZMBaseModel *model;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithMid:(NSString *)mid NS_UNAVAILABLE;
- (instancetype)initWithModel:(BZMBaseModel *)model;

- (void)didInitialize;

@end

