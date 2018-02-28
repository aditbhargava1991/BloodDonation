//
//  ProfileViewController.h
//  BloodDonation
//
//  Created by apple on 21/11/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController

- (IBAction)back:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextField *txt_fullName;
@property (weak, nonatomic) IBOutlet UITextField *txt_bloodGroup;
@property (weak, nonatomic) IBOutlet UITextField *txt_mobile;
@property (weak, nonatomic) IBOutlet UIButton *btn_countryCode;
@property (weak, nonatomic) IBOutlet UITextField *txt_email;
@property (weak, nonatomic) IBOutlet UITextField *txt_password;
@property (weak, nonatomic) IBOutlet UITextField *txt_country;
@property (weak, nonatomic) IBOutlet UITextField *txt_state;
@property (weak, nonatomic) IBOutlet UITextField *txt_city;
@property (weak, nonatomic) IBOutlet UITextField *txt_lastDonationDate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_donations;
@property (weak, nonatomic) IBOutlet UILabel *lbl_shares;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
