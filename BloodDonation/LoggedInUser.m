//
//  LoggedInUser.m
//  BloodDonation
//
//  Created by apple on 18/11/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "LoggedInUser.h"
#import "AppDelegate.h"

@implementation LoggedInUser

@synthesize fullName, bloodGroup, city, country, emailAddress, lastDonationDate, mobile, profileImageURL, state, userId;

-(id)initWithDictionary:(NSDictionary *)userInfo{
    
    fullName = [userInfo objectForKey:FULL_NAME_KEY];
    mobile = [userInfo objectForKey:PHONE_KEY];
    emailAddress = [userInfo objectForKey:EMAIL_KEY];
    bloodGroup = [userInfo objectForKey:BLOOD_GROUP_KEY];
    country = [userInfo objectForKey:COUNTRY_KEY];
    state = [userInfo objectForKey:STATE_KEY];
    city = [userInfo objectForKey:CITY_KEY];
    lastDonationDate = [userInfo objectForKey:LAST_DONATION_DATE_KEY];
    profileImageURL = [userInfo objectForKey:PROFILE_IMAGE_URL_KEY];
    userId = [userInfo objectForKey:USER_ID_KEY];
    
    return self;
}

-(NSDictionary *)info{
    
    NSMutableDictionary *dictInfo = [[NSMutableDictionary alloc] init];
    
    if(fullName){
        
        [dictInfo setObject:fullName forKey:FULL_NAME_KEY];
    }
    
    if(mobile){
        
        [dictInfo setObject:mobile forKey:PHONE_KEY];
    }
    
    if(emailAddress){
        
        [dictInfo setObject:emailAddress forKey:EMAIL_KEY];
    }
    
    if(bloodGroup){
        
        [dictInfo setObject:bloodGroup forKey:BLOOD_GROUP_KEY];
    }
    
    if(country){
        
        [dictInfo setObject:country forKey:COUNTRY_KEY];
    }
    
    if(state){
    
        [dictInfo setObject:state forKey:STATE_KEY];
    }
    
    if(city){
        
        [dictInfo setObject:city forKey:CITY_KEY];
    }
    
    if(lastDonationDate){
        
        [dictInfo setObject:lastDonationDate forKey:LAST_DONATION_DATE_KEY];
    }
    
    if(userId){
        
        [dictInfo setObject:userId forKey:USER_ID_KEY];
    }
    
    if(profileImageURL){
        
        [dictInfo setObject:profileImageURL forKey:PROFILE_IMAGE_URL_KEY];
    }
    
    return dictInfo;
}

@end
