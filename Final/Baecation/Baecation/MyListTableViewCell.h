//
//  MyListTableViewCell.h
//  Baecation
//
//  Created by Alexander Tsu on 5/24/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UIImageView *cityImage;
@property (weak, nonatomic) IBOutlet UILabel *shareSettings;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@end
