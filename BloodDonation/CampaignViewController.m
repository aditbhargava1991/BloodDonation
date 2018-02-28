//
//  CampaignViewController.m
//  BloodDonation
//
//  Created by apple on 18/11/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "CampaignViewController.h"
#import "AppDelegate.h"

@interface CampaignViewController ()

@end

@implementation CampaignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addPaddingToTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.topItem.title = @"Campaign";
    self.navigationController.navigationBar.topItem.hidesBackButton = YES;
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
    
    if([_txt_date isFirstResponder]){
        
        [_txt_fullName becomeFirstResponder];
    }else if ([_txt_mobile isFirstResponder]){
        
        [_txt_mobile resignFirstResponder];
    }
}

#pragma mark - UITextField Delegates -

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField == _txt_venue){
        
        [_txt_date becomeFirstResponder];
    }else if (textField == _txt_fullName){
        
        [_txt_mobile becomeFirstResponder];
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if(textField == _txt_mobile){
        
        [self setupInputAccessoryViews];
        
        [_txt_mobile setInputAccessoryView:[_inputAccessoryViews objectAtIndex:0]];
    }else if (textField == _txt_date){
        
        [self setupInputAccessoryViews];
        [textField setInputAccessoryView:[_inputAccessoryViews objectAtIndex:0]];
        
        datePicker = [UIDatePicker new];
        [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
        [datePicker setMinimumDate:[NSDate date]];
        [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        [self datePickerValueChanged:datePicker];
        
        [textField setInputView:datePicker];
    }
}

-(void)datePickerValueChanged:(id)sender{
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd MMM yyyy hh:mm a"];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    
    [_txt_date setText:[df stringFromDate:[datePicker date]]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)callForCampaign:(id)sender {
    
    
}

@end
