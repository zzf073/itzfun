//
//  AdminVc.h
//  MobileNight
//
//  Created by Anand Patel on 06/07/15.
//  Copyright (c) 2015 Anand Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderVC.h"
#import "VenueInfo.h"
#import "UIKeyBoardVC.h"
#import "Venue.h"

@interface AdminVc : UIKeyBoardVC <UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate> {
    UIPickerView *pickerVenue;
    NSArray *arrVenues;
    NSOperationQueue  *queue;
    Venue *selectedVenue;

}

@property (nonatomic,retain) IBOutlet UISlider *sliderMale;
@property (nonatomic,retain) IBOutlet UISlider *sliderFemale;

@property (nonatomic,retain) IBOutlet UILabel *lblFemale;
@property (nonatomic,retain) IBOutlet UILabel *lblMale;

@property (nonatomic,retain) IBOutlet UITextField *txtCoverCharge;
@property (nonatomic,retain) IBOutlet UITextField *txtCutlineCharge;
@property (nonatomic,retain) IBOutlet UITextField *txtNoOfTables;
@property (nonatomic,retain) IBOutlet UITextField *txtAvgCostPerTable;
@property (nonatomic,retain) IBOutlet UITextField *txtVenue;

@property (nonatomic, retain) IBOutlet UITextField *txtWaitTime;





@end
