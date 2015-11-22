//
//  CustomTabController.m
//  MobileNight
//
//  Created by Anand Patel on 10/07/15.
//  Copyright (c) 2015 Anand Patel. All rights reserved.
//

#import "CustomTabController.h"
#import "LoginVC.h"
#import "AdminVc.h"
#import "MapDisplayVC.h"

@interface CustomTabController ()<UIActionSheetDelegate>

@end

@implementation CustomTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.definesPresentationContext = YES;

    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabChanged) name:MHCustomTabBarControllerViewControllerChangedNotification object:nil];
    [kAPP_DELEGATE setTabBarController:self];
}

- (void)tabChanged {
    [self setColors];
    //UIColor *selectedColor  = [UIColor colorWithRed:37.0/255.0 green:167.0/255.0 blue:220.0/255.0 alpha:100];
    
    UIColor *tintColor = [UIColor whiteColor];
   

    switch (self.selectedIndex) {
        case 0: {
            [[self.footerView imgTabIcon1] setTintColor:tintColor];
            [[self.footerView imgTabText1] setTintColor:tintColor];
            [[self.footerView lblTab1] setTextColor:tintColor];

          //  [[self.footerView tab1] setBackgroundColor:selectedColor];
            break;
        }
          
        case 1: {
            [[self.footerView imgTabIcon2] setTintColor:tintColor];
            [[self.footerView imgTabText2] setTintColor:tintColor];
            [[self.footerView lblTab2] setTextColor:tintColor];

            //[[self.footerView tab2] setBackgroundColor:selectedColor];
            break;
        }
          

        case 2: {
            [[self.footerView imgTabIcon3] setTintColor:tintColor];
            [[self.footerView imgTabText3] setTintColor:tintColor];
            [[self.footerView lblTab3] setTextColor:tintColor];

           // [[self.footerView tab3] setBackgroundColor:selectedColor];
            break;

        }
           
        case 3: {
            [[self.footerView imgTabIcon4] setTintColor:tintColor];
            [[self.footerView imgTabText4] setTintColor:tintColor];
            [[self.footerView lblTab4] setTextColor:tintColor];

           // [[self.footerView tab4] setBackgroundColor:selectedColor];
            break;
        }
           
        case 4: {
            [[self.footerView imgTabIcon5] setTintColor:tintColor];
            [[self.footerView imgTabText5] setTintColor:tintColor];
            [[self.footerView lblTab5] setTextColor:tintColor];

           // [[self.footerView tab5] setBackgroundColor:selectedColor];
            break;
        }
    default:
            break;
    }
}

- (void)setColors {
    
    [self.footerView setImages];
    UIColor *backColor  = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    [[self.footerView tab1] setBackgroundColor:backColor];
    [[self.footerView tab2] setBackgroundColor:backColor];
    [[self.footerView tab3] setBackgroundColor:backColor];
    [[self.footerView tab4] setBackgroundColor:backColor];
    [[self.footerView tab5] setBackgroundColor:backColor];
    
    UIColor *tintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    [[self.footerView imgTabIcon1] setTintColor:tintColor];
    [[self.footerView imgTabIcon2] setTintColor:tintColor];
    [[self.footerView imgTabIcon3] setTintColor:tintColor];
    [[self.footerView imgTabIcon4] setTintColor:tintColor];
    [[self.footerView imgTabIcon5] setTintColor:tintColor];
    
    [[self.footerView imgTabText1] setTintColor:tintColor];
    [[self.footerView imgTabText2] setTintColor:tintColor];
    [[self.footerView imgTabText3] setTintColor:tintColor];
    [[self.footerView imgTabText4] setTintColor:tintColor];
    [[self.footerView imgTabText5] setTintColor:tintColor];
    
    [[self.footerView lblTab1] setTextColor:tintColor];
    [[self.footerView lblTab2] setTextColor:tintColor];
    [[self.footerView lblTab3] setTextColor:tintColor];
    [[self.footerView lblTab4] setTextColor:tintColor];
    [[self.footerView lblTab5] setTextColor:tintColor];
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    
    [sidebar dismissAnimated:YES];
    if (index<4) {
        [[self.buttons objectAtIndex:index] sendActionsForControlEvents:UIControlEventTouchUpInside];
    } else {
        switch (index) {
            case 4: {
                if ([[kAPP_DELEGATE visitor] isAdmin]) {
                    [self gotoAdmin];
                } else {
                    if ([kAPP_DELEGATE isLogin]) {
                        [[self.buttons objectAtIndex:3] sendActionsForControlEvents:UIControlEventTouchUpInside];
                    } else {
                        [self gotoLogin];
                    }
                }
                break;
            }
            case 5: {
                
                if ([kAPP_DELEGATE isLogin]) {
                    [[self.buttons objectAtIndex:3] sendActionsForControlEvents:UIControlEventTouchUpInside];
                } else {
                    [self gotoLogin];
                }
                break;
            }
            case 555: { //log out
                [kAPP_DELEGATE setIsLogin:NO];
                [kAPP_DELEGATE setVisitor:nil];
                [self gotoLogin];
            }
            default:
                break;
        }
    }

    /*switch (index) {
        case 0:
            [self performSegueWithIdentifier:@"viewController1" sender:[self.buttons objectAtIndex:0]];

            break;
        case 1:
            [self performSegueWithIdentifier:@"viewController2" sender:[self.buttons objectAtIndex:1]];
            break;


        case 2:
            [self performSegueWithIdentifier:@"viewController3" sender:[self.buttons objectAtIndex:2]];
            break;
        case 3:
            [self performSegueWithIdentifier:@"viewController4" sender:[self.buttons objectAtIndex:3]];

            break;
        case 4:
        case 5:
            break;
        
        case 555: { //log out
           
        }
        default:
            break;
    }*/
}

- (void)gotoLogin {
    UINavigationController *navController = [self.childViewControllers objectAtIndex:0];
    for (UIViewController *vc in navController.viewControllers) {
        if ([vc isKindOfClass:[LoginVC class]]) {
            //[self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    //LoginVC *vc  = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    LoginVC *vc = [[LoginVC alloc]initWithNibName:@"LoginVC" bundle:nil];
    [navController pushViewController:vc animated:YES];
}
- (void)gotoAdmin {
    UINavigationController *navController = [self.childViewControllers objectAtIndex:0];

    for (UIViewController *vc in navController.viewControllers) {
        if ([vc isKindOfClass:[AdminVc class]]) {
           // [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    //AdminVc *vc  = [self.storyboard instantiateViewControllerWithIdentifier:@"AdminVc"];
    AdminVc *vc = [[AdminVc alloc]initWithNibName:@"AdminVc" bundle:nil];
    [navController pushViewController:vc animated:YES];
}
- (IBAction)btnVIPClicked:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"VIP line",@"Order table service",@"Need Service", nil];
    [sheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
        {
            //[self performSegueWithIdentifier:@"viewController2" sender:self.oldViewController];
            MapDisplayVC *vc = [[MapDisplayVC alloc]initWithNibName:@"MapDisplayVC" bundle:nil];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            [self.navigationController pushViewController:nav animated:YES];
            break;
        }
        default:
            break;
    }
    
}

@end
