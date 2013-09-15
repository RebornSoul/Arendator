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
#import "ARMetroStations.h"
#import "DataModel+Helper.h"

#define rowHeight 68
#define blueColor [UIColor colorWithRed:0 green:122/255. blue:1 alpha:1]

@interface ARSearchResultItemTableViewCell : UITableViewCell  {
    
}

@property (nonatomic, readonly) UILabel *priceLabel;
@property (nonatomic, readonly) UILabel *priceLabel2;
@property (nonatomic, readonly) UILabel *roomLabel;
@property (nonatomic, readonly) UILabel *metroLabel;
@property (nonatomic, readonly) UIImageView *metroIcon;

@end


@implementation ARSearchResultItemTableViewCell

- (id)initWithReuseIdentifier:(NSString *)ruid {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ruid];
    self.backgroundColor = [UIColor clearColor];
    
    self.detailTextLabel.font = [self.detailTextLabel.font fontWithSize:12];
    
    self.textLabel.font = [UIFont systemFontOfSize:16];
    self.textLabel.minimumScaleFactor = 0.5;
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textColor = blueColor;
    _priceLabel.highlightedTextColor = self.textLabel.highlightedTextColor;
    _priceLabel.font = [UIFont boldSystemFontOfSize:24];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    _priceLabel.minimumScaleFactor = 0.5;
    _priceLabel.adjustsFontSizeToFitWidth = YES;
    [self.textLabel.superview addSubview:_priceLabel];
    
    _priceLabel2 = [[UILabel alloc] init];
    _priceLabel2.textColor = blueColor;
    _priceLabel2.highlightedTextColor = self.textLabel.highlightedTextColor;
    _priceLabel2.font = [UIFont boldSystemFontOfSize:11];
    _priceLabel2.textAlignment = NSTextAlignmentCenter;
    [self.textLabel.superview addSubview:_priceLabel2];

    _roomLabel = [[UILabel alloc] init];
    _roomLabel.textColor = blueColor;
    _roomLabel.highlightedTextColor = self.textLabel.highlightedTextColor;
    _roomLabel.font = self.detailTextLabel.font;
    _roomLabel.textAlignment = NSTextAlignmentCenter;
    [self.textLabel.superview addSubview:_roomLabel];
    
    _metroLabel = [[UILabel alloc] init];
    _metroLabel.font = [self.detailTextLabel.font fontWithSize:11];
    _metroLabel.highlightedTextColor = self.textLabel.highlightedTextColor;
    [self.textLabel.superview addSubview:_metroLabel];
    
    _metroIcon = [[UIImageView alloc] init];
    [self.textLabel.superview addSubview:_metroIcon];
    
    return self;
}


- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    _metroLabel.highlighted = highlighted;
    _roomLabel.highlighted = highlighted;
    _priceLabel.highlighted = highlighted;
}


#define priceWidth 50
#define priceHeight 40
#define gap 5
#define topGap 5
#define vertGap 3
#define iconSize 15
- (void)layoutSubviews {
    [super layoutSubviews];
    int leftGap = self.textLabel.frame.origin.x;
    
    int newLeft = leftGap + priceWidth + gap;
    self.textLabel.frame = CGRectMake(newLeft, topGap, self.textLabel.superview.frame.size.width - newLeft, self.textLabel.frame.size.height);
    self.detailTextLabel.frame = CGRectMake(newLeft, self.textLabel.frame.size.height + self.textLabel.frame.origin.y + vertGap, self.detailTextLabel.superview.frame.size.width - newLeft, self.detailTextLabel.frame.size.height);
    
    _priceLabel.frame = CGRectMake(leftGap, topGap, priceWidth, priceHeight * 0.62);
    _priceLabel2.frame = CGRectMake(leftGap, topGap + _priceLabel.frame.size.height, priceWidth, priceHeight * 0.38);
    _roomLabel.frame = CGRectMake(leftGap, topGap + priceHeight + vertGap, priceWidth, self.detailTextLabel.frame.size.height);

    int metroLeft = newLeft + iconSize + 3;
    _metroLabel.frame = CGRectMake(metroLeft, _roomLabel.frame.origin.y, _roomLabel.superview.frame.size.width - metroLeft, self.detailTextLabel.frame.size.height);
    
    _metroIcon.frame = CGRectMake(newLeft, _metroLabel.frame.origin.y, iconSize, iconSize);
    
//    _priceLabel.backgroundColor = [UIColor redColor];
//    _priceLabel2.backgroundColor = [UIColor grayColor];

/*    _metroLabel.backgroundColor = [UIColor greenColor];
    _roomLabel.backgroundColor = [UIColor yellowColor];
    self.textLabel.backgroundColor = [UIColor lightGrayColor];
    self.detailTextLabel.backgroundColor = [UIColor orangeColor]; */
}

@end



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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return rowHeight;
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
    ARSearchResultItemTableViewCell *cell = (ARSearchResultItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ruid];
    if (!cell)
        cell = [[ARSearchResultItemTableViewCell alloc] initWithReuseIdentifier:ruid];

    [cell prepareForReuse];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    SearchResult *result = results[indexPath.row];
    cell.textLabel.text = result.humanReadableAddress;
    cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"listItemFlorFMT", @""), result.flor.intValue, result.florTotal.intValue];
    if (result.options)
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@. %@", cell.detailTextLabel.text, [result.options stringByReplacingOccurrencesOfString:@"," withString:@", "]];
    cell.metroLabel.text = [ARMetroStations stationNameById:result.metroId.intValue];
    if (result.distanceFromMetro)
        cell.metroLabel.text = [NSString stringWithFormat:@"%@, %@", cell.metroLabel.text, result.distanceFromMetro];
    cell.metroIcon.image = [ARMetroStations imageForStationWithId:result.metroId.intValue];
    
    NSString *price = result.humanReadablePrice;
    cell.priceLabel.text = [price componentsSeparatedByString:@" "][0];
    cell.priceLabel2.text = [price componentsSeparatedByString:@" "][1];
    cell.roomLabel.text = [NSString stringWithFormat:NSLocalizedString(@"listItemRoomsFMT", @""), result.rooms.intValue];
    
    return cell;
}
@end
