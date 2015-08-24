//
//  CoreDataHelper.h
//  Baecation
//
//  Created by Alexander Tsu on 5/19/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"


@interface CoreDataHelper : NSObject
+ (void) storeDataFromJSON;
+ (NSArray *) accessDataOfSpecifiedType: (NSString *) adjective;
+ (City *) accessDataWithSpecifiedCityName: (NSString *) cityName;
@end
