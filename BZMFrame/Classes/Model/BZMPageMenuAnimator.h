//
//  BZMPageMenuAnimator.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/10.
//

#import <UIKit/UIKit.h>

@interface BZMPageMenuAnimator : NSObject
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, copy) void(^progressCallback)(CGFloat percent);
@property (nonatomic, copy) void(^completeCallback)(void);
@property (readonly, getter=isExecuting) BOOL executing;

- (void)start;
- (void)stop;
- (void)invalid;

@end
