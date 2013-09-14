//
//  ARSearchResultsViewController.m
//  Arendator
//
//  Created by Grig Uskov on 14/9/13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import "ARSearchResultsViewController.h"

@implementation ARSearchResultsViewController {
    Search *_search;
}

- (id)initWithSearch:(Search *)search {
    self = [super init];
    
    _search = search;
    
    return self;
}

@end
