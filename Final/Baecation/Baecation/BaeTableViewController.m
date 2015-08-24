//
//  BaeTableViewController.m
//  Baecation
//
//  Created by Alexander Tsu on 5/26/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import "BaeTableViewController.h"
#import "BaeTableViewCell.h"
#import "MyListTableViewController.h"
#import "ParseHelper.h"

@interface BaeTableViewController ()
@property (strong, nonatomic) NSArray * baes;
@end

@implementation BaeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Get your friends from NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.baes = [defaults objectForKey:@"friends"];
    
    //Color the status bar
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 22)];
    statusBarView.backgroundColor = [UIColor colorWithRed:253.0f/255.0f green:94.0f/255.0f blue:112.0f/255.0f alpha:1.0f];
    [self.navigationController.navigationBar addSubview:statusBarView];
    [ParseHelper getSharedListsFromParse];
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
    return [self.baes count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"baeCell" forIndexPath:indexPath];
    
    //Set the text and font of the friend name
    cell.baeName.text = [[self.baes objectAtIndex:indexPath.row] objectForKey:@"name"];
    [cell.baeName setFont:[UIFont fontWithName:@"lato-regular" size:18]];
    
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //Segue to the MyListTableViewController, passing in the boolean, YES for fromBaeTable
    if ([[segue identifier] isEqualToString:@"getSharedLists"]) {
        UINavigationController *navController = [segue destinationViewController];
        MyListTableViewController * temp = (MyListTableViewController *)([navController viewControllers][0]);
        [temp setFromBaeTable:YES];
    }
}


@end
