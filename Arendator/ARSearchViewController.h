//
//  ARSearchViewController.h
//  Arendator
//
//  Created by Grig Uskov on 14/9/13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARBaseViewController.h"
#import "Search.h"

@interface ARSearchViewController : ARBaseViewController <UITextFieldDelegate>

- (id)initWithSearch:(Search *)search;

@end
