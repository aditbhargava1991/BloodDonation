//
//  EditProfileViewController.h
//  BloodDonation
//
//  Created by apple on 21/11/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditProfileViewController : UIViewController<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>{
    
    NSArray *bloodGroups;
    UIPickerView *bloodGroupPicker;
}

@property (strong, nonatomic) NSArray *inputAccessoryViews;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIScrollView *containeScrollView;
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

- (IBAction)updateProfile:(id)sender;
- (IBAction)selectImage:(id)sender;

- (IBAction)back:(id)sender;

@end
