//
//  LoginViewController.m
//  BloodDonation
//
//  Created by apple on 17/11/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "LoggedInUser.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addPaddingToTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITextField Delegates -

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField == _txt_email){
        
        [_txt_password becomeFirstResponder];
    }else if (textField == _txt_password){
        
        [_txt_password resignFirstResponder];
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
}

- (IBAction)login:(id)sender {
    
    [_txt_email resignFirstResponder];
    [_txt_password resignFirstResponder];
    
    if(_txt_email.text.length == 0 || _txt_password.text.length == 0){
        
        NSLog(@"Please fill all details");
    }else{
        
        if([AppDelegate validateEmailWithString:_txt_email.text]){
            
            [self sendRequestForLoginWithEmail:_txt_email.text andPassowrd:_txt_password.text];
            
        }else{
            
            [_txt_email becomeFirstResponder];
            NSLog(@"Invalid Email");
        }
    }
}

- (IBAction)back:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Login API -

-(void)sendRequestForLoginWithEmail:(NSString *) email andPassowrd:(NSString *) password{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:API_URL]];
    
    //Set up your request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *dictParameters = [[NSDictionary alloc] initWithObjects:@[REQUEST_TYPE_LOGIN, _txt_email.text, _txt_password.text] forKeys:@[REQUEST_TYPE_KEY, EMAIL_KEY, PASSWORD_KEY]];
    
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dictParameters options:kNilOptions error:nil];
    
    [request setHTTPBody:requestData];
    
    [AppDelegate showLoadingView];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [AppDelegate hideLoadingView];
            
            if(error){
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:APP_NAME message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            }else if (data){
                
                NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                
                if([[dictResponse objectForKey:STATUS_CODE_KEY] integerValue] == 200){
                    
                    NSDictionary *userInfo = [[dictResponse objectForKey:@"loginData"] objectAtIndex:0];
                    
                    loggedInUser = [[LoggedInUser alloc] init];
                    
                    loggedInUser.fullName = [userInfo objectForKey:FULL_NAME_KEY];
                    loggedInUser.mobile = [userInfo objectForKey:PHONE_KEY];
                    loggedInUser.emailAddress = [userInfo objectForKey:EMAIL_KEY];
                    loggedInUser.bloodGroup = [userInfo objectForKey:BLOOD_GROUP_KEY];
                    loggedInUser.country = [userInfo objectForKey:COUNTRY_KEY];
                    loggedInUser.state = [userInfo objectForKey:STATE_KEY];
                    loggedInUser.city = [userInfo objectForKey:CITY_KEY];
                    loggedInUser.lastDonationDate = [userInfo objectForKey:LAST_DONATION_DATE_KEY];
                    loggedInUser.userId = [userInfo objectForKey:USER_ID_KEY];
                    loggedInUser.profileImageURL = [userInfo objectForKey:PROFILE_IMAGE_URL_KEY];
                    
                    NSLog(@"login successfull - %@", loggedInUser.info);
                    
                    [self dismissViewControllerAnimated:YES completion:^{
                       
                        [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCESS_NOTIFICATION_KEY object:nil];
                        
                    }];
                    
                }else{
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:APP_NAME message:[dictResponse objectForKey:MESSAGE_KEY] preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:nil]];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }
            
        });
        
    }] resume];
}

@end
