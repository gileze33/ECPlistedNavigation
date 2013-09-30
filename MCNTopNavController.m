//
//  MCNTopNavController.m
//  Massuese Connect
//
//  Created by Giles Williams on 05/09/2013.
//  Copyright (c) 2013 Tang Williams. All rights reserved.
//

#import "MCNTopNavController.h"

@interface MCNTopNavController ()

@end

@implementation MCNTopNavController

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    [self.navigationBar setOpaque:YES];
    [self.navigationBar setTranslucent:NO];
    //[self.navigationBar setBarStyle:UIBarStyleBlack];
    
    if(self.viewControllers.count > 0) {
        UIViewController *theFirstVC = (UIViewController *)self.viewControllers[0];
        theFirstVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NewNavMore.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftNavBarButtonPressed)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)leftNavBarButtonPressed {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

@end
