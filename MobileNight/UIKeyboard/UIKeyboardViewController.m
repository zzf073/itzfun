//
//  UIKeyboardViewController.m
// 
//
//  Created by  YFengchen on 13-1-4.
//  Copyright 2013 __zhongyan__. All rights reserved.
//

#import "UIKeyboardViewController.h"

static CGFloat kboardHeight = 254.0f;
static CGFloat keyBoardToolbarHeight = 38.0f;
static CGFloat spacerY = 10.0f;
static CGFloat viewFrameY = 0;

@interface UIKeyboardViewController () 

- (void)animateView:(BOOL)isShow textField:(id)textField heightforkeyboard:(CGFloat)kheight;
- (void)addKeyBoardNotification;
- (void)removeKeyBoardNotification;
- (void)checkBarButton:(id)textField;
- (id)firstResponder:(UIView *)navView;
- (NSArray *)allSubviews:(UIView *)theView;
- (void)resignKeyboard:(UIView *)resignView;

@end

@implementation UIKeyboardViewController

@synthesize boardDelegate = _boardDelegate;

- (void)dealloc {
    _boardDelegate = nil;
	[self removeKeyBoardNotification];
}

//Hide and show the keyboard event listener
- (void)addKeyBoardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillHideNotification object:nil];
}

//Listen for events canceled
- (void)removeKeyBoardNotification {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

//Calculate the current height of the keyboard
-(void)keyboardWillShowOrHide:(NSNotification *)notification
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_2
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
#endif
		kboardHeight = 264.0f + keyBoardToolbarHeight;
	}
	NSValue *keyboardBoundsValue;
	if (IOS_VERSION >= 3.2)
    {
		keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
	}
	else
    {
		keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
	}
    
	[keyboardBoundsValue getValue:&keyboardBounds];
	BOOL isShow = [[notification name] isEqualToString:UIKeyboardWillShowNotification] ? YES : NO;
	if ([self firstResponder:objectView])
    {
		[self animateView:isShow textField:[self firstResponder:objectView]
		heightforkeyboard:keyboardBounds.size.height];
	}
}

//Frameshift prevent keyboard input blocking
- (void)animateView:(BOOL)isShow textField:(id)textField heightforkeyboard:(CGFloat)kheight {
	kboardHeight = kheight;
	[self checkBarButton:textField];
	CGRect rect = objectView.frame;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	if (isShow)
    {
		if ([textField isKindOfClass:[UITextField class]])
        {
			UITextField *newText = ((UITextField *)textField);
			CGPoint textPoint = [newText convertPoint:CGPointMake(0, newText.frame.size.height + spacerY+15) toView:objectView];
            
            if (textPoint.y>=[UIScreen mainScreen].bounds.size.height)
            {
                textPoint.y=[UIScreen mainScreen].bounds.size.height;
            }
            
            NSLog(@"Point:%@", NSStringFromCGPoint(textPoint));
            
			if (rect.size.height - textPoint.y < kheight)
				rect.origin.y = rect.size.height - textPoint.y - kheight + viewFrameY;
			else rect.origin.y = viewFrameY;
		}
		else
        {
            
			UITextView *newView = ((UITextView *)textField);
			CGPoint textPoint = [newView convertPoint:CGPointMake(0, newView.frame.size.height + spacerY+15) toView:objectView];
            
            if (textPoint.y>=[UIScreen mainScreen].bounds.size.height)
            {
                textPoint.y=[UIScreen mainScreen].bounds.size.height;
            }
            NSLog(@"Point:%@", NSStringFromCGPoint(textPoint));
            
			if (rect.size.height - textPoint.y < kheight) 
				rect.origin.y = rect.size.height - textPoint.y - kheight + viewFrameY;
			else rect.origin.y = viewFrameY;
		}
	}
	else rect.origin.y = viewFrameY;
	objectView.frame = rect;
	[UIView commitAnimations];
}

//CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, [UIScreen mainScreen].bounds.size.height)
//Input box gets focus
- (id)firstResponder:(UIView *)navView
{
	for (id aview in [self allSubviews:navView])
    {
		if ([aview isKindOfClass:[UITextField class]] && [(UITextField *)aview isFirstResponder])
        {
			return (UITextField *)aview;
		}
		else if ([aview isKindOfClass:[UITextView class]] && [(UITextView *)aview isFirstResponder])
        {
			return (UITextView *)aview;
		}
	}
	return NULL;
}

//Find all the subview
- (NSArray *)allSubviews:(UIView *)theView {
	NSArray *results = [theView subviews];
	for (UIView *eachView in [theView subviews]) {
		NSArray *riz = [self allSubviews:eachView];
		if (riz) {
			results = [results arrayByAddingObjectsFromArray:riz];
		}
	}
	return results;
}

//input box loses focus, hide the keyboard
- (void)resignKeyboard:(UIView *)resignView
{
	[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)checkBarButton:(id)textField
{
	int i = 0,j = 0;
	UIBarButtonItem *previousBarItem = [keyboardToolbar itemForIndex:0];
    UIBarButtonItem *nextBarItem = [keyboardToolbar itemForIndex:1];
	for (id aview in [self allSubviews:objectView]) {
		if ([aview isKindOfClass:[UITextField class]] && ((UITextField*)aview).userInteractionEnabled && ((UITextField*)aview).enabled) {
			i++;
			if ([(UITextField *)aview isEqual:textField]) {
				j = i;
			}
		}
		else if ([aview isKindOfClass:[UITextView class]] && ((UITextView*)aview).userInteractionEnabled && ((UITextView*)aview).editable) {
			i++;
			if ([(UITextView *)aview isEqual:textField]) {
				j = i;
			}
		}
	}
	[previousBarItem setEnabled:j > 1 ? YES : NO];
	[nextBarItem setEnabled:j < i ? YES : NO];
}

//toolbar button Click on the event
#pragma mark - UIKeyboardView delegate methods
-(void)toolbarButtonTap:(UIButton *)button
{
	NSInteger buttonTag = button.tag;
	NSMutableArray *textFieldArray=[NSMutableArray arrayWithCapacity:10];
	for (id aview in [self allSubviews:objectView]) {
		if ([aview isKindOfClass:[UITextField class]] && ((UITextField*)aview).userInteractionEnabled && ((UITextField*)aview).enabled) {
			[textFieldArray addObject:(UITextField *)aview];
		}
		else if ([aview isKindOfClass:[UITextView class]] && ((UITextView*)aview).userInteractionEnabled && ((UITextView*)aview).editable) {
			[textFieldArray addObject:(UITextView *)aview];
		}
	}
	for (int i = 0; i < [textFieldArray count]; i++)
    {
		id textField = [textFieldArray objectAtIndex:i];
		if ([textField isKindOfClass:[UITextField class]]) {
			textField = ((UITextField *)textField);
		}
		else {
			textField = ((UITextView *)textField);
		}
		if ([textField isFirstResponder]) {
			if (buttonTag == 1) {
				if (i > 0) {
					[[textFieldArray objectAtIndex:--i] becomeFirstResponder];
					[self animateView:YES textField:[textFieldArray objectAtIndex:i] heightforkeyboard:kboardHeight];
				}
			}
			else if (buttonTag == 2) {
				if (i < [textFieldArray count] - 1) {
					[[textFieldArray objectAtIndex:++i] becomeFirstResponder];
					[self animateView:YES textField:[textFieldArray objectAtIndex:i] heightforkeyboard:kboardHeight];
				}
			}
		}
	}
	if (buttonTag == 3) 
		[self resignKeyboard:objectView];
}


#pragma mark - TextField delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.boardDelegate respondsToSelector:@selector(alttextFieldDidBeginEditing:)])
    {
		[self.boardDelegate alttextFieldDidBeginEditing:textField];
	}
	[self checkBarButton:textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	if ([self.boardDelegate respondsToSelector:@selector(alttextFieldDidEndEditing:)])
    {
		[self.boardDelegate alttextFieldDidEndEditing:textField];
	}
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if ([self.boardDelegate respondsToSelector:@selector(alttextField:shouldChangeCharactersInRange:replacementString:)])
    {
		return [self.boardDelegate alttextField:textField shouldChangeCharactersInRange:range replacementString:string];
	}
    return YES;
}
#pragma mark - UITextView delegate methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([self.boardDelegate respondsToSelector:@selector(alttextView:shouldChangeTextInRange:replacementText:)])
    {
		return [self.boardDelegate alttextView:textView shouldChangeTextInRange:range replacementText:text];
	}
    return YES;
	/*if ([text isEqualToString:@"\n"])
    {
		[textView resignFirstResponder];    
		return NO;    
	}
	return YES;    */
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
	if ([self.boardDelegate respondsToSelector:@selector(alttextViewDidEndEditing:)])
    {
		[self.boardDelegate alttextViewDidEndEditing:textView];
	}
}

@end



#pragma mark - UIkeyboadView Controller

@implementation UIKeyboardViewController (UIKeyboardViewControllerCreation)

- (id)initWithControllerDelegate:(id <UIKeyboardViewControllerDelegate>)delegateObject {
	if (self = [super init])
    {
		self.boardDelegate = delegateObject;
        if ([self.boardDelegate isKindOfClass:[UIViewController class]])
        {
			objectView = [(UIViewController *)[self boardDelegate] view];
		}
		else if ([self.boardDelegate isKindOfClass:[UIView class]])
        {
			objectView = (UIView *)[self boardDelegate];
		}
        
        viewFrameY = objectView.frame.origin.y;
		[self addKeyBoardNotification];
	}
	return self;
}

@end

@implementation UIKeyboardViewController (UIKeyboardViewControllerAction)

//Add toolbar to the keyboard
- (void)addToolbarToKeyboard
{
	keyboardToolbar = [[UIKeyboardView alloc] initWithFrame:CGRectMake(0, 0, objectView.frame.size.width, keyBoardToolbarHeight)];
	keyboardToolbar.delegate = self;
	for (id aview in [self allSubviews:objectView])
    {
		if ([aview isKindOfClass:[UITextField class]])
        {
			((UITextField *)aview).inputAccessoryView = keyboardToolbar;
			((UITextField *)aview).delegate = self;
		}
		else if ([aview isKindOfClass:[UITextView class]])
        {
			((UITextView *)aview).inputAccessoryView = keyboardToolbar;
			((UITextView *)aview).delegate = self;
		}
	}
}

@end
