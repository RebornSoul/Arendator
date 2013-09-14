//
//  ARCIANFetcher.m
//  Arendator
//
//  Created by Yury Nechaev on 14.09.13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import "ARCIANFetcher.h"
#import "AFNetworking.h"

@implementation ARCIANFetcher


static double defaultTimeInterval = 60.0;
static ARCIANFetcher *instanceFetcher = nil;

+ (ARCIANFetcher *) sharedInstance {
	static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instanceFetcher = [[ARCIANFetcher alloc] init];
    });
    return instanceFetcher;
}

- (void)fetchDataFromURL:(NSURL*)url result:(void (^)(BOOL finished, NSData *data))successBlock
                            onFailure:(void (^)(NSError *error))failureBlock
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeoutInterval:defaultTimeInterval];
    [request setHTTPMethod:@"GET"];
    AFHTTPRequestOperation *afRequest = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    __weak AFHTTPRequestOperation *wafRequest = afRequest;
    [afRequest setSuccessCallbackQueue:^{
        if (successBlock) {
            successBlock(wafRequest.isFinished, wafRequest.responseData);
        }
    }];
    [afRequest setFailureCallbackQueue:^{
        if (failureBlock) {
            failureBlock(wafRequest.error);
        }
    }];
    [afRequest start];
}





@end
