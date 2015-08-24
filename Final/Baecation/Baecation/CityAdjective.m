//
//  CityAdjective.m
//  Baecation
//
//  Created by Alexander Tsu on 5/18/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import "CityAdjective.h"

//Purpose: Object representing name and image of an adjective

@implementation CityAdjective

-(id) initWithName: (NSString *) name andImage: (UIImage *) image {
    self = [super init];
    
    self.name = name;
    self.image = image;
    
    return self;
}

@end
