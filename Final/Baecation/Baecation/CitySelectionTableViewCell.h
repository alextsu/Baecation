//
//  CitySelectionTableViewCell.h
//  Baecation
//
//  Created by Alexander Tsu on 5/19/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CitySelectionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UIView *overlayColor;
@property (weak, nonatomic) IBOutlet UIImageView *cityImage;
@property (weak, nonatomic) IBOutlet UIView *pinkCircle;

@end
