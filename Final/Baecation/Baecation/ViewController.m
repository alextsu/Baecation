//
//  ViewController.m
//  Baecation
//
//  Created by Alexander Tsu on 5/13/15.
//  Copyright (c) 2015 Alexander Tsu. All rights reserved.
//

#import "ViewController.h"
#import "TabBarController.h"

#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>

//Purpose: Cotains Login Screen and registers FB login/logout

@interface ViewController ()
@property (strong, nonatomic) FBSDKLoginButton * loginButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Make status bar white
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 22)];
    statusBarView.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:statusBarView];
    
    //Create a FB Login BUtton, set its size and bring it in
    self.loginButton = [[FBSDKLoginButton alloc] init];
    self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    self.loginButton.delegate = self;
    self.loginButton.center = CGPointMake(self.view.center.x, self.view.frame.size.height - 100);
    [self.view addSubview:self.loginButton];
    [self.view bringSubviewToFront:self.loginButton];
    
    //For Debugging, verify that FB Access Token is valid
    if([FBSDKAccessToken currentAccessToken] != nil) {
        NSLog(@"Already Logged In");
    }
    else {
         NSLog(@"Not Already Logged In");
    }
    
    //For verifying connection
    if(!self.hasConnectivity) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet Connection Required"
                                                        message:@"Please check your connection settings. This app requires internet connection to function properly."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Delegate method triggered when login to FB
- (void) loginButton:	(FBSDKLoginButton *)loginButton didCompleteWithResult:	(FBSDKLoginManagerLoginResult *)result error:	(NSError *)error {
    
    NSLog(@"Log in");
    
    if (error != nil) {
        NSLog(@"Error");
    }
    //Catch if user cancels FB Login
    else if (result.isCancelled) {
        NSLog(@"Cancelled");
    }
    //Verify that user grants permissions, then segue
    else {
        if([result.grantedPermissions containsObject:@"user_friends"] && [result.grantedPermissions containsObject:@"public_profile"]) {
            
            [self performSegueWithIdentifier:@"showTabBar" sender:self];
        }
        
    }
    
}

//Delegate method triggered when logout of FB
- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    
    //Return to this screen if button pressed
    ViewController * thisView = [self.storyboard instantiateViewControllerWithIdentifier:@"homeView"];
    [self presentViewController:thisView animated:YES completion:nil];
    
    NSLog(@"Log out");

}


- (IBAction)moreInfo:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                    message:@"Baecation is an app to help you find places to travel to. To use this app, first login with your Facebook account. Then select the type of destination you wish to go to by tapping on the pink adjective text. Once you've selected a city, click on one of three icons at the bottom of the page to see destinations, restaurants, and photos of your selected city. After you've saved the list, you can view it in the Lists tab and share it in the Baes tab."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

/*
 The following method checks for connectivity.
 The following method was copied from Apple's Reachability Example: http://developer.apple.com/library/ios/#samplecode/Reachability
 I discovered this code in the following stack overflow link: http://stackoverflow.com/questions/1083701/how-to-check-for-an-active-internet-connection-on-iphone-sdk
 */
-(BOOL)hasConnectivity {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    if(reachability != NULL) {
        //NetworkStatus retVal = NotReachable;
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
            {
                // if target host is not reachable
                return NO;
            }
            
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
            {
                // if target host is reachable and no connection is required
                //  then we'll assume (for now) that your on Wi-Fi
                return YES;
            }
            
            
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
            {
                // ... and the connection is on-demand (or on-traffic) if the
                //     calling application is using the CFSocketStream or higher APIs
                
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
                {
                    // ... and no [user] intervention is needed
                    return YES;
                }
            }
            
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
            {
                // ... but WWAN connections are OK if the calling application
                //     is using the CFNetwork (CFSocketStream?) APIs.
                return YES;
            }
        }
    }
    
    return NO;
}

@end
