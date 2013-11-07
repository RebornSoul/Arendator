//
//  ARMapViewController.h
//  Arendator
//
//  Created by Yury Nechaev on 07.11.13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

@class Search;

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CLLocationManager.h>

@interface ARMapViewController : UIViewController <GMSMapViewDelegate>
- (id) initWithSearchResults:(NSArray*)searchResults forSearch:(Search*)search;
@end
