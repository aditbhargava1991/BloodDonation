//
//  MyRequestsViewController.h
//  BloodDonation
//
//  Created by apple on 17/11/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Messages/Messages.h>
#import <MessageUI/MessageUI.h>

@interface MyRequestsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate, UINavigationBarDelegate>{
    
    NSMutableArray *arr_bloodRequests;
}

@property (weak, nonatomic) IBOutlet UITableView *table_requests;
@property (weak, nonatomic) IBOutlet UILabel *lbl_noRequests;
- (IBAction)requestForBlood:(id)sender;
@end
