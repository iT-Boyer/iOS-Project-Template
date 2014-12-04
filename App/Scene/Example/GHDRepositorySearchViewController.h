//
//  GHDRepositorySearchViewController.h
//  App
//
//  Created by BB9z on 12/4/14.
//  Copyright (c) 2014 Chinamobo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBTableView.h"

@class GHDRepositoryEntity;
@class MBAutoSearchBar;

@interface GHDRepositorySearchViewController : UIViewController
@property (weak, nonatomic) IBOutlet MBAutoSearchBar *searchBar;
@property (weak, nonatomic) IBOutlet MBTableView *tableView;

@end


@interface GHDRepositoryCell : UITableViewCell
@property (strong, nonatomic) GHDRepositoryEntity *item;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@end
