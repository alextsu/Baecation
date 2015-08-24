//
//  FlickrPhoto.h
//  Baecation
//
//  Created by Alexander Tsu on 5/23/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrPhoto : NSObject

@property (strong, nonatomic) NSString * photoTitle;
@property (strong, nonatomic) NSString * photoURL;

-(id) initWithName: (NSString *) photoTitle andURL: (NSString *) photoURL;

@end
