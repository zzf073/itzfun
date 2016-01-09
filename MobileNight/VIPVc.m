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
#import "UIKeyboardViewController.h"

@interface VIPVc()<UIKeyboardViewControllerDelegate>
{
    UIKeyboardViewController *keyBoardController;
}

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
    
    basLinePrice = 0;
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
                
                //
                
                double latitudeUser = [[kAPP_DELEGATE CurrentLatitude] doubleValue];
                double longitudeUser = [[kAPP_DELEGATE CurrentLongitude] doubleValue];
                
                //CLLocation *locB = [[CLLocation alloc] initWithLatitude:latitudeUser longitude:longitudeUser];
                
                //CLLocationDistance distance = [locA distanceFromLocation:locB];

                CLLocation *currentUserLocation = [[CLLocation alloc] initWithLatitude:latitudeUser longitude:longitudeUser];
                
                CLLocation *closestLocation;
                CLLocationDistance closestLocationDistance = -1;
                
                NSUInteger index=0;
                
                for (int i =0; i < arrVenues.count; i++) {

                    Venue *ven = [arrVenues objectAtIndex:i];
                    CLLocation *locA = [[CLLocation alloc] initWithLatitude:ven.latitude longitude:ven.longitude];
                    
                    if (!closestLocation) {
                        closestLocation = locA;
                        closestLocationDistance = [currentUserLocation distanceFromLocation:locA];
                        
                        index = i;
                        continue;
                    }
                    
                    CLLocationDistance currentDistance = [currentUserLocation distanceFromLocation:locA];
                    
                    if (currentDistance < closestLocationDistance) {
                        closestLocation = locA;
                        closestLocationDistance = currentDistance;
                        
                        index = i;
                    }
                }
                
                ven = [arrVenues objectAtIndex:index];
                SelectedVenueId = [NSString stringWithFormat:@"%d",ven.venueId];
                self.txtVenue.text = [NSString stringWithFormat:@"%@ ▽",ven.venueName];
                
                basLinePrice = [ven.info.fastlineCharges integerValue];
                lblCutLine.text = [NSString stringWithFormat:@"$%lu",(unsigned long)basLinePrice];
                //
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
        //[self.txtVenue setHidden:YES];
        
        //lblNotification.frame = CGRectMake(25, 18, 270, 21);
        lblNotification.frame = CGRectMake(lblNotification.frame.origin.x, 56, lblNotification.frame.size.width, 21);
        self.notificationList.frame = CGRectMake(0, lblNotification.frame.origin.y+30, screenWidth, screenHeight-200);
    }
    else
        self.notificationList.frame = CGRectMake(self.notificationList.frame.origin.x, self.notificationList.frame.origin.y, screenWidth, screenHeight-self.notificationList.frame.origin.y-115);
    
    if (_refreshHeaderView == nil) {
        
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.notificationList.bounds.size.height, self.view.frame.size.width, self.notificationList.bounds.size.height)];
        view.delegate = self;
        [self.notificationList addSubview:view];
        _refreshHeaderView = view;
    }
    
    //  update the last update date
    [_refreshHeaderView refreshLastUpdatedDate];
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
    
    //
    if (![kAPP_DELEGATE isLogin])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please login first." message:nil delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil,nil];
        [alert show];
    }
    else
    {
        if (SelectedVenueId.length == 0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please select venue." message:nil delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil,nil];
            [alert show];
        }
        else {
            
            ContactPopup.frame=CGRectMake(0, 0, screenWidth, screenHeight);
            [self.view addSubview:ContactPopup];
            
            keyBoardController=[[UIKeyboardViewController alloc] initWithControllerDelegate:self];
            [keyBoardController addToolbarToKeyboard];
            
            CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            popAnimation.duration = 0.4;
            popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                                    [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                                    [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                                    [NSValue valueWithCATransform3D:CATransform3DIdentity]];
            popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
            popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [ContactPopup.layer addAnimation:popAnimation forKey:nil];
            innerContactPopup.center=ContactPopup.center;
        }
        //[self orderServicewithVenueID:SelectedVenueId withServiceType:@"VIP Line" withServiceDescription:@"VIP Line"];
    }
    //
}

-(IBAction)CancelPopup:(id)sender
{
    self.txtGuestNumber.text = @"0";
    [ContactPopup removeFromSuperview];
}

-(IBAction)ClickBaseLine:(id)sender
{
    if (![kAPP_DELEGATE isLogin])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please login first." message:nil delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil,nil];
        [alert show];
    }
    else
    {
        NSUInteger count = [self.txtGuestNumber.text integerValue];
        if (count == 0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please enter guest number greater than zero." message:nil delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil,nil];
            [alert show];
        }
        else
            [self orderServicewithVenueID:SelectedVenueId withServiceType:@"VIP Line" withServiceDescription:@"VIP Line"];
    }
}

- (IBAction)btnOrderTableServiceClicked:(id)sender {
    
    //RewardDetailVc *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RewardDetailVc"];
    //[self.navigationController pushViewController:vc animated:YES];
    
    if (![kAPP_DELEGATE isLogin])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please login first." message:nil delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil,nil];
        [alert show];
    }
    else
    {
        if (SelectedVenueId.length == 0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please select venue." message:nil delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil,nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Order Table Service" message:@"Please enter how many tables to reserve." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Reserve",nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            alert.tag = 4545;
            [alert show];
        }
    }
}

- (IBAction)btnRequestServiceClicked:(id)sender {
    
    //RewardDetailVc *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RewardDetailVc"];
    //[self.navigationController pushViewController:vc animated:YES];
    
    if (![kAPP_DELEGATE isLogin])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please login first." message:nil delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil,nil];
        [alert show];
    }
    else
    {
        if (SelectedVenueId.length == 0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please select venue." message:nil delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil,nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Request Service"
                                                            message:@"Please describe your service request."
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Request",nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            alert.tag = 6565;
            [alert show];
        }
    }
}

- (IBAction)btnPickupServiceClicked:(id)sender
{
    if (![kAPP_DELEGATE isLogin])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please login first." message:nil delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil,nil];
        [alert show];
    }
    else
    {
        if (SelectedVenueId.length == 0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please select venue." message:nil delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil,nil];
            [alert show];
        }
        else
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
    //
    NSString *strOrderStatus = [NSString stringWithFormat:@"%@",[[notifications objectAtIndex:indexPath.row] valueForKey:@"status"]];
    //
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
        //[AcceptButton setTitle:@"Accept" forState:UIControlStateNormal];
        
        AcceptButton.frame = CGRectMake(notificationText.frame.origin.x, notificationText.frame.origin.y + notificationText.frame.size.height + 4, 50, 20);
        [AcceptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        //
        if ([strOrderStatus isEqualToString:@"REQUEST"])
            [AcceptButton setTitle:@"Accept" forState:UIControlStateNormal];
        else
            [AcceptButton setTitle:@"In Progress" forState:UIControlStateNormal];
        [AcceptButton sizeToFit];
        //

        AcceptButton.tag = indexPath.row;
        [cell addSubview:AcceptButton];
        
        UIButton *RejectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [RejectButton addTarget:self
                         action:@selector(RejectButtonAction:)
               forControlEvents:UIControlEventTouchUpInside];
        //[RejectButton setTitle:@"Reject" forState:UIControlStateNormal];
        
        [RejectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        RejectButton.frame = CGRectMake(AcceptButton.frame.origin.x + AcceptButton.frame.size.width + 20, notificationText.frame.origin.y + notificationText.frame.size.height + 4, 50, 20);
        
        //
        if ([strOrderStatus isEqualToString:@"REQUEST"])
            [RejectButton setTitle:@"Reject" forState:UIControlStateNormal];
        else
            [RejectButton setTitle:@"Completed" forState:UIControlStateNormal];
        [RejectButton sizeToFit];
        //

        RejectButton.tag = indexPath.row;
        [cell addSubview:RejectButton];
    }
    
    //self.notificationList.contentSize = CGSizeMake(screenWidth, self.notificationList.contentSize.height);
    
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
                //self.notificationList.contentSize = CGSizeMake(screenWidth, self.notificationList.contentSize.height);
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
                
                if ([serviceType isEqualToString:@"VIP Line"]) {
                 
                    [[[UIAlertView alloc] initWithTitle:nil message:@"VIP Service Ordered." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
                    
                    self.txtGuestNumber.text = @"0";
                }
                else
                {
                    [[[UIAlertView alloc] initWithTitle:nil message:@"Request Service Ordered." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
                }
                
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

- (BOOL)alttextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.txtGuestNumber)
    {
        [self performSelector:@selector(calculateTotal) withObject:nil afterDelay:0.1];
    }
    
    return YES;
}

-(void)calculateTotal
{
    NSUInteger guestCount = [self.txtGuestNumber.text integerValue];
    double total = (guestCount*basLinePrice)+basLinePrice;
    
    lblTotal.text = [NSString stringWithFormat:@"$%.0f",total];
}

- (void)alttextFieldDidBeginEditing:(UITextField *)textField;
{
    if (textField==self.txtVenue)
    {
        [textField setInputView:pickerVenue];
    }    
}

- (void)alttextFieldDidEndEditing:(UITextField *)textField
{
    /*if (textField == self.txtGuestNumber)
    {
        NSUInteger guestCount = [self.txtGuestNumber.text integerValue];
        double total = (guestCount*basLinePrice)+basLinePrice;
        
        lblTotal.text = [NSString stringWithFormat:@"$%.0f",total];
    }*/
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
    
    //
    basLinePrice = [ven.info.fastlineCharges integerValue];
    lblCutLine.text = [NSString stringWithFormat:@"$%lu",(unsigned long)basLinePrice];
    //
    
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
                //
                NSArray *reverseOrder=[[notifications reverseObjectEnumerator] allObjects];
                //
                notifications = [reverseOrder mutableCopy];
                [self.notificationList reloadData];
                //self.notificationList.contentSize = CGSizeMake(screenWidth, self.notificationList.contentSize.height);
                [kAPP_DELEGATE stopLoader];
                
            } else {
                [kAPP_DELEGATE stopLoader];
            }
        }];
    } else {
        [[[UIAlertView alloc] initWithTitle:internet_not_available message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
    }
}

#pragma mark- PullToRefresh

-(IBAction)clickRefresh:(id)sender
{
    [kAPP_DELEGATE ShowLoader];
    [self getNotificationsWithVenueID:SelectedVenueId withRoleCode:VISITOR];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
    _reloading = YES;
    
}

- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.notificationList];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self reloadTableViewDataSource];
    [self getNotificationsWithVenueID:SelectedVenueId withRoleCode:VISITOR];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}

@end