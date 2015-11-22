//
//  EditProfileVC.h
//  MobileNight
//

#import <UIKit/UIKit.h>
#import "UIKeyBoardVC.h"

@interface EditProfileVC : UIKeyBoardVC <UITextFieldDelegate> {
    IBOutlet UIView *ChangePasswordPopUp,*ChangePasswordinnerPopUp;

}

@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;

@property (weak, nonatomic) IBOutlet UITextField *txtGender;
@property (weak, nonatomic) IBOutlet UITextField *txtAgeGroup;
@property (weak, nonatomic) IBOutlet UITextField *txtZip;

@end