//
//  CityWikiViewController.m
//  Baecation
//
//  Created by Alexander Tsu on 5/20/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import "CityWikiViewController.h"

//Purpose: Display a wikipedia UIWebView for the user

@interface CityWikiViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation CityWikiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Wikipedia";
    
    //Create a URL with path equal to the name and state
    NSString * link = @"http://en.wikipedia.org/wiki/";
    NSString * nameConstruct = [self.selectedCity.name stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    link = [NSString stringWithFormat:@"%@%@,_%@", link, nameConstruct,self.selectedCity.state];
    
    NSURL *url = [NSURL URLWithString:link];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
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
