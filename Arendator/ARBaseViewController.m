//
//  ARBaseViewController.m
//  Arendator
//
//  Created by Grig Uskov on 14/9/13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import "ARBaseViewController.h"

@implementation ARBaseViewController


- (void)reloadData {
    [self.tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (void)loadView {
    [super loadView];
    
    self.view.clipsToBounds = YES;
    
    _landscape = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"landscape"]];
    _landscape.alpha = 0.2;
    [self.view addSubview:_landscape];
    
    _tableView = [[UITableView alloc] init];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.0];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _landscape.frame = CGRectMake(0, self.view.frame.size.height - 60 + 20 - _landscape.image.size.height, _landscape.image.size.width, _landscape.image.size.height);
    
    [self animateLandscape];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _tableView.frame = CGRectMake(0, 64, 320, self.view.frame.size.height - 112);
    
}


- (void)animateLandscape {
    int duration = 120;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _landscape.transform = CGAffineTransformMakeTranslation(-_landscape.image.size.width + 320, 0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            _landscape.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [self animateLandscape];
        }];
    }];
}

@end
