//
//  CityDetailsViewController.m
//  Baecation
//
//  Created by Alexander Tsu on 5/20/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import "CityDetailsViewController.h"
#import "CityWikiViewController.h"
#import "DiscoverViewController.h"
#import "ListPopoverTableViewController.h"
#import "FoodTableViewController.h"
#import "PhotoTableViewController.h"
#import "ParseHelper.h"

//Purpose: Serve as the homepage for each city. Allow users to access tourist destinations, restaurants and photos on the selected city.

@interface CityDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *selectedCityImage;
@property (weak, nonatomic) IBOutlet UILabel *cityDescriptors;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIToolbar *saveToolbar;
@property (strong, nonatomic) ListPopoverTableViewController * lptvc;
- (IBAction)cancelButton:(UIBarButtonItem *)sender;

@end

@implementation CityDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //Call helper methods to set up the page
    [self setupDescriptor];
    [self setupToolbar];
    [self setupNavigationBar];
}

- (void) viewDidAppear:(BOOL)animated {
    
    //Set the image at the center of the screen. This works improperly if placed in ViewDidLoad
    self.selectedCityImage.image = self.selectedCity.image;
    self.selectedCityImage.layer.cornerRadius = self.selectedCityImage.frame.size.height /2;
    self.selectedCityImage.layer.masksToBounds = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// Segues to Food, Tourist, and Photos, as well as the popover that contains user-generated list
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"openWeb"]) {
        CityWikiViewController *temp = [segue destinationViewController];
        [temp setSelectedCity:self.selectedCity];
    }
    if ([[segue identifier] isEqualToString:@"showPopover"]) {
        
        UINavigationController * destNav = segue.destinationViewController;
        self.lptvc= destNav.viewControllers.firstObject;
        UIPopoverPresentationController * popPC = destNav.popoverPresentationController;
        popPC.delegate = self;
    }
    if ([[segue identifier] isEqualToString:@"showFood"]) {
        
        UINavigationController *navController = [segue destinationViewController];
        FoodTableViewController * temp = (FoodTableViewController *)([navController viewControllers][0]);
        [temp setSelectedCity:self.selectedCity];
    }
    if ([[segue identifier] isEqualToString:@"showTourist"]) {
        
        UINavigationController *navController = [segue destinationViewController];
        FoodTableViewController * temp = (FoodTableViewController *)([navController viewControllers][0]);
        [temp setSelectedCity:self.selectedCity];
        [temp setIsTourist:YES];
    }
    if ([[segue identifier] isEqualToString:@"showPhotos"]) {
        UINavigationController *navController = [segue destinationViewController];
        PhotoTableViewController * temp = (PhotoTableViewController *)([navController viewControllers][0]);
        [temp setSelectedCity:self.selectedCity];
    }
}

#pragma mark - Popover Delegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

#pragma mark - Alert View Delegate
//Delegate mthod called when user clicks the cancel. Deletes the temporary list in the popover and returns to the Tab Bar Controller
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex]){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"tempList"];
        [self performSegueWithIdentifier:@"returnToRoot" sender:self];
    }
}

//Called when user taps the X at top left
- (IBAction)cancelButton:(UIBarButtonItem *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Exit"
                                                    message:@"Are you sure you wish to leave this screen? Tapping OK will permanently delete this list."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}

//Called when user taps the Save Button
- (IBAction)saveButton:(id)sender {
    NSLog(@"Save Button Tapped");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    //Check if user has started a list
    if([defaults objectForKey:@"tempList"] != nil) {
        
        //If so, create new NSDictionary and add data into it
        NSDictionary * permList = [[NSDictionary alloc] initWithObjectsAndKeys:[defaults objectForKey:@"tempList"], @"listContent",self.selectedCity.name,@"listName",@"Private", @"shareSettings",nil];
        
        
        //[ParseHelper deleteListFromParseWithName:self.selectedCity.name];
        
        //Save the user-generated list to parse
        [ParseHelper saveListToParse:permList];
        
        //[self saveToDefaults:permList];
        
        //Remove the list from the temporary NSUserDefaults and segue back
        [defaults removeObjectForKey:@"tempList"];
        [self performSegueWithIdentifier:@"returnToRoot" sender:self];
    }
    //If no list has been started, present UIAlertView
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty List"
                                                        message:@"Please add a restaurant, photo, or destination to your list before saving."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

//NOTE: Not currently in use. Used only for local version of app
- (void) saveToDefaults: (NSDictionary *) listEntry {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSObject * object = [defaults objectForKey:@"permList"];
    if (object != nil) {
        //If default exists, get the array and copy over every element in it
        NSArray *permListArray = [defaults objectForKey:@"permList"];
        NSMutableArray *duplicatePermListArray = [NSMutableArray arrayWithCapacity:[permListArray count]+1];
        for (id anObject in permListArray) {
            [duplicatePermListArray addObject:[anObject mutableCopy]];
        }
        
        int i;
        for (i = 0; i < [duplicatePermListArray count]; i++) {
            if ([[[duplicatePermListArray objectAtIndex:i] objectForKey:@"listName" ] isEqual: self.selectedCity.name]) {
                [duplicatePermListArray removeObjectAtIndex:i];
                break;
            }
        }
        
        [duplicatePermListArray addObject:listEntry];
        
        [defaults setObject:[NSArray arrayWithArray:duplicatePermListArray] forKey:@"permList"];
        NSLog(@"Perm List Array %@", duplicatePermListArray);
        
    }
    else {
        //If this the first time you're adding to the defaults, create new arrays and add them in
        NSMutableArray *permListArray = [[NSMutableArray alloc] init];
        [permListArray addObject:listEntry];
        [defaults setObject:[NSArray arrayWithArray:permListArray] forKey:@"permList"];
        NSLog(@"Perm List Array %@", permListArray);
    }
}

#pragma mark - Display Helper Methods
//Set the descriptor string at top of screen based on the fields in the city object
- (void) setupDescriptor {
    NSString * descriptor = @"";
    if ([self.selectedCity.artsy isEqualToString:@"1"]) {
        descriptor = [NSString stringWithFormat:@"%@  %@ ", descriptor,@"Artsy"];
    }
    if ([self.selectedCity.outdoorsy isEqualToString:@"1"]) {
        descriptor = [NSString stringWithFormat:@"%@  %@ ", descriptor,@"Outdoorsy"];
    }
    if ([self.selectedCity.relaxing isEqualToString:@"1"]) {
        descriptor = [NSString stringWithFormat:@"%@  %@ ", descriptor,@"Relaxing"];
    }
    if ([self.selectedCity.festive isEqualToString:@"1"]) {
        descriptor = [NSString stringWithFormat:@"%@  %@ ", descriptor,@"Festive"];
    }
    if ([self.selectedCity.historic isEqualToString:@"1"]) {
        descriptor = [NSString stringWithFormat:@"%@  %@ ", descriptor,@"Historic"];
    }
    if ([self.selectedCity.touristy isEqualToString:@"1"]) {
        descriptor = [NSString stringWithFormat:@"%@  %@ ", descriptor,@"Touristy"];
    }
    if ([self.selectedCity.lowkey isEqualToString:@"1"]) {
        descriptor = [NSString stringWithFormat:@"%@  %@ ", descriptor,@"Low-Key"];
    }
    descriptor = [descriptor substringFromIndex:1];
    self.cityDescriptors.text = descriptor;
}

//Set toolbar with save button
- (void) setupToolbar {
    [self.saveToolbar setBarTintColor:[UIColor colorWithRed:44.0f/255.0f green:62.0f/255.0f blue:80.0f/255.0f alpha:1.0f]];
    [self.saveButton setTitleTextAttributes:@{ NSFontAttributeName: [UIFont fontWithName:@"Lato-Regular" size:19.0],NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
    
}

//Instantiate the navigation bar title and status bar with pink color
- (void) setupNavigationBar {
    self.navigationItem.title = self.selectedCity.name;
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 22)];
    statusBarView.backgroundColor = [UIColor colorWithRed:253.0f/255.0f green:94.0f/255.0f blue:112.0f/255.0f alpha:1.0f];
    [self.navigationController.navigationBar addSubview:statusBarView];
    
}

@end
