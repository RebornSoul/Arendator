//
//  ARPriceSelector.m
//  Arendator
//
//  Created by Grig Uskov on 14/9/13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import "ARPriceSelector.h"

@implementation ARPriceSelector {
    Search *_search;
}

- (id)initWithSearch:(Search *)search {
    self = [super init];
    
    _search = search;
    self.title = NSLocalizedString(@"titlePrice", @"");
        
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tableView.hidden = YES;
}


@end
