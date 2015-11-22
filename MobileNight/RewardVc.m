//
//  RewardVc.m
//  MobileNight
//
//  Created by Anand Patel on 11/07/15.
//  Copyright (c) 2015 Anand Patel. All rights reserved.
//

#import "RewardVc.h"
#import "RewardDetailVc.h"
#import "SignUPVC.h"

@interface RewardVc ()<FBLoginViewDelegate>  {
    FBLoginView *loginview;
}

@end

@implementation RewardVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    loginview = [[FBLoginView alloc] initWithReadPermissions:[NSArray arrayWithObjects:@"email", nil]];
    loginview.frame=CGRectMake(10,355,300, 45);
    loginview.delegate = self;
    // Do any additional setup after loading the view.
    arrRewards = [NSArray array];
   
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([kAPP_DELEGATE isLogin]) {
        [self.vwSingUp setHidden:YES];
        [tblRewards setHidden:NO];
    } else {
        [self.vwSingUp setHidden:NO];
        [tblRewards setHidden:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RewardCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"Reward %d",indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //RewardDetailVc *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RewardDetailVc"];
    RewardDetailVc *vc = [[RewardDetailVc alloc]initWithNibName:@"RewardDetailVc" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)btnSignUPClicked:(id)sender {
    
    //SignUPVC *vc  = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUPVC"];
    SignUPVC *vc = [[SignUPVC alloc]initWithNibName:@"SignUPVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnFBClicked:(id)sender {
    [self.view endEditing:YES];
    
    
    UIButton * loginButton;
    for (id obj in loginview.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            loginButton =  obj;
        }
    }
    [loginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark - FBLoginViewDelegate
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user
{
    NSString *fbAccessToken = [FBSession activeSession].accessTokenData.accessToken;
    [[NSUserDefaults standardUserDefaults]setObject:user.id forKey:@"facebook_id"];
    [[NSUserDefaults standardUserDefaults]setObject:fbAccessToken forKey:@"facebook_token"];
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    
}
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    FBShareDialogParams *p = [[FBShareDialogParams alloc] init];
    p.link = [NSURL URLWithString:@"http://developers.facebook.com/ios"];
#ifdef DEBUG
    [FBSettings enableBetaFeatures:FBBetaFeaturesShareDialog];
#endif
}
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    NSString *alertMessage, *alertTitle;
    if ([FBErrorUtility shouldNotifyUserForError:error])
    {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
    }
    else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession)
    {
        alertTitle = @"Session Error";
        alertMessage = m_fb_login_error;
    }
    else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled)
    {
        NSLog(@"user cancelled login");
    }
    else
    {
        alertTitle  = @"Something went wrong";
        alertMessage = internet_not_available;
        NSLog(@"Unexpected error:%@", error);
    }
    if (alertMessage)
    {
        [[[UIAlertView alloc] initWithTitle:alertMessage
                                    message:nil
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

@end
