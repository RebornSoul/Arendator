//
//  SearchCoordinate.h
//  Arendator
//
//  Created by Yury Nechaev on 07.11.13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Search;

@interface SearchCoordinate : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * radius;
@property (nonatomic, retain) Search *search;

@end
