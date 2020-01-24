//
//  BZMPageContentProtocol.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/11.
//

#import <UIKit/UIKit.h>

@protocol BZMPageContentProtocol <NSObject>
@required
/**
 如果内容是VC，就返回VC.view
 如果内容是View，就返回View自己

 @return 返回内容视图
 */
- (UIView *)contentView;

@optional
/**
 可选实现，内容将要显示的时候调用
 */
- (void)contentWillAppear;

/**
 可选实现，内容显示的时候调用
 */
- (void)contentDidAppear;

/**
 可选实现，内容将要消失的时候调用
 */
- (void)contentWillDisappear;

/**
 可选实现，内容消失的时候调用
 */
- (void)contentDidDisappear;

@end

