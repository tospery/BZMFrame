//
//  BZMLoginViewController.m
//  Pods
//
//  Created by 杨建祥 on 2020/2/23.
//

#import "BZMLoginViewController.h"
#import "BZMLoginViewReactor.h"

@interface BZMLoginViewController ()
@property (nonatomic, strong, readwrite) BZMLoginViewReactor *reactor;

@end

@implementation BZMLoginViewController
@dynamic reactor;

- (instancetype)initWithReactor:(BZMViewReactor *)reactor {
    if (self = [super initWithReactor:reactor]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)bind:(BZMBaseReactor *)reactor {
    [super bind:reactor];
}

@end
