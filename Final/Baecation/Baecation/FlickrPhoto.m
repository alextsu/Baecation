//
//  FlickrPhoto.m
//  Baecation
//
//  Created by Alexander Tsu on 5/23/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import "FlickrPhoto.h"

//Purpose: Object representing a Flickr Photo

@implementation FlickrPhoto

-(id) initWithName: (NSString *) photoTitle andURL: (NSString *) photoURL {
    self = [super init];
    
    self.photoTitle = photoTitle;
    self.photoURL = photoURL;
    
    return self;
}

@end
