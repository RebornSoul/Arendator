//
//  ARSearchResultViewController.m
//  Arendator
//
//  Created by Grig Uskov on 14/9/13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import "ARSearchResultViewController.h"
#import "DataModel+Helper.h"
#import "ARMetroStations.h"

@implementation ARSearchResultViewController {
    SearchResult *_searchResult;
    UITextView *textView;
}

- (id)initWithSearchResult:(SearchResult *)searchResult {
    self = [super init];
    
    _searchResult = searchResult;
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
#define mapHeight ([UIScreen mainScreen].bounds.size.height / 3)
    UIView *map = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - mapHeight - 48, 320, mapHeight)];
    map.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
    [self.view addSubview:map];
    
    NSString *metroStr = [ARMetroStations stationNameById:_searchResult.metroId.intValue];
    if (_searchResult.distanceFromMetro)
        metroStr = [NSString stringWithFormat:@"%@, %@", metroStr, _searchResult.distanceFromMetro];
    textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 64, 310, self.view.frame.size.height - 48 - 64 - mapHeight)];
    textView.editable = NO;
    textView.font = [UIFont systemFontOfSize:15];
    textView.text = [NSString stringWithFormat:@"%@, %@, %@\n%@\n%@\nм. %@\n--------------------------------------------------\n%@",
                     _searchResult.humanReadablePrice,
                     [NSString stringWithFormat:NSLocalizedString(@"listItemRoomsFMT", @""), _searchResult.rooms.intValue],
                     [NSString stringWithFormat:NSLocalizedString(@"listItemFlorFMT", @""), _searchResult.flor.intValue, _searchResult.florTotal.intValue],
                     [_searchResult.phones stringByReplacingOccurrencesOfString:@"," withString:@", "],
                     [_searchResult.options stringByReplacingOccurrencesOfString:@"," withString:@", "],
                     metroStr,
                     !!_searchResult.info ? _searchResult.info : @""];
    textView.dataDetectorTypes = UIDataDetectorTypePhoneNumber | UIDataDetectorTypeLink  | UIDataDetectorTypeAddress;
    [self.view addSubview:textView];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = [NSString stringWithFormat:@"%@, %@", _searchResult.street, _searchResult.house];
    
    self.tableView.hidden = YES;
}


@end
