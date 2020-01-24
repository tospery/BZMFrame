//
//  BZMPageMenuAnimator.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/10.
//

#import "BZMPageMenuAnimator.h"

@interface BZMPageMenuAnimator ()
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CFTimeInterval firstTimestamp;
@property (readwrite, getter=isExecuting) BOOL executing;

@end

@implementation BZMPageMenuAnimator
- (void)dealloc
{
    self.progressCallback = nil;
    self.completeCallback = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _executing = NO;
        _duration = 0.25;
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(processDisplayLink:)];
    }
    return self;
}

- (void)start {
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    self.executing = YES;
}

- (void)stop {
    !self.progressCallback ?: self.progressCallback(1);
    [self.displayLink invalidate];
    !self.completeCallback ?: self.completeCallback();
    self.executing = NO;
}

- (void)invalid {
    [self.displayLink invalidate];
    !self.completeCallback ?: self.completeCallback();
    self.executing = NO;
}

- (void)processDisplayLink:(CADisplayLink *)sender {
    if (self.firstTimestamp == 0) {
        self.firstTimestamp = sender.timestamp;
        return;
    }
    CGFloat percent = (sender.timestamp - self.firstTimestamp)/self.duration;
    if (percent >= 1) {
        !self.progressCallback ?: self.progressCallback(percent);
        [self.displayLink invalidate];
        !self.completeCallback ?: self.completeCallback();
        self.executing = NO;
    }else {
        !self.progressCallback ?: self.progressCallback(percent);
        self.executing = YES;
    }
}

@end
