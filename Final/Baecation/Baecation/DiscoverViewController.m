//
//  DiscoverViewController.m
//  Baecation
//
//  Created by Alexander Tsu on 5/18/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import "DiscoverViewController.h"
#import "CityAdjective.h"
#import "CitySelectionTableViewController.h"
#import "FacebookHelper.h"

//Purpose: Contains UIScrollView allowing user to select type of city he/she wishes to visit

@interface DiscoverViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *cityScroll;
@property (weak, nonatomic) IBOutlet UIButton *cityAdjective;
@property (nonatomic, strong) NSMutableArray * adjectives;
@property (nonatomic, strong) CityAdjective * currentlySelectedAdjective;
@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Call helper methods to instantiate Scroll
    [self instantiateAdjectives];
    [self instantiateScrollView];
    
    //Set the first adjective selected
    CityAdjective * firstAdjective = [self.adjectives objectAtIndex:0];
    self.currentlySelectedAdjective = firstAdjective;
    [self.cityAdjective setTitle: firstAdjective.name forState:UIControlStateNormal];
    
    //Set status bar to pink
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 22)];
    statusBarView.backgroundColor = [UIColor colorWithRed:253.0f/255.0f green:94.0f/255.0f blue:112.0f/255.0f alpha:1.0f];
    [self.navigationController.navigationBar addSubview:statusBarView];
    
    //Get user data and store in NS UserDefaults
    [FacebookHelper getUserData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Helper method to check if iPhone 6 Plus. Scrollview dimensions are off for iPhone 6 Plus, so I needed to hardcode coordinates to offset this.
-(BOOL)iPhone6PlusDevice{
    if ([UIScreen mainScreen].scale > 2.9) return YES;
    return NO;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int indexOfPage;
    
    //Hard-coded fixes to iPhone 6 Plus display errors
    if ([self iPhone6PlusDevice]) {
        indexOfPage = scrollView.contentOffset.x / (scrollView.frame.size.width - 9);
    }
    else {
        indexOfPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    }

    //Print page index
    NSLog(@"Index: %d", indexOfPage);
    
    //Set the selectedAdjective when user switches to another scrollview
    CityAdjective* selectedAdjective = [self.adjectives objectAtIndex:indexOfPage];
    self.currentlySelectedAdjective = selectedAdjective;
    [self.cityAdjective setTitle: selectedAdjective.name forState:UIControlStateNormal];
}

#pragma mark - Instantiation Helper Methods

//Instantiates Adjective objects and loads them into the adjectives array, which is used to set the scrollview
- (void) instantiateAdjectives {
    CityAdjective * artsy = [[CityAdjective alloc] initWithName:@"Artsy" andImage:[UIImage imageNamed:@"Artsy.png"]];
    CityAdjective * outdoorsy = [[CityAdjective alloc] initWithName:@"Outdoorsy" andImage:[UIImage imageNamed:@"Outdoorsy.png"]];
    CityAdjective * festive = [[CityAdjective alloc] initWithName:@"Festive" andImage:[UIImage imageNamed:@"Festive.png"]];
    CityAdjective * historic = [[CityAdjective alloc] initWithName:@"Historic" andImage:[UIImage imageNamed:@"Historic.png"]];
    CityAdjective * lowkey = [[CityAdjective alloc] initWithName:@"Low-Key" andImage:[UIImage imageNamed:@"Low-Key.png"]];
    CityAdjective * relaxing = [[CityAdjective alloc] initWithName:@"Relaxing" andImage:[UIImage imageNamed:@"Relaxing.png"]];
    CityAdjective * touristy = [[CityAdjective alloc] initWithName:@"Touristy" andImage:[UIImage imageNamed:@"Touristy.png"]];
    
    self.adjectives = [NSMutableArray arrayWithObjects:artsy,outdoorsy,festive,historic,lowkey,relaxing,touristy, nil];
    
}

//Instantiates Scroll View by utilizing the adjectives array to set each imageview
- (void) instantiateScrollView {
    self.cityScroll.delegate = self;
    self.cityScroll.pagingEnabled = YES;
    
    //Fix display errors on iPhone 6 Plus
    if ([self iPhone6PlusDevice]) self.cityScroll.contentSize = CGSizeMake((self.view.frame.size.width-9) * self.adjectives.count, 0);
    else self.cityScroll.contentSize = CGSizeMake(self.view.frame.size.width * self.adjectives.count, 0);
    
    //For each uiimageview set it to corresponding Adjective's image
    for (int i = 0; i < self.adjectives.count; i++) {
        CityAdjective * cItem = [self.adjectives objectAtIndex:i];
        
        UIImageView * cImage;
        
        //Fix the offset on iPhone 6 Plus
        if ([self iPhone6PlusDevice]) {
            cImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-9)*i, 0, self.view.frame.size.width, self.view.frame.size.width)];
        }
        else {
            cImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width)*i, 0, self.view.frame.size.width, self.view.frame.size.width)];
        }
        
        //Pass the image in and add it to the scrollview
        cImage.image = cItem.image;
        [self.cityScroll addSubview:cImage];
        
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navController = [segue destinationViewController];
    CitySelectionTableViewController * cstvc = (CitySelectionTableViewController *)([navController viewControllers][0]);
    [cstvc setSelectedAdjective: self.currentlySelectedAdjective];
}


@end
