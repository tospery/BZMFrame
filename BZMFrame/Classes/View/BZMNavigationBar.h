//
//  BZMNavigationBar.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/23.
//

#import <UIKit/UIKit.h>

@interface BZMNavigationBar : UIView
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIImageView *bgImageView;
@property (nonatomic, strong, readonly) UIButton *backButton;
@property (nonatomic, strong, readonly) UIButton *closeButton;
@property (nonatomic, strong, readonly) NSArray *leftButtons;
@property (nonatomic, strong, readonly) NSArray *rightButtons;

- (UIButton *)addBackButtonToLeft;
- (UIButton *)addCloseButtonToLeft;
- (UIButton *)addButtonToLeftWithImage:(UIImage *)image;
- (UIButton *)addButtonToRightWithImage:(UIImage *)image;
- (UIButton *)addButtonToRightWithTitle:(NSAttributedString *)title;

- (void)transparet;
- (void)reset;

@end

