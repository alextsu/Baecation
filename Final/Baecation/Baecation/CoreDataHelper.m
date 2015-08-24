//
//  CoreDataHelper.m
//  Baecation
//
//  Created by Alexander Tsu on 5/19/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import "CoreDataHelper.h"
#import "CoreData/CoreData.h"
#import "UIKit/UIKit.h"
#import "AppDelegate.h"

//Purpose: Interact with the Core Data Store through methods that store and access CoreData

@implementation CoreDataHelper

//Convert JSON to CoreDataStore
+ (void) storeDataFromJSON {
    
    //Get the path to the City Data JSON and store that JSON as an array
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"citydata" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfMappedFile:filePath];
    NSArray * json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    AppDelegate * ad = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *moc = ad.managedObjectContext;
    
    //For each entry in the JSON
    for (NSDictionary * entry in json) {
        
        //Create a new Entity
        NSEntityDescription * entity = [NSEntityDescription entityForName:@"City" inManagedObjectContext:moc];
        NSManagedObject * cityEntity = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:moc];
        
        //Store each property in the entry
        [cityEntity setValue:entry[@"Artsy"] forKey:@"artsy"];
        [cityEntity setValue:entry[@"City"] forKey:@"city"];
        [cityEntity setValue:entry[@"Festive"] forKey:@"festive"];
        [cityEntity setValue:entry[@"Historic"] forKey:@"historic"];
        [cityEntity setValue:entry[@"Low-Key"] forKey:@"lowkey"];
        [cityEntity setValue:entry[@"Outdoorsy"] forKey:@"outdoorsy"];
        [cityEntity setValue:entry[@"Relaxing"] forKey:@"relaxing"];
        [cityEntity setValue:entry[@"State"] forKey:@"state"];
        [cityEntity setValue:entry[@"Touristy"] forKey:@"touristy"];
        
        //Save the entry in CoreData
        NSError *error = nil;
        if (![moc save:&error]) {
        }
    }
}

//Input an adjective and output an array of cities that match that adjective
+ (NSArray *) accessDataOfSpecifiedType: (NSString *) adjective {
    
    //Fix the LowKey and make adjective lower case
    if ([adjective isEqualToString:@"Low-Key"]) {
        adjective = @"lowkey";
    }
    adjective = [adjective lowercaseString];
    
    //Access managed object context
    AppDelegate * ad = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *moc = ad.managedObjectContext;
    
    //Make a fetch request
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"City" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    //Predicate the results to just the cities that have the inputted adjective as a property
    NSString * predicateText = [NSString stringWithFormat:@"%@ == '1'", adjective];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: predicateText];
    [request setPredicate:predicate];
    
    //Get the array returned
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
   
    NSMutableArray * output = [[NSMutableArray alloc] init];
    
    //Iterate through each element of the predicated array
    for (int i = 0; i < array.count; i++) {
        
        NSString * imageStringBuilder = [NSString stringWithFormat:@"%@.png", [array[i] valueForKeyPath:@"city"]];
        
        //Store each element as a City object
        City * cityEntity = [[City alloc] initWithName:[array[i] valueForKeyPath:@"city"] andState:[array[i] valueForKeyPath:@"state"] andOutdoorsy:[array[i] valueForKeyPath:@"outdoorsy"] andRelaxing:[array[i] valueForKeyPath:@"relaxing"] andFestive:[array[i] valueForKeyPath:@"festive"] andHistoric:[array[i] valueForKeyPath:@"historic"] andTouristy:[array[i] valueForKeyPath:@"touristy"] andLowKey:[array[i] valueForKeyPath:@"lowkey"] andArtsy:[array[i] valueForKeyPath:@"artsy"] andImage:[UIImage imageNamed:imageStringBuilder]];
        
        [output addObject:cityEntity];
    }
    
    //Return all the cities as an NSArray
    return output;
}

//Input a city name and output a City object with the name
+ (City *) accessDataWithSpecifiedCityName: (NSString *) cityName {
    
    //Make a fetch request
    AppDelegate * ad = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *moc = ad.managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"City" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    //Predicate to just entries with the name
    NSString * predicateText = [NSString stringWithFormat:@"city == '%@'", cityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: predicateText];
    [request setPredicate:predicate];
    
    
    //Get the request as an array, but use only the element at index 0
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    
    //Store index 0 as a city
    NSString * imageStringBuilder = [NSString stringWithFormat:@"%@.png", [array[0] valueForKeyPath:@"city"]];
    City * cityEntity = [[City alloc] initWithName:[array[0] valueForKeyPath:@"city"] andState:[array[0] valueForKeyPath:@"state"] andOutdoorsy:[array[0] valueForKeyPath:@"outdoorsy"] andRelaxing:[array[0] valueForKeyPath:@"relaxing"] andFestive:[array[0] valueForKeyPath:@"festive"] andHistoric:[array[0] valueForKeyPath:@"historic"] andTouristy:[array[0] valueForKeyPath:@"touristy"] andLowKey:[array[0] valueForKeyPath:@"lowkey"] andArtsy:[array[0] valueForKeyPath:@"artsy"] andImage:[UIImage imageNamed:imageStringBuilder]];
    
    NSLog(@"State Name %@", cityEntity.state);
    
    //return the city
    return cityEntity;
}

@end
