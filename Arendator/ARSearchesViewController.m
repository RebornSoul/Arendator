//
//  ARSearchesViewController.m
//  Arendator
//
//  Created by Grig Uskov on 14/9/13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import "ARSearchesViewController.h"
#import "ARSearchViewController.h"
#import "DataModel.h"
#import "Search.h"

@implementation ARSearchesViewController {
    NSArray *oldSearches;
}

- (id)init {
    self = [super init];
    self.title = NSLocalizedString(@"titleSearch", @"");
    self.tabBarItem.image = [UIImage imageNamed:@"tbSearch"];
    
    return self;
}


- (void)reloadData {
    NSMutableArray *old = [NSMutableArray arrayWithArray:[DataModel allInstances:[Search class]]];
    oldSearches = [old sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(id obj1, id obj2) {
        Search *s1 = obj1;
        Search *s2 = obj2;
        return [s1.time compare:s2.time];
    }];
    
    oldSearches = old;
    [self->_tableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadData];
}


#define SECT_NEW 0
#define SECT_SAVED_SEARCHES 1

#define ITEM_NEW_SEARCH 0

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ARSearchViewController *controller = [[ARSearchViewController alloc] initWithSearch:indexPath.section == SECT_NEW ? nil : oldSearches[indexPath.row]];
    [self.navigationController pushViewController:controller animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ruid = @"";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ruid];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ruid];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == SECT_NEW) {
        cell.textLabel.text = NSLocalizedString(@"itemNewSearch", @"");
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        Search *search = oldSearches[indexPath.row];
        cell.textLabel.text = search.title;
        cell.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:search.time dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle];
    }

    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == SECT_NEW ? nil : NSLocalizedString(@"sectionPreviousSearches", @"");
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == SECT_NEW ? 1 : oldSearches.count;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

@end
