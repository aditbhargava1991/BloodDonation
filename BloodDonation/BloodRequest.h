//
//  BloodRequest.h
//  BloodDonation
//
//  Created by apple on 25/11/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BloodRequest : NSObject

-(id)initWithDictionary:(NSDictionary *)request;

@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *bloodGroup;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *numberOfUnits;
@property (strong, nonatomic) NSString *hospital;
@property (strong, nonatomic) NSString *requestId;

@end
