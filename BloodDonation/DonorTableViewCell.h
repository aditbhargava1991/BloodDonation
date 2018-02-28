//
//  DonorTableViewCell.h
//  BloodDonation
//
//  Created by apple on 17/11/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DonorTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *bloodGroup;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@end
