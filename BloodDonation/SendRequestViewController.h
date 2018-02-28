//
//  SendRequestViewController.h
//  BloodDonation
//
//  Created by apple on 18/11/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendRequestViewController : UIViewController<UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate>{
    
    NSArray *bloodGroups;
    UIPickerView *bloodGroupPicker;
}

@property (strong, nonatomic) NSArray *inputAccessoryViews;

@property (weak, nonatomic) IBOutlet UITextField *txt_bloodGroup;
@property (weak, nonatomic) IBOutlet UITextField *txt_fullName;
@property (weak, nonatomic) IBOutlet UITextField *txt_mobile;
@property (weak, nonatomic) IBOutlet UITextField *txt_units;
@property (weak, nonatomic) IBOutlet UITextField *txt_hospital;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)requestForBlood:(id)sender;
- (IBAction)back:(id)sender;

@end
