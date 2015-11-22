//
//  UIKeyBoardVC.m
//  MobileNight
//

#import "UIKeyBoardVC.h"
#import "UIKeyboardViewController.h"

@interface UIKeyBoardVC ()<UIKeyboardViewControllerDelegate> {
    UIKeyboardViewController *keyBoardController;
}

@end

@implementation UIKeyBoardVC
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    keyBoardController=[[UIKeyboardViewController alloc] initWithControllerDelegate:self];
    [keyBoardController addToolbarToKeyboard];
}



#pragma - UIKeyboardViewController delegate methods

- (BOOL)alttextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if (textField.text.length==0)
    {
        if ([string isEqualToString:@" "])
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return YES;
}
- (void)alttextFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"%@", textField.text);
    textField.inputView = nil;
}
- (void)alttextViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"%@", textView.text);
}


@end
