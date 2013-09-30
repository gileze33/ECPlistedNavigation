//
//  MCNLeftMenuViewController.h
//  Massuese Connect
//
//  Created by Giles Williams on 05/09/2013.
//  Copyright (c) 2013 Tang Williams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCNPlistedNavigation.h"

@protocol MCNLeftMenuViewControllerDelegate <NSObject>

@required
- (void)didSelectMenuOption:(NSDictionary *)item atIndex:(int)index;
- (bool)disableMenuOption:(NSDictionary *)item atIndex:(int)index;
- (bool)canSelectMenuOption:(NSDictionary *)item atIndex:(int)index;

@end

@interface MCNLeftMenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *topTableView;
@property (strong, nonatomic) IBOutlet UITableView *bottomTableView;

@property IBOutlet NSLayoutConstraint *topTableTopPosition;
@property IBOutlet NSLayoutConstraint *topTableViewHeight;
@property IBOutlet NSLayoutConstraint *bottomTableViewHeight;

@property (retain) NSArray *topTableItems;
@property (retain) NSArray *bottomTableItems;
@property id<MCNLeftMenuViewControllerDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *lastSelectedIndex;
@property bool lastSelectedWasBottomTable;

@property bool firstAppear;

- (void)setupWithTopTableItems:(NSArray *)topItems bottomTableItems:(NSArray *)bottomItems;

@end
