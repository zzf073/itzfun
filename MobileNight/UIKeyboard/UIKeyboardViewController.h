//
//  UIKeyboardViewController.h
//
//
//  Created by  YFengchen on 13-1-4.
//  Copyright 2013 __zhongyan__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIKeyboardView.h"

@protocol UIKeyboardViewControllerDelegate;

@interface UIKeyboardViewController : NSObject <UITextFieldDelegate, UIKeyboardViewDelegate, UITextViewDelegate>
{
	CGRect keyboardBounds;
	UIKeyboardView *keyboardToolbar;
   __unsafe_unretained  id<UIKeyboardViewControllerDelegate> _boardDelegate;
    UIView *objectView;
}

@property (nonatomic, assign)  __unsafe_unretained id<UIKeyboardViewControllerDelegate> boardDelegate;

@end

@interface UIKeyboardViewController (UIKeyboardViewControllerCreation)

- (id)initWithControllerDelegate:(id <UIKeyboardViewControllerDelegate>)delegateObject;

@end

@interface UIKeyboardViewController (UIKeyboardViewControllerAction)

- (void)addToolbarToKeyboard;

@end

@protocol UIKeyboardViewControllerDelegate <NSObject>

@optional

#pragma mark - TextField
- (void)alttextFieldDidBeginEditing:(UITextField *)textField;
- (void)alttextFieldDidEndEditing:(UITextField *)textField;
- (BOOL)alttextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;


#pragma mark - TextView
- (void)alttextViewDidEndEditing:(UITextView *)textView;
- (BOOL)alttextView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;


@end
