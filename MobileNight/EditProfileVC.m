//
//  EditProfileVC.m
//  MobileNight
//

#import "EditProfileVC.h"
#import "LoginVC.h"
#import "ChangePasswordVc.h"

@interface EditProfileVC ()

@end

@implementation EditProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnSaveClickedClicked:(id)sender {
    
}
- (IBAction)btnChangePasswordClicked:(id)sender
{
    //ChangePasswordVc *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordVc"];
    ChangePasswordVc *vc = [[ChangePasswordVc alloc]initWithNibName:@"ChangePasswordVc" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)btnLogoutClicked:(id)sender
{
    [kAPP_DELEGATE setIsLogin:NO];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[LoginVC class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    //LoginVC *vc  = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    LoginVC *vc = [[LoginVC alloc]initWithNibName:@"LoginVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
-(IBAction)btnCancelCliked:(id)sender
{
    ChangePasswordPopUp.hidden = YES;
}

@end
