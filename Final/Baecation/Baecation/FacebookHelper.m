//
//  FacebookHelper.m
//  Baecation
//
//  Created by Alexander Tsu on 5/25/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "FacebookHelper.h"

//Purpose: Access user and friends data from Facebook SDK

@implementation FacebookHelper : NSObject

//Use FBSDKGraphRequest to get info on user and user's friends who use the app
+ (void) getUserData {
    
    //Create a FBSDKGraphRequest and call it for user
    FBSDKGraphRequest * graphRequest = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
    [graphRequest startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (error != nil) {
            
        }
        else {
            NSString * userName = [result valueForKey:@"name"];
            NSLog(@"User Name: %@", userName);
            
            NSString * myID = [result valueForKey:@"id"];
            NSLog(@"ID: %@", myID);
            
            //Save userID. This is used to pull your info from Parse
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[result valueForKey:@"id"] forKey:@"myID"];
        }
    }];
    
    //Make another request to get friends
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/me/friends" parameters:nil HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        // Handle the result
        
        NSDictionary * friends = result;
        NSLog(@"Friend: %@", friends[@"data"]);
            
        //Save that in NSUserDefaults to be retrieved in BaeTable and ShareTable
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:friends[@"data"] forKey:@"friends"];
        
    }];
}


@end
