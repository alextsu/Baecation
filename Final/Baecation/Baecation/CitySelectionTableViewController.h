//
//  CitySelectionTableViewController.h
//  Baecation
//
//  Created by Alexander Tsu on 5/19/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityAdjective.h"

@interface CitySelectionTableViewController : UITableViewController
@property (strong, nonatomic) CityAdjective * selectedAdjective;
@end
