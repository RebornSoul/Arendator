//
//  ARSearchResultsViewController.m
//  Arendator
//
//  Created by Grig Uskov on 14/9/13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import "ARSearchResultsViewController.h"
#import "SearchResult.h"
#import "ARSearchResultViewController.h"

@implementation ARSearchResultsViewController {
    Search *_search;
    NSArray *results;
}

- (id)initWithSearch:(Search *)search {
    self = [super init];
    
    _search = search;
    results = [_search.searchResults allObjects];
    self.title = [NSString stringWithFormat:@"%@ (%i)", NSLocalizedString(@"titleSearchResults", @""), _search.searchResults.count];
    
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return results.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SearchResult *result = results[indexPath.row];
    ARSearchResultViewController *controller = [[ARSearchResultViewController alloc] initWithSearchResult:result];
    [self.navigationController pushViewController:controller animated:YES];    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ruid = @"";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ruid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ruid];
        cell.backgroundColor = [UIColor clearColor];
    }
    [cell prepareForReuse];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    SearchResult *result = results[indexPath.row];
    cell.textLabel.text = result.street;
    
    return cell;
}
@end
