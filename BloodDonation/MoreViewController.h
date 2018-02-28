//
//  MoreViewController.h
//  BloodDonation
//
//  Created by apple on 19/11/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *profileView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_bloodGroup;
@property (weak, nonatomic) IBOutlet UIButton *btn_Logout;

- (IBAction)logout:(id)sender;
- (IBAction)inviteFriends:(id)sender;
- (IBAction)shareWithFacebook:(id)sender;
- (IBAction)rateUs:(id)sender;
- (IBAction)feedbackSupport:(id)sender;
- (IBAction)aboutUs:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lbl_version;

@end
