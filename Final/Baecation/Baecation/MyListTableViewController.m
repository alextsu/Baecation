//
//  MyListTableViewController.m
//  Baecation
//
//  Created by Alexander Tsu on 5/24/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import "MyListTableViewController.h"
#import "MyListTableViewCell.h"
#import "MyListDetailsTableViewController.h"
#import "ParseHelper.h"
#import "ShareTableViewController.h"

//Purpose: Display lists created by user

@interface MyListTableViewController ()
@property (strong, nonatomic) NSMutableArray * permList;
@end

@implementation MyListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    //Set color of status bar
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 20)];
    statusBarView.backgroundColor = [UIColor colorWithRed:253.0f/255.0f green:94.0f/255.0f blue:112.0f/255.0f alpha:1.0f];
    [self.navigationController.navigationBar addSubview:statusBarView];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [[self editButtonItem] setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //If this view controller was reached from tab bar
     NSLog(@"Tab Bar Selected");
    if(!self.fromBaeTable) {
        //Get data from Parse
        [ParseHelper getListsFromParse];
        [self getDefaults];
        [self.tableView reloadData];
    }
    //If this view controller was reached from the Bae Table. Get Shared Lists from Parse
    else {
        //Set the navigation bar details
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.title = @"Shared Lists";
        
        //Get from Shared Lists from Parse and set array
        [ParseHelper getSharedListsFromParse];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.permList = [[defaults objectForKey:@"sharedList"] mutableCopy];
        
        //Throw a UIAlertView if list is empty
        if (self.permList.count == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please note"
                                                            message:@"None of your baes have shared a list with you yet."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
        
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.permList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myListCell" forIndexPath:indexPath];
    
    //Hide the share button if its from the Bae tab
    if (self.fromBaeTable) {
        cell.shareButton.hidden = YES;
    }
    
    //Get the item at the selected index
    NSDictionary * listItem = [self.permList objectAtIndex:indexPath.row];
    
    //Set the text and font of the item name
    cell.cityName.text = [listItem objectForKey:@"listName"];
    [cell.cityName setFont:[UIFont fontWithName:@"lato-regular" size:18]];
    
    //Set the sub-header based on share setting.
    if([[listItem objectForKey:@"shareSettings"] isEqualToString:@"Private"]) {
        cell.shareSettings.text = [listItem objectForKey:@"shareSettings"];
    }
    else {
        //Call the getNameFromFacebookID helper method to display the name associated with the saved Facebook ID
        cell.shareSettings.text = [NSString stringWithFormat:@"Shared with %@", [self getNameFromFacebookID:[listItem objectForKey:@"shareSettings"]]];
    }
    
    //Set the City image based on the list title and place it in a circle
    NSString * imageStringBuilder = [NSString stringWithFormat:@"%@.png", [listItem objectForKey:@"listName"]];
    cell.cityImage.image = [UIImage imageNamed:imageStringBuilder];
    cell.cityImage.layer.cornerRadius = cell.cityImage.frame.size.height /2;
    cell.cityImage.layer.masksToBounds = YES;
    
    
    return cell;
}

//Get defaults and set the permList array to this
- (void) getDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.permList = [[defaults objectForKey:@"permList"] mutableCopy];
}

//Get friend name from Facebook user ID by retrieving the friends NSDictionary from NSUserDefaults
- (NSString *) getNameFromFacebookID: (NSString *) fbID {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray * friends = [defaults objectForKey:@"friends"];
    
    //Iterate through the Array, check if the given ID matches the iterated item's ID and return the name if there's a match
    for (NSDictionary * friend in friends) {
        if([[friend objectForKey:@"id"] isEqualToString:fbID]) {
            return [friend objectForKey:@"name"];
            
        }
    }
    
    //If the ID is not among the friendlist ID, then the user himself/herself must be the target of the shared list
    return @"me";
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the row from the data source
         NSLog(@"Deleting object: %@", [self.permList objectAtIndex:indexPath.row]);
        
        //remove it
        [ParseHelper deleteListFromParseWithName:[[self.permList objectAtIndex:indexPath.row] objectForKey:@"listName"]];
        [self.permList removeObjectAtIndex:indexPath.row];
        
        //delete the row from the tableviewcontroller
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        
        //Segue back to the tab bar (basically as a work-around for the tableviewcontroller not reloading the new data
        [self performSegueWithIdentifier:@"returnToRoot" sender:self];
        
        //update the defaults to make sure they match what's been deleted
        //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //[defaults setObject:self.permList forKey:@"permList"];
        //[ParseHelper getListsFromParse];
        //[self getDefaults];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"showDetails"]) {
        UINavigationController *navController = [segue destinationViewController];
        MyListDetailsTableViewController * temp = (MyListDetailsTableViewController *)([navController viewControllers][0]);
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [temp setListDetails:[self.permList objectAtIndex:indexPath.row]];
        if (self.fromBaeTable) {
            [temp setFromBaeTable:YES];
        }
    }
    
    if ([[segue identifier] isEqualToString:@"showShareList"]) {
        
        //Get the segue target's view controller
        UINavigationController *navController = [segue destinationViewController];
        ShareTableViewController * temp = (ShareTableViewController *)([navController viewControllers][0]);
        
        //Get the button press index
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
        NSLog(@"Button Pressed at Index %ld", (long)indexPath.row);
        
        //Set the Share Table's selected list to the list entry at the button's index
        [temp setListDetails:[[self.permList objectAtIndex:indexPath.row] mutableCopy]];
    }
}


@end
