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

@implementation MCNInitialViewController

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
    [menuVC setupWithTopTableItems:navDict[@"Top"] bottomTableItems:navDict[@"Bottom"]];
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

- (void)processSectionDict:(NSDictionary *)sectionDict {
    for(NSDictionary *vcDict in sectionDict[@"Items"]) {
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

- (bool)disableMenuOption:(NSDictionary *)item atIndex:(int)index {
    if(index == 1) {
        return YES;
    }
    
    return NO;
}

- (bool)canSelectMenuOptionAtIndex:(int)index {
    return YES;
}

- (void)didSelectMenuOption:(NSDictionary *)item atIndex:(int)index {
    if([self disableMenuOption:item atIndex:index]) {
        
    }
    else if(item[@"PresentModally"]) {
        if(self.viewControllerStacks[index] != nil) {
            [self resetTopView];
            
            UIViewController *theVC = self.viewControllerStacks[index];
            [self presentViewController:theVC animated:YES completion:^{
                
            }];
        }
    }
    else {
        if(self.viewControllerStacks[index] != nil) {
            self.topViewController = self.viewControllerStacks[index];
            self.selectedVCIndex = index;
            
            
            MCNLeftMenuViewController *leftVC = (MCNLeftMenuViewController *)self.underLeftViewController;
            
            [self resetTopView];
            //[leftVC selectRowAtIndex:index];
        }
        else {
            NSLog(@"Attempted to select a menu item that doesn't yet exist");
        }
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
