//
//  ARCIANFetcher.m
//  Arendator
//
//  Created by Yury Nechaev on 14.09.13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import "ARCIANFetcher.h"
#import "AFNetworking.h"
#import "Search.h"
#import "TFHpple.h"

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

- (void)loadResultsForSearch:(Search*)search {
    // 1
    NSURL *tutorialsUrl = [NSURL URLWithString:@"http://www.cian.ru/cat.php?deal_type=1&obl_id=10&city[0]=11622&p=1"];
    NSData *tutorialsHtmlDataRAW = [NSData dataWithContentsOfURL:tutorialsUrl];
    NSString* newStr = [[NSString alloc] initWithData:tutorialsHtmlDataRAW
                                             encoding:NSWindowsCP1251StringEncoding];
    NSData* tutorialsHtmlData = [newStr dataUsingEncoding:NSUTF16StringEncoding];
    
    // 2
    TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:tutorialsHtmlData];
    
    
    // 3
    NSString *tutorialsXpathQueryString = @"//td[@class='cat']";
    NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
    
    // 4
    NSLog(@"Nodes: %i", tutorialsNodes.count);
    for (TFHppleElement *element in tutorialsNodes) {
        //        NSLog(@"Element: %@", element);
        for (TFHppleElement *elementChild in element.children) {
            //            NSLog(@"Content: %@", element);
            for (TFHppleElement *elementChildChild in elementChild.children) {
                NSString *content = elementChildChild.content;
                if (content.length) {
                    NSLog(@"Child tag: %@",elementChildChild.tagName);
                    NSLog(@"Child content: %@", elementChildChild.content);
                } else {
                    for (TFHppleElement *elementChild2 in elementChildChild.children) {
                        NSString *innerContent = elementChild2.content;
                        if (innerContent.length ){
                            NSLog(@"Inner tag: %@",elementChildChild.tagName);
                            NSLog(@"Inner content: %@", elementChild2.content);
                        }
                    }
                }
            }
        }
    }
}






@end
