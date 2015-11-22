//
//  SignUPVC.h
//  MobileNight
//
//  Created by Anand Patel on 27/05/15.
//  Copyright (c) 2015 Anand Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIKeyBoardVC.h"

@interface SignUPVC : UIKeyBoardVC <UITextFieldDelegate> {
    UIPickerView *pickerGender;
    UIDatePicker *pickerAgeGroup;
}

@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfiremPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtGender;
@property (weak, nonatomic) IBOutlet UITextField *txtAgeGroup;
@property (weak, nonatomic) IBOutlet UITextField *txtZip;

@property (weak, nonatomic) IBOutlet UIButton *btnMale;
@property (weak, nonatomic) IBOutlet UIButton *btnFemale;
@property (weak, nonatomic) IBOutlet UIButton *btnSingle;
@property (weak, nonatomic) IBOutlet UIImageView *imgSingle;







@end
