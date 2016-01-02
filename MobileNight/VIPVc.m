//
//  VIPVc.m
//  MobileNight
//
//  Created by Anand Patel on 25/07/15.
//  Copyright (c) 2015 Anand Patel. All rights reserved.
//

#import "VIPVc.h"
#import "RewardDetailVc.h"
#import "Venue.h"
#import "WebViewController.h"

@interface VIPVc()

- (void) processOrder:(NSDictionary*) payload forRow: (id)sender;

@end

@implementation VIPVc

#pragma mark- View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    notifications = [[NSMutableArray alloc] init];
    
    arrVenues = [NSArray array];
    pickerVenue = [[UIPickerView alloc] init];
    pickerVenue.delegate = self;
    pickerVenue.dataSource = self;
    //[pickerVenue selectRow:1 inComponent:0 animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([kAPP_DELEGATE checkForInternetConnection]) {
        
        [kAPP_DELEGATE secheduleTimer];
        [kAPP_DELEGATE ShowLoader];
        
        [APIClient getVenues:^(NSDictionary *response, NSError *error) {
            //[kAPP_DELEGATE stopLoader];
            [[kAPP_DELEGATE Request_timer] invalidate];
            if (error == nil) {
                arrVenues = [Venue getVenues:response];
                
                Venue *ven = [arrVenues objectAtIndex:0];
                SelectedVenueId = [NSString stringWithFormat:@"%d",ven.venueId];
                
                [self getNotificationsWithVenueID:SelectedVenueId withRoleCode:VISITOR];
                
                //[self getVenueInfo];
                //[self.ListTableView reloadData];
                [kAPP_DELEGATE stopLoader];
                
            } else {
                [kAPP_DELEGATE stopLoader];
            }
        }];
    } else {
        [[[UIAlertView alloc] initWithTitle:internet_not_available message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
    }
    
    /*
     Notifications = [[NSMutableArray alloc] initWithObjects:@"Notification Description 1",@"Notification Description 2",@"Notification Description 3",@"Notification Description 4",@"Notification Description 5",@"Notification Description 6", nil];
     */
    
    self.navigationController.navigationBarHidden = YES;
    if ([[kAPP_DELEGATE visitor] isAdmin])
    {
        self.TopSpace.constant = 0;
        
        [vipLine setHidden:YES];
        [orderTableService setHidden:YES];
        [requestService setHidden:YES];
        [requestCabService setHidden:YES];
        [self.txtVenue setHidden:YES];
        
        lblNotification.frame = CGRectMake(25, 18, 270, 21);
        self.notificationList.frame = CGRectMake(0, lblNotification.frame.origin.x+30, screenWidth, screenHeight);
    }
}

//
- (NSString *)tabTitle
{
    return @"VIP";
}

- (NSString *)tabImageName
{
    return @"reward-icon.png";
}

- (NSString *)activeTabImageName
{
    return @"reward-icon.png";
}
//

- (IBAction)btnCutLineClcked:(id)sender
{
    /*
    RewardDetailVc *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RewardDetailVc"];
    [self.navigationController pushViewController:vc animated:YES];
     */
    
    [self orderServicewithVenueID:SelectedVenueId withServiceType:@"VIP Line" withServiceDescription:@""];
    
}

- (IBAction)btnOrderTableServiceClicked:(id)sender {
    //RewardDetailVc *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RewardDetailVc"];
    //[self.navigationController pushViewController:vc animated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Order Table Service"
                                                    message:@"Please enter how many tables to reserve."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Reserve",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 4545;
    [alert show];
    
}

- (IBAction)btnRequestServiceClicked:(id)sender {
    //RewardDetailVc *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RewardDetailVc"];
    //[self.navigationController pushViewController:vc animated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Request Service"
                                                    message:@"Please describe your service request."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Request",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 6565;
    [alert show];
}

- (IBAction)btnPickupServiceClicked:(id)sender
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"uber://"]])
    {
        NSString *Latitude = [kAPP_DELEGATE CurrentLatitude];
        NSString *Longitude = [kAPP_DELEGATE CurrentLongitude];
        NSString *ClientKey = @"YOUR_CLIENT_ID";
        
        NSString *URL = [NSString stringWithFormat:@"uber://?client_id=%@&action=setPickup&pickup[latitude]=%@&pickup[longitude]=%@",ClientKey,Latitude,Longitude];
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL]];
        
        // this will invoke the UBER app if it is already installed and show the current location of the consumer as pickup
        
        WebViewController *openUrl = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
        openUrl.strLink = URL;
        [self.navigationController pushViewController:openUrl animated:YES];
    }
    else {
        
        // No Uber app! Open Mobile Website.
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.uber.com"]];
        
        WebViewController *openUrl = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
        openUrl.strLink = [NSString stringWithFormat:@"https://www.uber.com"];
        [self.navigationController pushViewController:openUrl animated:YES];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 4545)
    {
        
        if (buttonIndex == 0)
        {
            NSLog(@"Cancel Order Table Service");
        }
        else if (buttonIndex == 1)
        {
            NSLog(@"Order Table Service");
            NSLog(@"Number or Table Want: %@", [alertView textFieldAtIndex:0].text);
            
            [self orderServicewithVenueID:SelectedVenueId withServiceType:@"Order Table Service" withServiceDescription:[alertView textFieldAtIndex:0].text];
            
        }
       
    }
    else if (alertView.tag == 6565)
    {
        if (buttonIndex == 0)
            NSLog(@"Cancel Request Service");
        else if (buttonIndex == 1)
        {
            NSLog(@"Request Service");
            NSLog(@"Requested Service is: %@", [alertView textFieldAtIndex:0].text);
            
            [self orderServicewithVenueID:SelectedVenueId withServiceType:@"Request Service" withServiceDescription:[alertView textFieldAtIndex:0].text];
        }
    }
}

#pragma mark- UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float Height;
    if ([[kAPP_DELEGATE visitor] isAdmin])
        Height = 56;
    else
        Height = 40;
    
    return Height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return notifications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    //if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    UIImageView *notificationIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, cell.frame.size.height/2 - 10, 16, 16)];
    notificationIcon.image = [UIImage imageNamed:@"icon2_vip"];
    [cell addSubview:notificationIcon];
    
    // For display name.
    UILabel *notificationText = [[UILabel alloc]initWithFrame:CGRectMake(notificationIcon.frame.origin.x + notificationIcon.frame.size.width + 10, cell.frame.size.height/2-10, 200, 16)];
    notificationText.text = [[[notifications objectAtIndex:indexPath.row] valueForKey:@"vaService"] valueForKey:@"serviceDescription"];
    notificationText.textColor = [UIColor whiteColor];
    notificationText.font = [UIFont systemFontOfSize:15.0];
    [cell addSubview:notificationText];
    
    UILabel *notificationStatus = [[UILabel alloc]initWithFrame:CGRectMake(notificationIcon.frame.origin.x + notificationIcon.frame.size.width + 180, cell.frame.size.height/2-10, 200, 16)];
    notificationStatus.text = [[notifications objectAtIndex:indexPath.row] valueForKey:@"status"];
    notificationStatus.textColor = [UIColor whiteColor];
    notificationStatus.font = [UIFont systemFontOfSize:15.0];
    
    [cell addSubview:notificationStatus];
    
    [cell.contentView setBackgroundColor:[UIColor colorWithRed:46.0/255.0 green:59.0/255.0 blue:79.0/255.0 alpha:1.0]];
    
    if ([[kAPP_DELEGATE visitor] isAdmin])
    {
        /*
        UIButton *AcceptButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [AcceptButton addTarget:self
                   action:@selector(AcceptButtonAction:)
         forControlEvents:UIControlEventTouchUpInside];
        [AcceptButton setTitle:@"Accept" forState:UIControlStateNormal];
       
        int xAcceptPos = 0;
        int xRejectPos = 0;
        if (IS_IPHONE_5){
            xAcceptPos = 115;
            xRejectPos = 55;
        }else if (IS_IPHONE_6_PLUS || IS_IPHONE_6){
            xAcceptPos = 80;
            xRejectPos = 20;
        }
        
        AcceptButton.frame = CGRectMake(cell.frame.size.width - xAcceptPos, 10, 50, 20);
        [AcceptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        AcceptButton.tag = indexPath.row;
        [cell addSubview:AcceptButton];
        
        UIButton *RejectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [RejectButton addTarget:self
                         action:@selector(RejectButtonAction:)
               forControlEvents:UIControlEventTouchUpInside];
        [RejectButton setTitle:@"Reject" forState:UIControlStateNormal];
        [RejectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        RejectButton.frame = CGRectMake(cell.frame.size.width - xRejectPos, 10, 50, 20);
        RejectButton.tag = indexPath.row;
        [cell addSubview:RejectButton];
        */
        
        UIButton *AcceptButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [AcceptButton addTarget:self
                         action:@selector(AcceptButtonAction:)
               forControlEvents:UIControlEventTouchUpInside];
        [AcceptButton setTitle:@"Accept" forState:UIControlStateNormal];
        AcceptButton.frame = CGRectMake(notificationText.frame.origin.x, notificationText.frame.origin.y + notificationText.frame.size.height + 4, 50, 20);
        [AcceptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        AcceptButton.tag = indexPath.row;
        [cell addSubview:AcceptButton];
        
        UIButton *RejectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [RejectButton addTarget:self
                         action:@selector(RejectButtonAction:)
               forControlEvents:UIControlEventTouchUpInside];
        [RejectButton setTitle:@"Reject" forState:UIControlStateNormal];
        [RejectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        RejectButton.frame = CGRectMake(AcceptButton.frame.origin.x + AcceptButton.frame.size.width + 20, notificationText.frame.origin.y + notificationText.frame.size.height + 4, 50, 20);
        RejectButton.tag = indexPath.row;
        [cell addSubview:RejectButton];
    }
    return cell;
}

-(IBAction)AcceptButtonAction:(id)sender
{
    NSDictionary *dictParams = @{@"status":@"COMPLETED",@"description":@"Your order is ready."};
    [self processOrder:dictParams forRow:sender];
}

-(IBAction)RejectButtonAction:(id)sender
{
     NSDictionary *dictParams = @{@"status":@"REJECTED",@"description":@"Your order is ready."};
    [self processOrder:dictParams forRow:sender];
}

- (void) processOrder:(NSDictionary*) payload forRow: (id)sender
{
    if ([kAPP_DELEGATE checkForInternetConnection]) {
        
        [kAPP_DELEGATE ShowLoader];
        NSDictionary* notification = [notifications objectAtIndex:[sender tag]];
       
        
        [APIClient processServiceWithParameter:payload forVenue: [[notification valueForKey:@"venueNumber"] integerValue] forNotification:[[notification valueForKey:@"id"] integerValue] with:^(NSDictionary *response, NSError *error) {
            
            //[kAPP_DELEGATE stopLoader];
            [[kAPP_DELEGATE Request_timer] invalidate];
            [kAPP_DELEGATE stopLoader];
            if (error == nil) {
                [notifications removeObjectAtIndex:[sender tag]];
                [self.notificationList reloadData];
            }
        }];
    } else {
        [[[UIAlertView alloc] initWithTitle:internet_not_available message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
        [kAPP_DELEGATE stopLoader];
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)orderServicewithVenueID:(NSString *)venueId withServiceType:(NSString *)serviceType withServiceDescription:(NSString *)description
{
    
    /*
    NSString *UrlString = [NSString stringWithFormat:@"http://localhost:8280/WebServices/mobin/venue/services/visitors/11/service"];
    {
        “serviceType”:”Bottle Service”,
        “serviceDescription”:””,
        “actualPrice”:0.0,
        “discountPrice”:0.0
    }*/
    
    
    if ([kAPP_DELEGATE checkForInternetConnection]) {
        
        [kAPP_DELEGATE ShowLoader];
        
        NSDictionary *dictParams = @{@"serviceType":serviceType,@"serviceDescription":description,@"actualPrice":@"",@"discountPrice":@""};
        
        [APIClient orderServiceWithParameter:dictParams withVenueId:venueId with:^(NSDictionary *response, NSError *error) {
            
            //[kAPP_DELEGATE stopLoader];
            [[kAPP_DELEGATE Request_timer] invalidate];
            if (error == nil) {
                
                [[[UIAlertView alloc] initWithTitle:nil message:@"VIP Service Ordered." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
                
                [kAPP_DELEGATE stopLoader];
                
            } else {
                [kAPP_DELEGATE stopLoader];
            }
        }];
    } else {
        [[[UIAlertView alloc] initWithTitle:internet_not_available message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
        [kAPP_DELEGATE stopLoader];
    }
}

#pragma mark- UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==self.txtVenue)
    {
        NSLog(@"Venue Selected");
    }
}

#pragma - UIKeyboardViewController Delegate
- (void)alttextFieldDidBeginEditing:(UITextField *)textField;
{
    if (textField==self.txtVenue)
    {
        [textField setInputView:pickerVenue];
    }
}

#pragma mark- PickerView Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return arrVenues.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Venue *ven = [arrVenues objectAtIndex:row];
    if (![Util isNullValue:ven.venueName])
    {
        return ven.venueName;
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    Venue *ven = [arrVenues objectAtIndex:row];
    self.txtVenue.text = [NSString stringWithFormat:@"%@ ▽",ven.venueName];
    SelectedVenueId = [NSString stringWithFormat:@"%d",ven.venueId];
    [self getNotificationsWithVenueID:SelectedVenueId withRoleCode:VISITOR];
}

-(void)getNotificationsWithVenueID:(NSString *)venueId withRoleCode:(NSString *)roleCode
{
    //For getting notifications.
    if ([kAPP_DELEGATE checkForInternetConnection]) {
        [kAPP_DELEGATE secheduleTimer];
        [kAPP_DELEGATE ShowLoader];
        
        [APIClient getNotificationsWithVenueId:venueId withRoleCode:roleCode with:^(NSDictionary *response, NSError *error) {
            
            //[kAPP_DELEGATE stopLoader];
            [[kAPP_DELEGATE Request_timer] invalidate];
            if (error == nil) {
                NSLog(@"NOTIFICATION RESPONSE: %@",response);
                
                notifications = [[response valueForKey:@"notifications"] mutableCopy];
                [self.notificationList reloadData];
                [kAPP_DELEGATE stopLoader];
                
            } else {
                [kAPP_DELEGATE stopLoader];
            }
        }];
    } else {
        [[[UIAlertView alloc] initWithTitle:internet_not_available message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
    }
}

@end