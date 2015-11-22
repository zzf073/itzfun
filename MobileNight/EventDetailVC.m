//
//  EventDetailVC.m
//  MobileNight
//

#import "EventDetailVC.h"
#import "DJDetailVc.h"

@implementation EventDetailVC


@synthesize UserRateView;

@synthesize pieChartRight = _pieChart;
//@synthesize selectedSliceLabel = _selectedSlice;
//@synthesize numOfSlices = _numOfSlices;
//@synthesize indexOfSlices = _indexOfSlices;
@synthesize sliceColors = _sliceColors;
@synthesize ven;
@synthesize EventDetail;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    CLLocationCoordinate2D cordinate = CLLocationCoordinate2DMake(self.ven.latitude, self.ven.longitude);
    [self.mapView setCenterCoordinate:cordinate animated:YES];
    
    MKPointAnnotation *address = [[MKPointAnnotation alloc] init];
    [address setCoordinate:cordinate];
    [address setTitle:@"Johnny Foley's Irish House"];
    [address setSubtitle:@"243 O'Farrell Street"];
    [self.mapView addAnnotation:address];
    
    self.vwReview.layer.cornerRadius = 5;
    
    
   /* ProfileImageView.layer.cornerRadius = ProfileImageView.frame.size.width/2;
    ProfileImageView.layer.borderWidth = 1;
    ProfileImageView.layer.borderColor = [[UIColor redColor] CGColor];*/
    
    
    UserRateView.notSelectedImage = [UIImage imageNamed:@"star-gray.png"];
    UserRateView.fullSelectedImage = [UIImage imageNamed:@"star-yellow.png"];
    UserRateView.rating = 3;//[AgentReting intValue];
    UserRateView.editable = NO;
    UserRateView.maxRating = 5;
    
    [self.pieChartRight setDelegate:self];
    [self.pieChartRight setDataSource:self];
    [self.pieChartRight setShowPercentage:NO];
    [self.pieChartRight setLabelColor:[UIColor clearColor]];
    
    //[self.percentageLabel.layer setCornerRadius:90];
    
    self.sliceColors =[NSArray arrayWithObjects:[UIColor redColor],[UIColor colorWithRed:255.0 green:0.0 blue:255.0 alpha:1.0],[UIColor lightGrayColor],
                       nil];
}
- (void)updateUI {
    self.lblMalePercentage.text = [venInfo.male stringByAppendingString:@"%"];
    self.lblFemalePercentage.text = [venInfo.female stringByAppendingString:@"%"];
    self.lblWaitTime.text = venInfo.waitTime;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *EventName = [EventDetail valueForKey:@"eventName"];
    self.lblEventName.text = EventName;
    
   /* NSString *EventDate = [EventDetail valueForKey:@"startDate"];
    NSDateFormatter *dateFormatterNew = [[NSDateFormatter alloc] init];
    [dateFormatterNew setDateFormat:@"MMM dd, yyyy"];
    NSString *stringForNewDate = EventDate;
    NSString *Date = [NSString stringWithFormat:@"%@",stringForNewDate];
    self.lblDate.text = Date;
    */
    NSString *EventPerformer = [[EventDetail valueForKey:@"performer"] valueForKey:@"performerName"];
    self.lblPerformerName.text = EventPerformer;
    
    NSString *EventPerformerImageUrl = [[EventDetail valueForKey:@"performer"] valueForKey:@"imageURL"];

    if (![Util isNullValue:EventPerformerImageUrl])
    {
        NSURL *url = [NSURL URLWithString:EventPerformerImageUrl];
        [self.PerformerImage sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
        
    } else {
        [self.PerformerImage setImage:[UIImage imageNamed:@"user.jpg"]];
    }
    
    
    self.lblTime.text = [EventDetail valueForKey:@"eventTime"];

    /*
    NSString *EventImageUrl = [EventDetail valueForKey:@"eventImage"];

    if (![Util isNullValue:EventImageUrl])
    {
        NSURL *url = [NSURL URLWithString:EventImageUrl];
        [self.EventImage sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];

    } else {
        [self.EventImage setImage:[UIImage imageNamed:@"user.jpg"]];
    }
    
     
    NSString *EventAddress;
    if ([EventDetail valueForKey:@"eventLocation"] != nil)
    {
        EventAddress = [EventDetail valueForKey:@"eventLocation"];
    }
    else
    {
        EventAddress = @"";
    }
    self.lblAddress.text = EventAddress;
    
    NSString *EventDescription;
    if ([EventDetail valueForKey:@"eventDescription"] != nil)
    {
         EventDescription = [EventDetail valueForKey:@"eventDescription"];
    }
    else
    {
        EventDescription = @"";
    }
   
    self.lblDescription.text = EventDescription;
    
    
    //
    
//    PerformerImage;
//    EventImage;
     */
    

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.pieChartRight reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)clearSlices {
    [self.pieChartRight reloadData];
}
- (IBAction)showSlicePercentage:(id)sender {
    UISwitch *perSwitch = (UISwitch *)sender;
    [self.pieChartRight setShowPercentage:perSwitch.isOn];
}
- (IBAction)btnCallClicked:(id)sender {
    
    NSString *number = @"123456789";
    NSURL* callUrl=[NSURL URLWithString:[NSString   stringWithFormat:@"tel:%@",number]];
    
    //check  Call Function available only in iphone
    if([[UIApplication sharedApplication] canOpenURL:callUrl])
    {
        [[UIApplication sharedApplication] openURL:callUrl];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Unable to make phone call at this time."  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return 3;
}
- (IBAction)btnBackClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return (index+1) * 20;
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    if(pieChart == self.pieChartRight)
        
        if (index == 0)
        {
            return [self.sliceColors objectAtIndex:0];
        }
    if (index == 1)
    {
        return [self.sliceColors objectAtIndex:1];
    }
    if (index == 2)
    {
        return [self.sliceColors objectAtIndex:2];
    }
    return 0;
}

- (IBAction)btnDjClicked:(id)sender {
    //DJDetailVc *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DJDetailVc"];
    DJDetailVc *vc = [[DJDetailVc alloc]initWithNibName:@"DJDetailVc" bundle:nil];
    vc.PerformerDetail = EventDetail;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
