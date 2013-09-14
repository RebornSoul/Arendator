//
//  ARMetroStations.m
//  Arendator
//
//  Created by Grig Uskov on 14/9/13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import "ARMetroStations.h"

@implementation ARMetroStations

static NSArray *_data = nil;
+ (NSArray *)stationsForCity:(NSInteger)cityId {
    if (!_data) {
        NSMutableArray *result = [NSMutableArray array];
        
        NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"spb_metro.json" ofType:nil]];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        result = [NSMutableArray arrayWithArray:dict[@"stations"]];
        [result sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *name1 = ((NSDictionary *)obj1)[@"name"];
            NSString *name2 = ((NSDictionary *)obj2)[@"name"];
            return [name1 compare:name2];
        }];
        _data = [NSArray arrayWithArray:result];
    }
    return _data;
}


+ (NSInteger)metroStationIdByText:(NSString *)text {
    [ARMetroStations stationsForCity:0];
    for (NSDictionary *station in _data) {
        NSString *name = [@"м." stringByAppendingString:text];
        if ([text isEqualToString:name]) return [station[@"id"] integerValue];
    }
    return -1;
}


+ (NSString *)humanReadableSationsStringFormIdString:(NSString *)ids {
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *ssId in [ids componentsSeparatedByString:@","])
        for (NSDictionary *station in _data)
            if ([ssId isEqualToString:station[@"id"]])
                [result addObject:station[@"name"]];
    return [result componentsJoinedByString:@", "];
}

@end
