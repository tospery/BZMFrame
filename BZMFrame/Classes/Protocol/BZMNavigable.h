//
//  BZMNavigable.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import <UIKit/UIKit.h>

@class BZMViewReactor;

@protocol BZMNavigable <NSObject>

- (void)resetRootReactor:(BZMViewReactor *)reactor;

@end

