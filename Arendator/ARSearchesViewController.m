//
//  ARSearchesViewController.m
//  Arendator
//
//  Created by Grig Uskov on 14/9/13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import "ARSearchesViewController.h"
#import "ARSearchViewController.h"
#import "Search.h"
#import <QuartzCore/QuartzCore.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>

#define blueColor [UIColor colorWithRed:0 green:122/255. blue:1 alpha:1]

@interface ARSearchTableViewCell : UITableViewCell 

@property (nonatomic, readonly) UILabel *leftLabel;

@end


@implementation ARSearchTableViewCell

- (id)initWithReuseIdentifier:(NSString *)ruid {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ruid];
    self.backgroundColor = [UIColor clearColor];
    
    self.detailTextLabel.font = [self.detailTextLabel.font fontWithSize:12];
    
    _leftLabel = [[UILabel alloc] init];
    _leftLabel.backgroundColor = [UIColor clearColor];
    _leftLabel.textColor = blueColor;
    _leftLabel.highlightedTextColor = blueColor;
    _leftLabel.font = [UIFont systemFontOfSize:16];
    _leftLabel.textAlignment = NSTextAlignmentCenter;
    _leftLabel.minimumScaleFactor = 0.5;
    _leftLabel.layer.borderWidth = 1;    
    [self.textLabel.superview addSubview:_leftLabel];
    
    return self;
}


- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    _leftLabel.highlighted = highlighted;
}


#define countWidth 32
- (void)layoutSubviews {
    _leftLabel.backgroundColor = [UIColor clearColor];
    _leftLabel.layer.borderColor = blueColor.CGColor;
    
    [super layoutSubviews];
    int leftGap = self.textLabel.frame.origin.x;
    
    int newLeft = leftGap + countWidth + 7;
    self.textLabel.frame = CGRectMake(newLeft, self.textLabel.frame.origin.y, self.textLabel.superview.frame.size.width - newLeft, self.textLabel.frame.size.height);
    self.detailTextLabel.frame = CGRectMake(newLeft, self.detailTextLabel.frame.origin.y, self.detailTextLabel.superview.frame.size.width - newLeft, self.detailTextLabel.frame.size.height);
    
    _leftLabel.frame = CGRectMake(leftGap, 6, countWidth, countWidth);
    _leftLabel.layer.cornerRadius = countWidth / 2;
}

@end



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
    oldSearches = [NSMutableArray arrayWithArray:[Search findAll]];
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
    NSString *ruid = [NSString stringWithFormat:@"%i", indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ruid];
    if (!cell) {
        cell = indexPath.section == SECT_NEW ? [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ruid] : [[ARSearchTableViewCell alloc] initWithReuseIdentifier:ruid];
        cell.backgroundColor = [UIColor clearColor];
    }
    [cell prepareForReuse];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == SECT_NEW) {
        cell.textLabel.text = NSLocalizedString(@"itemNewSearch", @"");
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"btSearch"];
    } else {
        ARSearchTableViewCell *cell2 = (ARSearchTableViewCell *)cell;
        Search *search = oldSearches[indexPath.row];
        cell2.textLabel.text = search.title.length == 0 ? NSLocalizedString(@"noName", @"") : search.title;
        cell2.leftLabel.text = [NSString stringWithFormat:@"%i", search.searchResults.count];
        cell2.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:search.time dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        Search *search = oldSearches[indexPath.row];
        [search deleteEntity];

        [oldSearches removeObjectAtIndex:indexPath.row];
        [tableView endUpdates];
        
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
