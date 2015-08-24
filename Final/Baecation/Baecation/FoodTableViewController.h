//
//  FoodTableViewController.h
//  Baecation
//
//  Created by Alexander Tsu on 5/22/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"

@interface FoodTableViewController : UITableViewController <UIPopoverPresentationControllerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) City * selectedCity;
@property BOOL isTourist;
@end
