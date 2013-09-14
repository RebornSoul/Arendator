//
//  DataModel+Helper.m
//  Arendator
//
//  Created by Grig Uskov on 14/9/13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import "DataModel+Helper.h"
#import "DataModel.h"
#import "Search.h"
#import "SearchResult.h"

static NSString *generateGUID() {
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidString = (__bridge NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString;
}

@implementation SearchResult (Helper)

+ (SearchResult *)newInstanceForSearch:(Search *)parent {
    SearchResult *result = (SearchResult *)[DataModel createObjectOfClass:[SearchResult class]];
    if (result) {
        result.uid = generateGUID();
        result.search = parent;
    }
    return result;
}

@end


// ---------------------------------------------------------- //
@implementation Search (Helper)

+ (Search *)newInstance {
    Search *result = (Search *)[DataModel createObjectOfClass:[Search class]];
    if (result) {
        result.uid = generateGUID();
        result.time = [NSDate date];
        result.cityId = @0;
    }
    return result;
}


- (Boolean)metroStationChecked:(NSInteger)stationId {
    NSArray *stations = [self.metroIdStr componentsSeparatedByString:@","];
    for (NSString *station in stations)
        if ([station isEqualToString:[NSString stringWithFormat:@"%i", stationId]])
            return YES;
    return NO;
}


- (void)checkMetroStation:(NSInteger)stationId check:(Boolean)value {
    NSMutableArray *stations = [NSMutableArray arrayWithArray:[self.metroIdStr componentsSeparatedByString:@","]];
    [stations removeObject:[NSString stringWithFormat:@"%i", stationId]];
    if (value)
        [stations addObject:[NSString stringWithFormat:@"%i", stationId]];
    self.metroIdStr = [stations componentsJoinedByString:@","];
}


- (NSString *)humanReadablePriceRange {
    if (!self.priceFrom && !self.priceTo)
        return NSLocalizedString(@"rangeDoesNotMatter", @"");
    if (!!self.priceFrom && !!self.priceTo) {
        if (self.priceFrom.intValue == self.priceTo.intValue)
            return [NSString stringWithFormat:NSLocalizedString(@"priceExactFMT", @""), formatBabki(self.priceFrom)];
        return [NSString stringWithFormat:NSLocalizedString(@"priceFromToFMT", @""), formatBabki(self.priceFrom), formatBabki(self.priceTo)];
    }
    if (!!self.priceFrom)
        return [NSString stringWithFormat:NSLocalizedString(@"priceFromFMT", @""), formatBabki(self.priceFrom)];
    if (!!self.priceTo)
        return [NSString stringWithFormat:NSLocalizedString(@"priceToFMT", @""), formatBabki(self.priceTo)];
    return @"???";
}


static NSString *formatBabki(NSNumber *value) {
    float val = roundf(value.integerValue / 500) / 2;
    NSString *result = [NSString stringWithFormat:@"%.1f", val];
    return [[result stringByReplacingOccurrencesOfString:@".0" withString:@""] stringByReplacingOccurrencesOfString:@",0" withString:@""];
}


- (NSString *)humanReadableRoomRange {
    if (!self.roomFrom && !self.roomTo)
        return NSLocalizedString(@"rangeDoesNotMatter", @"");
    if (!!self.roomFrom && !!self.roomTo) {
        if (self.roomFrom.integerValue == self.roomTo.integerValue)
            return [NSString stringWithFormat:@"%i", self.roomFrom.integerValue];
        return [NSString stringWithFormat:NSLocalizedString(@"rangeFromToFMT", @""), self.roomFrom.integerValue, self.roomTo.integerValue];
    }
    if (!!self.roomFrom)
        return [NSString stringWithFormat:NSLocalizedString(@"rangeFromFMT", @""), self.roomFrom.integerValue];
    if (!!self.roomTo)
        return [NSString stringWithFormat:NSLocalizedString(@"rangeToFMT", @""), self.roomTo.integerValue];
    return @"???";
}

@end