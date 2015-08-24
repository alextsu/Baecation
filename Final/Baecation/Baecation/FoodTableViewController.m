//
//  FoodTableViewController.m
//  Baecation
//
//  Created by Alexander Tsu on 5/22/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import "FoodTableViewController.h"
#import "YPAPISample.h"
#import "FoodTableViewCell.h"
#import "ListPopoverTableViewController.h"
#import "YelpViewController.h"

//Purpose: Display Food (and Tourist) Destinations via Yelp API. Allow users to add entries to their list

@interface FoodTableViewController ()

@property (strong, nonatomic) NSArray * restaurants;
@property (strong, nonatomic) ListPopoverTableViewController * lptvc;
@property (strong, nonatomic) NSMutableDictionary * imageCache;
@property NSInteger selectedIndex;
@end

@implementation FoodTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set title
    if(self.isTourist) {
        self.navigationItem.title = @"Destinations";
    }
    else {
        self.navigationItem.title = @"Food";
    }
    
    //Get results from Yelp
    [self queryYelp];
    
    //Instantiate an image cache
    self.imageCache = [[NSMutableDictionary alloc] init];
    
    //Set the background to an image
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;
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
    return [self.restaurants count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"foodCell" forIndexPath:indexPath];
    
    //Make the cells transparent and remove selection of the cell itself
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    tableView.backgroundColor = [UIColor clearColor];
    
    //Set text and font of establishment
    cell.restaurantName.text = [[self.restaurants objectAtIndex:indexPath.row] objectForKey:@"name"];
    [cell.restaurantName setFont:[UIFont fontWithName:@"lato-regular" size:18]];
    
    //Get the category and location and set the cell's subheader to that
    NSArray * categoryList = [[self.restaurants objectAtIndex:indexPath.row]objectForKey:@"categories"];
    NSDictionary * location = [[self.restaurants objectAtIndex:indexPath.row]objectForKey:@"location"];
    NSArray * neighborhood = [location objectForKey:@"neighborhoods"];
    if (neighborhood != nil) {
        cell.restaurantCategory.text = [NSString stringWithFormat:@"%@  in  %@", categoryList[0][0], neighborhood[0]];
    }
    else {
        cell.restaurantCategory.text = categoryList[0][0];
    }
    
    
    NSString *identifier = [NSString stringWithFormat:@"Cell%ld" ,(long)indexPath.row];
    
    //Set image if already saved in image cache
    if ([self.imageCache objectForKey:identifier] != nil) {
        cell.restaurantImage.image = [self.imageCache valueForKey:identifier];
        cell.restaurantImage.layer.cornerRadius = cell.restaurantImage.frame.size.height /2;
        cell.restaurantImage.layer.masksToBounds = YES; 
    }
    else {
        char const * s = [identifier  UTF8String];
        dispatch_queue_t queue = dispatch_queue_create(s, 0);
        dispatch_async(queue, ^{
            
            //If not in cache, get the image. Do some URL magic to get a slightly larger image
            NSString *ImageURL = [[self.restaurants objectAtIndex:indexPath.row] objectForKey:@"image_url"];
            ImageURL = [ImageURL substringToIndex:[ImageURL length] - 6];
            ImageURL = [ImageURL stringByAppendingString:@"ls.jpg"];
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([tableView indexPathForCell:cell].row == indexPath.row) {
    
                    //Set the image from data and put it in a circle
                    [self.imageCache setValue:[UIImage imageWithData:imageData] forKey:identifier];
                    
                    cell.restaurantImage.image = [self.imageCache valueForKey:identifier];
                    cell.restaurantImage.layer.cornerRadius = cell.restaurantImage.frame.size.height /2;
                    cell.restaurantImage.layer.masksToBounds = YES;
                }
            });
        });
    }
    
    
    return cell;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"showPopover"]) {
        
        UINavigationController * destNav = segue.destinationViewController;
        self.lptvc= destNav.viewControllers.firstObject;
        UIPopoverPresentationController * popPC = destNav.popoverPresentationController;
        popPC.delegate = self;
    }
    if ([[segue identifier] isEqualToString:@"openYelp"]) {
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
        NSLog(@"Button Pressed at Index %ld", (long)indexPath.row);
        
        YelpViewController *temp = [segue destinationViewController];
        [temp setUrl:[[self.restaurants objectAtIndex:indexPath.row] objectForKey:@"url"]];
    }
}

#pragma mark - Add to List Button
//Action adds the Yelp entry at specified row to the user's temporary list
- (IBAction)addToList:(UIButton *)sender {
    
    //Get index of button press
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSLog(@"Add to List Button Pressed at Index %ld", (long)indexPath.row);
    self.selectedIndex = indexPath.row;
    
    //Present a UIAlertView allowing user to enter a note
    UIAlertView *alertViewChangeName=[[UIAlertView alloc]initWithTitle:@"Add to List" message:@"Add a note about this restaurant?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    alertViewChangeName.alertViewStyle=UIAlertViewStylePlainTextInput;
    [alertViewChangeName show];
}

#pragma mark - UIAlertViewDelegate
//Delegate mthod called from UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != [alertView cancelButtonIndex]){
        
        //Get the note that user inputed into the UIAlertView
        NSString *note = [[alertView textFieldAtIndex:0] text];
        if ([note length] == 0) {
            note = @"";
        }
        
        //Store name, URL, and image URL for the specified entry in an NSDictionary
        NSString *name = [[self.restaurants objectAtIndex:self.selectedIndex] objectForKey:@"name"];
        NSString *link = [[self.restaurants objectAtIndex:self.selectedIndex] objectForKey:@"url"];
        NSString *imageLink = [[self.restaurants objectAtIndex:self.selectedIndex] objectForKey:@"image_url"];
        NSDictionary * listEntry = [[NSDictionary alloc] initWithObjects:@[name, link, note, imageLink] forKeys:@[@"name", @"link", @"note", @"imageLink"]];
        
        NSLog(@"List Entry: %@", listEntry);
        
        //Save that to defaults
        [self saveToDefaults:listEntry];
    }
}

#pragma mark - Helper Methods
//Called when user adds an entry to list. Take an NSDictionary input, check if it's in the list already. If it isn't add it to the NSUserDefaults correspoding to "tempList"
- (void) saveToDefaults: (NSDictionary *) listEntry {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSObject * object = [defaults objectForKey:@"tempList"];
    if (object != nil) {
        //If default exists, get the array and copy over every element in it
        NSArray *tempListArray = [defaults objectForKey:@"tempList"];
        NSMutableArray *duplicateTempListArray = [NSMutableArray arrayWithCapacity:[tempListArray count]+1];
        for (id anObject in tempListArray) {
            [duplicateTempListArray addObject:[anObject mutableCopy]];
        }
        
        //ensure all items in the NSMutableArray are unique
        int i;
        for (i = 0; i < [duplicateTempListArray count]; i++) {
            if ([[[duplicateTempListArray objectAtIndex:i] objectForKey:@"link" ] isEqual: [listEntry objectForKey:@"link"]]) {
                break;
            }
        }
        
        //Add a new object only if it's unique
        if(i == ([duplicateTempListArray count]))[duplicateTempListArray addObject:listEntry];
        
        [defaults setObject:[NSArray arrayWithArray:duplicateTempListArray] forKey:@"tempList"];
        NSLog(@"Temp List Array %@", duplicateTempListArray);
    }
    else {
        //If this the first time you're adding to the defaults, create new arrays and add them in
        NSMutableArray *tempListArray = [[NSMutableArray alloc] init];
        [tempListArray addObject:listEntry];
        [defaults setObject:[NSArray arrayWithArray:tempListArray] forKey:@"tempList"];
        NSLog(@"Temp List Array %@", tempListArray);
    }
}

//Query Yelp based on files in the /OAuthConsumer and /YelpFiles folder with a given term and location
- (void) queryYelp {
    //Following code is modified from Yelp API Sample Project: https://github.com/Yelp/yelp-api/tree/master/v2/objective-c
    @autoreleasepool {
        
        NSString *defaultTerm;
        
        if (self.isTourist) {
            defaultTerm = @"Tourist";

        }
        else {
            defaultTerm = @"Restaurant";
        }
        
        NSString *defaultLocation = [NSString stringWithFormat:@"%@, %@", self.selectedCity.name, self.selectedCity.state];
        
        //Get the term and location from the command line if there were any, otherwise assign default values.
        NSString *term = [[NSUserDefaults standardUserDefaults] valueForKey:@"term"] ?: defaultTerm;
        NSString *location = [[NSUserDefaults standardUserDefaults] valueForKey:@"location"] ?: defaultLocation;
        
        YPAPISample *APISample = [[YPAPISample alloc] init];
        dispatch_group_t requestGroup = dispatch_group_create();
        
        dispatch_group_enter(requestGroup);
        [APISample queryTopBusinessInfoForTerm:term location:location completionHandler:^(NSArray *topBusinessJSON, NSError *error) {
            
            if (error) {
                NSLog(@"An error happened during the request: %@", error);
            } else if (topBusinessJSON) {
                //topBusinessJSON contains the results of the Yelp Query
                NSLog(@"Top business info: \n %@", topBusinessJSON);
                self.restaurants = topBusinessJSON;
            } else {
                NSLog(@"No business was found");
            }
            
            dispatch_group_leave(requestGroup);
        }];
        
        dispatch_group_wait(requestGroup, DISPATCH_TIME_FOREVER); // This avoids the program exiting before all our asynchronous callbacks have been made.
    }
}

#pragma mark - Popover Delegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

@end
