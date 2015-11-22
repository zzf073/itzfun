//
//  ChangePasswordVc.h
//  MobileNight
//

#import <UIKit/UIKit.h>

@interface ChangePasswordVc : HeaderVC


@property (weak, nonatomic) IBOutlet UITextField *txtChangePwdEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtCurrentPwd;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPwd;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPwd;

@end
