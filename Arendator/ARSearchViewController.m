//
//  ARSearchViewController.m
//  Arendator
//
//  Created by Grig Uskov on 14/9/13.
//  Copyright (c) 2013 Yury Nechaev. All rights reserved.
//

#import "ARSearchViewController.h"
#import "ARBaseViewController.h"
#import "DataModel+Helper.h"
#import "DataModel.h"

@implementation ARSearchViewController {
    Search *_search;
    UITextField *titleTF;
    Boolean canceled;
    Boolean newEntity;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (canceled && newEntity) {
        [DataModel deleteObject:_search];
    }
}


- (id)initWithSearch:(Search *)search {
    self = [super init];
    self.title = NSLocalizedString(@"titleSearchVC", @"");
    
    canceled = YES;
    _search = search;
    newEntity = !!!_search;
    if (!_search)
        _search = [Search newInstance];
    
    titleTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 25)];
    titleTF.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.1];
    titleTF.textAlignment = NSTextAlignmentRight;
    titleTF.text = search.title;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"btnSearch", @"") style:UIBarButtonItemStyleDone target:self action:@selector(onSearchClick:)];
    
    return self;
}


- (void)onSearchClick:(UIBarButtonItem *)sender {
    canceled = NO;
    [DataModel save];
    [[[UIAlertView alloc] initWithTitle:@"???" message:@"NOT IMPL" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}


#define ITEM_TITLE 0

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ruid = @"";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ruid];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ruid];
    cell.accessoryView = nil;
    
    switch (indexPath.row) {
        case ITEM_TITLE:
            cell.textLabel.text = NSLocalizedString(@"itemTitle", @"");
            cell.accessoryView = titleTF;
            break;
        default:
            break;
    }
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
