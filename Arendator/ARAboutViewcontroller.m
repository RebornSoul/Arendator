//
//  ARAboutViewcontroller.m
//  Arendator
//
//  Created by Grig Uskov on 14/9/13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import "ARAboutViewcontroller.h"

@implementation ARAboutViewcontroller

- (id)init {
    self = [super init];
    
    self.title = NSLocalizedString(@"tabBarAbout", @"");
    self.tabBarItem.image = [UIImage imageNamed:@"tbAbout"];
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tableView.hidden = YES;
}

@end
