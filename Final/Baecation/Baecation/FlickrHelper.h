//
//  FlickrHelper.h
//  Baecation
//
//  Created by Alexander Tsu on 5/23/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"

@interface FlickrHelper : NSObject
+ (NSArray *) queryFlickrWithCity: (City *) city;
@end
