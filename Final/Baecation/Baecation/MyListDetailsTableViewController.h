//
//  MyListDetailsTableViewController.h
//  Baecation
//
//  Created by Alexander Tsu on 5/24/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyListDetailsTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableDictionary * listDetails;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *customEditButton;
@property BOOL fromBaeTable;
@end
