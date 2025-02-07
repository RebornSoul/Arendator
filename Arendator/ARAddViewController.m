//
//  ARAddViewController.m
//  Arendator
//
//  Created by Grig Uskov on 14/9/13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import "ARAddViewController.h"

@implementation ARAddViewController

- (id)init {
    self = [super init];
    
    self.title = NSLocalizedString(@"tabBarPlus", @"");
    self.tabBarItem.image = [UIImage imageNamed:@"tbPlus"];
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tableView.hidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(160 - 117, 100, 235, 235)];
    iv.image = [UIImage imageNamed:@"imgComingSoon"];
    [self.view addSubview:iv];
}


@end
