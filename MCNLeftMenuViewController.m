//
//  MCNLeftMenuViewController.m
//  Massuese Connect
//
//  Created by Giles Williams on 05/09/2013.
//  Copyright (c) 2013 Tang Williams. All rights reserved.
//

#import "MCNLeftMenuViewController.h"

@interface MCNLeftMenuViewController ()

@end

@implementation MCNLeftMenuViewController

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
    self.firstAppear = YES;
    
    self.lastSelectedIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    self.lastSelectedWasBottomTable = NO;
    
    self.topTableItems = [[NSArray alloc] init];
    self.bottomTableItems = [[NSArray alloc] init];
    
    self.topTableView.delegate = self;
    self.topTableView.dataSource = self;
    self.bottomTableView.delegate = self;
    self.bottomTableView.dataSource = self;
}

- (void)setupWithTopTableItems:(NSArray *)topItems bottomTableItems:(NSArray *)bottomItems {
    int vcIndex = 0;
    int vcCount = 0;
    int sectionHeaderCount = 0;
    
    NSMutableArray *newTopItems = [[NSMutableArray alloc] init];
    for(int x=0;x<topItems.count;x++) {
        NSMutableDictionary *sectionDict = [NSMutableDictionary dictionaryWithDictionary:[topItems objectAtIndex:x]];
        
        if(![sectionDict[@"Title"] isEqualToString:@""]) {
            sectionHeaderCount++;
        }
        
        NSMutableArray *newSectionItems = [[NSMutableArray alloc] init];
        NSArray *sectionItems = sectionDict[@"Items"];
        
        for(int i=0;i<sectionItems.count;i++) {
            NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:[sectionItems objectAtIndex:i]];
            [mutDict setObject:[NSNumber numberWithInt:vcIndex] forKey:@"Index"];
            [newSectionItems addObject:[NSDictionary dictionaryWithDictionary:mutDict]];
            vcIndex++;
            vcCount++;
        }
        [sectionDict setObject:[NSArray arrayWithArray:newSectionItems] forKey:@"Items"];
        [newTopItems addObject:[NSDictionary dictionaryWithDictionary:sectionDict]];
    }
    self.topTableItems = [NSArray arrayWithArray:newTopItems];
    self.topTableViewHeight.constant = ((vcCount)*self.topTableView.rowHeight) + ((sectionHeaderCount)*self.topTableView.sectionHeaderHeight);
    [self.topTableView layoutIfNeeded];
    [self.topTableView reloadData];
    
    vcCount = 0;
    sectionHeaderCount = 0;
    
    NSMutableArray *newBottomItems = [[NSMutableArray alloc] init];
    for(int x=0;x<bottomItems.count;x++) {
        NSMutableDictionary *sectionDict = [NSMutableDictionary dictionaryWithDictionary:[bottomItems objectAtIndex:x]];
        
        if(![sectionDict[@"Title"] isEqualToString:@""]) {
            sectionHeaderCount++;
        }
        
        NSMutableArray *newSectionItems = [[NSMutableArray alloc] init];
        NSArray *sectionItems = sectionDict[@"Items"];
        
        for(int i=0;i<sectionItems.count;i++) {
            NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:[sectionItems objectAtIndex:i]];
            [mutDict setObject:[NSNumber numberWithInt:vcIndex] forKey:@"Index"];
            [newSectionItems addObject:[NSDictionary dictionaryWithDictionary:mutDict]];
            vcIndex++;
            vcCount++;
        }
        [sectionDict setObject:[NSArray arrayWithArray:newSectionItems] forKey:@"Items"];
        [newBottomItems addObject:[NSDictionary dictionaryWithDictionary:sectionDict]];
    }
    self.bottomTableItems = [NSArray arrayWithArray:newBottomItems];
    self.bottomTableViewHeight.constant = ((vcCount)*self.self.bottomTableView.rowHeight) + ((sectionHeaderCount)*self.bottomTableView.sectionHeaderHeight) - 1;
    [self.bottomTableView layoutIfNeeded];
    [self.bottomTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    if(self.firstAppear) {
        //[self setup];
        self.firstAppear = NO;
        [self.topTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)getViewControllerIndexForIndexPath:(NSIndexPath *)indexPath {
    
    
    return 0;
}

- (int)numberOfSectionsInTableView:(UITableView *)tableView {
    if([tableView isEqual:self.topTableView]) {
        return self.topTableItems.count;
    }
    else if([tableView isEqual:self.bottomTableView]) {
        return self.bottomTableItems.count;
    }
    
    return 0;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([tableView isEqual:self.topTableView]) {
        if(section > self.topTableItems.count) {
            return 0;
        }
        
        NSArray *thisSectionItems = [self.topTableItems objectAtIndex:section][@"Items"];
        return thisSectionItems.count;
    }
    else if([tableView isEqual:self.bottomTableView]) {
        if(section > self.bottomTableItems.count) {
            return 0;
        }
        
        NSArray *thisSectionItems = [self.bottomTableItems objectAtIndex:section][@"Items"];
        return thisSectionItems.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([tableView isEqual:self.topTableView]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MCNLeftNavTopCell"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MCNLeftNavTopCell"];
        }
        
        if(indexPath.section < self.topTableItems.count) {
            NSArray *thisSectionItems = [self.topTableItems objectAtIndex:indexPath.section][@"Items"];
            if(indexPath.row < thisSectionItems.count) {
                NSDictionary *thisItem = [thisSectionItems objectAtIndex:indexPath.row];
                cell.textLabel.text = thisItem[@"NavTitle"];
                
                NSNumber *index = (NSNumber *)thisItem[@"Index"];
                if([self.delegate disableMenuOption:thisItem atIndex:[index intValue]]) {
                    cell.textLabel.enabled = NO;
                }
                else {
                    cell.textLabel.enabled = YES;
                }
                if([self.delegate canSelectMenuOptionAtIndex:[index intValue]]) {
                    cell.userInteractionEnabled = YES;
                }
                else {
                    cell.userInteractionEnabled = NO;
                }
            }
        }
        
        return cell;
    }
    else if([tableView isEqual:self.bottomTableView]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MCNLeftNavBottomCell"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MCNLeftNavBottomCell"];
        }
        
        if(indexPath.section < self.bottomTableItems.count) {
            NSArray *thisSectionItems = [self.bottomTableItems objectAtIndex:indexPath.section][@"Items"];
            if(indexPath.row < thisSectionItems.count) {
                NSDictionary *thisItem = [thisSectionItems objectAtIndex:indexPath.row];
                cell.textLabel.text = [thisSectionItems objectAtIndex:indexPath.row][@"NavTitle"];
                
                NSNumber *index = (NSNumber *)thisItem[@"Index"];
                if([self.delegate disableMenuOption:thisItem atIndex:[index intValue]]) {
                    cell.textLabel.enabled = NO;
                }
                else {
                    cell.textLabel.enabled = YES;
                }
                if([self.delegate canSelectMenuOptionAtIndex:[index intValue]]) {
                    cell.userInteractionEnabled = YES;
                }
                else {
                    cell.userInteractionEnabled = NO;
                }
            }
        }
        
        return cell;
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if([tableView isEqual:self.topTableView]) {
        NSString *header = nil;
        
        if(section < self.topTableItems.count) {
            NSString *theTitle = [self.topTableItems objectAtIndex:section][@"Title"];
            if(![theTitle isEqualToString:@""]) {
                header = theTitle;
            }
        }
        
        return header;
    }
    else if([tableView isEqual:self.bottomTableView]) {
        NSString *header = nil;
        
        if(section < self.bottomTableItems.count) {
            NSString *theTitle = [self.bottomTableItems objectAtIndex:section][@"Title"];
            if(![theTitle isEqualToString:@""]) {
                header = theTitle;
            }
        }
        
        return header;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int vcIndex = -1;
    bool isBottomTable = NO;
    NSDictionary *thisItem;
    if([tableView isEqual:self.topTableView]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MCNLeftNavTopCell"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MCNLeftNavTopCell"];
        }
        
        if(indexPath.section < self.topTableItems.count) {
            NSArray *thisSectionItems = [self.topTableItems objectAtIndex:indexPath.section][@"Items"];
            if(indexPath.row < thisSectionItems.count) {
                thisItem = [thisSectionItems objectAtIndex:indexPath.row];
                NSNumber *index = (NSNumber *)thisItem[@"Index"];
                vcIndex = [index intValue];
            }
        }
    }
    else if([tableView isEqual:self.bottomTableView]) {
        isBottomTable = YES;
        if(indexPath.section < self.bottomTableItems.count) {
            NSArray *thisSectionItems = [self.bottomTableItems objectAtIndex:indexPath.section][@"Items"];
            if(indexPath.row < thisSectionItems.count) {
                thisItem = [thisSectionItems objectAtIndex:indexPath.row];
                NSNumber *index = (NSNumber *)thisItem[@"Index"];
                vcIndex = [index intValue];
            }
        }
    }
    
    if(vcIndex > -1) {
        if([self.delegate disableMenuOption:thisItem atIndex:vcIndex]) {
            // TODO
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            if(self.lastSelectedWasBottomTable) {
                [self.bottomTableView selectRowAtIndexPath:self.lastSelectedIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            else {
                [self.topTableView selectRowAtIndexPath:self.lastSelectedIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            
            [self.delegate didSelectMenuOption:thisItem atIndex:vcIndex];
        }
        else {
            [self.delegate didSelectMenuOption:thisItem atIndex:vcIndex];
            
            if(thisItem[@"PresentModally"]) {
                [tableView deselectRowAtIndexPath:indexPath animated:NO];
                if(self.lastSelectedWasBottomTable) {
                    [self.bottomTableView selectRowAtIndexPath:self.lastSelectedIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
                }
                else {
                    [self.topTableView selectRowAtIndexPath:self.lastSelectedIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
                }
            }
            else {
                if(self.lastSelectedWasBottomTable) {
                    [self.bottomTableView deselectRowAtIndexPath:self.lastSelectedIndex animated:NO];
                }
                else {
                    [self.topTableView deselectRowAtIndexPath:self.lastSelectedIndex animated:NO];
                }
                
                self.lastSelectedIndex = indexPath;
                self.lastSelectedWasBottomTable = isBottomTable;
                
                
                if(self.lastSelectedWasBottomTable) {
                    [self.bottomTableView selectRowAtIndexPath:self.lastSelectedIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
                }
                else {
                    [self.topTableView selectRowAtIndexPath:self.lastSelectedIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
                }
            }
        }
    }
}

@end
