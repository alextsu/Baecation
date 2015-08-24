//
//  MyListDetailsTableViewController.m
//  Baecation
//
//  Created by Alexander Tsu on 5/24/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import "MyListDetailsTableViewController.h"
#import "MyListDetailsTableViewCell.h"
#import "YelpViewController.h"
#import "CityDetailsViewController.h"
#import "CoreDataHelper.h"
#import "ParseHelper.h"

//Purpose: Display the individual list entry items within a list

@interface MyListDetailsTableViewController ()

@end

@implementation MyListDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set the title of viewcontroller
    self.navigationItem.title = [self.listDetails objectForKey:@"listName"];
    
    //Set the status bar background color
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 22)];
    statusBarView.backgroundColor = [UIColor colorWithRed:253.0f/255.0f green:94.0f/255.0f blue:112.0f/255.0f alpha:1.0f];
    [self.navigationController.navigationBar addSubview:statusBarView];
    
    //Hide the edit button if its from the Bae tab. You shouldn't be able to edit a list created by someone else.
    if (self.fromBaeTable) {
        self.customEditButton.width = 0.01;
        self.customEditButton.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    //[self reloadDefaults];
    [self.tableView reloadData];
    
}

//NOTE: Not currently used in the Parse version. This was just for the local version
- (void) reloadDefaults{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray * temp = [defaults objectForKey:@"permList"];
    for (NSDictionary * tempItem in temp) {
        NSLog(@"tempItem = %@", tempItem);
        if ([[tempItem objectForKey:@"listName"] isEqualToString:[self.listDetails objectForKey:@"listName"]]) {
            self.listDetails = [tempItem mutableCopy];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSArray * temp = [self.listDetails objectForKey:@"listContent"];
    return [temp count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyListDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myListDetailsCell" forIndexPath:indexPath];
    
    //Get the NSDictionary at the selected index
    NSDictionary * detailItem = [[self.listDetails objectForKey:@"listContent"] objectAtIndex:indexPath.row];
    
    //Set the text and font
    cell.itemName.text = [detailItem objectForKey:@"name"];
    [cell.itemName setFont:[UIFont fontWithName:@"lato-regular" size:18]];
    
    //Set the note text
    cell.note.text = [detailItem objectForKey:@"note"];
    
    //Dispatch queue used to place the images in circles properly
    //Get the image of the list entry and place it in a circular window
    NSString * imageURL = [detailItem objectForKey:@"imageLink"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
        UIImage *rawImage = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(),^{
            
            cell.itemImage.image = [self imageWithImage:rawImage scaledToSize:cell.itemImage.frame.size];
            cell.itemImage.layer.cornerRadius = cell.itemImage.frame.size.height /2;
            cell.itemImage.layer.masksToBounds = YES;
            
        });
    });
    
    return cell;
}

//Method referenced from StackOverflow here: http://stackoverflow.com/questions/7645454/resize-uiimage-by-keeping-aspect-ratio-and-width
//Resize UIImage with inputed CGSize
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size {
    CGFloat oldWidth = image.size.width;
    CGFloat oldHeight = image.size.height;
    
    CGFloat scaleFactor = (oldWidth > oldHeight) ? size.width / oldWidth : size.height / oldHeight;
    
    return [UIImage imageWithCGImage:image.CGImage scale:scaleFactor orientation:UIImageOrientationUp];
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     //Show the web page or web image associated with a particular list entry
     if ([[segue identifier] isEqualToString:@"showWeb"]) {
         YelpViewController *temp = [segue destinationViewController];
         NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
         NSDictionary * detailItem = [[self.listDetails objectForKey:@"listContent"] objectAtIndex:indexPath.row];
         [temp setUrl:[detailItem objectForKey:@"link"]];
         NSLog(@"Link: %@", [detailItem objectForKey:@"link"]);
     }
     
     //Segue to CityDetailsViewController to allow user to edit entry
     if ([[segue identifier] isEqualToString:@"editList"]) {
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
         [defaults setObject:[self.listDetails objectForKey:@"listContent"] forKey:@"tempList"];
         
         [ParseHelper deleteListFromParseWithName:[self.listDetails objectForKey:@"listName"]];
         
         UINavigationController *navController = [segue destinationViewController];
         CityDetailsViewController * temp = (CityDetailsViewController *)([navController viewControllers][0]);
         [temp setSelectedCity:[CoreDataHelper accessDataWithSpecifiedCityName:[self.listDetails objectForKey:@"listName"]]];
         
         
     }
 }


@end
