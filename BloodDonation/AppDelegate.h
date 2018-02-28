//
//  AppDelegate.h
//  BloodDonation
//
//  Created by apple on 16/11/16.
//  Copyright © 2016 apple. All rights reserved.
//

#define API_URL         @"http://www.phpprojectstatus.in/blooddoner/webservice/appservices.php"

#define APP_NAME                            @"Blood Donation"

#define LOGIN_SUCCESS_NOTIFICATION_KEY      @"Login Success"

#define APP_RED_TRANSPERENT                 [UIColor colorWithRed:199.0/255.0 green:64.0/255.0 blue:76.0/255.0 alpha:1.0]

#define APP_RED_SOLID                       [UIColor colorWithRed:193.0/255.0 green:31.0/255.0 blue:45.0/255.0 alpha:1.0]

#define LOGGED_IN_USER_INFO_KEY             @"userInfo"

// API Keys
#define REQUEST_TYPE_KEY                    @"request"
#define EMAIL_KEY                           @"email"
#define PASSWORD_KEY                        @"password"
#define BLOOD_GROUP_KEY                     @"blood_group"
#define PHONE_KEY                           @"phone"
#define COUNTRY_KEY                         @"country"
#define STATE_KEY                           @"state"
#define CITY_KEY                            @"city"
#define FULL_NAME_KEY                       @"fname"
#define LAST_DONATION_DATE_KEY              @"lastdonationdate"
#define VERIFICATION_CODE_KEY               @"verificationcode"
#define STATUS_CODE_KEY                     @"statusCode"
#define MESSAGE_KEY                         @"msg"
#define USER_ID_KEY                         @"user_id"
#define PAGE_NUM_KEY                        @"pagenum"
#define COUNT_KEY                           @"count"
#define PROFILE_IMAGE_URL_KEY               @"user_img"
#define HOSPITAL_KEY                        @"hospital"
#define NUMBER_OF_UNITS_KEY                 @"no_of_units"
#define BLOOD_REQUEST_LIST_KEY              @"bRequestList"
#define BLOOD_REQUEST_ID_KEY                @"id"


// API Request Types
#define REQUEST_TYPE_NEW_USER               @"new_user"
#define REQUEST_TYPE_LOGIN                  @"login"
#define REQUEST_TYPE_GET_PROFILE            @"user_profile"
#define REQUEST_TYPE_UPDATE_USER_PROFILE    @"update_user_profile"
#define REQUEST_TYPE_SEND_BLOOD_REQUEST     @"send_breq"
#define REQUEST_TYPE_GET_BLOOD_REQUESTS     @"blood_request_list"


#import <UIKit/UIKit.h>
#import "LoggedInUser.h"
#import "BloodRequest.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (void)showLoadingView;
+ (void)hideLoadingView;
+ (BOOL)validatePhone:(NSString *)phoneNumber;
+ (BOOL)validateEmailWithString:(NSString*)checkString;

extern LoggedInUser *loggedInUser;
extern BloodRequest *brequest;
@end

