//
//  ARBaseViewController.m
//  Arendator
//
//  Created by Grig Uskov on 14/9/13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import "ARBaseViewController.h"

@implementation ARBaseViewController {
    UITableView *tableView;
    UIImageView *landscape;
}


- (void)loadView {
    [super loadView];
    
    tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:tableView];
    
    _landscape = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"landscape"]];
    [self.view addSubview:_landscape];
}

@end
