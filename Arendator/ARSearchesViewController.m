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
    NSMutableArray *oldSearches;
}

- (id)init {
    self = [super init];
    self.title = NSLocalizedString(@"tabBarSearch", @"");
    self.tabBarItem.image = [UIImage imageNamed:@"tbSearch"];
    
    return self;
}


- (void)reloadData {
    oldSearches = [NSMutableArray arrayWithArray:[DataModel allInstances:[Search class]]];
    [oldSearches sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Search *s1 = obj1;
        Search *s2 = obj2;
        return [s2.time compare:s1.time];
    }];
    
    [super reloadData];
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
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ruid];
        cell.backgroundColor = [UIColor clearColor];
    }
    [cell prepareForReuse];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == SECT_NEW) {
        cell.textLabel.text = NSLocalizedString(@"itemNewSearch", @"");
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        Search *search = oldSearches[indexPath.row];
        cell.textLabel.text = search.title;
        if (search.serachResults.count > 0)
            cell.textLabel.text = [cell.textLabel.text stringByAppendingFormat:NSLocalizedString(@"resultCountXFlatsFMT", @""), search.serachResults.count];
        cell.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:search.time dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle];
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [oldSearches removeObjectAtIndex:indexPath.row];
        [tableView endUpdates];
        
        Search *search = oldSearches[indexPath.row];
        [DataModel deleteObject:search];
        [DataModel save];
        
        [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.25];
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == SECT_SAVED_SEARCHES;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
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
