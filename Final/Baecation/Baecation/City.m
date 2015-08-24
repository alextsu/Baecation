//
//  City.m
//  Baecation
//
//  Created by Alexander Tsu on 5/19/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import "City.h"

//Purpose: Object representing the City's descriptors, name, state, and image

@implementation City

-(id) initWithName: (NSString *) name andState: (NSString *) state andOutdoorsy: (NSString *) outdoorsy andRelaxing: (NSString *) relaxing andFestive: (NSString *) festive andHistoric: (NSString *) historic andTouristy: (NSString *) touristy andLowKey: (NSString *) lowkey andArtsy: (NSString *) artsy andImage: (UIImage *) image {
    
    self = [super init];
    
    self.name = name;
    self.state = state;
    self.outdoorsy = outdoorsy;
    self.relaxing = relaxing;
    self.festive = festive;
    self.historic = historic;
    self.touristy = touristy;
    self.lowkey = lowkey;
    self.artsy = artsy;
    
    self.image = image;
    
    
    return self;
    
}

@end
