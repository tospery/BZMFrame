//
//  UIColor+BZMFrame.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import <UIKit/UIKit.h>
#import <QMUIKit/QMUIKit.h>
#import <DKNightVersion/DKNightVersion.h>

#define BZMColorRGB(r, g, b)                (UIColorMake((r), (g), (b)))
#define BZMColorVal(value)                  ([UIColor bzm_colorWithHex:(value)])
#define BZMColorStr(string)                 ([UIColor qmui_colorWithHexString:(string)])
#define BZMColorKey(t)                      (DKColorPickerWithKey(t)(self.dk_manager.themeVersion))

//#define BZMColorRGB(r, g, b)                 (UIColorMake((r), (g), (b)))
//#define BZMColorKey(t)                       (DKColorPickerWithKey(t)(self.dk_manager.themeVersion))
//#pragma mark 黑白
//#define BZMColorClear                        (UIColorMakeWithRGBA(255, 255, 255, 0))
//#define BZMColorWhite                        (UIColorMake(255, 255, 255))
//#define BZMColorBlack                        (UIColorMake(0, 0, 0))

@interface UIColor (BZMFrame)

@end

