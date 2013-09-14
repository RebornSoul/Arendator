//
//  DataModel+Helper.h
//  Arendator
//
//  Created by Grig Uskov on 14/9/13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import "Search.h"
#import "SearchResult.h"

@interface SearchResult (Helper)

+ (SearchResult *)newInstanceForSearch:(Search *)parent;

@end


@interface Search (Helper)

+ (Search *)newInstance;

- (Boolean)metroStationChecked:(NSInteger)stationId;
- (void)checkMetroStation:(NSInteger)stationId check:(Boolean)value;

@end

