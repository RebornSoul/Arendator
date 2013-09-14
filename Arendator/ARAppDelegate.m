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
#import "GDataXMLParser.h"


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
    [self test];
    return YES;
}

- (void) test {
    NSString *urlString = @"http://www.cian.ru/cat.php?deal_type=1&obl_id=10&city[0]=11622&p=1";
    GDataXMLParser *parser = [[GDataXMLParser alloc] init];
    [parser downloadAndParse:[NSURL URLWithString:urlString]];
}

@end
