//
//  ARRoomCountSelector.m
//  Arendator
//
//  Created by Grig Uskov on 14/9/13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import "ARRoomCountSelector.h"
#import "DataModel.h"

@implementation ARRoomCountSelector {
    Search *_search;    
    UISegmentedControl *sc_from, *sc_to;
}


- (id)initWithSearch:(Search *)search {
    self = [super init];
    
    _search = search;
    self.title = NSLocalizedString(@"titleRoomCount", @"");    
    
    return self;
}

#define topGap 75
#define gap 8
#define height 30
#define step (height + 15)
#define width1 33
#define left2 (gap + width1 + gap - 4)
#define scWidth 190
#define btnWith (320 - gap * 2.5 - scWidth - width1)

- (UISegmentedControl *)scWithFrame:(CGRect)rect {
    UISegmentedControl *result = [[UISegmentedControl alloc] initWithFrame:rect];
    for (int i = 6; i >= 1; i--)
        [result insertSegmentWithTitle:[NSString stringWithFormat:@"%i", i] atIndex:0 animated:NO];
    [result addTarget:self action:@selector(onSCValueChanged:) forControlEvents:UIControlEventValueChanged];
    return result;
}


- (void)onSCValueChanged:(UISegmentedControl *)sender {
    if (sender == sc_from) {
        _search.roomFrom = [NSNumber numberWithInt:sender.selectedSegmentIndex + 1];
        if (!!_search.roomTo && [_search.roomFrom intValue] > [_search.roomTo intValue]) {
            _search.roomTo = _search.roomFrom;
            [sc_to setSelectedSegmentIndex:sender.selectedSegmentIndex];
        }
    }
    if (sender == sc_to) {
        _search.roomTo = [NSNumber numberWithInt:sender.selectedSegmentIndex + 1];
        if (!!_search.roomFrom && [_search.roomFrom intValue] > [_search.roomTo intValue]) {
            _search.roomFrom = _search.roomTo;
            [sc_from setSelectedSegmentIndex:sender.selectedSegmentIndex];
        } 
    }
}


- (void)onButtonClick:(UIButton *)sender {
    if (sender.tag == 0) {
        [sc_from setSelectedSegmentIndex:-1];
        _search.roomFrom = nil;
    } else {
        [sc_to setSelectedSegmentIndex:-1];
        _search.roomTo = nil;
    }
    [DataModel save];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(gap, topGap, width1, height)];
    lbl.text = NSLocalizedString(@"lblFrom", @"");
    lbl.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lbl];
    
    sc_from = [self scWithFrame:CGRectMake(left2, topGap, scWidth, height)];
    if (!!_search.roomFrom) [sc_from setSelectedSegmentIndex:[_search.roomFrom integerValue] - 1];
    [self.view addSubview:sc_from];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(320 - gap - btnWith , topGap, btnWith, height);
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitle:NSLocalizedString(@"btnDoesNotMatter", @"") forState:UIControlStateNormal];
    btn.tag = 0;
    [btn addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(gap, topGap + step * 1, width1, height)];
    lbl.text = NSLocalizedString(@"lblTo", @"");
    lbl.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lbl];
    
    sc_to = [self scWithFrame:CGRectMake(left2, topGap + step * 1, scWidth, height)];
    if (!!_search.roomTo) [sc_to setSelectedSegmentIndex:[_search.roomTo integerValue] - 1];
    [self.view addSubview:sc_to];
    
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(320 - gap - btnWith , topGap + step * 1, btnWith, height);
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitle:NSLocalizedString(@"btnDoesNotMatter", @"") forState:UIControlStateNormal];
    btn.tag = 1;
    [btn addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
/*
 */
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tableView.hidden = YES;
}



@end
