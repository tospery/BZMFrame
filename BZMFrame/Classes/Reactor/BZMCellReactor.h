//
//  BZMCellReactor.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/24.
//

#import "BZMBaseReactor.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "BZMIdentifiable.h"
#import "BZMBaseModel.h"

@interface BZMCellReactor : BZMBaseReactor <BZMIdentifiable>
@property (nonatomic, strong, readonly) NSString *mid;
@property (nonatomic, strong, readonly) BZMBaseModel *model;
@property (nonatomic, strong, readonly) RACCommand *clickCommand;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithMid:(NSString *)mid NS_UNAVAILABLE;
- (instancetype)initWithModel:(BZMBaseModel *)model;

@end

