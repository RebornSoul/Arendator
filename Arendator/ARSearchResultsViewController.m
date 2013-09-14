//
//  ARSearchResultsViewController.m
//  Arendator
//
//  Created by Grig Uskov on 14/9/13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import "ARSearchResultsViewController.h"
#import "SearchResult.h"

@implementation ARSearchResultsViewController {
    Search *_search;
    NSArray *results;
}

- (id)initWithSearch:(Search *)search {
    self = [super init];
    
    _search = search;
    results = [search.searchResults allObjects];
    
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return results.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ruid = @"";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ruid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ruid];
        cell.backgroundColor = [UIColor clearColor];
    }
    [cell prepareForReuse];
    
    SearchResult *result = results[indexPath.row];
    
    
    return cell;
}
@end
