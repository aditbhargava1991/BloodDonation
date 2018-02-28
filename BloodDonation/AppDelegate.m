//
//  AppDelegate.m
//  BloodDonation
//
//  Created by apple on 16/11/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "AppDelegate.h"
#import <MFSideMenu/MFSideMenu.h>
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

LoggedInUser *loggedInUser;
BloodRequest *brequest;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UITabBar appearance] setTintColor:APP_RED_TRANSPERENT];
    
    [UITabBarItem.appearance setTitleTextAttributes:
     @{NSForegroundColorAttributeName : APP_RED_SOLID}
                                           forState:UIControlStateSelected];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    if(loggedInUser){
        
        NSLog(@"Logged In User: %@", loggedInUser.info);
        
        [[NSUserDefaults standardUserDefaults] setObject:loggedInUser.info forKey:LOGGED_IN_USER_INFO_KEY];
        
        NSLog(@"Logged In User: %@", [[NSUserDefaults standardUserDefaults] objectForKey:LOGGED_IN_USER_INFO_KEY]);
        
        loggedInUser = nil;
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:LOGGED_IN_USER_INFO_KEY]){
        
        loggedInUser = [[LoggedInUser alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:LOGGED_IN_USER_INFO_KEY]];
        
        NSLog(@"Logged In User: %@", loggedInUser.info);
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    if(brequest){
        
        brequest = nil;
    }
    
    if(loggedInUser){
        
        [[NSUserDefaults standardUserDefaults] setObject:loggedInUser.info forKey:LOGGED_IN_USER_INFO_KEY];
        loggedInUser = nil;
    }
}

#pragma mark - Helper Methods -

+(void)showLoadingView{
    
    UIView *bgView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [bgView setBackgroundColor:[UIColor clearColor]];
    [bgView setAlpha:1.0];
    [bgView setTag:101];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator setColor:APP_RED_TRANSPERENT];
    [activityIndicator setCenter:bgView.center];
    [activityIndicator setTag:101];
    [activityIndicator startAnimating];
    
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        bgView.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = bgView.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [bgView addSubview:blurEffectView];
    } else {
        bgView.backgroundColor = [UIColor blackColor];
    }
    
//    UIImageView *imgLoading = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 51)];
//    [imgLoading setTag:101];
//    
//    NSMutableArray *arr_animationImages = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"logo1"], [UIImage imageNamed:@"logo2"], [UIImage imageNamed:@"logo3"], [UIImage imageNamed:@"logo4"], [UIImage imageNamed:@"logo5"],[UIImage imageNamed:@"logo6"], [UIImage imageNamed:@"logo7"], [UIImage imageNamed:@"logo8"], [UIImage imageNamed:@"logo9"], [UIImage imageNamed:@"logo10"],[UIImage imageNamed:@"logo11"], [UIImage imageNamed:@"logo12"], [UIImage imageNamed:@"logo13"], [UIImage imageNamed:@"logo14"], [UIImage imageNamed:@"logo15"], [UIImage imageNamed:@"logo16"], nil];
//    
//    [imgLoading setAnimationImages:arr_animationImages];
//    [imgLoading setCenter:bgView.center];
//    [imgLoading setAnimationDuration:1.0];
//    [imgLoading startAnimating];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:bgView];
    [[[UIApplication sharedApplication] keyWindow] addSubview:activityIndicator];
}

+(void)hideLoadingView{
    
    for(UIView *view in [[[UIApplication sharedApplication] keyWindow] subviews]){
        
        if([view tag] == 101){
            
            for(UIImageView *imgLoading in view.subviews){
                if(imgLoading.tag == 101){
                    [imgLoading stopAnimating];
                    [imgLoading removeFromSuperview];
                    
                    break;
                }
            }
            
            [view removeFromSuperview];
        }
    }
}

+ (BOOL)validatePhone:(NSString *)phoneNumber{
    
    //    NSString *phoneRegex = @"^[0-9]{6,14}$";
    //    NSString *phoneRegex = PHONE_NUMBER_VALIDATION_REGEX;
    //    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    if(phoneNumber.length < 10){
        
        return NO;
    }
    
    return YES;
}

+ (BOOL)validateEmailWithString:(NSString*)checkString{
    
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

@end
