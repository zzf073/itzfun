//
//  RewardDetailVc.m
//  MobileNight
//
//  Created by Anand Patel on 11/07/15.
//  Copyright (c) 2015 Anand Patel. All rights reserved.
//

#import "RewardDetailVc.h"

@interface RewardDetailVc ()

@end

@implementation RewardDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
