//
//  BZMAppDependency.m
//  Pods
//
//  Created by 杨建祥 on 2019/12/30.
//

#import "BZMAppDependency.h"
#import <JLRoutes/JLRoutes.h>
#import "BZMConst.h"
#import "BZMFunction.h"
#import "BZMUser.h"

BZMUser *gUser;

@interface BZMAppDependency ()
@property (nonatomic, strong, readwrite) UIWindow *window;

@end

@implementation BZMAppDependency
#pragma mark - Init
- (instancetype)initWithWindow:(UIWindow *)window {
    if (self = [super init]) {
        self.window = window;
        [self setupFrame];
        [self setupVendor];
        [self setupAppearance];
        [self setupData];
    }
    return self;
}

#pragma mark - Setup
- (void)setupFrame {
    
}

- (void)setupVendor {
    
}

- (void)setupAppearance {
    
}

- (void)setupData {
    Class cls = NSClassFromString(@"User");
    SEL sel = NSSelectorFromString(@"cachedObject");
    if (cls && sel && [cls respondsToSelector:sel]) {
        gUser = ((id (*)(id, SEL))[cls methodForSelector:sel])(cls, sel);
        if (!gUser) {
            gUser = [[cls alloc] init];
        }
    } else {
        gUser = [[BZMUser alloc] init];
    }
}

#pragma mark - Launch
- (void)entryDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
}

- (void)leaveDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
}

#pragma mark - Status
- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [gUser saveWithKey:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    BZMLog(kBZMFrameName, @"disk = %@", NSHomeDirectory());
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [gUser saveWithKey:nil];
}

#pragma mark - URL
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [JLRoutes routeURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [JLRoutes routeURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    return [JLRoutes routeURL:url];
}

@end
