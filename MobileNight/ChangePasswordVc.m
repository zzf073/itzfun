//
//  ChangePasswordVc.m
//  MobileNight
//

#import "ChangePasswordVc.h"

@interface ChangePasswordVc ()

@end

@implementation ChangePasswordVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnSaveClicked:(id)sender {
    
}
- (IBAction)btnCancelClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
