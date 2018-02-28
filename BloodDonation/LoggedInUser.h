//
//  LoggedInUser.h
//  BloodDonation
//
//  Created by apple on 18/11/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoggedInUser : NSObject

-(id)initWithDictionary:(NSDictionary *)userInfo;

@property NSString *fullName;
@property NSString *mobile;
@property NSString *emailAddress;
@property NSString *bloodGroup;
@property NSString *country;
@property NSString *state;
@property NSString *city;
@property NSString *lastDonationDate;
@property NSString *userId;
@property NSString *profileImageURL;

-(NSDictionary *)info;

@end
