//
//  ARBlockingView.m
//  Arendator
//
//  Created by Grig Uskov on 14/9/13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import "ARBlockingView.h"
#import "ARAppDelegate.h"


@implementation ARBlockingView {
    UILabel *titleLabel;
}


#define top ([UIScreen mainScreen].bounds.size.height / 2 - 15)
- (id)init {
    self = [super init];
    
    self.frame = [UIScreen mainScreen].bounds;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, top, 300, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, top - 20, 20, 20)];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [indicator startAnimating];
    [self addSubview:indicator];
    
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.95];
    
    return self;
}

static ARBlockingView *instance = nil;

+ (void)showWithTitle:(NSString *)title {
    if (instance) return;
    instance = [[ARBlockingView alloc] init];
    instance.alpha = 0;
    [ARBlockingView setTitle:title];
    [((ARAppDelegate *)[UIApplication sharedApplication].delegate).window addSubview:instance];
    [UIView animateWithDuration:0.2 animations:^{
        instance.alpha = 1;
    }];
}


+ (void)setTitle:(NSString *)title {
    if (!instance) return;
    instance->titleLabel.text = title;
}


+ (void)hide {
    if (!instance) return;
    [UIView animateWithDuration:0.2 animations:^{
        instance.alpha = 0;
    } completion:^(BOOL finished) {
        [instance removeFromSuperview];
        instance = nil;
    }];
}


@end
