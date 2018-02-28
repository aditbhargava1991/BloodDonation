//
//  BloodRequest.m
//  BloodDonation
//
//  Created by apple on 25/11/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "BloodRequest.h"
#import "AppDelegate.h"

@implementation BloodRequest

@synthesize fullName, numberOfUnits, bloodGroup, hospital, mobile, requestId;

-(id)initWithDictionary:(NSDictionary *)request{
    
    if(request){
        
        fullName = [request objectForKey:FULL_NAME_KEY];
        numberOfUnits = [request objectForKey:NUMBER_OF_UNITS_KEY];
        bloodGroup = [request objectForKey:BLOOD_GROUP_KEY];
        hospital = [request objectForKey:HOSPITAL_KEY];
        mobile = [request objectForKey:PHONE_KEY];
        requestId = [request objectForKey:BLOOD_REQUEST_ID_KEY];
    }
    
    return self;
}

@end
