//
//  RegisterAsDonorViewController.m
//  BloodDonation
//
//  Created by apple on 10/12/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "RegisterAsDonorViewController.h"
#import "AppDelegate.h"

@interface RegisterAsDonorViewController ()

@end

@implementation RegisterAsDonorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self addPaddingToTextField];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self signUpWithValueChanged:_loginWithSegment];
    
    bloodGroups = [[NSArray alloc] initWithObjects:@"O+", @"O-", @"A+", @"A-", @"B+", @"B-", @"AB+", @"AB-", nil];
}

-(void)addPaddingToTextField{
    
    for(UIView *view in self.view.subviews){
        
        if([view isKindOfClass:[UITextField class]]){
            
            UITextField *txt = (UITextField *) view;
            
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, txt.frame.size.height)];
            
            [txt setLeftView:paddingView];
            [txt setLeftViewMode:UITextFieldViewModeAlways];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)resignKeyboard{
    for(UIView *view in self.view.subviews){
        
        if([view isKindOfClass:[UITextField class]]){
            
            UITextField *txt = (UITextField *) view;
            
            [txt resignFirstResponder];
        }
    }
    
}

- (IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registerAsDonor:(id)sender {
    
    if([self allValuesFilled]){
        
        if(isSignUpWithMobile){
            
            if([AppDelegate validatePhone:_txt_mobile.text]){
                
                [self registerWithMobile:_txt_mobile.text];
                
            }else{
                
                NSLog(@"phone not valid");
                [_txt_mobile becomeFirstResponder];
            }
            
        }else{
            
            if([AppDelegate validateEmailWithString:_txt_mobile.text]){
                
                [self registerWithEmail:_txt_mobile.text];
                
            }else{
                
                NSLog(@"email not valid");
                [_txt_mobile becomeFirstResponder];
            }
        }
        
        
    }else{
        
        NSLog(@"fill in all values");
    }
}

- (IBAction)signUpWithValueChanged:(id)sender{
    
    [self resignKeyboard];
    
    [_txt_mobile setText:@""];
    
    if([_loginWithSegment selectedSegmentIndex] == 0){
        
        isSignUpWithMobile = YES;
        [_txt_mobile setPlaceholder:@"Mobile Number"];
        [_txt_mobile setKeyboardType:UIKeyboardTypePhonePad];
        
    }else{
        
        isSignUpWithMobile = NO;
        [_txt_mobile setPlaceholder:@"Email Address"];
        [_txt_mobile setKeyboardType:UIKeyboardTypeEmailAddress];
    }
}

#pragma mark - UITextField Delegates -

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
   if (textField == _txt_mobile){//If signup with email
        
        [_txt_dob becomeFirstResponder];
    }else if (textField == _txt_dob){
        
        [_txt_bloodGroup becomeFirstResponder];
    }else if (textField == _txt_password){
        
        [_txt_password resignFirstResponder];
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if(textField == _txt_mobile && isSignUpWithMobile){
        
        [self setupInputAccessoryViews];
        
        [textField setInputAccessoryView:[_inputAccessoryViews objectAtIndex:0]];
    }else if (textField == _txt_bloodGroup){
        
        [self setupInputAccessoryViews];
        
        [textField setInputAccessoryView:[_inputAccessoryViews objectAtIndex:0]];
        
        bloodGroupPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        [bloodGroupPicker setDelegate:self];
        [bloodGroupPicker setDataSource:self];
        
        [textField setInputView:bloodGroupPicker];
    }else if (textField == _txt_dob){
        
        [self setupInputAccessoryViews];
        
        [textField setInputAccessoryView:[_inputAccessoryViews objectAtIndex:0]];
        
        dateOfBirthPicker = [[UIDatePicker alloc] init];
        [dateOfBirthPicker setDatePickerMode:UIDatePickerModeDate];
        [dateOfBirthPicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        [textField setInputView:dateOfBirthPicker];
    }
}

- (void)setupInputAccessoryViews {
    _inputAccessoryViews = [[NSArray alloc] initWithObjects:[[UIToolbar alloc] init], [[UIToolbar alloc] init], [[UIToolbar alloc] init], [[UIToolbar alloc] init], nil];
    
    for(UIToolbar *accessoryView in _inputAccessoryViews) {
        
        UIBarButtonItem *doneButton  = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:nil action:@selector(dismissKeyboard:)];
        
        NSDictionary *barButtonAppearanceDict = @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:16.0], NSForegroundColorAttributeName : [UIColor colorWithRed:151.0/225/0 green:0.0 blue:19.0/225.0 alpha:1.0]};
        
        [[UIBarButtonItem appearance] setTitleTextAttributes:barButtonAppearanceDict forState:UIControlStateNormal];
        
        UIBarButtonItem *flexSpace   = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        [accessoryView sizeToFit];
        [accessoryView setItems:[NSArray arrayWithObjects: flexSpace, doneButton, nil] animated:YES];
    }
}

-(void)dismissKeyboard:(id)sender{
    
    if([_txt_mobile isFirstResponder]){// if signup with mobile
        
        [_txt_dob becomeFirstResponder];
    }else if ([_txt_bloodGroup isFirstResponder]){
        
        [_txt_bloodGroup setText:[bloodGroups objectAtIndex:[bloodGroupPicker selectedRowInComponent:0]]];
        
        [_txt_password becomeFirstResponder];
    }else if ([_txt_dob isFirstResponder]){
        
        [_txt_bloodGroup becomeFirstResponder];
    }
}

#pragma mark - UIDatePicker Methods -

-(void)datePickerValueChanged:(id)datePicker{
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    
    [_txt_dob setText:[df stringFromDate:[datePicker date]]];
}

#pragma mark - PIcker View Delegates -

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return bloodGroups.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [bloodGroups objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    [_txt_bloodGroup setText:[bloodGroups objectAtIndex:row]];
}

#pragma mark - Helper Methods -

-(BOOL)allValuesFilled{
    
    for(UIView *view in self.view.subviews){
        
        if([view isKindOfClass:[UITextField class]]){
            
            UITextField *txt = (UITextField *) view;
            
            if(txt.text.length == 0){
                
                return NO;
            }
        }
    }
    
    return YES;
}

-(void)registerWithMobile:(NSString *)mobileNumber{
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NewUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)registerWithEmail:(NSString *)mobileNumber{
    
    
}

@end
