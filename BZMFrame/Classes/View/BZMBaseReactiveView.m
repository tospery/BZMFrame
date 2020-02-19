//
//  BZMBaseReactiveView.m
//  ReactHub
//
//  Created by 杨建祥 on 2019/12/30.
//  Copyright © 2019 杨建祥. All rights reserved.
//

#import "BZMBaseReactiveView.h"
#import <QMUIKit/QMUIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <Mantle/Mantle.h>
#import "BZMConstant.h"
#import "BZMFunction.h"
#import "BZMParameter.h"
#import "NSObject+BZMFrame.h"
#import "NSDictionary+BZMFrame.h"

@interface BZMBaseReactiveView ()
@property (nonatomic, strong, readwrite) NSDictionary<NSString *,id> *parameters;
@property (nonatomic, strong, readwrite) id viewModel;

@end

@implementation BZMBaseReactiveView
- (instancetype)initWithRouteParameters:(NSDictionary<NSString *,id> *)parameters {
    if (self = [self initWithFrame:CGRectZero]) {
        self.parameters = parameters;
        id modelObject = BZMStrMember(parameters, BZMParameter.viewModel, nil).bzm_JSONObject;
        if (modelObject && [modelObject isKindOfClass:NSDictionary.class]) {
            NSString *name = NSStringFromClass(self.class);
            name = [name stringByReplacingCharactersInRange:NSMakeRange(name.length - 4, 4) withString:@""];
            Class modelClass = NSClassFromString(name);
            if (modelClass && [modelClass isSubclassOfClass:MTLModel.class]) {
                self.viewModel = [[modelClass alloc] initWithDictionary:(NSDictionary *)modelObject error:nil];
            }
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    }
    return self;
}

- (void)bindViewModel:(id)viewModel {
//    if (self.viewModel == viewModel) {
//        return;
//    }
    self.viewModel = viewModel;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    BZMBaseReactiveView *view = [super allocWithZone:zone];
    @weakify(view)
    [[view rac_signalForSelector:@selector(initWithRouteParameters:)] subscribeNext:^(id x) {
        @strongify(view)
        [view sizeToFit];
        if (view.viewModel) {
            [view bindViewModel:view.viewModel];
        }
    }];
    return view;
}

@end
