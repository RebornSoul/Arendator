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

@end


static NSString *generateGUID() {
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidString = (__bridge NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString;
}