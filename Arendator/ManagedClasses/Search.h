//
//  Search.h
//  Arendator
//
//  Created by Grig Uskov on 14/9/13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SearchResult;

@interface Search : NSManagedObject

@property (nonatomic, retain) NSNumber * allowedChildren;
@property (nonatomic, retain) NSNumber * allowedPets;
@property (nonatomic, retain) NSNumber * cityId;
@property (nonatomic, retain) NSString * metroIdStr;
@property (nonatomic, retain) NSNumber * optBalcony;
@property (nonatomic, retain) NSNumber * optFridge;
@property (nonatomic, retain) NSNumber * optFurniture;
@property (nonatomic, retain) NSNumber * optKitchenFurniture;
@property (nonatomic, retain) NSNumber * optPhone;
@property (nonatomic, retain) NSNumber * optTV;
@property (nonatomic, retain) NSNumber * optWashMachine;
@property (nonatomic, retain) NSNumber * priceFrom;
@property (nonatomic, retain) NSNumber * priceTo;
@property (nonatomic, retain) NSNumber * roomFrom;
@property (nonatomic, retain) NSNumber * roomTo;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *serachResults;
@end

@interface Search (CoreDataGeneratedAccessors)

- (void)addSerachResultsObject:(SearchResult *)value;
- (void)removeSerachResultsObject:(SearchResult *)value;
- (void)addSerachResults:(NSSet *)values;
- (void)removeSerachResults:(NSSet *)values;

@end
