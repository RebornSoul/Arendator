//
//  ARTabBarVC.h
//  Arendator
//
//  Created by Yury Nechaev on 13.09.13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDataXMLParser : NSObject {
    
    NSDateFormatter *parseFormatter;
    NSMutableData *xmlData;
    BOOL done;
    NSURLConnection *rssConnection;
    
}

@property (nonatomic, retain) NSDateFormatter *parseFormatter;
@property (nonatomic, retain) NSMutableData *xmlData;
@property (nonatomic, retain) NSURLConnection *rssConnection;

- (void)downloadAndParse:(NSURL *)url;
- (id) initWithXPath:(NSString*)xPath valueKeys:(NSSet*)keys;

@end
