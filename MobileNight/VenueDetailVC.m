//
//  VenueDetailVC.m
//  MobileNight
//

#import "VenueDetailVC.h"
#import "EventsVC.h"
#import "ViewController.h"
#import "KxMenu.h"
#import "LoginVC.h"
#import <CoreLocation/CoreLocation.h>

@interface VenueDetailVC ()

@end

@implementation VenueDetailVC

@synthesize UserRateView;

@synthesize pieChartRight = _pieChart;
@synthesize selectedSliceLabel = _selectedSlice;
@synthesize numOfSlices = _numOfSlices;
@synthesize indexOfSlices = _indexOfSlices;
@synthesize sliceColors = _sliceColors;
@synthesize ven;
@synthesize lblReviewsCount = _lblReviewsCount;
//@synthesize venInfo;

-(void)getRatingsAndReviews
{
    if ([kAPP_DELEGATE checkForInternetConnection])
    {
        [APIClient getVenueRatingAndReviewsWithVenueName:self.ven.venueName withLatitude:[kAPP_DELEGATE CurrentLatitude] withLongitude:[kAPP_DELEGATE CurrentLongitude] with:^(NSDictionary *response, NSError *error)
         {
             
             if (error == nil) {
                 [kAPP_DELEGATE stopLoader];
                 
                 NSString *RatingStars = [response valueForKey:@"rating"];
                 NSString *ReviewCount = [NSString stringWithFormat:@"%@ reviews",[response valueForKey:@"review_count"]];
                 
                 UserRateView.notSelectedImage = [UIImage imageNamed:@"star-gray.png"];
                 UserRateView.fullSelectedImage = [UIImage imageNamed:@"star-yellow.png"];
                 UserRateView.rating = [RatingStars integerValue];//[AgentReting intValue];
                 UserRateView.editable = NO;
                 UserRateView.maxRating = 5;
                 
                 self.lblReviewsCount.text = ReviewCount;
                 
             } else {
                 [kAPP_DELEGATE stopLoader];
             }
         }];
    } else {
        [[[UIAlertView alloc] initWithTitle:internet_not_available message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"CHECK: %@",self.ven.venueName);
    
    [self performSelector:@selector(getRatingsAndReviews) withObject:nil afterDelay:0.5];
    
    if ([kAPP_DELEGATE checkForInternetConnection])
    {
        [kAPP_DELEGATE ShowLoader];
        [APIClient getVenueDetailById:self.ven.venueId with:^(NSDictionary *response, NSError *error)
        {
            
            if (error == nil) {
                [kAPP_DELEGATE stopLoader];
                
                self.ven.info = [VenueInfo getVenueInfo:response];
                [self updateUI];
                
            } else {
                [kAPP_DELEGATE stopLoader];
            }
        }];
        
    } else {
        [[[UIAlertView alloc] initWithTitle:internet_not_available message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
    }
    
    self.vwReview.layer.cornerRadius = 5;
    
    self.boxView1.layer.cornerRadius = 6;
    self.boxView2.layer.cornerRadius = 6;
    
    self.boxView1.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.boxView2.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    self.boxView1.layer.borderWidth = 1;
    self.boxView2.layer.borderWidth = 1;
    
    self.boxView1.clipsToBounds = YES;
    self.boxView2.clipsToBounds = YES;
    
    [self.pieChartRight setDelegate:self];
    [self.pieChartRight setDataSource:self];
    [self.pieChartRight setShowPercentage:NO];
    [self.pieChartRight setLabelColor:[UIColor clearColor]];
    
    [self.percentageLabel.layer setCornerRadius:90];
    
    UIColor *maleColor = [UIColor colorWithRed:109 green:209 blue:232 alpha:100];
    UIColor *femaleColor = [UIColor colorWithRed:255 green:0 blue:255 alpha:100];
    UIColor *singleColor = [UIColor colorWithRed:164 green:170 blue:143 alpha:100];
    self.sliceColors =[NSArray arrayWithObjects:maleColor,femaleColor,singleColor,nil];
    
    //[self updateUI];
}

- (void)updateUI {
    
    CLLocationCoordinate2D cordinate = CLLocationCoordinate2DMake(self.ven.latitude, self.ven.longitude);
    [self.mapView setCenterCoordinate:cordinate animated:YES];
    
    MKPointAnnotation *address = [[MKPointAnnotation alloc] init];
    [address setCoordinate:cordinate];
    [address setTitle:ven.venueName];
    [address setSubtitle:ven.address];
    [self.mapView addAnnotation:address];
    
    if (![Util isNullValue:[self.ven.info male]]) {
        self.lblMalePercentage.text = [self.ven.info.male stringByAppendingString:@"%"];
    }
    if (![Util isNullValue:[self.ven.info female]]) {
        self.lblFemalePercentage.text = [self.ven.info.female stringByAppendingString:@"%"];
    }
    if (![Util isNullValue:[self.ven.info waitTime]]) {
        self.lblWaitTime.text = self.ven.info.waitTime;
    }
    if (![Util isNullValue:[self.ven address]]) {
        self.lblAddress.text = self.ven.address;
    }
    if (![Util isNullValue:[self.ven phone]]) {
        self.lblPhoneNumber.text = self.ven.phone;
    }
    if (![Util isNullValue:[self.ven venueName]]) {
        self.lblVenueName.text = self.ven.venueName;
    }
    if (![Util isNullValue:[self.ven.info coverCharges]]) {
        self.lblCoverCharge.text = [NSString stringWithFormat:@"$%@",self.ven.info.coverCharges];
    }
    if (![Util isNullValue:[self.ven.info fastlineCharges]]) {
        self.lblCutlineCharge.text = [NSString stringWithFormat:@"$%@",self.ven.info.fastlineCharges];
    }
    if (![Util isNullValue:[self.ven imageURL]]) {
        NSURL *url = [NSURL URLWithString:[self.ven imageURL]];
        [ProfileImageView sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
    } else {
        ProfileImageView.image = nil;
        //[ProfileImageView setImage:[UIImage imageNamed:@"noimage.png"]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.svBack setContentSize:CGSizeMake(screenWidth, scrollContentView.frame.size.height)];
    self.automaticallyAdjustsScrollViewInsets = NO;
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

- (IBAction)clearSlices
{
    //[_slices removeAllObjects];
    [self.pieChartRight reloadData];
}

- (IBAction)showSlicePercentage:(id)sender
{
    UISwitch *perSwitch = (UISwitch *)sender;
    [self.pieChartRight setShowPercentage:perSwitch.isOn];
}

- (IBAction)btnCallClicked:(id)sender
{    
    NSString *number = self.ven.phone;
    NSURL* callUrl=[NSURL URLWithString:[NSString   stringWithFormat:@"tel:%@",number]];
    
    //check  Call Function available only in iphone
    if([[UIApplication sharedApplication] canOpenURL:callUrl]){
        
        [[UIApplication sharedApplication] openURL:callUrl];
        
    }else{
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Unable to make phone call at this time."  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }


}

-(IBAction)btnClickAddress:(id)sender
{
    [[UIApplication sharedApplication] canOpenURL:
     [NSURL URLWithString:@"comgooglemaps://"]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
                                                @"comgooglemaps://?center=40.765819,-73.975866&zoom=14&views=traffic"]];
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
    if (index == 0) {
        return [self.ven.info.male intValue];
    } else if (index == 1) {
        return [self.ven.info.female intValue];
    } else {
        return 100 - [self.ven.info.male intValue] - [self.ven.info.female intValue] ;
    }
    //return (index+1) * 20;
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

@end
