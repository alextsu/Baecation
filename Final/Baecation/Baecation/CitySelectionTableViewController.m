//
//  CitySelectionTableViewController.m
//  Baecation
//
//  Created by Alexander Tsu on 5/19/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import "CitySelectionTableViewController.h"
#import "CitySelectionTableViewCell.h"
#import "City.h"
#import "CoreDataHelper.h"
#import "CityDetailsViewController.h"

//Purpose: set a TableView of Cities that match the user selected adjective

@interface CitySelectionTableViewController ()

@property (strong, nonatomic) NSArray * retrievedCities;
@property (strong, nonatomic) NSMutableDictionary * imageCache;
@end

@implementation CitySelectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set title and modify visuals
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.navigationItem.title = self.selectedAdjective.name;
    
    //Query Core Data for the list of cities that match the selected Adjective passed in from DiscoverViewController
    self.retrievedCities = [CoreDataHelper accessDataOfSpecifiedType:self.selectedAdjective.name];
    
    //Instantiate imageCache for better performance
    self.imageCache = [[NSMutableDictionary alloc] init];
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
    return [self.retrievedCities count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CitySelectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //Get city at corresponding index
    City * specifiedCity = [self.retrievedCities objectAtIndex:indexPath.row];
    
    //Set the cell iulabel based on the city's name. Edit its font and color
    cell.cityName.text = specifiedCity.name;
    cell.cityName.textColor = [UIColor whiteColor];
    [cell.cityName setFont:[UIFont fontWithName:@"lato-bold" size:18]];
    cell.cityName.alpha = 1.0;
    
    NSString *identifier = [NSString stringWithFormat:@"Cell%ld" ,(long)indexPath.row];
    
    //Check if image is already cached. If so, set cell to the cached image
    if ([self.imageCache objectForKey:identifier] != nil) {
        cell.backgroundView = [[UIImageView alloc] initWithImage: [self.imageCache valueForKey:identifier]];
    }
    //If not
    else {
        char const * s = [identifier  UTF8String];
        dispatch_queue_t queue = dispatch_queue_create(s, 0);
        dispatch_async(queue, ^{
            
            //Create a CGRect based on cell size and call imageWithImage to scale the image to proper size
            CGRect imageRect = CGRectMake(0, specifiedCity.image.size.height/4, cell.frame.size.width, cell.frame.size.height);
            UIImage * newImage = [self imageWithImage:specifiedCity.image scaledToSize:CGSizeMake(cell.frame.size.width, cell.frame.size.width)];
            CGImageRef imageRef = CGImageCreateWithImageInRect([newImage CGImage], imageRect);
            UIImage * croppedImg = [UIImage imageWithCGImage:imageRef];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([tableView indexPathForCell:cell].row == indexPath.row) {
                    
                    //Store the cropped image in the imageCache and set backgroundView to that image
                    [self.imageCache setValue:croppedImg forKey:identifier];
                    cell.backgroundView = [[UIImageView alloc] initWithImage: [self.imageCache valueForKey:identifier]];
                }
            });
        });
    }
    
    return cell;
}


#pragma mark - Image Editing Helper
//Scales an inputted UImage to the inputted CGSize and returns that UIImage
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


 #pragma mark - Navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     if([[segue identifier] isEqualToString:@"segueToDetails"]) {
         NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
         City *selectedCity = [self.retrievedCities objectAtIndex:indexPath.row];
         
         UINavigationController *navController = [segue destinationViewController];
         CityDetailsViewController * cdvc = (CityDetailsViewController *)([navController viewControllers][0]);
         [cdvc setSelectedCity:selectedCity];
     }
 }


@end
