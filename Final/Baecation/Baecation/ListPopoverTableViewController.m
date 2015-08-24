//
//  ListPopoverTableViewController.m
//  Baecation
//
//  Created by Alexander Tsu on 5/22/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import "ListPopoverTableViewController.h"
#import "ListPopoverTableViewCell.h"

//Purpose: Manage a temporary user-generated list while user is exploring a selected city. The content of this popover table view controller is emptied when user leaves the city details view controller

@interface ListPopoverTableViewController ()
@property (strong, nonatomic) NSMutableArray * tempList;
@end

@implementation ListPopoverTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Allow user to edit
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //Access defaults for the list. Throw a UIAlertView if it's empty.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSObject * object = [defaults objectForKey:@"tempList"];
    if (object != nil) {
        self.tempList = [[defaults objectForKey:@"tempList"] mutableCopy];
    }
    else {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"You haven't added anything" message:@"Select a restaurant, photo, or destination and press the 'Add to List' button to construct a Baecation list" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    NSLog(@"Popover Temp List %@", self.tempList);
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
    return [self.tempList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ListPopoverTableViewCell *cell = (ListPopoverTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"popoverCell" forIndexPath:indexPath];
    
    //NSLog(@"Cell Link: %@", [[self.tempList objectAtIndex:indexPath.row] objectForKey:@"imageLink"]);
    
    //Set name of list item
    cell.popoverName.text = [[self.tempList objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    //Get the image. Placed in dispatch because the circle cornerRadius code does not work properly if called immediately at ViewDidLoad
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(),^{
            NSString *ImageURL = [[self.tempList objectAtIndex:indexPath.row] objectForKey:@"imageLink"];
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
            cell.popoverImage.image = [UIImage imageWithData:imageData];
            cell.popoverImage.layer.cornerRadius = cell.popoverImage.frame.size.height /2;
            cell.popoverImage.layer.masksToBounds = YES;
        });
    });
    return cell;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        NSLog(@"Deleting object: %@", [self.tempList objectAtIndex:indexPath.row]);
        
        //Remove it from the view and delete the row at index
        [self.tempList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
        
        //Update NSUserDefault
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.tempList forKey:@"tempList"];
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}



@end
