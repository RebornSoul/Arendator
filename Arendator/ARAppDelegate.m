//
//  ARAppDelegate.m
//  Arendator
//
//  Created by Yury Nechaev on 13.09.13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import "ARAppDelegate.h"
#import "ARTabBarVC.h"
#import "DataModel.h"


@interface  ARAppDelegate ()
@property (nonatomic, strong) UITabBarController *tabBarController;
@end

@implementation ARAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        
    
    self.tabBarController = [ARTabBarVC sharedInstance];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
//    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"ARModel"];
	self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
    return YES;
}

@end
