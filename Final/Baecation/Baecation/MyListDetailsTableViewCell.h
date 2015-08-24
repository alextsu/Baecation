//
//  MyListDetailsTableViewCell.h
//  Baecation
//
//  Created by Alexander Tsu on 5/24/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyListDetailsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *itemName;
@property (weak, nonatomic) IBOutlet UILabel *note;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;

@end
