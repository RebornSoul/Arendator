//
//  ARCIANFetcher.h
//  Arendator
//
//  Created by Yury Nechaev on 14.09.13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SearchResult;
@class Search;

@interface ARCIANFetcher : NSObject

+ (ARCIANFetcher *) sharedInstance;
- (SearchResult* ) performSearch:(Search*)search;
@end
