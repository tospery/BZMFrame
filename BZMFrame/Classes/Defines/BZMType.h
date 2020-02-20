//
//  BZMType.h
//  ReactHub
//
//  Created by 杨建祥 on 2019/12/28.
//  Copyright © 2019 杨建祥. All rights reserved.
//

#ifndef BZMType_h
#define BZMType_h

typedef void        (^BZMVoidBlock)(void);
typedef BOOL        (^BZMBoolBlock)(void);
typedef NSInteger   (^BZMIntBlock) (void);
typedef id          (^BZMIdBlock)  (void);

typedef void        (^BZMVoidBlock_bool)(BOOL);
typedef BOOL        (^BZMBoolBlock_bool)(BOOL);
typedef NSInteger   (^BZMIntBlock_bool) (BOOL);
typedef id          (^BZMIdBlock_bool)  (BOOL);

typedef void        (^BZMVoidBlock_int)(NSInteger);
typedef BOOL        (^BZMBoolBlock_int)(NSInteger);
typedef NSInteger   (^BZMIntBlock_int) (NSInteger);
typedef id          (^BZMIdBlock_int)  (NSInteger);

typedef void        (^BZMVoidBlock_string)(NSString *);
typedef BOOL        (^BZMBoolBlock_string)(NSString *);
typedef NSInteger   (^BZMIntBlock_string) (NSString *);
typedef id          (^BZMIdBlock_string)  (NSString *);

typedef void        (^BZMVoidBlock_id)(id);
typedef BOOL        (^BZMBoolBlock_id)(id);
typedef NSInteger   (^BZMIntBlock_id) (id);
typedef id          (^BZMIdBlock_id)  (id);


typedef NS_ENUM(NSInteger, BZMPageKey){
    BZMPageKeyNone,
    BZMPageKeyWeb = 1,                   // 普通网页
    BZMPageKeyInteractiveWeb,            // 交互网页
    BZMPageKeyGuide,                     // 引导页
    BZMPageKeyLogin                      // 登录页
};

typedef NS_ENUM(NSInteger, BZMRequestMode) {
    BZMRequestModeNone,
    BZMRequestModeLoad,
    BZMRequestModeUpdate,
    BZMRequestModeRefresh,
    BZMRequestModeMore,
    BZMRequestModeToast
};

typedef NS_ENUM(NSInteger, BZMReturnType){
    BZMReturnTypeBack,
    BZMReturnTypeClose
};

typedef NS_ENUM(NSInteger, BZMPageComponentPosition){
    BZMPageComponentPositionBottom,
    BZMPageComponentPositionTop
};

typedef NS_ENUM(NSInteger, BZMPageCellClickedPosition){
    BZMPageCellClickedPositionLeft,
    BZMPageCellClickedPositionRight
};

typedef NS_ENUM(NSUInteger, BZMPageMenuCellState) {
    BZMPageMenuCellStateSelected,
    BZMPageMenuCellStateNormal,
};

typedef NS_ENUM(NSUInteger, BZMPageMenuViewStyle) {
    BZMPageMenuViewStyleDefault,
    BZMPageMenuViewStyleLine,
    BZMPageMenuViewStyleTriangle,
    BZMPageMenuViewStyleFlood,
    BZMPageMenuViewStyleFloodHollow,
    BZMPageMenuViewStyleSegmented
};

typedef NS_ENUM(NSUInteger, BZMPageMenuViewLayout) {
    BZMPageMenuViewLayoutScatter,
    BZMPageMenuViewLayoutLeft,
    BZMPageMenuViewLayoutRight,
    BZMPageMenuViewLayoutCenter
};

typedef void(^BZMPageMenuCellSelectedAnimationBlock)(CGFloat percent);

typedef NS_ENUM(NSUInteger, BZMPageMenuComponentPosition) {
    BZMPageMenuComponentPositionBottom,
    BZMPageMenuComponentPositionTop,
};

// cell被选中的类型
typedef NS_ENUM(NSUInteger, BZMPageMenuCellSelectedType) {
    BZMPageMenuCellSelectedTypeUnknown,          //未知，不是选中（cellForRow方法里面、两个cell过渡时）
    BZMPageMenuCellSelectedTypeClick,            //点击选中
    BZMPageMenuCellSelectedTypeCode,             //调用方法`- (void)selectItemAtIndex:(NSInteger)index`选中
    BZMPageMenuCellSelectedTypeScroll            //通过滚动到某个cell选中
};

typedef NS_ENUM(NSUInteger, BZMPageMenuTitleLabelAnchorPointStyle) {
    BZMPageMenuTitleLabelAnchorPointStyleCenter,
    BZMPageMenuTitleLabelAnchorPointStyleTop,
    BZMPageMenuTitleLabelAnchorPointStyleBottom,
};

typedef NS_ENUM(NSUInteger, BZMPageMenuIndicatorScrollStyle) {
    BZMPageMenuIndicatorScrollStyleSimple,                   //简单滚动，即从当前位置过渡到目标位置
    BZMPageMenuIndicatorScrollStyleSameAsUserScroll,         //和用户左右滚动列表时的效果一样
};

typedef NS_ENUM(NSInteger, BZMViewControllerBackType){
    BZMViewControllerBackTypePop,
    BZMViewControllerBackTypeDismiss,
    BZMViewControllerBackTypeClose
};


#endif /* BZMType_h */
