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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(60, 90, 200, 160)];
    iv.image = [UIImage imageNamed:@"imgAbout"];
    [self.view addSubview:iv];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 260, 280, 180)];
    lbl.text = NSLocalizedString(@"aboutText", @"");
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.numberOfLines = 999;
    [self.view addSubview:lbl];
}

@end
