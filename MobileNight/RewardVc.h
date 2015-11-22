//
//  RewardVc.h
//  MobileNight
//
//  Created by Anand Patel on 11/07/15.
//  Copyright (c) 2015 Anand Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderVC.h"

@interface RewardVc : HeaderVC <UITableViewDataSource,UITableViewDelegate> {
    IBOutlet UITableView *tblRewards;
    NSArray *arrRewards;
    
}
@property (nonatomic, retain) IBOutlet UIView *vwSingUp;

@end
