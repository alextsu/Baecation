//
//  ShareTableViewController.m
//  Baecation
//
//  Created by Alexander Tsu on 5/26/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import "ShareTableViewController.h"
#import "ShareTableViewCell.h"
#import "ParseHelper.h"

//Display a list of Friends who also have the Baecation app and allow user to select one of these friends to share a list with

@interface ShareTableViewController ()
@property (strong, nonatomic) NSArray * baes;
@end

@implementation ShareTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Change the color of the status bar (for visual purposes)
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 22)];
    statusBarView.backgroundColor = [UIColor colorWithRed:253.0f/255.0f green:94.0f/255.0f blue:112.0f/255.0f alpha:1.0f];
    [self.navigationController.navigationBar addSubview:statusBarView];
    
    //Get friends from NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.baes = [defaults objectForKey:@"friends"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.baes count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shareCell" forIndexPath:indexPath];
    
    //Get the names of friends and set the font
    cell.shareName.text = [[self.baes objectAtIndex:indexPath.row] objectForKey:@"name"];
    [cell.shareName setFont:[UIFont fontWithName:@"lato-regular" size:18]];
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    //Segue home
    if ([[segue identifier] isEqualToString:@"returnHome"]) {
        
        //Get the index path of the list
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [self.listDetails setValue:[[self.baes objectAtIndex:indexPath.row] objectForKey:@"id"] forKey:@"shareSettings"];
        NSLog(@"Share Table: %@", self.listDetails);
        
        //Update parse with new parameters
        [ParseHelper deleteListFromParseWithName:[self.listDetails objectForKey:@"listName"]];
        [ParseHelper saveListToParse:self.listDetails];
        
        //Present a UIAlertView
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"List Shared"
                                                        message:[NSString stringWithFormat:@"You've shared %@ List with %@.",[self.listDetails objectForKey:@"listName"], [[self.baes objectAtIndex:indexPath.row] objectForKey:@"name"]]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
}


@end
