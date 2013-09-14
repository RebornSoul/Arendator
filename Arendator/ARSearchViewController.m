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
#import "DataModel.h"

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


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (canceled && newEntity) {
        [DataModel deleteObject:_search];
    }
}


- (UISegmentedControl *)scForValue:(NSNumber *)value {
    UISegmentedControl *result = [[UISegmentedControl alloc] init];
    [result insertSegmentWithTitle:NSLocalizedString(@"doesnotmatter", @"") atIndex:0 animated:NO];
    [result insertSegmentWithTitle:NSLocalizedString(@"no", @"") atIndex:0 animated:NO];
    [result insertSegmentWithTitle:NSLocalizedString(@"yes", @"") atIndex:0 animated:NO];
    [result setSelectedSegmentIndex:!value ? 2 : [value boolValue] ? 0 : 1];
    [result addTarget:self action:@selector(onSCValueChanged:) forControlEvents:UIControlEventValueChanged];
    result.frame = CGRectMake(0, 0, 100, 26);
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
    self.title = NSLocalizedString(@"titleSearchVC", @"");
    
    canceled = YES;
    _search = search;
    newEntity = !!!_search;
    if (!_search)
        _search = [Search newInstance];
    
    titleTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 25)];
    titleTF.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.1];
    titleTF.textAlignment = NSTextAlignmentRight;
    titleTF.text = search.title;
    
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


- (void)onSearchClick:(UIBarButtonItem *)sender {
    canceled = NO;
    [DataModel save];
    
    [[[UIAlertView alloc] initWithTitle:@"???" message:@"NOT IMPL" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//    [someone DOSEARCH:_search]; //ЮРА
}


#define SECT_MAIN 0
#define SECT_MORE 1

#define ITEM_TITLE 0

#define ITEM_allowedChildren 0
#define ITEM_allowedPets 1
#define ITEM_optBalcony 2
#define ITEM_optFridge 3
#define ITEM_optFurniture 4
#define ITEM_optKitchenFurniture 5
#define ITEM_optPhone 6
#define ITEM_optTV 7
#define ITEM_optWashMachine 8

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ruid = @"";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ruid];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ruid];
    [cell prepareForReuse];
    cell.backgroundColor = [UIColor clearColor];
    
    if (indexPath.section == SECT_MAIN)
    switch (indexPath.row) {
        case ITEM_TITLE:
            cell.textLabel.text = NSLocalizedString(@"itemTitle", @"");
            cell.accessoryView = titleTF;
            break;
    } else
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
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == SECT_MAIN ? nil : NSLocalizedString(@"sectionMoreOptions", @"");
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == SECT_MAIN ? 1 : 8;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

@end
