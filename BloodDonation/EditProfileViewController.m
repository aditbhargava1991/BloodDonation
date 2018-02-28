//
//  EditProfileViewController.m
//  BloodDonation
//
//  Created by apple on 21/11/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "EditProfileViewController.h"
#import "AppDelegate.h"

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if(loggedInUser)
        [self fillUserInfo];
    
    bloodGroups = [[NSArray alloc] initWithObjects:@"O+", @"O-", @"A+", @"A-", @"B+", @"B-", @"AB+", @"AB-", nil];
}

-(void)fillUserInfo{
    
    [_txt_fullName setText:loggedInUser.fullName];
    [_txt_mobile setText:loggedInUser.mobile];
    [_txt_email setText:loggedInUser.emailAddress];
    [_txt_bloodGroup setText:loggedInUser.bloodGroup];
    [_txt_country setText:loggedInUser.country];
    [_txt_city setText:loggedInUser.city];
    [_txt_state setText:loggedInUser.state];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)keyboardHide:(NSNotification *)notificaiton{
    
    UIEdgeInsets contentInset = self.containeScrollView.contentInset;
    contentInset.bottom = 0.0;
    self.containeScrollView.contentInset = contentInset;
}

-(void)keyboardShow:(NSNotification *)notification{
    
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    UIEdgeInsets contentInset = self.containeScrollView.contentInset;
    contentInset.bottom = keyboardRect.size.height;
    self.containeScrollView.contentInset = contentInset;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)updateProfile:(id)sender{
    
    [self resignKeyboard];
    
    if([self allValuesFilled]){
        
        if([AppDelegate validatePhone:_txt_mobile.text]){
            
            if(_txt_email.text.length > 0){
            
                if([AppDelegate validateEmailWithString:_txt_email.text]){
                    
                    [self updateUserProfile];
                    
                }else{
                    
                    NSLog(@"email not valid");
                    [_txt_email becomeFirstResponder];
                }
            }else{
                
                [self updateUserProfile];
            }
        }else{
            
            NSLog(@"phone not valid");
            [_txt_mobile becomeFirstResponder];
        }
    }else{
        
        NSLog(@"fill in all values");
    }
}

-(BOOL)allValuesFilled{
    
    for(UIView *view in _containerView.subviews){
        
        if([view isKindOfClass:[UITextField class]]){
            
            UITextField *txt = (UITextField *) view;
            
            if(txt.text.length == 0 && txt != _txt_email){
                
                return NO;
            }
        }
    }
    
    return YES;
}

- (IBAction)back:(id)sender{
    
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - Select Image -

- (IBAction)selectImage:(id)sender {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    [imagePicker setDelegate:self];
    
    UIAlertController *alertActionSheet = [UIAlertController alertControllerWithTitle:@"" message:@"Select Image Source" preferredStyle:UIAlertControllerStyleActionSheet];
    
    if(![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] || ![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]){
        
        [alertActionSheet addAction:[UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            
            [self presentViewController:imagePicker animated:YES completion:nil];
        }]];
    }else{
        
        [alertActionSheet addAction:[UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            
            [self presentViewController:imagePicker animated:YES completion:nil];
        }]];
        
        [alertActionSheet addAction:[UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            
            [self presentViewController:imagePicker animated:YES completion:nil];
        }]];
        
    }
    
    [alertActionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertActionSheet animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage* originalImage = nil;
    
    originalImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if(originalImage==nil)
    {
        originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    if(originalImage==nil)
    {
        originalImage = [info objectForKey:UIImagePickerControllerCropRect];
    }
    
    [_profileImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_profileImageView setClipsToBounds:YES];
    [_profileImageView setImage:originalImage];
    
    originalImage = [self compressForUpload:originalImage scale:0.1];
    
    //    NSLog(@"%.2f,%.2f", originalImage.size.width, originalImage.size.height);
    //
    //    NSData *imgData = UIImageJPEGRepresentation(originalImage, 1); //1 it represents the quality of the image.
    //    NSLog(@"Size of Image(bytes):%d",[imgData length]);
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (UIImage *)compressForUpload:(UIImage *)original scale:(CGFloat)scale
{
    // Calculate new size given scale factor.
    CGSize originalSize = original.size;
    CGSize newSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale);
    
    // Scale the original image to match the new size.
    UIGraphicsBeginImageContext(newSize);
    [original drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return compressedImage;
}

-(NSString *)saveImage:(UIImage *)parcelImage{
    
    NSData *imageData = UIImageJPEGRepresentation(parcelImage, 0.99);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",@"cached"]];
    
    NSLog((@"pre writing to file"));
    
    if (![imageData writeToFile:imagePath atomically:NO])
    {
        NSLog((@"Failed to cache image data to disk"));
    }
    else
    {
        
        //        NSLog((@"the cachedImagedPath is %@",imagePath));
        
        return imagePath;
    }
    
    //    To retrieve.
    
    //    NSString *theImagePath = [yourDictionary objectForKey:@"cachedImagePath"];
    //    UIImage *customImage = [UIImage imageWithContentsOfFile:theImagePath];
    
    return @"";
}

#pragma mark - UITextField Delegates -

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField == _txt_fullName){
        
        [_txt_bloodGroup becomeFirstResponder];
    }else if (textField == _txt_bloodGroup){
        
        [_txt_mobile becomeFirstResponder];
    }else if (textField == _txt_email){
        
        [_txt_country becomeFirstResponder];
    }else if (textField == _txt_password){
        
        [_txt_country becomeFirstResponder];
    }else if (textField == _txt_country){
        
        [_txt_state becomeFirstResponder];
    }else if (textField == _txt_state){
        
        [_txt_city becomeFirstResponder];
    }else if (textField == _txt_city){
        
        [_txt_city resignFirstResponder];
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if(textField == _txt_mobile){
        
        [self setupInputAccessoryViews];
        
        [textField setInputAccessoryView:[_inputAccessoryViews objectAtIndex:0]];
    }else if (textField == _txt_bloodGroup){
        
        [self setupInputAccessoryViews];
        
        [textField setInputAccessoryView:[_inputAccessoryViews objectAtIndex:0]];
        
        bloodGroupPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        [bloodGroupPicker setDelegate:self];
        [bloodGroupPicker setDataSource:self];
        
        [textField setInputView:bloodGroupPicker];
    }
}

- (void)setupInputAccessoryViews {
    _inputAccessoryViews = [[NSArray alloc] initWithObjects:[[UIToolbar alloc] init], [[UIToolbar alloc] init], [[UIToolbar alloc] init], [[UIToolbar alloc] init], nil];
    
    for(UIToolbar *accessoryView in _inputAccessoryViews) {
        
        UIBarButtonItem *doneButton  = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:nil action:@selector(dismissKeyboard:)];
        
        NSDictionary *barButtonAppearanceDict = @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:16.0], NSForegroundColorAttributeName : [UIColor colorWithRed:151.0/225/0 green:0.0 blue:19.0/225.0 alpha:1.0]};
        
        [[UIBarButtonItem appearance] setTitleTextAttributes:barButtonAppearanceDict forState:UIControlStateNormal];
        
        UIBarButtonItem *flexSpace   = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        [accessoryView sizeToFit];
        [accessoryView setItems:[NSArray arrayWithObjects: flexSpace, doneButton, nil] animated:YES];
    }
}

-(void)dismissKeyboard:(id)sender{
    
    if([_txt_mobile isFirstResponder]){
        
        [_txt_email becomeFirstResponder];
    }else if ([_txt_bloodGroup isFirstResponder]){
        
        [_txt_bloodGroup setText:[bloodGroups objectAtIndex:[bloodGroupPicker selectedRowInComponent:0]]];
        
        [_txt_mobile becomeFirstResponder];
    }
}

#pragma mark - PIcker View Delegates -

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return bloodGroups.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [bloodGroups objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    [_txt_bloodGroup setText:[bloodGroups objectAtIndex:row]];
}


#pragma mark - Update Profile API -

-(void)updateUserProfile{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:API_URL]];
    
    //Set up your request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
    
    [dictParameters setObject:REQUEST_TYPE_UPDATE_USER_PROFILE forKey:REQUEST_TYPE_KEY];
    [dictParameters setObject:_txt_email.text forKey:EMAIL_KEY];
    [dictParameters setObject:_txt_fullName.text forKey:FULL_NAME_KEY];
    [dictParameters setObject:_txt_mobile.text forKey:PHONE_KEY];
    [dictParameters setObject:_txt_bloodGroup.text forKey:BLOOD_GROUP_KEY];
    [dictParameters setObject:_txt_country.text forKey:COUNTRY_KEY];
    [dictParameters setObject:_txt_state.text forKey:STATE_KEY];
    [dictParameters setObject:_txt_city.text forKey:CITY_KEY];
    [dictParameters setObject:loggedInUser.userId forKey:USER_ID_KEY];
    
    NSError *parseError;
    
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dictParameters options:kNilOptions error:&parseError];
    
    if(parseError){
        
        NSLog(@"Parse Error - %@", parseError.localizedDescription);
    }else{
        
        [request setHTTPBody:requestData];
    }
    
    [AppDelegate showLoadingView];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [AppDelegate hideLoadingView];
            
            if(error){
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            }else if (data){
                
                NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                
                if([[dictResponse objectForKey:STATUS_CODE_KEY] integerValue] == 200){
                    
//                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[dictResponse objectForKey:MESSAGE_KEY] preferredStyle:UIAlertControllerStyleAlert];
//                    
//                    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                        [self getUserProfile];
//                    }]];
//                    [self presentViewController:alert animated:YES completion:nil];
                    
                }else{
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[dictResponse objectForKey:MESSAGE_KEY] preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:nil]];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }
            
        });
        
    }] resume];
}

-(void)getUserProfile{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", API_URL]];
    
    //Set up your request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"ContentType"];
    
    NSDictionary *requestDict = [NSDictionary dictionaryWithObjectsAndKeys:REQUEST_TYPE_GET_PROFILE, REQUEST_TYPE_KEY, loggedInUser.userId, USER_ID_KEY, nil];
    
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
                    
                    //                    NSLog(@"User Profile - %@", dictResponse);
                    
                    NSDictionary *userInfo = [[dictResponse objectForKey:@"userProfileData"] objectAtIndex:0];
                    
                    loggedInUser = [[LoggedInUser alloc] init];
                    
                    loggedInUser.fullName = [userInfo objectForKey:FULL_NAME_KEY];
                    loggedInUser.mobile = [userInfo objectForKey:PHONE_KEY];
                    loggedInUser.emailAddress = [userInfo objectForKey:EMAIL_KEY];
                    loggedInUser.bloodGroup = [userInfo objectForKey:BLOOD_GROUP_KEY];
                    loggedInUser.country = [userInfo objectForKey:COUNTRY_KEY];
                    loggedInUser.state = [userInfo objectForKey:STATE_KEY];
                    loggedInUser.city = [userInfo objectForKey:CITY_KEY];
                    loggedInUser.lastDonationDate = [userInfo objectForKey:LAST_DONATION_DATE_KEY];
                    loggedInUser.userId = [userInfo objectForKey:USER_ID_KEY];
                    loggedInUser.profileImageURL = [userInfo objectForKey:PROFILE_IMAGE_URL_KEY];
                    
                    NSLog(@"update successfull - %@", loggedInUser.info);
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Blood Donate" message:@"Profile Updated" preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [[self navigationController] popViewControllerAnimated:YES];
                    }]];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                    
                }else{
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:APP_NAME message:[dictResponse objectForKey:MESSAGE_KEY] preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:nil]];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }
            
        });
        
    }] resume];
}

-(void)resignKeyboard{
    for(UIView *view in self.containerView.subviews){
        
        if([view isKindOfClass:[UITextField class]]){
            
            UITextField *txt = (UITextField *) view;
            
            [txt resignFirstResponder];
        }
    }
    
}

@end
