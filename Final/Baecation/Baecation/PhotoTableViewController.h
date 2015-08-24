//
//  PhotoTableViewController.h
//  Baecation
//
//  Created by Alexander Tsu on 5/23/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"

@interface PhotoTableViewController : UITableViewController <UIPopoverPresentationControllerDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) City * selectedCity;
@end
