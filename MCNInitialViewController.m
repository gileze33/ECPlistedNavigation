//
//  MCNInitialViewController.m
//  Massuese Connect
//
//  Created by Giles Williams on 05/09/2013.
//  Copyright (c) 2013 Tang Williams. All rights reserved.
//

#import "MCNInitialViewController.h"
#import "MCNTopNavController.h"
#import <QuartzCore/QuartzCore.h>

@interface MCNInitialViewController ()

@end

@implementation MCNInitialViewController {
    bool gotFirstItem;
}

+ (UIViewController *)viewControllerWithName:(NSString *)name inStoryboard:(NSString *)storyboard {
    UIStoryboard *theStoryboard = [UIStoryboard storyboardWithName:FormatStoryboardString(storyboard) bundle:nil];
    
    UIViewController *theVC;
    if([name isEqualToString:@""]) {
        theVC = [theStoryboard instantiateInitialViewController];
    }
    else {
        theVC = [theStoryboard instantiateViewControllerWithIdentifier:name];
    }
    
    return theVC;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.isFirstOpen = YES;
    gotFirstItem = NO;
    
    // load the plist
    NSDictionary *navDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Navigation" ofType:@"plist"]];
    
    // setup the menu
    if (![self.underLeftViewController isKindOfClass:[MCNLeftMenuViewController class]]) {
        self.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuVC"];
    }
    MCNLeftMenuViewController *menuVC = (MCNLeftMenuViewController *)self.underLeftViewController;
    //menuVC.topTableItems = navDict[@"Top"];
    //menuVC.bottomTableItems = navDict[@"Bottom"];
    [menuVC setDelegate:self];
    
    [menuVC setupWithTopTableItems:[self preProcessSectionsArray:navDict[@"Top"]] bottomTableItems:[self preProcessSectionsArray:navDict[@"Bottom"]]];
    [self setAnchorRightRevealAmount:200.0f];
    
    self.viewControllerStacks = [[NSMutableArray alloc] init];
    for(NSDictionary *sectionDict in menuVC.topTableItems) {
        [self processSectionDict:sectionDict];
    }
    for(NSDictionary *sectionDict in menuVC.bottomTableItems) {
        [self processSectionDict:sectionDict];
    }
    
    self.topViewController = self.viewControllerStacks[0];
    self.selectedVCIndex = 0;
}

- (NSArray *)preProcessSectionsArray:(NSArray *)sectionsArr {
    NSMutableArray *mutArr = [[NSMutableArray alloc] init];
    
    for(NSDictionary *sectionDict in sectionsArr) {
        NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:sectionDict];
        NSMutableArray *sectionItems = [NSMutableArray arrayWithArray:mutDict[@"Items"]];
        for(NSDictionary *vcDict in mutDict[@"Items"]) {
            if(vcDict[@"HideOnTablet"] && IS_TABLET) {
                [sectionItems removeObject:vcDict];
            }
        }
        mutDict[@"Items"] = [NSArray arrayWithArray:sectionItems];
        [mutArr addObject:mutDict];
    }
    
    return [NSArray arrayWithArray:mutArr];
}

- (void)processSectionDict:(NSDictionary *)sectionDict {
    for(NSDictionary *vcDict in sectionDict[@"Items"]) {
        if(!gotFirstItem) {
            self.currentItem = vcDict;
            gotFirstItem = YES;
        }
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:FormatStoryboardString(vcDict[@"Storyboard"]) bundle:nil];
        UIViewController *theVC;
        if([vcDict[@"StoryboardName"] isEqualToString:@""]) {
            theVC = [storyboard instantiateInitialViewController];
        }
        else {
            theVC = [storyboard instantiateViewControllerWithIdentifier:vcDict[@"StoryboardName"]];
        }
        
        theVC.title = vcDict[@"Title"];
        
        UINavigationController *topNC;
        
        if(vcDict[@"PresentModally"]) {
            topNC = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ModalNC"];
        }
        else {
            topNC = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"TopNC"];
        }
        
        [topNC setViewControllers:[NSArray arrayWithObject:theVC]];
        
        topNC.view.layer.shadowOpacity = 0.75f;
        topNC.view.layer.shadowRadius = 10.0f;
        topNC.view.layer.shadowColor = [UIColor blackColor].CGColor;
        
        [self.viewControllerStacks addObject:topNC];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark MCNLeftMenuTableViewDelegate methods

- (void)didSelectMenuOption:(NSDictionary *)item atIndex:(int)index {
    if([self disableMenuOption:item atIndex:index]) {
        
    }
    else if(item[@"PresentModally"]) {
        if(self.viewControllerStacks[index] != nil) {
            //[self resetTopView];
            
            UIViewController *theVC = self.viewControllerStacks[index];
            [self presentViewController:theVC animated:YES completion:^{
                
            }];
        }
    }
    else {
        if(self.viewControllerStacks[index] != nil) {
            self.topViewController = self.viewControllerStacks[index];
            self.selectedVCIndex = index;
            self.currentItem = item;
            
            MCNLeftMenuViewController *leftVC = (MCNLeftMenuViewController *)self.underLeftViewController;
            
            //[self resetTopView];
            //[leftVC selectRowAtIndex:index];
        }
        else {
            NSLog(@"Attempted to select a menu item that doesn't yet exist");
        }
    }
    [self resetTopView];
}

- (bool)canSelectMenuOption:(NSDictionary *)item atIndex:(int)index {
    return YES;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
