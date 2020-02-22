//
//  BZMReactive.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import <UIKit/UIKit.h>
#import "BZMBaseReactor.h"

@protocol BZMReactive <NSObject>
@property (nonatomic, strong, readonly) BZMBaseReactor *reactor;

/// 用于绑定Reactor
/// 1. View的操作 -> Reactor的业务
/// 2. Reactor的数据 -> View的展示
/// 注：单向
/// @param reactor 绑定的Reactor
- (void)bind:(BZMBaseReactor *)reactor;

@end

