//
//  BZMViewController.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import <UIKit/UIKit.h>
#import "BZMReactive.h"
#import "BZMViewReactor.h"
#import "BZMNavigationBar.h"

typedef NS_ENUM(NSInteger, BZMViewControllerBackType){
    BZMViewControllerBackTypePopOne,
    BZMViewControllerBackTypePopAll,
    BZMViewControllerBackTypeDismiss,
    BZMViewControllerBackTypeClose
};

@interface BZMViewController : UIViewController <BZMReactive>
@property (nonatomic, assign, readonly) CGFloat contentTop;
@property (nonatomic, assign, readonly) CGFloat contentBottom;
@property (nonatomic, assign, readonly) CGRect contentFrame;
@property (nonatomic, strong, readonly) BZMNavigationBar *navigationBar;
@property (nonatomic, strong, readonly) BZMViewReactor *reactor;

- (instancetype)initWithReactor:(BZMViewReactor *)reactor;

@end

