//
//  BZMWebViewModel.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/8.
//

#import "BZMScrollViewModel.h"

@interface BZMWebViewModel : BZMScrollViewModel
@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic, strong, readonly) UIColor *progressColor;
@property (nonatomic, strong) NSArray *nativeHandlers;
@property (nonatomic, strong) NSArray *jsHandlers;

@end

