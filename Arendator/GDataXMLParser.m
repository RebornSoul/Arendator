//
//  ARTabBarVC.h
//  Arendator
//
//  Created by Yury Nechaev on 13.09.13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import "GDataXMLParser.h"
#include "GDataXMLNode.h"

@interface GDataXMLParser ()
@property (nonatomic, strong) NSString *currentXPath;
@property (nonatomic, strong) NSSet *currentKeys;

@end

@implementation GDataXMLParser

@synthesize parseFormatter, xmlData, rssConnection;

- (id) initWithXPath:(NSString*)xPath valueKeys:(NSSet*)keys {
    self = [super init];
    if (self) {
        self.currentXPath = xPath;
        self.currentKeys = keys;
    }
    return self;
}

- (void)downloadAndParse:(NSURL *)url {
    
    done = NO;
    self.parseFormatter = [[NSDateFormatter alloc] init];
    [parseFormatter setDateStyle:NSDateFormatterLongStyle];
    [parseFormatter setTimeStyle:NSDateFormatterNoStyle];
//    [parseFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale currentLocale] valueForKey:NSLocaleLanguageCode]]];
    self.xmlData = [NSMutableData data];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:url];
    // create the connection with the request and start loading the data
    rssConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
//    [self performSelectorOnMainThread:@selector(downloadStarted) withObject:nil waitUntilDone:NO];
    if (rssConnection != nil) {
        do {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        } while (!done);
    }
    self.rssConnection = nil;
    self.parseFormatter = nil;
    
}

#pragma mark NSURLConnection Delegate methods

/*
 Disable caching so that each time we run this app we are starting with a clean slate. You may not want to do this in your application.
 */
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

// Forward errors to the delegate.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    done = YES;
//    [self performSelectorOnMainThread:@selector(parseError:) withObject:error waitUntilDone:NO];
}

// Called when a chunk of data has been downloaded.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the downloaded chunk of data.
    [xmlData appendData:data];
}

// Constants for the XML element names that will be considered during the parse. 
// Declaring these as static constants reduces the number of objects created during the run
// and is less prone to programmer error.
static NSString *kXPath_Item = @"/html/body[@id='doc']/table[@id='tbody']/tbody/tr/td/table/tbody/tr/td/div[1]/fieldset/table[@class='cat']/tbody/tr/td[@class='cat']";
static NSString *kObj_Format = @"dl2m_%@_%@"; // td cell id format
static NSString *kObj_Metro = @"metro";
static NSString *kObj_Room = @"room";
static NSString *kObj_Rooms = @"rooms";
static NSString *kObj_Com = @"com";
static NSString *kObj_Floor = @"releasedate";
static NSString *kObj_dopSved = @"dopsved";
static NSString *kObj_Contacts = @"contacts";
static NSString *kObj_Comment = @"comment";


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *error = nil;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if (error) {
        NSLog(@"Parse error: %@", error.localizedDescription);
    }
    NSArray *items = [doc nodesForXPath:kXPath_Item error:nil];
    for (GDataXMLElement *item in items) {
        NSLog(@"Item: %@", item);
        NSArray *metroTitles = [item elementsForName:[NSString stringWithFormat:kObj_Format,kObj_Metro]];
        for(GDataXMLElement *title in metroTitles) {
            NSLog(@"Metro: %@", title.stringValue);
            break;
        }
    }
    self.xmlData = nil;
    done = YES;
}

@end
