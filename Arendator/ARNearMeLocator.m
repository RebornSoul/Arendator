//
//  ARNearMeLocator.m
//  Arendator
//
//  Created by Yury Nechaev on 14.10.13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import "ARNearMeLocator.h"
#import "Search.h"


@interface ARNearMeLocator ()
    @property (nonatomic, strong) IBOutlet GMSMapView *mapView;
    @property (nonatomic, strong) Search *currentSearch;
@end

@implementation ARNearMeLocator
    
    - (id) initWithSearch:(Search*)search {
        self = [super init];
        if (self) {
            _currentSearch = search;
        }
        return self;
    }

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.mapView setDelegate:self];
    [self.mapView setMyLocationEnabled:YES];
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    NSLog(@"NewLocation %f %f", location.coordinate.latitude, location.coordinate.longitude);
    NSLog(@"Hotizontal accuracy: %f", location.horizontalAccuracy);
    NSLog(@"Vertical accuracy: %f", location.verticalAccuracy);
    self.currentSearch setLatitude:[NSNumber numberWithDouble:<#(double)#>]
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
//    marker.snippet = NSLocalizedString(@"mePositionSnippet", nil);
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.coordinate.latitude
                                                            longitude:location.coordinate.longitude
                                                                 zoom:MAX(location.horizontalAccuracy, location.verticalAccuracy)];
    [self.mapView setCamera:camera];
    marker.map = self.mapView;

}

@end
