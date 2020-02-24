//
//  BZMWebViewReactor.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/23.
//

#import "BZMScrollViewReactor.h"

@interface BZMWebViewReactor : BZMScrollViewReactor
@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, strong) NSArray *ocHandlers;
@property (nonatomic, strong) NSArray *jsHandlers;
@property (nonatomic, strong, readonly) NSURL *url;

@end

