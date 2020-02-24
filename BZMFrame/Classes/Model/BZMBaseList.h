//
//  BZMBaseList.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/23.
//

#import "BZMBaseModel.h"

@interface BZMBaseList : BZMBaseModel
@property (nonatomic, assign, readonly) BOOL hasNext;
@property (nonatomic, assign, readonly) NSInteger count;
@property (nonatomic, strong, readonly) NSArray *items;

@end
