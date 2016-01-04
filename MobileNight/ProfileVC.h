//
//  ProfileVC.h
//  MobileNight
//

#import <UIKit/UIKit.h>
#import "HeaderVC.h"

@interface ProfileVC : HeaderVC<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
{
    IBOutlet UILabel *lblUserName,*lblEmail;
    IBOutlet UIImageView *imgvwProfile;
    UIImagePickerController *pickerView;
}

@property (weak, nonatomic) IBOutlet UILabel *lblVistor1;
@property (weak, nonatomic) IBOutlet UILabel *lblVistor2;
@property (weak, nonatomic) IBOutlet UILabel *lblVistor3;
@property (weak, nonatomic) IBOutlet UILabel *lblCreditCard;

@end
