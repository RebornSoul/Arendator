//
//  ARSearchViewController.m
//  Arendator
//
//  Created by Grig Uskov on 14/9/13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import "ARSearchViewController.h"

@implementation ARSearchViewController {
    UITableView *tableView;
}

- (id)init {
    self = [super init];
    self.title = NSLocalizedString(@"titleSearch", @"");
    
    self.tabBarItem.image = [UIImage imageNamed:@"tbSearch"];
    
    return self;
}


- (void)loadView {
    [super loadView];
    
    tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:tableView];
}

@end
