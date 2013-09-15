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
#import <GoogleMaps/GoogleMaps.h>

@interface  ARAppDelegate ()
@property (nonatomic, strong) UITabBarController *tabBarController;
@end

static NSString *googleApiKey = @"AIzaSyC2QnFXGejk4NtgLVclQ6PUVE48joyXhiY";

@implementation ARAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        
    
    self.tabBarController = [ARTabBarVC sharedInstance];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
	self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    [GMSServices provideAPIKey:googleApiKey];
    return YES;
}

@end
