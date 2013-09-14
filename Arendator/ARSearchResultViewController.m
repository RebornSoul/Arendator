//
//  ARSearchResultViewController.m
//  Arendator
//
//  Created by Grig Uskov on 14/9/13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import "ARSearchResultViewController.h"

@implementation ARSearchResultViewController {
    SearchResult *_searchResult;
}

- (id)initWithSearchResult:(SearchResult *)searchResult {
    self = [super init];
    
    _searchResult = searchResult;
    
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = _searchResult.street;
    
    self.tableView.hidden = YES;
}


@end
