//
//  ARMetroStations.h
//  Arendator
//
//  Created by Grig Uskov on 14/9/13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARMetroStations : NSObject

+ (NSArray *)stationsForCity:(NSInteger)cityId;
+ (NSInteger)metroStationIdByText:(NSString *)text;

@end
