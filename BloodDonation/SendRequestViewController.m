//
//  SendRequestViewController.m
//  BloodDonation
//
//  Created by apple on 18/11/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "SendRequestViewController.h"
#import "AppDelegate.h"

@interface SendRequestViewController ()

@end

@implementation SendRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self addPaddingToTextField];
    
    bloodGroups = [[NSArray alloc] initWithObjects:@"O+", @"O-", @"A+", @"A-", @"B+", @"B-", @"AB+", @"AB-", nil];
    
    if(loggedInUser){
        
        [self fillUserInfo];
    }
}

-(void)fillUserInfo{
    
    [_txt_fullName setText:loggedInUser.fullName];
    [_txt_mobile setText:loggedInUser.mobile];
//    [_txt_bloodGroup setText:loggedInUser.bloodGroup];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addPaddingToTextField{
    
    for(UIView *view in _containerView.subviews){
        
        if([view isKindOfClass:[UITextField class]]){
            
            UITextField *txt = (UITextField *) view;
            
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, txt.frame.size.height)];
            
            [txt setLeftView:paddingView];
            [txt setLeftViewMode:UITextFieldViewModeAlways];
        }
    }
}

#pragma mark - Keyboard Show/Hide -

-(void)keyboardHide:(NSNotification *)notificaiton{
    
    UIEdgeInsets contentInset = self.scrollView.contentInset;
    contentInset.bottom = 0.0;
    self.scrollView.contentInset = contentInset;
}

-(void)keyboardShow:(NSNotification *)notification{
    
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    UIEdgeInsets contentInset = self.scrollView.contentInset;
    contentInset.bottom = keyboardRect.size.height;
    self.scrollView.contentInset = contentInset;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

#pragma mark - UITextField Delegates -

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField == _txt_bloodGroup){
        
        [_txt_fullName becomeFirstResponder];
    }else if (textField == _txt_fullName){
        
        [_txt_mobile becomeFirstResponder];
    }else if (textField == _txt_hospital){
        
        [_txt_hospital resignFirstResponder];
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if(textField == _txt_mobile || textField == _txt_units){
        
        [self setupInputAccessoryViews];
        [textField setInputAccessoryView:[_inputAccessoryViews objectAtIndex:0]];
    }else if (textField == _txt_bloodGroup){
        
        [self setupInputAccessoryViews];
        
        [textField setInputAccessoryView:[_inputAccessoryViews objectAtIndex:0]];
        
        bloodGroupPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        [bloodGroupPicker setDelegate:self];
        [bloodGroupPicker setDataSource:self];
        
        [textField setInputView:bloodGroupPicker];
    }
}

#pragma mark - IBActions -

-(void)resignKeyboard{
    for(UIView *view in self.view.subviews){
        
        if([view isKindOfClass:[UITextField class]]){
            
            UITextField *txt = (UITextField *) view;
            
            [txt resignFirstResponder];
        }
    }
    
}

- (IBAction)requestForBlood:(id)sender {
    
    [self resignKeyboard];
    
    if([self allValuesFilled]){
        
        if([AppDelegate validatePhone:_txt_mobile.text]){
            
            [self sendBloodRequest];
            
        }else{
            
            NSLog(@"phone not valid");
            [_txt_mobile becomeFirstResponder];
        }
    }else{
        
        NSLog(@"fill in all values");
    }
}
- (IBAction)back:(id)sender {
    
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - Input Accessory Views -

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
    
    if([_txt_mobile isFirstResponder]){
        
        [_txt_units becomeFirstResponder];
    }else if ([_txt_units isFirstResponder]){
        
        [_txt_hospital becomeFirstResponder];
    }else if ([_txt_bloodGroup isFirstResponder]){
        
        [_txt_fullName becomeFirstResponder];
    }
}

-(BOOL)allValuesFilled{
    
    for(UIView *view in _containerView.subviews){
        
        if([view isKindOfClass:[UITextField class]]){
            
            UITextField *txt = (UITextField *) view;
            
            if(txt.text.length == 0){
                
                return NO;
            }
        }
    }
    
    return YES;
}

-(void)sendBloodRequest{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:API_URL]];
    
    //Set up your request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
    
    [dictParameters setObject:REQUEST_TYPE_SEND_BLOOD_REQUEST forKey:REQUEST_TYPE_KEY];
    [dictParameters setObject:_txt_fullName.text forKey:FULL_NAME_KEY];
    [dictParameters setObject:_txt_mobile.text forKey:PHONE_KEY];
    [dictParameters setObject:_txt_bloodGroup.text forKey:BLOOD_GROUP_KEY];
    [dictParameters setObject:_txt_units.text forKey:NUMBER_OF_UNITS_KEY];
    [dictParameters setObject:_txt_hospital.text forKey:HOSPITAL_KEY];
    [dictParameters setObject:loggedInUser.userId forKey:USER_ID_KEY];
    
    NSError *parseError;
    
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dictParameters options:kNilOptions error:&parseError];
    
    if(parseError){
        
        NSLog(@"Parse Error - %@", parseError.localizedDescription);
    }else{
        
        [request setHTTPBody:requestData];
    }
    
    [AppDelegate showLoadingView];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [AppDelegate hideLoadingView];
            
            if(error){
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            }else if (data){
                
                NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                
                if([[dictResponse objectForKey:STATUS_CODE_KEY] integerValue] == 200){
                    
                    brequest = [[BloodRequest alloc] initWithDictionary:dictParameters];
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[dictResponse objectForKey:MESSAGE_KEY] preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [[self navigationController ] popViewControllerAnimated:YES];
                    }]];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                }else{
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[dictResponse objectForKey:MESSAGE_KEY] preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:nil]];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }
            
        });
        
    }] resume];
}

@end
