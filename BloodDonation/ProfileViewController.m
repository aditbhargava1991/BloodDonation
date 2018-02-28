//
//  ProfileViewController.m
//  BloodDonation
//
//  Created by apple on 21/11/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self getUserProfile];
    [self addPaddingToTextField];
    
    if(loggedInUser)
        [self getUserProfile];
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

-(void)viewWillAppear:(BOOL)animated{
    
    [self fillUserInfo];
}

-(void)fillUserInfo{
    
    [_txt_fullName setText:loggedInUser.fullName];
    [_txt_mobile setText:loggedInUser.mobile];
    [_txt_email setText:loggedInUser.emailAddress];
    [_txt_bloodGroup setText:loggedInUser.bloodGroup];
    [_txt_country setText:loggedInUser.country];
    [_txt_city setText:loggedInUser.city];
    [_txt_state setText:loggedInUser.state];
    [_txt_lastDonationDate setText:loggedInUser.lastDonationDate];
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

- (IBAction)back:(id)sender{
    
    [[self navigationController] popViewControllerAnimated:YES];
}

-(void)getUserProfile{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", API_URL]];
    
    //Set up your request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"ContentType"];
    
    NSDictionary *requestDict = [NSDictionary dictionaryWithObjectsAndKeys:REQUEST_TYPE_GET_PROFILE, REQUEST_TYPE_KEY, loggedInUser.userId, USER_ID_KEY, nil];
    
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:requestDict options:kNilOptions error:nil]];
    
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
                    
//                    NSLog(@"User Profile - %@", dictResponse);
                    
                    NSDictionary *userInfo = [[dictResponse objectForKey:@"userProfileData"] objectAtIndex:0];
                    
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
                    
                    [self fillUserInfo];
                    
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
