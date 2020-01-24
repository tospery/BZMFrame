//
//  BZMBaseCommand.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/17.
//

#import "BZMBaseCommand.h"

@interface BZMBaseCommand ()
@property (nonatomic, strong, readwrite) BZMWebViewModel *viewModel;

@end

@implementation BZMBaseCommand
- (instancetype)initWithViewModel:(BZMWebViewModel *)viewModel {
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)handle:(id)data responseCallback:(WVJBResponseCallback)responseCallback {
    
}

@end
