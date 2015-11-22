//
//  AdminVc.m
//  MobileNight
//
//  Created by Anand Patel on 06/07/15.
//  Copyright (c) 2015 Anand Patel. All rights reserved.
//

#import "AdminVc.h"
#import "Venue.h"

@implementation AdminVc

/*
-(void)TestFunction
{
    if ([kAPP_DELEGATE checkForInternetConnection]) {
        // [kAPP_DELEGATE secheduleTimer];
        [kAPP_DELEGATE ShowLoader];
        NSDictionary *dictParams = @{
                                     @"male":               @"1",
                                     @"female":             @"0",
                                     @"cover-charges":      @"2",
                                     @"fastline-charges":   @"3",
                                     @"available-tables":   @"3",
                                     @"price-per-table":    @"5",
                                     @"venueId":            @"4"
                                     };
        [APIClient updateVenueInfo:dictParams with:^(NSDictionary *response, NSError *error) {
            // [[kAPP_DELEGATE Request_timer] invalidate];
            [kAPP_DELEGATE stopLoader];
            if (response != nil) {
                [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Updated successfully." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
            }
            NSLog(@"Venue ID Function response %@ %@",response,error);
        }];
    } else {
        [[[UIAlertView alloc] initWithTitle:internet_not_available message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
    }
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self TestFunction];
    
    arrVenues = [NSArray array];
    queue = [[NSOperationQueue alloc] init];
    [queue addObserver:self forKeyPath:@"operations" options:0 context:nil];
    
    pickerVenue = [[UIPickerView alloc] init];
    pickerVenue.delegate = self;
    pickerVenue.dataSource = self;
    //[pickerVenue selectRow:1 inComponent:0 animated:YES];
    
    
    if ([kAPP_DELEGATE checkForInternetConnection]) {
        [kAPP_DELEGATE secheduleTimer];
        [kAPP_DELEGATE ShowLoader];
        /*[APIClient getVenues:^(NSDictionary *response, NSError *error) {
         [kAPP_DELEGATE stopLoader];
         if (error == nil) {
         arrVenues = [Venue getVenues:response];
         [self.ListTableView reloadData];
         }
         }];*/
        [APIClient getVenues:^(NSDictionary *response, NSError *error) {
            //[kAPP_DELEGATE stopLoader];
            [[kAPP_DELEGATE Request_timer] invalidate];
            if (error == nil) {
                arrVenues = [Venue getVenues:response];
                
                [self getVenueInfo];
                //[self.ListTableView reloadData];

                
            } else {
                [kAPP_DELEGATE stopLoader];
            }
        }];
    } else {
        [[[UIAlertView alloc] initWithTitle:internet_not_available message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
    }
}

- (IBAction)btnSubmitClicked:(UIButton *)sender {
    if (selectedVenue == nil) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please Select Venue" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
        return;
    }
    if ([kAPP_DELEGATE checkForInternetConnection]) {
       // [kAPP_DELEGATE secheduleTimer];
        [kAPP_DELEGATE ShowLoader];
        NSDictionary *dictParams = @{
                                     @"male":               [self.lblMale.text stringByReplacingOccurrencesOfString:@"%" withString:@""],
                                     @"female":             [self.lblFemale.text stringByReplacingOccurrencesOfString:@"%" withString:@""],
                                     @"cover-charges":      self.txtCoverCharge.text,
                                     @"fastline-charges":   self.txtCutlineCharge.text,
                                     @"available-tables":   self.txtNoOfTables.text,
                                     @"price-per-table":    self.txtAvgCostPerTable.text,
                                     @"venueId":            [NSString stringWithFormat:@"%d",selectedVenue.venueId],
                                     @"wait-time": self.txtWaitTime.text
                                     };
        
        [APIClient updateVenueInfo:dictParams with:^(NSDictionary *response, NSError *error) {
           // [[kAPP_DELEGATE Request_timer] invalidate];
            [kAPP_DELEGATE stopLoader];
            if (response != nil) {
                [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Updated successfully." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
            }
            NSLog(@"response %@ %@",response,error);
        }];
    } else {
        [[[UIAlertView alloc] initWithTitle:internet_not_available message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)sliderValueChanged:(UISlider *)slider {
    
    if (slider == self.sliderMale) {
        
        //self.lblMale.text = [NSString stringWithFormat:@"%.f%@",slider.value,@"%"];
        self.lblMale.text = [NSString stringWithFormat:@"%.f%@",slider.value,@"%"];
        
    } else {

        self.lblFemale.text = [NSString stringWithFormat:@"%.f%@",slider.value,@"%"];
    }
}

-(IBAction)finalSliderValue:(UISlider *)slider
{
    
    if (slider == self.sliderMale)
    {
        self.sliderMale.value = slider.value;
        self.sliderFemale.value = 100 - self.sliderMale.value;
        
        self.lblMale.text = [NSString stringWithFormat:@"%.f%@",self.sliderMale.value,@"%"];
        self.lblFemale.text = [NSString stringWithFormat:@"%.f%@",self.sliderFemale.value,@"%"];
        
    } else {
        
        self.sliderFemale.value = slider.value;
        self.sliderMale.value = 100 - self.sliderFemale.value;
        
        self.lblMale.text = [NSString stringWithFormat:@"%.f%@",self.sliderMale.value,@"%"];
        self.lblFemale.text = [NSString stringWithFormat:@"%.f%@",self.sliderFemale.value,@"%"];
    }
    
}

#pragma - UIKeyboardViewController delegate methods
- (void)alttextFieldDidBeginEditing:(UITextField *)textField;
{
    if (textField==self.txtVenue)
    {
        if (arrVenues.count > 0)
        {
            
            Venue *ven = [arrVenues objectAtIndex:0];
            selectedVenue = ven;
            if (![Util isNullValue:[ven.info male]]) {
                float SliderMaleRatio = 100 - [ven.info.male floatValue];
                self.sliderMale.value = SliderMaleRatio;
                self.lblMale.text = [NSString stringWithFormat:@"%.f%@",self.sliderMale.value,@"%"];
            }
            if (![Util isNullValue:[ven.info female]]) {
                
                float SliderFemalelRatio = 100 - [ven.info.female floatValue];
                self.sliderFemale.value = SliderFemalelRatio;
                self.lblFemale.text = [NSString stringWithFormat:@"%.f%@",self.sliderFemale.value,@"%"];
            }
            
            if (![Util isNullValue:[ven.info coverCharges]]) {
                NSString *RemoveDoller = [ven.info.coverCharges stringByReplacingOccurrencesOfString:@"$" withString:@""];
                //self.txtCoverCharge.text = [NSString stringWithFormat:@"%@",ven.info.coverCharges];
                self.txtCoverCharge.text = RemoveDoller;
            }
            if (![Util isNullValue:[ven.info fastlineCharges]]) {
                NSString *RemoveDoller = [ven.info.fastlineCharges stringByReplacingOccurrencesOfString:@"$" withString:@""];
                self.txtCutlineCharge.text = RemoveDoller;
            }
            
            if (![Util isNullValue:[ven.info availableTables]]) {
                self.txtNoOfTables.text = [ven.info availableTables];
            }
            
            if (![Util isNullValue:[ven.info pricePerTable]]) {
                self.txtAvgCostPerTable.text = [ven.info pricePerTable];
            }
            
            if (![Util isNullValue:[ven.info waitTime]]) {
                self.txtWaitTime.text = [ven.info waitTime];
            }
            
            self.txtVenue.text = ven.venueName;
        }
        [textField setInputView:pickerVenue];
    }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return arrVenues.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    Venue *ven = [arrVenues objectAtIndex:row];
    if (![Util isNullValue:ven.venueName]) {
        return ven.venueName;
    }
    return nil;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
  
    Venue *ven = [arrVenues objectAtIndex:row];
    selectedVenue = ven;
    if (![Util isNullValue:[ven.info male]]) {
        NSInteger SliderMaleRatio = 100 - [ven.info.male integerValue];
        self.sliderMale.value = SliderMaleRatio;
        self.lblMale.text = [NSString stringWithFormat:@"%ld%@",(long)SliderMaleRatio,@"%"];
    }
    if (![Util isNullValue:[ven.info female]]) {
        
        NSInteger SliderFemalelRatio = 100 - [ven.info.female integerValue];
        self.sliderFemale.value = SliderFemalelRatio;
        self.lblFemale.text = [NSString stringWithFormat:@"%ld%@",(long)SliderFemalelRatio,@"%"];
    }
  
    if (![Util isNullValue:[ven.info coverCharges]]) {
        NSString *RemoveDoller = [ven.info.coverCharges stringByReplacingOccurrencesOfString:@"$" withString:@""];
        //self.txtCoverCharge.text = [NSString stringWithFormat:@"%@",ven.info.coverCharges];
        self.txtCoverCharge.text = RemoveDoller;
    }
    if (![Util isNullValue:[ven.info fastlineCharges]]) {
        NSString *RemoveDoller = [ven.info.fastlineCharges stringByReplacingOccurrencesOfString:@"$" withString:@""];
        self.txtCutlineCharge.text = RemoveDoller;
    }
    
    if (![Util isNullValue:[ven.info availableTables]]) {
        self.txtNoOfTables.text = [ven.info availableTables];
    }
    
    if (![Util isNullValue:[ven.info pricePerTable]]) {
        self.txtAvgCostPerTable.text = [ven.info pricePerTable];
    }
    
    if (![Util isNullValue:[ven.info waitTime]]) {
        self.txtWaitTime.text = [ven.info waitTime];
    }
    
    self.txtVenue.text = ven.venueName;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                         change:(NSDictionary *)change context:(void *)context
{
    if (object == queue && [keyPath isEqualToString:@"operations"]) {
        if ([queue.operations count] == 0) {
            // Do something here when your queue has completed
            NSLog(@"queue has completed %@",arrVenues);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [pickerVenue reloadAllComponents];
                
                [self performSelector:@selector(selectFirstValueByDefault) withObject:nil afterDelay:1.0];
                
            });
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object
                               change:change context:context];
    }
}


- (void)getVenueInfo {
    NSMutableArray *marrOperation = [NSMutableArray array];
    
    for (int i = 0; i<arrVenues.count; i++) {
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            Venue *ven = [arrVenues objectAtIndex:i];
            [APIClient getVenueDetailById:ven.venueId with:^(NSDictionary *response, NSError *error) {
                ven.info = [VenueInfo getVenueInfo:response];
            }];
        }];
        [marrOperation addObject:operation];
    }
    [queue addOperations:marrOperation waitUntilFinished:NO];
    
}


-(void)selectFirstValueByDefault
{
    //For first by default selected.
    
    if (arrVenues.count > 0)
    {
        
        Venue *ven = [arrVenues objectAtIndex:0];
        
        
        selectedVenue = ven;
        if (![Util isNullValue:[ven.info male]]) {
            NSInteger SliderMaleRatio = 100 - [ven.info.female integerValue];
            self.sliderMale.value = SliderMaleRatio;
            self.lblMale.text = [NSString stringWithFormat:@"%ld%@",(long)SliderMaleRatio,@"%"];
        }
        if (![Util isNullValue:[ven.info female]]) {
            
            NSInteger SliderFemalelRatio = 100 - [ven.info.male integerValue];
            self.sliderFemale.value = SliderFemalelRatio;
            self.lblFemale.text = [NSString stringWithFormat:@"%ld%@",(long)SliderFemalelRatio,@"%"];
        }
        
        if (![Util isNullValue:[ven.info coverCharges]]) {
            NSString *RemoveDoller = [ven.info.coverCharges stringByReplacingOccurrencesOfString:@"$" withString:@""];
            //self.txtCoverCharge.text = [NSString stringWithFormat:@"%@",ven.info.coverCharges];
            self.txtCoverCharge.text = RemoveDoller;
        }
        if (![Util isNullValue:[ven.info fastlineCharges]]) {
            NSString *RemoveDoller = [ven.info.fastlineCharges stringByReplacingOccurrencesOfString:@"$" withString:@""];
            self.txtCutlineCharge.text = RemoveDoller;
        }
        
        if (![Util isNullValue:[ven.info availableTables]]) {
            self.txtNoOfTables.text = [ven.info availableTables];
        }
        
        if (![Util isNullValue:[ven.info pricePerTable]]) {
            self.txtAvgCostPerTable.text = [ven.info pricePerTable];
        }
        
        if (![Util isNullValue:[ven.info waitTime]]) {
            self.txtWaitTime.text = [ven.info waitTime];
        }
        
        self.txtVenue.text = ven.venueName;
    }

    [kAPP_DELEGATE stopLoader];
}

@end
