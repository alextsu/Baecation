//
//  FoodTableViewCell.h
//  Baecation
//
//  Created by Alexander Tsu on 5/22/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *restaurantName;
@property (weak, nonatomic) IBOutlet UILabel *restaurantCategory;
@property (weak, nonatomic) IBOutlet UIImageView *restaurantImage;
@end
