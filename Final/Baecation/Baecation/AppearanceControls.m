//
//  AppearanceControls.m
//  Baecation
//
//  Created by Alexander Tsu on 5/18/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import "AppearanceControls.h"

//Purpose: Use UIAppearanceProxy to customize the colors and fonts of elements in the application

@implementation AppearanceControls
+ (void)applyStyle
{
    //Create two colors
    UIColor * baePinkColor = [UIColor colorWithRed:253.0f/255.0f green:94.0f/255.0f blue:112.0f/255.0f alpha:1.0f];
    UIColor * baeBlueColor = [UIColor colorWithRed:44.0f/255.0f green:62.0f/255.0f blue:80.0f/255.0f alpha:1.0f];
    
    //Set the navigation bar to pink and title font to lato bold in white
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundColor:baePinkColor];
    [navigationBarAppearance setTitleTextAttributes: @{NSFontAttributeName: [UIFont fontWithName:@"lato-bold" size:19.0f], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    //Set tab bar tint color
    [[UITabBar appearance] setTintColor:baePinkColor];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor grayColor] }
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : baePinkColor }
                                             forState:UIControlStateSelected];
    
    //Set font and color of labels
    [[UILabel appearance] setFont:[UIFont fontWithName:@"lato-light" size:16.0]];
    [[UILabel appearance] setTextColor:baeBlueColor];
    
    //Set font and color of button
    [[UIButton appearance] setTitleColor:baePinkColor forState:UIControlStateNormal];
    [[UIButton appearance] setFont:[UIFont fontWithName:@"lato-regular" size:17.0f]];
    
    //Make it so that only the Chevron is displayed for back buttons
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
}
@end
