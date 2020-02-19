//
//  BZMBaseReactiveView.h
//  ReactHub
//
//  Created by 杨建祥 on 2019/12/30.
//  Copyright © 2019 杨建祥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JLRoutes/JLRRouteHandler.h>
#import "BZMReactiveView.h"

@interface BZMBaseReactiveView : UIView <BZMReactiveView, JLRRouteHandlerTarget>
@property (nonatomic, strong, readonly) NSDictionary<NSString *,id> *parameters;
@property (nonatomic, strong, readonly) id viewModel;

@end

