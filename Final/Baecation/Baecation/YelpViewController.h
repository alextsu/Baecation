//
//  YelpViewController.h
//  Baecation
//
//  Created by Alexander Tsu on 5/22/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YelpViewController : UIViewController
@property (strong, nonatomic) NSString * url;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
