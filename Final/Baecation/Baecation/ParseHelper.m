//
//  ParseHelper.m
//  Baecation
//
//  Created by Alexander Tsu on 5/26/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import "ParseHelper.h"

//Purpose: Save, Delete, and Retrieve items in Parse

@implementation ParseHelper

//Input a list as NSDictionary to be saved into Parse
+ (void) saveListToParse: (NSDictionary *) permList {
    
    //Get your ID
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * myID = [defaults objectForKey:@"myID"];
    
    //[self deleteListFromParseWithName:[permList objectForKey:@"listName"]];
    
    //Create new object and save elements
    PFObject *listObject = [PFObject objectWithClassName:@"List"];
    listObject[@"creatorID"] = myID;
    listObject[@"shareSettings"] = [permList objectForKey:@"shareSettings"];
    listObject[@"listName"] = [permList objectForKey:@"listName"];
    NSDictionary * listContent = [permList objectForKey:@"listContent"];
    listObject[@"listContent"] = listContent;
    
    //Save in background
    [listObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        //[self eliminateDuplicates:[permList objectForKey:@"listName"]];
    }];
}

//For all lists you have created, get NSMutableArray of list items and store in NSUserDefault
+ (void) getListsFromParse {
    
    //Get your ID
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * myID = [defaults objectForKey:@"myID"];
    
    //Query Parse for all items with the specified creator ID
    PFQuery *query = [PFQuery queryWithClassName:@"List"];
    [query whereKey:@"creatorID" equalTo:myID];
    [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError *error) {
        if (error == nil) {
            
            NSMutableArray * permList = [[NSMutableArray alloc] init];
            
            //Iterat through each object and store as a NSMutableDictionary
            for (PFObject * object in objects) {
                NSMutableDictionary * listEntry = [[NSMutableDictionary alloc] init ];
                [listEntry setObject:[object valueForKey:@"listName"] forKey:@"listName"];
                [listEntry setObject:[object valueForKey:@"shareSettings"] forKey:@"shareSettings"];
                [listEntry setObject:[object valueForKey:@"listContent"] forKey:@"listContent"];
                [permList addObject:listEntry];
            }
            
            //Add the array of Dictionaries to NSUserDefaults
            NSLog(@"My Lists Retrieved from Parse: %@", permList);
            [defaults setObject:[NSArray arrayWithArray:permList] forKey:@"permList"];
        }
    }];
}

//For all lists that others have shared with you, get NSMutableArray of list items and store in NSUserDefault
+ (void) getSharedListsFromParse {
    
    //Get your ID
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * myID = [defaults objectForKey:@"myID"];
    
    //Query Parse for all tiems with your ID in shareSettings
    PFQuery *query = [PFQuery queryWithClassName:@"List"];
    [query whereKey:@"shareSettings" equalTo:myID];
    [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError *error) {
        if (error == nil) {
            
            //Do the same thign as above
            NSMutableArray * permList = [[NSMutableArray alloc] init];
            
            for (PFObject * object in objects) {
                NSMutableDictionary * listEntry = [[NSMutableDictionary alloc] init ];
                [listEntry setObject:[object valueForKey:@"listName"] forKey:@"listName"];
                [listEntry setObject:[object valueForKey:@"shareSettings"] forKey:@"shareSettings"];
                [listEntry setObject:[object valueForKey:@"listContent"] forKey:@"listContent"];
                [permList addObject:listEntry];
            }
            
            NSLog(@"Shared Lists Retrieved from Parse: %@", permList);
            [defaults setObject:[NSArray arrayWithArray:permList] forKey:@"sharedList"];
        }
        
    }];
}

//Delete entry with name from Parse
+ (void) deleteListFromParseWithName: (NSString *) listName {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * myID = [defaults objectForKey:@"myID"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"List"];
    [query whereKey:@"creatorID" equalTo:myID];
    [query whereKey:@"listName" equalTo:listName];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError *error) {
        if (error == nil) {
            
            [objects[0] deleteInBackground];
            
            /*for (PFObject * object in objects) {
                [object deleteInBackground];
            }*/
            
            NSLog(@"Delete from Parse: %@", listName);
            
        }
        
    }];
    
}

//NOTE: Not currently in use
//Eliminate duplicates from Parse
+ (void) eliminateDuplicates: (NSString *) listName {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * myID = [defaults objectForKey:@"myID"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"List"];
    [query whereKey:@"creatorID" equalTo:myID];
    [query whereKey:@"listName" equalTo:listName];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError *error) {
        if (error == nil) {
            
            if ([objects count] > 0) {
                /*for (int i = 1; i < [objects count]; i++) {
                    [objects[i] deleteInBackground];
                }*/
                [objects[1] deleteInBackground];
            }
            [self getSharedListsFromParse];
            NSLog(@"Delete Duplicate from Parse: %@", listName);
            
        }
        
    }];
}

@end
