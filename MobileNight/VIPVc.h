//
//  VIPVc.h
//  MobileNight
//
//  Created by Anand Patel on 25/07/15.
//  Copyright (c) 2015 Anand Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderVC.h"
#import "UIKeyBoardVC.h"

//
#import "EGORefreshTableHeaderView.h"
//

@interface VIPVc : UIKeyBoardVC <UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,EGORefreshTableHeaderDelegate>
{
    NSMutableArray *notifications;
    
    IBOutlet UIView *vipLine;
    IBOutlet UIView *orderTableService;
    IBOutlet UIView *requestService;
    IBOutlet UIView *requestCabService;
    IBOutlet UILabel *lblNotification;
    
    UIPickerView *pickerVenue;
    NSArray *arrVenues;
    NSString *SelectedVenueId;
    NSUInteger basLinePrice;
    
    //BaseLine Popup
    IBOutlet UIView *ContactPopup,*innerContactPopup;
    IBOutlet UIButton *btnCancel,*btnConfirm;
    IBOutlet UILabel *lblCutLine,*lblTotal;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    //  Reloading var should really be your tableviews datasource
    //  Putting it here for demo purposes
    BOOL _reloading;
}

@property (nonatomic,retain) IBOutlet UITextField *txtVenue;
@property (nonatomic, retain) IBOutlet UITableView *notificationList;
@property (nonatomic, retain) IBOutlet NSLayoutConstraint *TopSpace;

@property (nonatomic,retain) IBOutlet UITextField *txtGuestNumber;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end