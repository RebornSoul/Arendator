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

typedef enum {
    kSearchStatusNone = 0,
    kSearchStatusDataLoading,
    kSearchStatusDataParsing,
    kSearchStatusDataSaving,
    kSearchStatusComplete
} kSearchStatus;

@interface ARCIANFetcher : NSObject

+ (ARCIANFetcher *) sharedInstance;
- (void)performSearch:(Search *)search
      onPage:(NSInteger)page
    progress:(void (^)(float progress, kSearchStatus status))progressBlock
      result:(void (^)(BOOL finished, NSArray *searchResults))successBlock
     failure:(void (^)(NSError *error))failureBlock;
@end
