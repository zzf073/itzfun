//
//  HeaderVC.m
//  MobileNight
//

#import "HeaderVC.h"
#import "EventsVC.h"
#import "EventCell.h"
#import "KxMenu.h"
#import "ListDisplayVC.h"
#import "LoginVC.h"
#import "ViewController.h"
#import "RNFrostedSidebar.h"
#import "ProfileVC.h"
#import "BookingVC.h"
#import "AdminVc.h"

#import "AKTabBarController.h"

@interface HeaderVC () <RNFrostedSidebarDelegate>

@end

@implementation HeaderVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = YES;
    self.definesPresentationContext = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)btnShowMenu:(id)sender
{
    [self showSideMenu];
}

- (void)showMenu:(UIButton *)sender
{
    [KxMenu showMenuInView:self.view fromRect:sender.frame menuItems:[self menuItems]];
}

- (NSArray *)menuItems
{
    KxMenuItem *city = [KxMenuItem menuItem:@"Cities"
                                      image:[UIImage imageNamed:@"city-icon.png"]
                                     target:self
                                     action:@selector(goToCites)];
    KxMenuItem *venue = [KxMenuItem menuItem:@"Venues"
                                       image:[UIImage imageNamed:@"venue-icon.png"]
                                      target:self
                                      action:@selector(gotoVenue)];
    KxMenuItem *event = [KxMenuItem menuItem:@"Events"
                                       image:[UIImage imageNamed:@"event-icon.png"]
                                      target:self
                                      action:@selector(goToEvents)];
    
    /*KxMenuItem *booking = [KxMenuItem menuItem:@"Booking"
                                         image:[UIImage imageNamed:@"bookign-icon.png"]
                                        target:self
                                        action:@selector(goToBooking)];*/
    KxMenuItem *login = [KxMenuItem menuItem:@"Login"
                                       image:[UIImage imageNamed:@"login-icon.png"]
                                      target:self
                                      action:@selector(gotoLogin)];
    
    KxMenuItem *profile = [KxMenuItem menuItem:@"Profile"
                                         image:[UIImage imageNamed:@"profile-icon.png"]
                                        target:self
                                        action:@selector(goToProfile)];
    
    KxMenuItem *user;
    
    if ([kAPP_DELEGATE isLogin])
        user = profile;
    else
        user = login;

    NSArray *items;
    
    if ([[kAPP_DELEGATE visitor] isAdmin])
        //items = @[city,venue,event,booking,user];
        items = @[city,venue,event,user];
    else
        //items = @[city,venue,event,booking,user];
        items = @[city,venue,event,user];
    
    return items;
}

- (void)gotoVenue
{
    for (UIViewController *vc in self.navigationController.viewControllers)
    {
        if ([vc isKindOfClass:[ListDisplayVC class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    //ListDisplayVC *vc  = [self.storyboard instantiateViewControllerWithIdentifier:@"ListDisplayVC"];
    ListDisplayVC *vc = [[ListDisplayVC alloc]initWithNibName:@"ListDisplayVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToEvents
{
    for (UIViewController *vc in self.navigationController.viewControllers)
    {
        if ([vc isKindOfClass:[EventsVC class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    
    //EventsVC *vc  = [self.storyboard instantiateViewControllerWithIdentifier:@"EventsVC"];
    EventsVC *vc = [[EventsVC alloc]initWithNibName:@"EventsVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoLogin
{
    for (UIViewController *vc in self.navigationController.viewControllers)
    {
        if ([vc isKindOfClass:[LoginVC class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    
    //LoginVC *vc  = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    LoginVC *vc = [[LoginVC alloc]initWithNibName:@"LoginVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoAdmin
{
    for (UIViewController *vc in self.navigationController.viewControllers)
    {
        if ([vc isKindOfClass:[AdminVc class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    //AdminVc *vc  = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminVc"];
    AdminVc *vc = [[AdminVc alloc]initWithNibName:@"AdminVc" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToCites
{
    for (UIViewController *vc in self.navigationController.viewControllers)
    {
        if ([vc isKindOfClass:[ViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    //ViewController *vc  = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    ViewController *vc = [[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToProfile
{
    for (UIViewController *vc in self.navigationController.viewControllers)
    {
        if ([vc isKindOfClass:[ProfileVC class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    //ProfileVC *vc  = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileVC"];
    ProfileVC *vc = [[ProfileVC alloc]initWithNibName:@"ProfileVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToBooking
{
    NSLog(@"Booking menu");
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)showSideMenu
{
    [self.view endEditing:YES];
    UIImage *imguser;
    UIImage *imgUserIcon;
    NSString *strUser;
    
    if ([kAPP_DELEGATE isLogin])
    {
        imguser = [UIImage imageNamed:@"profile.png"];
        imgUserIcon = [UIImage imageNamed:@"profile-icon.png"];
        strUser = @"Profile";
    }
    else
    {
        imguser = [UIImage imageNamed:@"login.png"];
        imgUserIcon = [UIImage imageNamed:@"login-icon.png"];
        strUser = @"Login";
    }
    
    NSArray *images;
    NSArray *menuIcons;
    NSArray *menuText;

    if ([[kAPP_DELEGATE visitor]isAdmin])
    {
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
    }
    else
    {
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
    
    if ([kAPP_DELEGATE tabBarController])
        callout.delegate = [kAPP_DELEGATE tabBarController];
    
    [callout show];
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index
{
    switch (index)
    {
        case 0:
            [self goToCites];
            break;
        case 1:
            [self gotoVenue];
            break;
        case 2:
            [self goToEvents];
            break;
        case 3:
           // [self goToProfile];
            break;
        case 4: {
            if ([[kAPP_DELEGATE visitor] isAdmin])
                [self gotoAdmin];
            else {
                if ([kAPP_DELEGATE isLogin])
                    [self goToCites];
                else
                    [self gotoLogin];
            }
            break;
        }
        case 5: {
            
            if ([kAPP_DELEGATE isLogin])
                [self goToCites];
            else
                [self gotoLogin];
            
            break;
        }
        case 555: { //log out
            [kAPP_DELEGATE setIsLogin:NO];
            [kAPP_DELEGATE setVisitor:nil];
            [self goToCites];
        }
        default:
            break;
    }
}

@end