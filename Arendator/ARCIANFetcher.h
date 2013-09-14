//
//  ARCIANFetcher.h
//  Arendator
//
//  Created by Yury Nechaev on 14.09.13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface ARCIANFetcher : NSObject
@property (nonatomic, strong) GDataXMLDocument *xmlDocument;

+ (ARCIANFetcher *) sharedInstance;

@end
