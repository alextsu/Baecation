//
//  CityDetailsViewController.h
//  Baecation
//
//  Created by Alexander Tsu on 5/20/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"

@interface CityDetailsViewController : UIViewController <UIAlertViewDelegate, UIPopoverPresentationControllerDelegate>

@property (strong, nonatomic) City * selectedCity;

@end
