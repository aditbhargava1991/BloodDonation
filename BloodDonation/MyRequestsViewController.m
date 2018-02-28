//
//  MyRequestsViewController.m
//  BloodDonation
//
//  Created by apple on 17/11/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "MyRequestsViewController.h"
#import "MyRequestsTableViewCell.h"
#import "AppDelegate.h"
#import "BloodRequest.h"

@interface MyRequestsViewController ()

@end

@implementation MyRequestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self navigationController] setNavigationBarHidden:NO];
    [[self navigationItem] setHidesBackButton:YES];
    
    [_table_requests setTableFooterView:[UIView new]];
    
//    [self getUserRequests];
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.topItem.title = @"My Requests";
    self.navigationController.navigationBar.topItem.hidesBackButton = YES;
    [self.tabBarItem setTitle:@"My Requests"];
    
//    if(brequest){
//        
//        [arr_bloodRequests insertObject:brequest atIndex:0];
//        
//        [_table_requests insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//        
//        brequest = nil;
//    }
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

- (IBAction)requestForBlood:(id)sender {
}

#pragma mark - UITableView Delegates and Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    return arr_bloodRequests.count;
    
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyRequestsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
//    BloodRequest *request = [arr_bloodRequests objectAtIndex:indexPath.row];
//    
//    [cell.shareButton addTarget:self action:@selector(shareRequest:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.callButton addTarget:self action:@selector(placeCall:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [cell.messageLabel setText:[NSString stringWithFormat:@"You requested %@ units of %@ blood at %@", request.numberOfUnits, request.bloodGroup, request.hospital]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

#pragma mark - Share / Call -

-(void)placeCall:(id)sender{
    
    MyRequestsTableViewCell *cell = (MyRequestsTableViewCell *) [[sender superview] superview];
//    use cell's indexPath to get mobile number here
    
    BloodRequest *req = [arr_bloodRequests objectAtIndex:[_table_requests indexPathForCell:cell].row];
    
    [self placeCallToPhoneNumber:req.mobile];
}

-(void)shareRequest:(id)sender{
    
    MyRequestsTableViewCell *cell = (MyRequestsTableViewCell *) [[sender superview] superview];
    
    UIAlertController *shareActionSheet = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [shareActionSheet addAction:[UIAlertAction actionWithTitle:@"Share With Messages" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self smsWithMessage:cell.messageLabel.text];
        
    }]];
    
    [shareActionSheet addAction:[UIAlertAction actionWithTitle:@"Share With WhatsApp" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self shareWithWhatsAppWithMessage:cell.messageLabel.text];
        
    }]];
    
    [shareActionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:nil]];
    
    [self presentViewController:shareActionSheet animated:YES completion:^{
        
    }];
}

#pragma mark Share With WhatsApp

-(void)shareWithWhatsAppWithMessage:(NSString *)message{
    
    NSURL *whatsappURL = [NSURL URLWithString:[[NSString stringWithFormat:@"whatsapp://send?text=%@", message] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }
}

#pragma mark Share With Message

-(void)smsWithMessage:(NSString *)message{
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = message;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

#pragma mark Message Conposer Delegates

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Call

-(void)placeCallToPhoneNumber:(NSString *)phoneNumber{
    
    NSString *phoneCallNum = [NSString stringWithFormat:@"tel://%@",phoneNumber ];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:phoneCallNum]]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:phoneNumber preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:nil]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Call" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneCallNum]];
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    } else{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Call Facility Not Available" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDestructive handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)getUserRequests{
    
    NSURL *url = [NSURL URLWithString:API_URL];
    
    //Set up your request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    
    NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
    
    [requestDict setObject:REQUEST_TYPE_GET_BLOOD_REQUESTS forKey:REQUEST_TYPE_KEY];
    [requestDict setObject:loggedInUser.userId forKey:USER_ID_KEY];
    
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
                    
                    arr_bloodRequests = [[NSMutableArray alloc] init];
                    
                    for(NSDictionary *dict in [dictResponse objectForKey:BLOOD_REQUEST_LIST_KEY]){
                        
                        BloodRequest *request = [[BloodRequest alloc] initWithDictionary:dict];
                        
                        [arr_bloodRequests addObject:request];
                    }
                    
                    [_table_requests reloadData];
                    
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
