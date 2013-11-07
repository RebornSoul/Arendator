//
//  ARMapViewController.m
//  Arendator
//
//  Created by Yury Nechaev on 07.11.13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import "ARMapViewController.h"
#import "SearchResult.h"
#import "SearchCoordinate.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "SBJson.h"
#import "DataModel+Helper.h"


@interface ARMapViewController ()
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) Search *currentSearch;
@property (nonatomic, strong) IBOutlet GMSMapView *mapView;
@property (nonatomic, strong) GMSCameraPosition *cameraPosition;
@end

@implementation ARMapViewController

- (id) initWithSearchResults:(NSArray*)searchResults forSearch:(Search*)search {
    self = [super init];
    if (self) {
        self.dataArray = searchResults;
        self.currentSearch = search;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.mapView setDelegate:self];
    [self.mapView setMyLocationEnabled:YES];
    self.mapView.settings.myLocationButton = YES;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.currentSearch.searchCoordinate) {
        self.cameraPosition = [GMSCameraPosition cameraWithLatitude:self.currentSearch.searchCoordinate.latitude.longValue
                                                          longitude:self.currentSearch.searchCoordinate.longitude.longValue
                                                               zoom:12];
        [self.mapView setCamera:self.cameraPosition];
    } else {
        
    }

    [self processResultsWithGeocoding];
}

- (void) processResultsWithGeocoding {
    __block ARMapViewController *wself = self;
    __block float minLatitude;
    __block float minLongitude;
    __block float maxLatitude;
    __block float maxLongitude;
    for (SearchResult *searchResult in self.dataArray) {
        AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://maps.googleapis.com/maps/api/geocode"]];
        NSString *_address = [@"Санкт-Петербург" stringByAppendingString:searchResult.humanReadableAddress];
        [client getPath:@"json" parameters:[self parametersContructedFromAddress:_address] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSData *recievedData = ((NSData*)responseObject);
            SBJsonParser *parser = [SBJsonParser new];
            id parsedData = [parser objectWithData:recievedData];
            id results = [parsedData objectForKey:@"results"];
            if ([results count]>0) {
                NSDictionary *results2 = results[0][@"geometry"][@"location"];
                //            NSLog(@"Results: %@", results2);
                float lat = [[results2 valueForKey:@"lat"] floatValue];
                float lng = [[results2 objectForKey:@"lng"] floatValue];
                if (minLatitude > lat) minLatitude = lat;
                if (minLongitude > lng) minLongitude = lng;
                if (maxLatitude < lat) maxLatitude = lat;
                if (maxLongitude < lng) maxLongitude = lng;
                //            NSLog(@"LAT: %f LNG: %f", lat, lng);
                GMSMarker *marker = [[GMSMarker alloc] init];
                marker.appearAnimation = kGMSMarkerAnimationPop;
                marker.title = searchResult.price.stringValue;
                marker.position = CLLocationCoordinate2DMake(lat, lng);
                marker.snippet = searchResult.humanReadableAddress;
                marker.map = wself.mapView;
            } else {
                NSLog(@"Status: %@", [parsedData objectForKey:@"status"]);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"ERROR: %@", error.localizedDescription);
        }];
    }
    CGPoint centerPoint = CGPointMake(minLatitude + (maxLatitude - minLatitude)/2, minLongitude + (maxLongitude - minLongitude)/2);
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(centerPoint.x, centerPoint.y);
    self.cameraPosition = [GMSCameraPosition cameraWithTarget:coordinate zoom:10];
}

- (NSDictionary*)parametersContructedFromAddress:(NSString*)address {
    NSMutableDictionary *params = [NSMutableDictionary new];
//    NSString *escapedAddress = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
//                                                                                         (__bridge CFStringRef)address,
//                                                                                         NULL,
//                                                                                         CFSTR("!*'();:@&=+$,/?%#[]\""),
//                                                                                         kCFStringEncodingUTF8));
//    NSLog(@"Escaped address: %@", escapedAddress);
    [params setObject:address forKey:@"address"];
    [params setObject:@"true" forKey:@"sensor"];
    return params;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    return YES;
}
@end
