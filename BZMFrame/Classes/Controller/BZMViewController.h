//
//  BZMViewController.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import <UIKit/UIKit.h>
#import "BZMReactive.h"
#import "BZMViewReactor.h"

@interface BZMViewController : UIViewController <BZMReactive>
@property (nonatomic, strong, readonly) BZMViewReactor *reactor;

- (instancetype)initWithReactor:(BZMViewReactor *)reactor;

@end

