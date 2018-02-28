//
//  RegisterAsDonorViewController.h
//  BloodDonation
//
//  Created by apple on 10/12/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterAsDonorViewController : UIViewController<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{
    
    NSArray *bloodGroups;
    UIPickerView *bloodGroupPicker;
    UIDatePicker *dateOfBirthPicker;
    BOOL isSignUpWithMobile;
}

@property (strong, nonatomic) NSArray *inputAccessoryViews;

@property (weak, nonatomic) IBOutlet UISegmentedControl *loginWithSegment;

- (IBAction)back:(id)sender;
- (IBAction)registerAsDonor:(id)sender;
- (IBAction)signUpWithValueChanged:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *txt_mobile;
@property (weak, nonatomic) IBOutlet UITextField *txt_dob;
@property (weak, nonatomic) IBOutlet UITextField *txt_password;
@property (weak, nonatomic) IBOutlet UITextField *txt_bloodGroup;

@end
