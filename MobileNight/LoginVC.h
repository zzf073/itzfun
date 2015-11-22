//
//  LoginVC.h
//  MobileNight
//

#import <UIKit/UIKit.h>
#import "UIKeyBoardVC.h"

@interface LoginVC : UIKeyBoardVC <UITextFieldDelegate> {
    FBLoginView *loginview;

    NSString *strLoginType;
    IBOutlet UIScrollView *scrvMain;
    IBOutlet UIView     *scrollContentView;

}

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (nonatomic, retain) IBOutlet UIButton *loginTypeBox;
-(IBAction)loginTypeBoxAction:(id)sender;
- (void) redirectTo: (id) methodTarget withMethod:(SEL)method withParam:(id) param;
@end
