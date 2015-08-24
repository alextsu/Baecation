//
//  ParseHelper.h
//  Baecation
//
//  Created by Alexander Tsu on 5/26/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface ParseHelper : NSObject

+ (void) saveListToParse: (NSDictionary *) permList;
+ (void) getListsFromParse;
+ (void) getSharedListsFromParse;
+ (void) deleteListFromParseWithName: (NSString *) listName;
@end
