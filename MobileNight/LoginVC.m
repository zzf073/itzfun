//
//  LoginVC.m
//  MobileNight
//

#import "LoginVC.h"
#import "SignUPVC.h"

@interface LoginVC () <UIAlertViewDelegate,FBLoginViewDelegate>
@property(nonatomic, retain) id methodTarget;
@property (nonatomic) SEL method;
@property (nonatomic, retain) id methodParam;
@end

@implementation LoginVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    scrvMain.contentSize = CGSizeMake(screenWidth, scrvMain.frame.size.height+64);
    
    loginview = [[FBLoginView alloc] initWithReadPermissions:[NSArray arrayWithObjects:@"email", nil]];
    loginview.frame=CGRectMake(10,355,300, 45);
    loginview.delegate = self;
    
    if ([self.txtEmail respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor grayColor];
        self.txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.txtEmail.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
    if ([self.txtPassword respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor grayColor];
        self.txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.txtPassword.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
    
    strLoginType = @"visitor";
    [self.loginTypeBox setSelected:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    scrvMain.contentSize  = CGSizeMake(screenWidth, scrollContentView.frame.size.height);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnLoginClicked:(id)sender {
    
    
    if ([strLoginType isEqualToString:@"visitor"])
    {
        if(self.txtEmail.text.length==0)
        {
            [[[UIAlertView alloc] initWithTitle:email_blank message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
        else if(![kAPP_DELEGATE validateEmail:self.txtEmail.text])
        {
            [[[UIAlertView alloc] initWithTitle:valid_email message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
        else if (self.txtPassword.text.length==0)
        {
            [[[UIAlertView alloc] initWithTitle:enter_Password message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
        else
        {
            if ([kAPP_DELEGATE checkForInternetConnection]) {
                [kAPP_DELEGATE secheduleTimer];
                [kAPP_DELEGATE ShowLoader];
                
                NSDictionary *dictParams = @{@"loginId": self.txtEmail.text,@"password":self.txtPassword.text,@"loginType":strLoginType};
                [APIClient loginWith:dictParams with:^(NSDictionary *response, NSError *error) {
                    [[kAPP_DELEGATE Request_timer] invalidate];
                    [kAPP_DELEGATE stopLoader];
                    if (error == nil)  {
                        NSInteger code = [[response valueForKey:@"code"] integerValue];
                        if (code == 0 || code == 200 || code == 201) {
                            [self logonSuccess:response];
                        } else {
                            [[[UIAlertView alloc] initWithTitle:@"Login Failed" message:[response valueForKey:@"message"] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
                        }
                        
                    } else {
                        [[[UIAlertView alloc] initWithTitle:@"Error" message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
                    }
                    NSLog(@"response %@ %@",response,error);
                }];
            } else {
                [[[UIAlertView alloc] initWithTitle:internet_not_available message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
            }
            
        }
    }
    else
    {
        if(self.txtEmail.text.length==0)
        {
            [[[UIAlertView alloc] initWithTitle:email_blank message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
        else if (self.txtPassword.text.length==0)
        {
            [[[UIAlertView alloc] initWithTitle:enter_Password message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
        else
        {
            if ([kAPP_DELEGATE checkForInternetConnection]) {
                [kAPP_DELEGATE secheduleTimer];
                [kAPP_DELEGATE ShowLoader];
                
                NSDictionary *dictParams = @{@"loginId": self.txtEmail.text,@"password":self.txtPassword.text,@"loginType":strLoginType};
                [APIClient loginWith:dictParams with:^(NSDictionary *response, NSError *error) {
                    [[kAPP_DELEGATE Request_timer] invalidate];
                    [kAPP_DELEGATE stopLoader];
                    if (error == nil) {
                        NSInteger code = [[response valueForKey:@"code"] integerValue];
                        if (code == 0 || code == 200 || code == 201) {
                            [self logonSuccess:response];
                        } else {
                            [[[UIAlertView alloc] initWithTitle:@"Login Failed" message:[response valueForKey:@"message"] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
                        }

                        
                    } else {
                        [[[UIAlertView alloc] initWithTitle:@"Error" message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
                    }
                    NSLog(@"response %@ %@",response,error);
                }];
            } else {
                [[[UIAlertView alloc] initWithTitle:internet_not_available message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
            }
            
        }
    }
    
}
- (void) redirectTo:(id)methodTarget withMethod:(SEL)method withParam:(id)param
{
    self.methodTarget = methodTarget;
    self.method = method;
    self.methodParam = param;
}
- (void) logonSuccess: (NSDictionary*) response {
    [kAPP_DELEGATE setIsLogin:YES];
    [kAPP_DELEGATE setVisitor:[Visitor getVisitor:response]];
    if (self.methodTarget && self.method && self.methodParam) {
        [self.methodTarget performSelector:self.method withObject:self.methodParam];
    } else {
        [self goToCites];
    }
}
- (IBAction)btnForgotPasswordClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Forgot Password" message:@"Please Enter Your  Registered Email" delegate:self cancelButtonTitle:@"Cacel" otherButtonTitles:@"Submit", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[alert textFieldAtIndex:0] setPlaceholder:@"Email"];
    [alert show];
    
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

- (IBAction)btnSignUPClicked:(id)sender {
    
    //SignUPVC *vc  = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUPVC"];
    SignUPVC *vc = [[SignUPVC alloc]initWithNibName:@"SignUPVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}



#pragma mark - FBLoginViewDelegate
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user
{
    NSString *fbAccessToken = [FBSession activeSession].accessTokenData.accessToken;
    [[NSUserDefaults standardUserDefaults]setObject:user.id forKey:@"facebook_id"];
    [[NSUserDefaults standardUserDefaults]setObject:fbAccessToken forKey:@"facebook_token"];
    
    if ([[FBSession activeSession] isOpen])
    {
        [kAPP_DELEGATE setIsLogin:YES];
    }
    
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

-(IBAction)loginTypeBoxAction:(id)sender
{
    if (self.loginTypeBox.isSelected)
    {
        [self.loginTypeBox setSelected:NO];
        [self.loginTypeBox setBackgroundColor:[UIColor yellowColor]];
        strLoginType = @"user";
    }
    else
    {
        [self.loginTypeBox setSelected:YES];
        [self.loginTypeBox setBackgroundColor:[UIColor lightGrayColor]];
        strLoginType = @"visitor";
    }
    NSLog(@"Login Type: %@",strLoginType);
}

@end
