//
//  ARNearMeLocator.m
//  Arendator
//
//  Created by Yury Nechaev on 14.10.13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import "ARNearMeLocator.h"
#import "Search.h"
#import "SearchCoordinate.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>


@interface ARNearMeLocator ()
@property (nonatomic, strong) IBOutlet GMSMapView *mapView;
@property (nonatomic, strong) Search *currentSearch;
@property (nonatomic, strong) GMSCameraPosition *cameraPosition;
@property (nonatomic, strong) GMSCircle *mapCircle;
@property (nonatomic, assign) CLLocationCoordinate2D currentCoordinate;
@property (nonatomic, assign) float currentRadius;
@property (nonatomic, strong) IBOutlet UILabel *radiusLabel;
@property (nonatomic, strong) IBOutlet UISlider *slider;
@property (nonatomic, assign) BOOL circleSetup;
@end

@implementation ARNearMeLocator
    
- (id) initWithSearch:(Search*)search {
    self = [super init];
    if (self) {
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
    self.currentRadius = 500;
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel",nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed:)];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save",nil) style:UIBarButtonItemStyleDone target:self action:@selector(savePressed:)];
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Clear",nil) style:UIBarButtonItemStylePlain target:self action:@selector(didClear:)];
    [self.navigationItem setRightBarButtonItems:@[doneButton,clearButton]];
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];

}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.currentSearch.searchCoordinate) {
        NSLog(@"LA:%f", self.currentSearch.searchCoordinate.latitude.floatValue);
        NSLog(@"LO:%f", self.currentSearch.searchCoordinate.longitude.floatValue);
        NSLog(@"RA:%f", self.currentSearch.searchCoordinate.radius.floatValue);
        self.currentCoordinate = CLLocationCoordinate2DMake(self.currentSearch.searchCoordinate.latitude.floatValue, self.currentSearch.searchCoordinate.longitude.floatValue);
        self.currentRadius = self.currentSearch.searchCoordinate.radius.floatValue;
        self.circleSetup = YES;
        [self.slider setValue:self.currentRadius];
        [self updateRadiusLabel];
        [self updateCirclePosition];
        
    }
}

- (void) didClear:(id)sender {
    [self.currentSearch.searchCoordinate deleteEntity];
    self.currentSearch.searchCoordinate = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) savePressed:(id)sender {
    if (self.currentSearch.searchCoordinate) [self.currentSearch.searchCoordinate deleteEntity];
    SearchCoordinate *sc = [SearchCoordinate createEntity];
    if (!sc) sc = [SearchCoordinate createEntity];
    sc.latitude = [NSNumber numberWithFloat:self.currentCoordinate.latitude];
    sc.longitude = [NSNumber numberWithFloat:self.currentCoordinate.longitude];
    sc.radius = [NSNumber numberWithFloat:self.currentRadius];
    [self.currentSearch setSearchCoordinate:sc];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) cancelPressed:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) drawCircleOnMapInCoordinate:(CLLocationCoordinate2D)coordinate withRadius:(double)radius {
    if (!self.mapCircle) {
        self.mapCircle = [GMSCircle circleWithPosition:coordinate
                                                radius:radius];
        self.mapCircle.fillColor = [UIColor colorWithRed:0.25 green:0 blue:0 alpha:0.15];
        self.mapCircle.strokeColor = [UIColor redColor];
        self.mapCircle.strokeWidth = 5;
        self.mapCircle.map = self.mapView;
    } else {
        self.mapCircle.position = coordinate;
        self.mapCircle.radius = radius;
    }
}

- (void) updateCirclePosition {
    [self drawCircleOnMapInCoordinate:self.currentCoordinate withRadius:self.currentRadius];
}

- (IBAction)sliderDidChange:(UISlider*)sender {
    self.circleSetup = YES;
    self.currentRadius = sender.value;
    [self updateRadiusLabel];
    [self drawCircleOnMapInCoordinate:self.currentCoordinate withRadius:self.currentRadius];
}

- (void) updateRadiusLabel {
    [self.radiusLabel setText:[NSString stringWithFormat:NSLocalizedString(@"titleRadius", nil), self.currentRadius]];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    counter += 1;
    CLLocation *location = [locations lastObject];
    NSLog(@"NewLocation %f %f", location.coordinate.latitude, location.coordinate.longitude);
    NSLog(@"Hotizontal accuracy: %f", location.horizontalAccuracy);
    NSLog(@"Vertical accuracy: %f", location.verticalAccuracy);
    if (counter > 5 || fmaxf(location.horizontalAccuracy, location.verticalAccuracy) < 30) {
        [locationManager stopUpdatingLocation];
        self.circleSetup = YES;
    }
    if (!self.circleSetup) self.currentCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);

//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
//    marker.snippet = NSLocalizedString(@"mePositionSnippet", nil);
    if (!self.cameraPosition) {
        self.cameraPosition = [GMSCameraPosition cameraWithLatitude:location.coordinate.latitude
                                                                longitude:location.coordinate.longitude
                                                                     zoom:12];
        [self.mapView setCamera:self.cameraPosition];
        if (!self.circleSetup) [self drawCircleOnMapInCoordinate:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude) withRadius:self.currentRadius];
    }

//    marker.map = self.mapView;

}

@end
