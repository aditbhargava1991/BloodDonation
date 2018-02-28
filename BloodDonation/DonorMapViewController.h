//
//  DonorMapViewController.h
//  BloodDonation
//
//  Created by apple on 19/11/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface DonorMapViewController : UIViewController<CLLocationManagerDelegate>{
    
    CLLocationManager *locationManager;
}
@property (weak, nonatomic) IBOutlet MKMapView *donorMapView;

- (IBAction)back:(id)sender;

@end
