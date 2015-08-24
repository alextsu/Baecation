//
//  PhotoTableViewController.m
//  Baecation
//
//  Created by Alexander Tsu on 5/23/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import "PhotoTableViewController.h"
#import "FlickrHelper.h"
#import "FlickrPhoto.h"
#import "PhotoTableViewCell.h"
#import "ListPopoverTableViewController.h"

//Leverage results from Flickr API to display a Table View of photos for user to add to the user-generated list

@interface PhotoTableViewController ()
@property (strong, nonatomic) NSArray * flickrPhotos;
@property (strong, nonatomic) NSMutableDictionary * imageCache;
@property (strong, nonatomic) ListPopoverTableViewController * lptvc;
@property NSInteger selectedIndex;
@end

@implementation PhotoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Create the image cache again
    self.imageCache = [[NSMutableDictionary alloc] init];
    
    //Get an array of flickrPhotos from the helper class
    self.flickrPhotos = [FlickrHelper queryFlickrWithCity:self.selectedCity];
    
    //Set the background of the page
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;
    
    //Present a UIAlertView warning that results may not be relevant
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Note"
                                                    message:@"Photo results are taken from Flickr. Baecation cannot guarantee the relevancy of all displayed photos."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
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
    return [self.flickrPhotos count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoTableViewCell *cell = (PhotoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"photoCell" forIndexPath:indexPath];
    
    //Set background of cell to transparent
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    tableView.backgroundColor = [UIColor clearColor];
    
    //Get the flickrPhoto object at row
    FlickrPhoto * temp = [self.flickrPhotos objectAtIndex:indexPath.row];
    
    //Set the title and font of the photo. Truncate text if too long
    if([temp.photoTitle length] < 30) {
        cell.photoTitle.text =temp.photoTitle;
    }
    else {
        cell.photoTitle.text = [NSString stringWithFormat:@"%@...",[temp.photoTitle substringToIndex:30]];
    }
    [cell.photoTitle setFont:[UIFont fontWithName:@"lato-regular" size:18]];
    
    
    NSString *identifier = [NSString stringWithFormat:@"Cell%ld" ,(long)indexPath.row];
    
    //Get image if already cached
    if ([self.imageCache objectForKey:identifier] != nil) {
        cell.photoImage.image = [self.imageCache valueForKey:identifier];
        cell.photoImage.layer.cornerRadius = cell.photoImage.frame.size.height /2;
        cell.photoImage.layer.masksToBounds = YES;
    }
    else {
        char const * s = [identifier  UTF8String];
        dispatch_queue_t queue = dispatch_queue_create(s, 0);
        dispatch_async(queue, ^{
            
            //Otherwise get NSData from URL
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:temp.photoURL]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([tableView indexPathForCell:cell].row == indexPath.row) {
                    
                    //Resize the image based on imageWithImage method
                    [self.imageCache setValue:[self imageWithImage:[UIImage imageWithData:imageData] scaledToSize:cell.photoImage.frame.size] forKey:identifier];
                    
                    //Place image in circle
                    cell.photoImage.image = [self.imageCache valueForKey:identifier];
                    cell.photoImage.layer.cornerRadius = cell.photoImage.frame.size.height /2;
                    cell.photoImage.layer.masksToBounds = YES;
                }
            });
        });

    }
    

    return cell;
}

#pragma mark - Image Editing Helper

//Method referenced from StackOverflow here: http://stackoverflow.com/questions/7645454/resize-uiimage-by-keeping-aspect-ratio-and-width
//Resize UIImage with inputed CGSize
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size {
    CGFloat oldWidth = image.size.width;
    CGFloat oldHeight = image.size.height;
    
    CGFloat scaleFactor = (oldWidth > oldHeight) ? size.width / oldWidth : size.height / oldHeight;
    
    return [UIImage imageWithCGImage:image.CGImage scale:scaleFactor orientation:UIImageOrientationUp];
}

//Add to list same as FoodTableViewController
- (IBAction)addToList:(UIButton *)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSLog(@"Add to List Button Pressed at Index %ld", (long)indexPath.row);
    
    self.selectedIndex = indexPath.row;
    
    UIAlertView *alertViewChangeName=[[UIAlertView alloc]initWithTitle:@"Add to List" message:@"Add a note about this photo?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    alertViewChangeName.alertViewStyle=UIAlertViewStylePlainTextInput;
    [alertViewChangeName show];
}

#pragma mark - UIAlertViewDelegate
//Delegate Method same as FoodTableViewController
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != [alertView cancelButtonIndex]){
        NSString *note = [[alertView textFieldAtIndex:0] text];
        
        if ([note length] == 0) {
            note = @"";
        }
        
        FlickrPhoto * fp = [self.flickrPhotos objectAtIndex:self.selectedIndex];
        
        NSString *name = [NSString stringWithFormat:@"%@ Photo", self.selectedCity.name];
        NSString *link = fp.photoURL;
        NSString *imageLink = fp.photoURL;
        
        NSDictionary * listEntry = [[NSDictionary alloc] initWithObjects:@[name, link, note, imageLink] forKeys:@[@"name", @"link", @"note", @"imageLink"]];
        
        NSLog(@"List Entry: %@", listEntry);
        
        [self saveToDefaults:listEntry];
    }
}

//Same as FoodTableViewController
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showPopover"]) {
        
        UINavigationController * destNav = segue.destinationViewController;
        self.lptvc= destNav.viewControllers.firstObject;
        UIPopoverPresentationController * popPC = destNav.popoverPresentationController;
        popPC.delegate = self;
    }
}

#pragma mark - Popover Delegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

@end
