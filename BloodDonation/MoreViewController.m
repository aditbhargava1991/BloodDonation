//
//  MoreViewController.m
//  BloodDonation
//
//  Created by apple on 19/11/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "MoreViewController.h"
#import "AppDelegate.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import <MessageUI/MessageUI.h>
#import <Messages/Messages.h>

@interface MoreViewController ()<CNContactPickerDelegate, MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate>

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"More";
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

- (IBAction)logout:(id)sender {
    
    loggedInUser = nil;
    
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

- (IBAction)inviteFriends:(id)sender {
    
    UIAlertController *shareActionSheet = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [shareActionSheet addAction:[UIAlertAction actionWithTitle:@"Share With Messages" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        CNContactPickerViewController *contactPicker = [CNContactPickerViewController new];
        contactPicker.delegate = self;
        [self presentViewController:contactPicker animated:YES completion:nil];
        
    }]];
    
    [shareActionSheet addAction:[UIAlertAction actionWithTitle:@"Share With WhatsApp" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self shareWithWhatsAppWithMessage:@"Test with WhatsApp"];
        
    }]];
    
    [shareActionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:nil]];
    
    [self presentViewController:shareActionSheet animated:YES completion:^{
        
    }];
}

- (IBAction)shareWithFacebook:(id)sender {
}

- (IBAction)rateUs:(id)sender {
}

- (IBAction)feedbackSupport:(id)sender {
    
    // Email Subject
    NSString *emailTitle = @"Test Email";
    // Email Content
    NSString *messageBody = @"iOS programming is so fun!";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"support@appcoda.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

- (IBAction)aboutUs:(id)sender {
}

#pragma mark - Contact Picker Delegate -

-(void)contactPickerDidCancel:(CNContactPickerViewController *)picker{
    
}

-(void)contactPicker:(CNContactPickerViewController *)picker didSelectContacts:(NSArray<CNContact *> *)contacts{
    
    NSArray *phoneNumbers = [self getMobileNumberForContacts:contacts];
    
    [self performSelector:@selector(smsToRecipients:) withObject:phoneNumbers afterDelay:1.0];
}
//
//-(void)getContactDetails:(CNContact *)contactObject {
//    
//    NSLog(@"NAME PREFIX :: %@",contactObject.namePrefix);
//    NSLog(@"NAME SUFFIX :: %@",contactObject.nameSuffix);
//    NSLog(@"FAMILY NAME :: %@",contactObject.familyName);
//    NSLog(@"GIVEN NAME :: %@",contactObject.givenName);
//    NSLog(@"MIDDLE NAME :: %@",contactObject.middleName);
//    
//    
//    NSString * fullName = [NSString stringWithFormat:@"%@ %@",contactObject.givenName,contactObject.familyName];
////    [self.personName setText:fullName];
//    
//    
//    if(contactObject.imageData) {
//        NSData * imageData = (NSData *)contactObject.imageData;
//        UIImage * contactImage = [[UIImage alloc] initWithData:imageData];
////        [self.personImage setImage:contactImage];
//    }
//    
//    NSString * phone = @"";
//    NSString * userPHONE_NO = @"";
//    for(CNLabeledValue * phonelabel in contactObject.phoneNumbers) {
//        CNPhoneNumber * phoneNo = phonelabel.value;
//        phone = [phoneNo stringValue];
//        if (phone) {
//            userPHONE_NO = phone;
//        }}
//    
//    NSString * email = @"";
//    NSString * userEMAIL_ID = @"";
//    for(CNLabeledValue * emaillabel in contactObject.emailAddresses) {
//        email = emaillabel.value;
//        if (email) {
//            userEMAIL_ID = email;
//        }}
//    
//    NSLog(@"PHONE NO :: %@",userPHONE_NO);
//    NSLog(@"EMAIL ID :: %@",userEMAIL_ID);
////    [self.emailId setText:userEMAIL_ID];
////    [self.phoneNo setText:userPHONE_NO];
//}

-(NSMutableArray *)getMobileNumberForContacts:(NSArray *)contacts{
    
    NSMutableArray *arr_contacts = [[NSMutableArray alloc] init];
    
    for(CNContact *contact in contacts){
        
        NSString * phone = @"";
        NSString * userPHONE_NO = @"";
        for(CNLabeledValue * phonelabel in contact.phoneNumbers) {
            CNPhoneNumber * phoneNo = phonelabel.value;
            phone = [phoneNo stringValue];
            if (phone) {
                userPHONE_NO = phone;
            }
        }
        
        [arr_contacts addObject:userPHONE_NO];
    }
    
    return arr_contacts;
}

#pragma mark - Share With Whatsapp -

-(void)shareWithWhatsAppWithMessage:(NSString *)message{
    
    NSURL *whatsappURL = [NSURL URLWithString:[[NSString stringWithFormat:@"whatsapp://send?text=%@", message] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }
}

#pragma mark - Share With Message -

-(void)smsToRecipients:(NSArray *)recipients{
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = @"";
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

#pragma mark Message Conposer Delegates

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Mail Composer Delegate -

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
