//
//  DonorMapViewController.m
//  BloodDonation
//
//  Created by apple on 19/11/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "DonorMapViewController.h"

@interface DonorMapViewController ()

@end

@implementation DonorMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender{
    
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - CLLocation Manager Delegates -

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *currentLocation = [locations firstObject];
    
    [_donorMapView setCenterCoordinate:currentLocation.coordinate animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
