//
//  SearchResult.h
//  Arendator
//
//  Created by Grig Uskov on 14/9/13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Search;

@interface SearchResult : NSManagedObject

@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSNumber * metroId;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * house;
@property (nonatomic, retain) NSNumber * flor;
@property (nonatomic, retain) NSNumber * florTotal;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * priceType;
@property (nonatomic, retain) NSNumber * requireDeposit;
@property (nonatomic, retain) NSNumber * requireExtraMonth;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) NSString * phones;
@property (nonatomic, retain) NSString * options;
@property (nonatomic, retain) NSNumber * rooms;
@property (nonatomic, retain) Search *search;

@end
