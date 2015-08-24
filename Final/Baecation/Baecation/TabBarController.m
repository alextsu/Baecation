//
//  TabBarController.m
//  Baecation
//
//  Created by Alexander Tsu on 5/25/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import "TabBarController.h"
#import "ParseHelper.h"

//Purpose: Tab Bar Controller for all of application. Calls Parse database when it appears to reload data in tables

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated {
    [ParseHelper getListsFromParse];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
