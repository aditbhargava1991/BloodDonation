//
//  ViewController.m
//  BloodDonation
//
//  Created by apple on 16/11/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<CLLocationManagerDelegate>
{
    
    CLLocationManager *locationManager;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:LOGIN_SUCCESS_NOTIFICATION_KEY object:nil];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    [locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
    
//    if(loggedInUser){
//        
//        [self loginSuccess];
//    }
}

-(void)loginSuccess{
    
    [self performSegueWithIdentifier:@"login" sender:nil];
}

- (void)viewWillAppear:(BOOL)animated{
  
    [[self navigationController] setNavigationBarHidden:YES];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"NewUser"]){
        
        [self performSegueWithIdentifier:@"login" sender:nil];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"NewUser"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"guest"]){
        
        loggedInUser = [[LoggedInUser alloc] init];
        
        loggedInUser.fullName = @"guest";
        loggedInUser.mobile = @"";
        loggedInUser.emailAddress = @"guest@blooddonate.com";
        loggedInUser.bloodGroup = @"O+";
        loggedInUser.country = @"";
        loggedInUser.state = @"";
        loggedInUser.city = @"";
        loggedInUser.lastDonationDate = @"";
        loggedInUser.userId = @"1";
        loggedInUser.profileImageURL = @"";
        
        NSLog(@"login successfull - %@", loggedInUser.info);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Location Manager Delegate -

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *currentLocation = [locations firstObject];
    
    NSLog(@"Current Location - %f, %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    
    NSLog(@"Horizontal Accuracy - %f, Vertical Accuracy - %f", currentLocation.horizontalAccuracy, currentLocation.verticalAccuracy);
    
    [locationManager stopUpdatingLocation];
}

@end
