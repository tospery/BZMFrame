//
//  BZMCollectionItem.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/7.
//

#import "BZMBaseItem.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface BZMCollectionItem : BZMBaseItem
@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, strong) RACCommand *didSelectCommand;

@end

