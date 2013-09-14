//
//  ARBaseViewController.h
//  Arendator
//
//  Created by Grig Uskov on 14/9/13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARBaseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
@protected
    UITableView *_tableView;
}

@property (nonatomic, readonly) UIImageView *landscape;

@end
