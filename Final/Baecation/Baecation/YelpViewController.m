//
//  YelpViewController.m
//  Baecation
//
//  Created by Alexander Tsu on 5/22/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import "YelpViewController.h"

//Purpose: Open up a webpage with an inputted URL

@interface YelpViewController ()

@end

@implementation YelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Web";
    
    if(self.url != nil) {
        NSURL *nsurl = [NSURL URLWithString:self.url];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:nsurl];
        [self.webView loadRequest:requestObj];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
