//
//  CampaignViewController.h
//  BloodDonation
//
//  Created by apple on 18/11/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CampaignViewController : UIViewController{
    
    UIDatePicker *datePicker;
}

@property (weak, nonatomic) IBOutlet UITextField *txt_venue;
@property (weak, nonatomic) IBOutlet UITextField *txt_date;
@property (weak, nonatomic) IBOutlet UITextField *txt_time;
@property (weak, nonatomic) IBOutlet UITextField *txt_fullName;
@property (weak, nonatomic) IBOutlet UITextField *txt_mobile;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)callForCampaign:(id)sender;

@property (strong, nonatomic) NSArray *inputAccessoryViews;

@end
