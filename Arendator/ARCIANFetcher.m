//
//  ARCIANFetcher.m
//  Arendator
//
//  Created by Yury Nechaev on 14.09.13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import "ARCIANFetcher.h"
#import "Search.h"
#import "TFHpple.h"
#import "DataModel+Helper.h"
#import "ARMetroStations.h"

@implementation ARCIANFetcher

static NSString *defaultRegion = @"10";
static NSString *defaultCity = @"11622";
static ARCIANFetcher *instanceFetcher = nil;

static NSString *xpath			= @"//table[@class='cat']//tr";
static NSString *baseURL		= @"http://www.cian.ru/";
static NSString *baseSuffix		= @"cat.php";

// Currency

static NSString *currencyRUR	= @"р.";
static NSString *currencyUSD	= @"$";
static NSString *currencyEUR	= @"€";

//Object types

static NSString *objectRoom		= @"комната";
static NSString *objectFlat1	= @"1-комн. квартира";
static NSString *objectFlat2	= @"2-комн. квартира";
static NSString *objectFlat3	= @"3-комн. квартира";
static NSString *objectFlat4	= @"4-комн. квартира";
static NSString *objectFlat5	= @"5-комн. квартира";
static NSString *objectFlat6etc	= @"многокомн. квартира";

// Time intervals

static NSString *timeIntervalDay = @"в сутки";

// Расположение
/*
 1 - Москва
 2 - Москвоская область
 10 - Санкт-петербург
 11 - Ленинградская область
*/

static NSString *regionKey		= @"region";			// Регион поиска
static NSString *metroKey		= @"metro[%i]";			// Метро

// Тип недвижимости
static NSString *suburbianKey	= @"suburbian";			// Загородный коттедж {yes}
static NSString *officeKey		= @"offices";			// Нежилое помещение {yes}
/*
 Типы помещений:
 1 - Офис					2 - Торговая площадь		3 - Склад
 4 - Общепит				5 - Cвободного назначения	6 - Гараж
 7 - Производственные		8 - Юридический адрес		9 - Под автосервис
 10 - Продажа бизнеса
*/
static NSString *officeType		= @"office_type[%i]";	// Типы помещений. %i - порядковый индекс параметра в url
static NSString *photoKey		= @"wp";				// Только с фото 1, без фото -1, можно без фото 0
static NSString *dateSorterKey  = @"totime";			// За сегодня -2, За 5 минут 300 итд в секундах
static NSString *contextKey 	= @"context";			// Включает слово
static NSString *acontextKey 	= @"acontext";			// Исключает слово

// Особенности объекта
static NSString *notLastFloorKey 	= @"floornl";		// Не последний этаж 1
static NSString *minFloorKey		= @"minfloor";		// Минимальный этаж объекта, полуподвал -1, подвал -2
static NSString *maxFloorKey		= @"maxfloor";		// Максимальный этаж объекта
static NSString *minFloorNKey		= @"minfloorn";		// Минимальное количество этажей всего
static NSString *maxFloorNKey		= @"maxfloorn";		// Максимальное количество этажей всего

// Метраж
static NSString *minKitchenAreaKey 	= @"minkarea";		// Минимальная площадь кухни
static NSString *maxKitchenAreaKey 	= @"maxkarea";		// Максимальная площадь кухни
static NSString *minLivingAreaKey 	= @"minlarea";		// Минимальная жилая площадь
static NSString *maxLivingAreaKey 	= @"maxlarea";		// Максимальная жилая площадь
static NSString *minAllAreaKey 		= @"minarea";		// Минимальная жилая площадь
static NSString *maxAllAreaKey 		= @"maxarea";		// Максимальная жилая площадь

// Условия
static NSString *rentTypeKey 	= @"type";				// Посуточно 2, От нескольких месяцев 3, От месяца 4, Длительно -2
static NSString *rentPriceTypeKey= @"m2";				// Цена указана за метр квадратный 1
static NSString *currencyKey	= @"currency";			// 1 - Доллар, 2 - Рубли, 3 - Евро
static NSString *spacialTax		= @"zerocom";			// Эксклюзивная комиссия 1
static NSString *minPriceKey	= @"minprice";			// Минимальная цена
static NSString *maxPriceKey	= @"maxprice";			// Максимальная цена
static NSString *dealTypeKey 	= @"deal_type"; 		// 1 - Аренда 2 - Продажа
static NSString *cityKey 		= @"city[%i]"; 			// Город
static NSString *unknown1 		= @"obl_id"; 			// Хз
static NSString *roomKey 		= @"room%i"; 			// %i-комнатная квартира, либо комната 0
static NSString *prepayKey 		= @"maxprepay"; 		// Предоплата до количества месяцев (1-6). Любая -1
static NSString *agentFilter 	= @"cl"; 				// -1 Без "агентам не звонить"
static NSString *pledgeKey		= @"pledge"; 			// Без залога -1, С залогом 1

// Удобства
static NSString *tvKey			= @"tv";				// Наличие телевизора
static NSString *washingMchnKey	= @"wm";				// Стиральная машина
static NSString *fridgeKey  	= @"rfgr";				// Холодильник
static NSString *furnitureKey	= @"mebel";				// Наличие мебели
static NSString *kitchenFurnKey = @"medel_k";			// Наличие кухонной мебели
static NSString *phoneKey		= @"phone";				// С телефоном 1
static NSString *petsKey		= @"pets";				// Можно с животными 1
static NSString *kidsKey		= @"kids";				// Можно с детьми 1
static NSString *balkonKey 		= @"minibalkon"; 		// Без балкона -1, Только с балконом 1


+ (ARCIANFetcher *) sharedInstance {
	static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instanceFetcher = [[ARCIANFetcher alloc] init];
    });
    return instanceFetcher;
}


static NSString *strBetween(NSString *src, NSString *from, NSString *to) {
    NSRange range = [src rangeOfString:from];
    if (range.length != 0) {
        src = [src substringFromIndex:range.location + range.length];
        range = [src rangeOfString:to];
        if (range.length != 0)
            return [src substringToIndex:range.location];
    }
    return nil;
}


- (void)performSearch:(Search *)search
             progress:(void (^)(float progress, kSearchStatus status))progressBlock
               result:(void (^)(BOOL finished, NSArray *searchResults))successBlock
              failure:(void (^)(NSError *error))failureBlock {
    if (progressBlock) progressBlock(0.05, kSearchStatusDataLoading);
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    NSDictionary *requestParams = [self parametersContructedFromSearch:search];
    if (progressBlock) progressBlock(0.25, kSearchStatusDataLoading);
    [httpClient getPath:baseSuffix parameters:requestParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (progressBlock) progressBlock(0.5, kSearchStatusDataParsing);
        NSData *recievedData = ((NSData*)responseObject);
        NSString* newStr = [[NSString alloc] initWithData:recievedData
                                                 encoding:NSWindowsCP1251StringEncoding];
        NSData* encodedData = [newStr dataUsingEncoding:NSUTF16StringEncoding];
        TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:encodedData];
        NSString *tutorialsXpathQueryString = xpath;
        NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
        NSLog(@"Nodes: %i", [tutorialsNodes count]);
        BOOL firstElement = YES;
        NSMutableArray *returnArray = [NSMutableArray new];
        int grandCounter = 0;
        for (TFHppleElement *element in tutorialsNodes) {
            if (firstElement) firstElement = NO;
            else {
                // Creating search result
                SearchResult *sresult = [SearchResult newInstanceForSearch:search];
                int upperCounter = 0;
                for (TFHppleElement *elementChild in element.children) {
                    NSLog(@"~============================{ %i", upperCounter);
                    NSLog(@"%i: Content: %@", upperCounter, element.content);
                    upperCounter += 1;
                    int midCounter = 0;
                    for (TFHppleElement *elementChildChild in elementChild.children) {
                        if (upperCounter == 6 && midCounter == 0) { // Тип квартиры
                            NSString *obj = [elementChildChild.attributes objectForKey:@"title"];
                            if (obj.length) {
                                if ([obj rangeOfString:objectRoom].location != NSNotFound) sresult.rooms = [NSNumber numberWithInt:0];
                                if ([obj rangeOfString:objectFlat1].location != NSNotFound) sresult.rooms = [NSNumber numberWithInt:1];
                                if ([obj rangeOfString:objectFlat2].location != NSNotFound) sresult.rooms = [NSNumber numberWithInt:2];
                                if ([obj rangeOfString:objectFlat3].location != NSNotFound) sresult.rooms = [NSNumber numberWithInt:3];
                                if ([obj rangeOfString:objectFlat4].location != NSNotFound) sresult.rooms = [NSNumber numberWithInt:4];
                                if ([obj rangeOfString:objectFlat5].location != NSNotFound) sresult.rooms = [NSNumber numberWithInt:5];
                                if ([obj rangeOfString:objectFlat6etc].location != NSNotFound) sresult.rooms = [NSNumber numberWithInt:6];
                                if (!sresult.rooms) sresult.rooms = [NSNumber numberWithInt:0];
                            } else {
                                sresult.rooms = [NSNumber numberWithInt:0];
                            }
                        }
                        if (upperCounter == 4 && midCounter == 11) { // Метро
                            NSString *rawStr = elementChildChild.raw;
                            rawStr = strBetween(rawStr, @"metro[0]=", @"\"");
                            sresult.metroId = !!rawStr ? [NSNumber numberWithInt:rawStr.integerValue] : @-1;
                        }
                        if (upperCounter == 4 && midCounter == 4) { // Улица
                            NSString *rawStr = elementChildChild.raw;
                            rawStr = strBetween(rawStr, @">", @"<");
                            rawStr = [rawStr stringByReplacingOccurrencesOfString:@"улица" withString:@"ул."];
                            rawStr = [rawStr stringByReplacingOccurrencesOfString:@"проспект" withString:@"пр."];
                            rawStr = [rawStr stringByReplacingOccurrencesOfString:@"площадь" withString:@"пл."];
                            rawStr = [rawStr stringByReplacingOccurrencesOfString:@"набережная" withString:@"наб."];
                            rawStr = [rawStr stringByReplacingOccurrencesOfString:@"переулок" withString:@"пер."];
                            sresult.street = rawStr;
                        }
                        if (upperCounter == 4 && midCounter == 6) { // Дом
                            NSString *rawStr = elementChildChild.raw;
                            rawStr = strBetween(rawStr, @">", @"<");
                            sresult.house = rawStr;
                        }
                        if (upperCounter == 18 && midCounter == 0) { // телефон
                            NSString *rawStr = elementChildChild.raw;
                            rawStr = strBetween(rawStr, @">", @"<");
                            sresult.phones = !!rawStr ? [@"+7" stringByAppendingString:rawStr] : nil;
                        }
                        if (upperCounter == 20 && midCounter == 5) { // ID
                            NSString *rawStr = elementChildChild.raw;
                            rawStr = strBetween(strBetween(rawStr, @">", @"<"), @":", @"&");
                            sresult.id = !!rawStr ? rawStr : nil;
                        }
                        if (upperCounter == 8 && midCounter == 0) { // Кух. Мебель
                            
                        }
                        if (upperCounter == 10 && midCounter == 0) { // Цена
                            NSLog(@"Price: %@", elementChildChild.content);
                            NSString *priceString = elementChildChild.content;
                            if ([priceString rangeOfString:currencyRUR].location != NSNotFound) sresult.priceCurrency = [NSNumber numberWithInt:2];
                            if ([priceString rangeOfString:currencyEUR].location != NSNotFound) sresult.priceCurrency = [NSNumber numberWithInt:3];
                            if ([priceString rangeOfString:currencyUSD].location != NSNotFound) sresult.priceCurrency = [NSNumber numberWithInt:1];
                            priceString = [priceString stringByReplacingOccurrencesOfString:@" " withString:@""];
                            priceString = [priceString stringByReplacingOccurrencesOfString:@"," withString:@""];
                            NSLog(@"Price string: %@", priceString);
                            NSNumber *priceNumber = [NSNumber numberWithInteger:[priceString integerValue]];
                            NSLog(@"Price number: %@", priceNumber.stringValue);
                            sresult.price = priceNumber;
                        }
                        if (upperCounter == 10 && midCounter == 2) { // в сутки
                            NSLog(@"Тип цены: %@", elementChildChild.content);
                            if (elementChildChild.content.length) {
                                if ([elementChildChild.content isEqualToString:timeIntervalDay]) {
                                    sresult.priceType = [NSNumber numberWithInt:1];
                                } else {
                                    sresult.priceType = [NSNumber numberWithInt:0];
                                }
                            } else {
                                sresult.priceType = [NSNumber numberWithInt:0];
                            }
                        }
                        if (upperCounter == 12 && midCounter == 0) { // Процент комиссии
                            
                        }
                        if (upperCounter == 14 && midCounter == 0) { // Этаж х/у
                            NSArray *components = [elementChildChild.content componentsSeparatedByString:@"/"];
							sresult.flor = [NSNumber numberWithInteger:[[components firstObject] integerValue]];
                            sresult.florTotal = [NSNumber numberWithInteger:[[components lastObject] integerValue]];
                        }
                        if (upperCounter == 16 && (midCounter == 0 || midCounter == 2 || midCounter == 4 || midCounter == 6 || midCounter == 8 || midCounter == 10 || midCounter == 12 || midCounter == 14)) { // Опции
                            NSLog(@"Option: %@", elementChildChild.content);
                            NSString *optionContent = [elementChildChild.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                            if (optionContent.length > 0) {
                                if (!sresult.options) sresult.options = @""; else sresult.options = [sresult.options stringByAppendingString:@","];
                                sresult.options = [sresult.options stringByAppendingString:optionContent];
                            }
                        }
                        if (upperCounter == 20 && midCounter == 8) { // Описание
                            if (elementChildChild.content.length) {
                                sresult.info = elementChildChild.content;
                            }
                        }
                        NSLog(@"%i,%i: Content: %@", upperCounter,midCounter, elementChildChild.content);
                        NSLog(@"%i,%i: Attributes: %@", upperCounter, midCounter, elementChildChild.attributes);
                        NSLog(@"%i,%i: Raw: %@", upperCounter, midCounter, elementChildChild.raw);
                        midCounter += 1;
                        int counter = 0;
                        for (TFHppleElement *subElement in elementChildChild.children) {
                            NSLog(@"~=========={ %i }===========~", counter);
                            NSLog(@"%i,%i,%i: Sub content: %@", upperCounter,midCounter,counter, elementChildChild.content);
                            counter += 1;
                            int lowerCounter = 0;
                            for (TFHppleElement *sub2Element in subElement.children) {
                                NSLog(@"~========{ %i", lowerCounter);
                                NSLog(@"%i,%i,%i,%i: Sub sub content: %@", upperCounter,midCounter,counter,lowerCounter, sub2Element.content);
                                lowerCounter += 1;
                                for (TFHppleElement *sub3Element in sub2Element.children) {
                                    NSLog(@"Sub sub sub content: %@", sub3Element.content);
                                    for (TFHppleElement *sub4Element in sub3Element.children) {
                                        NSLog(@"Sub sub sub sub content: %@", sub4Element.content);
                                        
                                    }
                                }
                            }
                        }
                    }
                }
                grandCounter += 1;
                // Убираем последнюю запятую
                if (sresult.options.length) {
                    if ([[sresult.options substringFromIndex:sresult.options.length-1] isEqualToString:@","])
                        sresult.options = [sresult.options substringToIndex:sresult.options.length-1];
                }
                [returnArray addObject:sresult];
            }
            NSLog(@"==============================================================");
        }
        if (successBlock) successBlock(YES, returnArray);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock) failureBlock(error);
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
    }];
}

- (NSDictionary*)parametersContructedFromSearch:(Search*)search {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (search.allowedChildren.boolValue) [params setObject:@"1" forKey:kidsKey];
    if (search.allowedPets.boolValue) [params setObject:@"1" forKey:petsKey];
// TODO: replace this with valid city ids
    [params setObject:defaultCity forKey:[NSString stringWithFormat:cityKey,0]];
    [params setObject:defaultRegion forKey:regionKey];
//    if (search.cityId) [params setObject:search.cityId.stringValue forKey:regionKey];
    if (search.metroIdStr) {
        NSArray *metroArray = [search.metroIdStr componentsSeparatedByString:@","];
        NSMutableDictionary *metroDict = [NSMutableDictionary new]; int counter = 0;
        for (NSString *metro in metroArray) {
            [metroDict setObject:metro forKey:[NSString stringWithFormat:metroKey, counter]];
            counter += 1;
        }
        [params addEntriesFromDictionary:metroDict];
    }
    if (search.optBalcony.boolValue) [params setObject:@"1" forKey:balkonKey];
    if (search.optFridge.boolValue) [params setObject:@"1" forKey:fridgeKey];
    if (search.optFurniture.boolValue) [params setObject:@"1" forKey:furnitureKey];
    if (search.optKitchenFurniture.boolValue) [params setObject:@"1" forKey:kitchenFurnKey];
    if (search.optPhone) [params setObject:@"1" forKey:phoneKey];
    if (search.optTV) [params setObject:@"1" forKey:tvKey];
    if (search.optWashMachine) [params setObject:@"1" forKey:washingMchnKey];
    if (search.priceFrom) [params setObject:search.priceFrom.stringValue forKey:minPriceKey];
    if (search.priceTo) [params setObject:search.priceTo.stringValue forKey:maxPriceKey];
    NSLog(@"%@",params);
    return params;
}

@end
