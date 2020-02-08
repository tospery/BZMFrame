//
//  BZMAppDependency.h
//  Pods
//
//  Created by 杨建祥 on 2019/12/30.
//

#import <UIKit/UIKit.h>

@interface BZMAppDependency : NSObject
@property (nonatomic, strong, readonly) UIWindow *window;

- (instancetype)initWithWindow:(UIWindow *)window;

- (void)initialScreen;

- (void)setupFrame;
- (void)setupVendor;
- (void)setupAppearance;
- (void)setupData;

- (void)entryDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)leaveDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (void)applicationWillResignActive:(UIApplication *)application;
- (void)applicationDidEnterBackground:(UIApplication *)application;
- (void)applicationWillEnterForeground:(UIApplication *)application;
- (void)applicationDidBecomeActive:(UIApplication *)application;
- (void)applicationWillTerminate:(UIApplication *)application;

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;

@end

