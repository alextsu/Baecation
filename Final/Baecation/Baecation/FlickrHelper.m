//
//  FlickrHelper.m
//  Baecation
//
//  Created by Alexander Tsu on 5/23/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import "FlickrHelper.h"
#import "FlickrPhoto.h"

//Purpose: Leverage Flickr API to get images corresponding with a city

@implementation FlickrHelper

//Input city object and output an array of FlickrPhotos taken at the inputted city location
+ (NSArray *) queryFlickrWithCity: (City *) city {
    
    NSMutableArray * output = [[NSMutableArray alloc] init];
    
    //Get the full city name
    NSLog(@"City name; %@", city.name);
    NSString * cityName = [city.name stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString * fullCityName = [NSString stringWithFormat:@"%@%%20%@", cityName, city.state];
    
    //Create the URL for the Flickr API in order to get the location ID for the City
    NSString * locationURLBuilder = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.places.find&api_key=%@&query=%@&format=json&nojsoncallback=1", @"9694547141eba6d5539a066123f7a0fa", fullCityName];
    
    //Call the URL and get the JSON with the location ID
    NSURL * locationURL = [NSURL URLWithString:locationURLBuilder];
    NSData * locationData = [NSData dataWithContentsOfURL:locationURL];
    NSError *error = nil;
    NSDictionary * locationResult = [NSJSONSerialization JSONObjectWithData:locationData options:kNilOptions error:&error];
    
    //Parse the JSON for the location ID
    NSString * placeID = locationResult[@"places"][@"place"][0][@"place_id"];
    
    //NSLog(@"Place ID:%@", placeID);
    
    //Using the location ID, query Flickr one more time to get images taken at the specified location iD
    NSString * builder = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&text=%@&place_id=%@&per_page=50&format=json&nojsoncallback=1", @"9694547141eba6d5539a066123f7a0fa", [NSString stringWithFormat:@"%@%%20view",fullCityName], placeID];
    
    //Get the JSON from Flickr
    NSURL * url = [NSURL URLWithString:builder];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSLog(@"%@", results);
    
    //Parse it to get the photos
    NSDictionary * photos = results[@"photos"][@"photo"];
    
    //Iterate through the results, saving the photo url and and title
    for (NSDictionary * result in photos) {

        NSString * photoURL = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@_b.jpg", result[@"farm"], result[@"server"], result[@"id"], result[@"secret"]];
        
        FlickrPhoto * temp = [[FlickrPhoto alloc] initWithName:result[@"title"] andURL:photoURL];
        NSLog(@"Photo URL %@", temp.photoURL);
        
        [output addObject:temp];
    }
    
    //Return the array of Flickr Photo
    return output;
}
@end
