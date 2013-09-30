//
//  MCNInitialViewController.h
//  Massuese Connect
//
//  Created by Giles Williams on 05/09/2013.
//  Copyright (c) 2013 Tang Williams. All rights reserved.
//

#import "ECSlidingViewController.h"
#import "MCNPlistedNavigation.h"
#import "MCNLeftMenuViewController.h"

@interface MCNInitialViewController : ECSlidingViewController <MCNLeftMenuViewControllerDelegate>

@property (retain) NSMutableArray *viewControllerStacks;
@property (retain) NSDictionary *currentItem;
@property int selectedVCIndex;
@property bool isFirstOpen;

+ (UIViewController *)viewControllerWithName:(NSString *)name inStoryboard:(NSString *)storyboard;

- (void)switchToViewControllerAtIndex:(int)index animated:(bool)animated;

@end
