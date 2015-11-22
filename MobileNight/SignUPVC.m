//
//  SignUPVC.m
//  MobileNight
//
//  Created by Anand Patel on 27/05/15.
//  Copyright (c) 2015 Anand Patel. All rights reserved.
//

#import "SignUPVC.h"
#import "UIKeyboardViewController.h"

@interface SignUPVC ()<UIPickerViewDataSource,UIPickerViewDelegate> {
    NSArray *arrGender;
    NSArray *arrAgeGroup;
}

@end

@implementation SignUPVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrGender   = @[@"Male",@"Female",@"Single"];
    arrAgeGroup = @[@"18-30",@"30-40",@"40-50",@"50+"];
    
    pickerGender = [[UIPickerView alloc] init];
    pickerAgeGroup = [[UIDatePicker alloc] init];
    
   // pickerAgeGroup.dataSource = self;
   // pickerAgeGroup.delegate = self;
    
    pickerGender.dataSource = self;
    pickerGender.delegate = self;
    
    pickerAgeGroup.datePickerMode = UIDatePickerModeDate;
    [pickerAgeGroup addTarget:self action:@selector(birthDateChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnSubmitClicked:(id)sender {
    
    if(self.txtFirstName.text.length==0)
    {
        [[[UIAlertView alloc] initWithTitle:firstNM_blank message:nil delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil, nil]show];
    } else if(self.txtEmail.text.length==0)
    {
        [[[UIAlertView alloc] initWithTitle:email_blank message:nil delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil, nil]show];
    } else if(![kAPP_DELEGATE validateEmail:self.txtEmail.text]){
        [[[UIAlertView alloc] initWithTitle:valid_email message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
        
    } else if(self.txtPassword.text.length==0)
    {
        [[[UIAlertView alloc] initWithTitle:pwd_blank message:nil delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil, nil]show];
    } else {
        if ([kAPP_DELEGATE checkForInternetConnection]) {
            [kAPP_DELEGATE ShowLoader];
            NSDictionary *params = @{
                                     @"email": self.txtEmail.text,
                                     @"name": self.txtFirstName.text,
                                     @"password": self.txtPassword.text,
                                     @"address": @"",
                                     @"city": @"",
                                     @"state": @"",
                                     @"country": @"",
                                     @"zip": @"",
                                     @"mobile": @""
                                     };
            [APIClient createVisitor:params with:^(NSDictionary *response, NSError *error) {
                [kAPP_DELEGATE stopLoader];
                

                if (error == nil) {
                    [self goToCites];
                } else {
                }
            }];
        } else {
            [[[UIAlertView alloc] initWithTitle:internet_not_available message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
        }
    }
}
- (IBAction)btnBackClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma - UIKeyboardViewController delegate methods

- (void)alttextFieldDidBeginEditing:(UITextField *)textField;
{
    if (textField==self.txtGender)
    {
        [textField setInputView:pickerGender];
    }
    else if (textField==self.txtAgeGroup)
    {
        [textField setInputView:pickerAgeGroup];
    }
}

#pragma mark- PickerView Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == pickerGender)
    {
        return arrGender.count;
    }
    else
    {
        return arrAgeGroup.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == pickerGender)
    {
        return [arrGender objectAtIndex:row];
    }
    else
    {
        return [arrAgeGroup objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerGender == pickerView)
    {
        self.txtGender.text = [arrGender objectAtIndex:row];
    }
    else
    {
        self.txtAgeGroup.text = [arrAgeGroup objectAtIndex:row];
    }
}

#pragma mark- Birthday Picker

- (void)birthDateChanged:(UIDatePicker *)picker
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    self.txtAgeGroup.text = [formatter stringFromDate:picker.date];
}

#pragma mark- Gender Selection

- (IBAction)btnSegmentClicked:(UIButton *)sender
{
    [self setSegmentsColors];
    
    [sender setBackgroundColor:[UIColor clearColor]];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    switch (sender.tag) {
        case 1: {
            [self.btnMale setBackgroundImage:[UIImage imageNamed:@"ltab1-ho.png"] forState:UIControlStateNormal];
            break;
        }
        case 2: {
            [self.btnFemale setBackgroundImage:[UIImage imageNamed:@"ltab2-ho.png"] forState:UIControlStateNormal];
            break;
        }
        case 3: {
            [self.btnSingle setBackgroundImage:[UIImage imageNamed:@"ltab3-ho.png"] forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
}
- (void)setSegmentsColors {
    UIColor *backColor = [UIColor clearColor];
    //UIColor *textColor = [UIColor colorWithRed:46 green:59 blue:79 alpha:100];
    UIColor *textColor = [UIColor lightGrayColor];

    
    [self.btnMale setBackgroundColor:backColor];
    [self.btnMale setTitleColor:textColor forState:UIControlStateNormal];
    
    [self.btnFemale setBackgroundColor:backColor];
    [self.btnFemale setTitleColor:textColor forState:UIControlStateNormal];
    
    [self.btnSingle setBackgroundColor:backColor];
    [self.btnSingle setTitleColor:textColor forState:UIControlStateNormal];
    
    
    [self.btnMale setBackgroundImage:[UIImage imageNamed:@"ltab1.png"] forState:UIControlStateNormal];
    [self.btnFemale setBackgroundImage:[UIImage imageNamed:@"ltab2.png"] forState:UIControlStateNormal];
    [self.btnSingle setBackgroundImage:[UIImage imageNamed:@"ltab3.png"] forState:UIControlStateNormal];
    
}

- (IBAction)btnSingleClicked:(UIButton *)sender {
    sender.tag = !sender.tag;
    if (sender.tag) {
        NSLog(@"single selected");
       // sender.tag = 0;
        self.imgSingle.image = [UIImage imageNamed:@"checked.png"] ;
        //[sender setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
    } else {
       // sender.tag = 1;
        self.imgSingle.image = [UIImage imageNamed:@"unchecked.png"];
        //[sender setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];

        NSLog(@"single unselected");
    }
    //sender.selected = !sender.selected;
}

@end