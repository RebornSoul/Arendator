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
#import <GoogleMaps/GoogleMaps.h>
#import "AFHTTPClient.h"
#import "SBJson.h"

@interface ARSearchResultViewController ()
@property (nonatomic, strong) GMSMapView *mapView;
@end

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
    
#define mapHeight ([UIScreen mainScreen].bounds.size.height / 2.7)
    CGRect mapFrame = CGRectMake(0, self.view.frame.size.height - mapHeight - 48, 320, mapHeight);

    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://maps.googleapis.com/maps/api/geocode"]];
    __weak ARSearchResultViewController *wself = self;
    NSString *_address = [@"Санкт-Петербург" stringByAppendingString:_searchResult.humanReadableAddress];
    [client getPath:@"json" parameters:[self parametersContructedFromAddress:_address] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *recievedData = ((NSData*)responseObject);
        SBJsonParser *parser = [SBJsonParser new];
        id parsedData = [parser objectWithData:recievedData];
        id results = [parsedData objectForKey:@"results"];
        NSDictionary *results2 = results[0][@"geometry"][@"location"];
        NSLog(@"Results: %@", results2);
        double lat = [[results2 valueForKey:@"lat"] doubleValue];
        double lng = [[results2 objectForKey:@"lng"] doubleValue];
        NSLog(@"LAT: %f LNG: %f", lat, lng);
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(lat, lng);
        marker.snippet = _searchResult.humanReadableAddress;
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat
                                                                longitude:lng
                                                                     zoom:16.0];
        wself.mapView = [GMSMapView mapWithFrame:mapFrame camera:camera];
        wself.mapView.myLocationEnabled = YES;
        marker.map = wself.mapView;
        wself.mapView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
        wself.mapView.alpha = 0;
        [wself.view addSubview:self.mapView];
        [UIView animateWithDuration:0.3 animations:^{
            wself.mapView.alpha = 1;
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", error.localizedDescription);
    }];
    NSString *metroStr = [ARMetroStations stationNameById:_searchResult.metroId.intValue];
    if (!!metroStr) {
        if (_searchResult.distanceFromMetro)
            metroStr = [NSString stringWithFormat:@"%@, %@", metroStr, _searchResult.distanceFromMetro];
    } else
        metroStr = NSLocalizedString(@"noMetroStation", @"");
    textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 64, 310, self.view.frame.size.height - 48 - 64 - mapHeight)];
    textView.editable = NO;
    textView.font = [UIFont systemFontOfSize:15];
    textView.text = [NSString stringWithFormat:@"%@, %@, %@\n%@\n%@\nм. %@\n%@",
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

- (NSDictionary*)parametersContructedFromAddress:(NSString*)address {
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSString *escapedAddress = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                         (__bridge CFStringRef)address,
                                                                                         NULL,
                                                                                         CFSTR("!*'();:@&=+$,/?%#[]\""),
                                                                                         kCFStringEncodingUTF8));
    NSLog(@"Escaped address: %@", escapedAddress);
    [params setObject:address forKey:@"address"];
    [params setObject:@"true" forKey:@"sensor"];
    return params;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = _searchResult.humanReadableAddress;
    
    self.tableView.hidden = YES;
}


@end
