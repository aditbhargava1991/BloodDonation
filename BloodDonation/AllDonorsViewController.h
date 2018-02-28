//
//  AllDonorsViewController.h
//  BloodDonation
//
//  Created by apple on 17/11/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllDonorsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>{
    
    UIPickerView *picker_filters;
    NSArray *arr_filters;
}

@property (weak, nonatomic) IBOutlet UITableView *table_donors;

@end
