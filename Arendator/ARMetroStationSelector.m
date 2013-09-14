//
//  ARMetroStationSelector.m
//  Arendator
//
//  Created by Grig Uskov on 14/9/13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import "ARMetroStationSelector.h"
#import "ARMetroStations.h"
#import "DataModel+Helper.h"

@implementation ARMetroStationSelector {
    Search *_search;
    NSArray *stations;
}

- (id)initWithSearch:(Search *)search {
    self = [super init];
    
    _search = search;
    self.title = NSLocalizedString(@"titleMetro", @"");
    
    stations = [ARMetroStations stationsForCity:[_search.cityId intValue]];
    
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return stations.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger stationId = [stations[indexPath.row][@"id"] integerValue];
    [_search checkMetroStation:stationId check:![_search metroStationChecked:stationId]];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ruid = @"";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ruid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ruid];
        cell.backgroundColor = [UIColor clearColor];
    }
    [cell prepareForReuse];
    
    NSDictionary *station = stations[indexPath.row];
    cell.textLabel.text = station[@"name"];
    cell.accessoryType = [_search metroStationChecked:[station[@"id"] integerValue]] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

@end
