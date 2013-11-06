//
//  ARSearchViewController.m
//  Arendator
//
//  Created by Grig Uskov on 14/9/13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import "ARSearchViewController.h"
#import "ARBaseViewController.h"
#import "DataModel+Helper.h"
#import "ARMetroStationSelector.h"
#import "ARRoomCountSelector.h"
#import "ARPriceSelector.h"
#import "ARMetroStations.h"
#import "ARBlockingView.h"
#import "ARSearchResultsViewController.h"
#import "ARCIANFetcher.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "ARNearMeLocator.h"

@implementation ARSearchViewController {
    Search *_search;
    UITextField *titleTF;
    Boolean canceled;
    Boolean newEntity;
    UISegmentedControl *sc_allowedChildren;
    UISegmentedControl *sc_allowedPets;
    UISegmentedControl *sc_optBalcony;
    UISegmentedControl *sc_optFridge;
    UISegmentedControl *sc_optFurniture;
    UISegmentedControl *sc_optKitchenFurniture;
    UISegmentedControl *sc_optPhone;
    UISegmentedControl *sc_optTV;
    UISegmentedControl *sc_optWashMachine;
}



- (void)updateHeader {
    if (_search.searchResults.count != 0) {
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 58)];
        int gap = 15;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.1];
        btn.frame = CGRectMake(gap, gap, self.tableView.tableHeaderView.frame.size.width - 2 * gap, self.tableView.tableHeaderView.frame.size.height - gap * 1.2);
        [btn setTitle:[NSString stringWithFormat:NSLocalizedString(@"btnPrevResultsFMT", @""), _search.searchResults.count] forState:UIControlStateNormal];
        [self.tableView.tableHeaderView addSubview:btn];
        self.tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(onPrevResultsClick:) forControlEvents:UIControlEventTouchUpInside];
    } else
        self.tableView.tableHeaderView = nil;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateHeader];
    
    [self reloadData];
}


- (void)onPrevResultsClick:(UIButton *)sender {
    ARSearchResultsViewController *controler = [[ARSearchResultsViewController alloc] initWithSearch:_search];
    [self.navigationController pushViewController:controler animated:YES];
}


- (UISegmentedControl *)scForValue:(NSNumber *)value {
    UISegmentedControl *result = [[UISegmentedControl alloc] init];
    [result insertSegmentWithTitle:NSLocalizedString(@"doesnotmatter", @"") atIndex:0 animated:NO];
    [result insertSegmentWithTitle:NSLocalizedString(@"no", @"") atIndex:0 animated:NO];
    [result insertSegmentWithTitle:NSLocalizedString(@"yes", @"") atIndex:0 animated:NO];
    [result setSelectedSegmentIndex:!value ? 2 : [value boolValue] ? 0 : 1];
    [result addTarget:self action:@selector(onSCValueChanged:) forControlEvents:UIControlEventValueChanged];
    result.frame = CGRectMake(0, 0, 100, 28);
    return result;
}


- (void)onSCValueChanged:(UISegmentedControl *)sender {
    NSNumber *value = sender.selectedSegmentIndex == 2 ? nil :[NSNumber numberWithBool:sender.selectedSegmentIndex == 0];
    if (sender == sc_allowedPets) _search.allowedPets = value;
    if (sender == sc_allowedChildren) _search.allowedChildren = value;

    if (sender == sc_optWashMachine) _search.optWashMachine = value;
    if (sender == sc_optTV) _search.optTV = value;
    if (sender == sc_optPhone) _search.optPhone = value;
    if (sender == sc_optKitchenFurniture) _search.optKitchenFurniture = value;
    if (sender == sc_optFurniture) _search.optFurniture = value;
    if (sender == sc_optFridge) _search.optFridge = value;
    if (sender == sc_optBalcony) _search.optBalcony = value;
}


- (id)initWithSearch:(Search *)search {
    self = [super init];
    self.title = NSLocalizedString(@"titleSearch", @"");
    
    canceled = YES;
    _search = search;
    newEntity = !!!_search;
    if (!_search) {
        _search = [Search newInstance];
    }
    
    titleTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 25)];
    titleTF.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.1];
    titleTF.textAlignment = NSTextAlignmentRight;
    titleTF.text = search.title;
    titleTF.delegate = self;
    
    sc_allowedChildren = [self scForValue:_search.allowedChildren];
    sc_allowedPets = [self scForValue:_search.allowedPets];
    sc_optBalcony = [self scForValue:_search.optBalcony];
    sc_optFridge = [self scForValue:_search.optFridge];
    sc_optFurniture = [self scForValue:_search.optFurniture];
    sc_optKitchenFurniture = [self scForValue:_search.optKitchenFurniture];
    sc_optPhone = [self scForValue:_search.optPhone];
    sc_optTV = [self scForValue:_search.optTV];
    sc_optWashMachine = [self scForValue:_search.optWashMachine];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"btnSearch", @"") style:UIBarButtonItemStyleDone target:self action:@selector(onSearchClick:)];
    
    return self;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    _search.title = textField.text;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    _search.title = textField.text;    
    [textField resignFirstResponder];
    return YES;
}


- (void)onSearchClick:(UIBarButtonItem *)sender {
    canceled = NO;
    newEntity = NO;
    
    //[_search clearSearchResults];
    __block NSSet *oldResults = [NSSet setWithSet:_search.searchResults];
    [[ARCIANFetcher sharedInstance] performSearch:_search progress:^(float progress, kSearchStatus status) {
        NSLog(@"------------- > progress: %f", progress);
            ARBlockingView *bv = [ARBlockingView instance];
            [bv.progressView setProgress:progress animated:YES];

//        dispatch_async(dispatch_get_main_queue(), ^{
//            ARBlockingView *bv = [ARBlockingView instance];
//            [bv.progressView setProgress:progress animated:YES];
//        });
    } result:^(BOOL finished, NSArray *searchResults) {
        NSLog(@"------------- > finished");
        [ARBlockingView hide];
        [self updateHeader];
        if (_search.searchResults.count > oldResults.count) {
            for (SearchResult *oldResult in oldResults)
            [oldResult deleteEntity];
            [self onPrevResultsClick:nil];
        } else
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"msgErrorTitle", @"")
                                       message:NSLocalizedString(@"msgErrorNoResults", @"")
                                      delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"btnOK", @"")
                              otherButtonTitles:nil] show];
    } failure:^(NSError *error) {
        [ARBlockingView hide];
        [self updateHeader];
        NSLog(@"------------- > failure %@", error.localizedDescription);
        
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"msgErrorTitle", @"")
                                   message:[NSString stringWithFormat:NSLocalizedString(@"msgDownloadErrorFMT", @""), error.localizedDescription]
                                  delegate:nil
                         cancelButtonTitle:NSLocalizedString(@"btnOK", @"")
                          otherButtonTitles:nil] show];
    }];

    [ARBlockingView showWithTitle:NSLocalizedString(@"pleaseWait", @"")];
    
//    [SearchResult randomTestInstanceForSearch:_search];
//    [SearchResult randomTestInstanceForSearch:_search];
//    [SearchResult randomTestInstanceForSearch:_search];
//    [DataModel save];
//    [self performSelector:@selector(hideTMP) withObject:nil afterDelay:3];
}


- (void)hideTMP {
    [ARBlockingView hide];
    [self updateHeader];
}

#define SECT_MAIN 0
#define SECT_MORE 1

#define ITEM_TITLE 0
#define ITEM_LOCATION 1
#define ITEM_METRO 2
#define ITEM_PRICE 3
#define ITEM_ROOMS 4

#define ITEM_allowedChildren 0
#define ITEM_allowedPets 1
#define ITEM_optBalcony 2
#define ITEM_optFridge 3
#define ITEM_optFurniture 4
#define ITEM_optKitchenFurniture 5
#define ITEM_optPhone 6
#define ITEM_optTV 7
#define ITEM_optWashMachine 8


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == SECT_MAIN)
        switch (indexPath.row) {
            case ITEM_LOCATION: {
                ARNearMeLocator *selector = [[ARNearMeLocator alloc] initWithSearch:_search];
                [self.navigationController pushViewController:selector animated:YES];
                break;
            }
            case ITEM_METRO: {
                ARMetroStationSelector *selector = [[ARMetroStationSelector alloc] initWithSearch:_search];
                [self.navigationController pushViewController:selector animated:YES];
                break;
            }
            case ITEM_PRICE: {
                ARPriceSelector *selector = [[ARPriceSelector alloc] initWithSearch:_search];
                [self.navigationController pushViewController:selector animated:YES];
                break;
            }
            case ITEM_ROOMS: {
                ARRoomCountSelector *selector = [[ARRoomCountSelector alloc] initWithSearch:_search];
                [self.navigationController pushViewController:selector animated:YES];
            }
        }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ruid = [NSString stringWithFormat:@"%i", indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ruid];
    if (!cell) {
        UITableViewCellStyle style = UITableViewCellStyleValue1;
        if (indexPath.section == SECT_MAIN && indexPath.row == ITEM_METRO)
            style = UITableViewCellStyleSubtitle;
        cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:ruid];
        cell.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.minimumScaleFactor = 0.5;
        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    }
    [cell prepareForReuse];
    
    if (indexPath.section == SECT_MAIN)
    switch (indexPath.row) {
        case ITEM_LOCATION:
        cell.textLabel.text = NSLocalizedString(@"itemLocation", @"");
        case ITEM_TITLE:
            cell.textLabel.text = NSLocalizedString(@"itemTitle", @"");
            cell.accessoryView = titleTF;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case ITEM_METRO:
            cell.textLabel.text = NSLocalizedString(@"itemMetro", @"");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = [ARMetroStations humanReadableSationsStringFormIdString:_search.metroIdStr];
            break;
        case ITEM_PRICE:
            cell.textLabel.text = NSLocalizedString(@"itemPrice", @"");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = [NSString  stringWithFormat:NSLocalizedString(@"pricePerMonth", @""), _search.humanReadablePriceRange];
            break;
        case ITEM_ROOMS:
            cell.textLabel.text = NSLocalizedString(@"itemRooms", @"");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = _search.humanReadableRoomRange;
            break;
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.row) {
            case ITEM_allowedChildren:
                cell.textLabel.text = NSLocalizedString(@"ITEM_allowedChildren", @"");
                cell.accessoryView = sc_allowedChildren;
                break;
            case ITEM_allowedPets:
                cell.textLabel.text = NSLocalizedString(@"ITEM_allowedPets", @"");
                cell.accessoryView = sc_allowedPets;
                break;
            case ITEM_optBalcony:
                cell.textLabel.text = NSLocalizedString(@"ITEM_optBalcony", @"");
                cell.accessoryView = sc_optBalcony;
                break;
            case ITEM_optFridge:
                cell.textLabel.text = NSLocalizedString(@"ITEM_optFridge", @"");
                cell.accessoryView = sc_optFridge;
                break;
            case ITEM_optFurniture:
                cell.textLabel.text = NSLocalizedString(@"ITEM_optFurniture", @"");
                cell.accessoryView = sc_optFurniture;
                break;
            case ITEM_optKitchenFurniture:
                cell.textLabel.text = NSLocalizedString(@"ITEM_optKitchenFurniture", @"");
                cell.accessoryView = sc_optKitchenFurniture;
                break;
            case ITEM_optPhone:
                cell.textLabel.text = NSLocalizedString(@"ITEM_optPhone", @"");
                cell.accessoryView = sc_optPhone;
                break;
            case ITEM_optTV:
                cell.textLabel.text = NSLocalizedString(@"ITEM_optTV", @"");
                cell.accessoryView = sc_optTV;
                break;
            case ITEM_optWashMachine:
                cell.textLabel.text = NSLocalizedString(@"ITEM_optWashMachine", @"");
                cell.accessoryView = sc_optWashMachine;
                break;
        }
    }
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == SECT_MAIN ? nil : NSLocalizedString(@"sectionMoreOptions", @"");
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == SECT_MAIN ? 5 : 8;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

@end
