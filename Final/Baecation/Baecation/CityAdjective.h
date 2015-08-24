//
//  CityAdjective.h
//  Baecation
//
//  Created by Alexander Tsu on 5/18/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CityAdjective : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) UIImage * image;

-(id) initWithName: (NSString *) name
    andImage: (UIImage *) image;

@end