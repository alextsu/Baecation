//
//  City.h
//  Baecation
//
//  Created by Alexander Tsu on 5/19/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface City : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) UIImage * image;
@property (nonatomic, strong) NSString * state;

@property (nonatomic, strong) NSString * outdoorsy;
@property (nonatomic, strong) NSString * relaxing;
@property (nonatomic, strong) NSString * festive;
@property (nonatomic, strong) NSString * historic;
@property (nonatomic, strong) NSString * touristy;
@property (nonatomic, strong) NSString * lowkey;
@property (nonatomic, strong) NSString * artsy;



-(id) initWithName: (NSString *) name andState: (NSString *) state andOutdoorsy: (NSString *) outdoorsy andRelaxing: (NSString *) relaxing andFestive: (NSString *) festive andHistoric: (NSString *) historic andTouristy: (NSString *) touristy andLowKey: (NSString *) lowkey andArtsy: (NSString *) artsy andImage: (UIImage *) image;

@end
