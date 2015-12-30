//
//  ProfileVC.m
//  MobileNight
//

#import "ProfileVC.h"
#import "EditProfileVC.h"


@implementation ProfileVC

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
                   [UIImage imageNamed:@"settings.png"],
                   [UIImage imageNamed:@"admin.png"]];//,
                   //imguser];
        menuIcons = @[[UIImage imageNamed:@"city-icon.png"],
                      [UIImage imageNamed:@"venue-icon.png"],
                      [UIImage imageNamed:@"event-icon.png"],
                      //[UIImage imageNamed:@"bookign-icon.png"],
                      [UIImage imageNamed:@"setting-icon.png"],
                      [UIImage imageNamed:@"admin-icon.png"]];//,
                      //imgUserIcon];
        
        menuText = @[@"Cities",
                     @"Venues",
                     @"Events",
                     //@"Booking",
                     @"Profile",
                     @"Admin"];//,
                     //strUser];
    } else {
        images = @[
                   [UIImage imageNamed:@"cites.png"],
                   [UIImage imageNamed:@"venues.png"],
                   [UIImage imageNamed:@"events.png"],
                   //[UIImage imageNamed:@"booking.png"],
                   [UIImage imageNamed:@"settings.png"],
                   imguser];
        menuIcons = @[[UIImage imageNamed:@"city-icon.png"],
                      [UIImage imageNamed:@"venue-icon.png"],
                      [UIImage imageNamed:@"event-icon.png"],
                      //[UIImage imageNamed:@"bookign-icon.png"],
                      [UIImage imageNamed:@"setting-icon.png"],
                      imgUserIcon];
        
        menuText = @[@"Cities",
                     @"Venues",
                     @"Events",
                     //@"Booking",
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

@end