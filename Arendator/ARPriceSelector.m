//
//  ARPriceSelector.m
//  Arendator
//
//  Created by Grig Uskov on 14/9/13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import "ARPriceSelector.h"
#import "DataModel+Helper.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>

@implementation ARPriceSelector {
    Search *_search;
    UISlider *sl_from, *sl_to;
    UILabel *lblFrom, *lblTo;
}


- (id)initWithSearch:(Search *)search {
    self = [super init];
    
    _search = search;
    self.title = NSLocalizedString(@"titlePrice", @"");
    
    return self;
}


- (void)onButtonClick:(UIButton *)sender {
    if (sender.tag == 0) {
        sl_from.value = sl_from.minimumValue;
        _search.priceFrom = nil;
    } else {
        sl_to.value = sl_to.maximumValue;
        _search.priceTo = nil;
    }
    [MagicalRecord saveUsingCurrentThreadContextWithBlock:nil completion:^(BOOL success, NSError *error) {
        if (success) {
            [self updateLablels];
        }
    }];
}


- (void)onSliderValueChanged:(UISlider *)sender {
    int value = round(sender.value / 500) * 500;
    if (sender == sl_from) {
        _search.priceFrom = [NSNumber numberWithInt:value];
        if (!!_search.priceTo && _search.priceFrom.intValue > _search.priceTo.intValue) {
            _search.priceTo = _search.priceFrom;
            sl_to.value = _search.priceTo.integerValue;
        }
    }
    if (sender == sl_to) {
        _search.priceTo = [NSNumber numberWithInt:value];
        if (!!_search.priceFrom && _search.priceFrom.intValue > _search.priceTo.intValue) {
            _search.priceFrom = _search.priceTo;
            sl_from.value = _search.priceFrom.integerValue;
        }
    }
    [MagicalRecord saveUsingCurrentThreadContextWithBlock:nil completion:^(BOOL success, NSError *error) {
        if (success) {
            [self updateLablels];
        }
    }];
}


- (UISlider *)slWithFrame:(CGRect)rect {
    UISlider *result = [[UISlider alloc] initWithFrame:rect];
    result.minimumValue = 1000;
    result.maximumValue = 200000;
    [result addTarget:self action:@selector(onSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    return result;
}


- (void)updateLablels {
    lblFrom.text = NSLocalizedString(@"lblFrom", @"");
    lblTo.text = NSLocalizedString(@"lblTo", @"");
    
    if (!!_search.priceFrom)
        lblFrom.text = [NSString  stringWithFormat:NSLocalizedString(@"pricePerMonth", @""), [NSString stringWithFormat:@"%@ %@", lblFrom.text, _search.humanReadablePriceForm]];
    
    if (!!_search.priceTo)
        lblTo.text = [NSString  stringWithFormat:NSLocalizedString(@"pricePerMonth", @""), [NSString stringWithFormat:@"%@ %@", lblTo.text, _search.humanReadablePriceTo]];
}


#define topGap 75
#define gap 8
#define height 30
#define step (height + 15)
#define width1 180
#define left2 (gap + width1 + gap - 4)
#define btnWith 74

- (void)viewDidLoad {
    [super viewDidLoad];
    
    lblFrom = [[UILabel alloc] initWithFrame:CGRectMake(gap, topGap, width1, height)];
    lblFrom.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lblFrom];
    
    sl_from = [self slWithFrame:CGRectMake(gap, topGap + step * 1, 320 - gap * 2, height)];
    if (!!_search.priceFrom) sl_from.value = _search.priceFrom.intValue; else sl_from.value = sl_from.minimumValue;
    [self.view addSubview:sl_from];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(320 - gap - btnWith , topGap, btnWith, height);
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitle:NSLocalizedString(@"btnDoesNotMatter", @"") forState:UIControlStateNormal];
    btn.tag = 0;
    [btn addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    lblTo = [[UILabel alloc] initWithFrame:CGRectMake(gap, topGap + step * 2, width1, height)];
    lblTo.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lblTo];
    
    sl_to = [self slWithFrame:CGRectMake(gap, topGap + step * 3, 320 - gap * 2, height)];
    if (!!_search.priceTo) sl_to.value = _search.priceTo.intValue; else sl_to.value = sl_from.maximumValue;
    [self.view addSubview:sl_to];
    
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(320 - gap - btnWith , topGap + step * 2, btnWith, height);
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitle:NSLocalizedString(@"btnDoesNotMatter", @"") forState:UIControlStateNormal];
    btn.tag = 1;
    [btn addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [self updateLablels];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tableView.hidden = YES;
}

@end
