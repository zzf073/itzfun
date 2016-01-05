//
//  ProfileVC.m
//  MobileNight
//

#import "ProfileVC.h"
#import "EditProfileVC.h"


@implementation ProfileVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    lblUserName.text = [NSString stringWithFormat:@"%@",[[kAPP_DELEGATE visitor] userName]];
    lblEmail.text = [NSString stringWithFormat:@"%@",[[kAPP_DELEGATE visitor] loginId]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (IBAction)btnEditClicked:(id)sender {
    //EditProfileVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileVC"];
    EditProfileVC *vc = [[EditProfileVC alloc]initWithNibName:@"EditProfileVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnShowMenu:(id)sender {
    
    [self showSideMenu];
}

- (void)showSideMenu {
    
    [self.view endEditing:YES];
    UIImage *imguser;
    UIImage *imgUserIcon;
    NSString *strUser;
    
    if ([kAPP_DELEGATE isLogin]) {
        imguser = [UIImage imageNamed:@"profile.png"];
         imgUserIcon = [UIImage imageNamed:@"profile-icon.png"];
         strUser = @"Profile"; 
    } else {
        imguser = [UIImage imageNamed:@"login.png"];
        imgUserIcon = [UIImage imageNamed:@"login-icon.png"];
        strUser = @"Login";
    }
    
    NSArray *images;
    NSArray *menuIcons;
    NSArray *menuText;
    
    if ([[kAPP_DELEGATE visitor] isAdmin]) {
        
        images = @[
                   [UIImage imageNamed:@"cites.png"],
                   [UIImage imageNamed:@"venues.png"],
                   [UIImage imageNamed:@"events.png"],
                   //[UIImage imageNamed:@"booking.png"],
                   [UIImage imageNamed:@"reward-icon.png"],
                   [UIImage imageNamed:@"settings.png"],
                   [UIImage imageNamed:@"admin.png"]];//,
                   //imguser];
        menuIcons = @[[UIImage imageNamed:@"city-icon.png"],
                      [UIImage imageNamed:@"venue-icon.png"],
                      [UIImage imageNamed:@"event-icon.png"],
                      //[UIImage imageNamed:@"bookign-icon.png"],
                      [UIImage imageNamed:@"reward-icon.png"],
                      [UIImage imageNamed:@"setting-icon.png"],
                      [UIImage imageNamed:@"admin-icon.png"]];//,
                      //imgUserIcon];
        
        menuText = @[@"Cities",
                     @"Venues",
                     @"Events",
                     @"VIP",
                     @"Profile",
                     @"Admin"];//,
                     //strUser];
    } else {
        images = @[
                   [UIImage imageNamed:@"cites.png"],
                   [UIImage imageNamed:@"venues.png"],
                   [UIImage imageNamed:@"events.png"],
                   //[UIImage imageNamed:@"booking.png"],
                   [UIImage imageNamed:@"reward-icon.png"],
                   [UIImage imageNamed:@"settings.png"],
                   imguser];
        menuIcons = @[[UIImage imageNamed:@"city-icon.png"],
                      [UIImage imageNamed:@"venue-icon.png"],
                      [UIImage imageNamed:@"event-icon.png"],
                      //[UIImage imageNamed:@"bookign-icon.png"],
                      [UIImage imageNamed:@"reward-icon.png"],
                      [UIImage imageNamed:@"setting-icon.png"],
                      imgUserIcon];
        
        menuText = @[@"Cities",
                     @"Venues",
                     @"Events",
                     @"VIP",
                     @"Settings",
                     strUser];
    }
    
    [kAPP_DELEGATE setMenuIcons:menuIcons];
    [kAPP_DELEGATE setMenuText:menuText];
    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images];
    
       if ([kAPP_DELEGATE tabBarController]) {
        callout.delegate = [kAPP_DELEGATE tabBarController];
    }
    [callout show];
}

//
- (NSString *)tabTitle
{
    return @"Settings";
}

- (NSString *)tabImageName
{
    return @"setting-icon.png";
}

- (NSString *)activeTabImageName
{
    return @"setting-icon.png";
}
//

#pragma mark- Change Profile Picture

-(IBAction)clickProfileImage:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Add a photo:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil                                         otherButtonTitles:@"Take photo",@"Photo Library", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            pickerView = [[UIImagePickerController alloc] init];
            pickerView.delegate = self;
            pickerView.allowsEditing = YES;
            pickerView.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:pickerView animated:YES completion:NULL];
        }
    }
    else if(buttonIndex==1)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            pickerView = [[UIImagePickerController alloc] init];
            pickerView.delegate = self;
            pickerView.allowsEditing = YES;
            pickerView.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:pickerView animated:YES completion:NULL];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    imgvwProfile.image = image;
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }];
    
    [pickerView dismissViewControllerAnimated:YES completion:nil];
    
    //
    [kAPP_DELEGATE ShowLoader];
    [self performSelector:@selector(uploadProfileImage) withObject:nil afterDelay:0.1];
}

-(void)uploadProfileImage
{
    NSData *imageData = UIImageJPEGRepresentation(imgvwProfile.image, 1.0);
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:imageData,@"file", nil];
    
    [APIClient uploadImageWithParams:params with:^(NSDictionary *response, NSError *error) {
        
        if (response != nil) {
            
            NSLog(@"%@",response);
            
            NSDictionary *params = @{
                                     @"email": [[kAPP_DELEGATE visitor] loginId],
                                     @"name": [[kAPP_DELEGATE visitor] userName],
                                     @"id": [[kAPP_DELEGATE visitor] loginId],
                                     @"profileImage" :[response objectForKey:@"original"],
                                     @"profileImageThumbnail": [response objectForKey:@"thumbnail"]
                                     };
            
            [APIClient createVisitor:params with:^(NSDictionary *response, NSError *error) {
                
                [kAPP_DELEGATE stopLoader];
                
                if (error == nil) {
                    
                    NSInteger code = [[response valueForKey:@"code"] integerValue];
                    
                    if (code == 0 || code == 200 || code == 201) {

                        [kAPP_DELEGATE setVisitor:[Visitor getVisitor:response]];
                    }
                    
                }else {
                    
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
                }
            }];
        }
        else
            NSLog(@"error");
    }];
    //
}

@end