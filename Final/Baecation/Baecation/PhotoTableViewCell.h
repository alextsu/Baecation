//
//  PhotoTableViewCell.h
//  Baecation
//
//  Created by Alexander Tsu on 5/23/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *photoTitle;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;

@end
