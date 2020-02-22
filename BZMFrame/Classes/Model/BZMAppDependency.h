//
//  BZMAppDependency.h
//  Pods
//
//  Created by 杨建祥 on 2020/2/22.
//

#import <UIKit/UIKit.h>
#import "BZMProvider.h"
#import "BZMNavigator.h"

@interface BZMAppDependency : NSObject
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong, readonly) BZMProvider *provider;
@property (nonatomic, strong, readonly) BZMNavigator *navigator;

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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;

+ (instancetype)sharedInstance;

@end

