//
//  VenueDetailVC.h
//  MobileNight
//

#import <UIKit/UIKit.h>
#import "RateView.h"

#import "XYPieChart.h"
#import <QuartzCore/QuartzCore.h>
#import "Venue.h"
#import "VenueInfo.h"
#import <MapKit/MapKit.h>

@interface VenueDetailVC : HeaderVC<XYPieChartDelegate, XYPieChartDataSource>
{
    RateView *UserRateView;
    
    IBOutlet UIImageView *CoverImageView;
    IBOutlet UIImageView *ProfileImageView;
    IBOutlet UIView *scrollContentView;
    
}
@property (weak, nonatomic) IBOutlet UILabel *lblReviewsCount;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblVenueName;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblMalePercentage;
@property (weak, nonatomic) IBOutlet UILabel *lblFemalePercentage;
@property (weak, nonatomic) IBOutlet UILabel *lblSinglePercentage;
@property (weak, nonatomic) IBOutlet UILabel *lblWaitTime;
@property (weak, nonatomic) IBOutlet UILabel *lblWaitTimeUnit;
@property (weak, nonatomic) IBOutlet UIView *vwReview;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *lblCoverCharge;
@property (weak, nonatomic) IBOutlet UILabel *lblCutlineCharge;


@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightOfSVContent;

@property (strong, nonatomic) IBOutlet XYPieChart *pieChartRight;
@property(nonatomic, strong) NSArray        *sliceColors;
@property (strong, nonatomic) IBOutlet UILabel *percentageLabel;
@property (strong, nonatomic) IBOutlet UILabel *selectedSliceLabel;
@property (strong, nonatomic) IBOutlet UITextField *numOfSlices;
@property (strong, nonatomic) IBOutlet UISegmentedControl *indexOfSlices;

@property (nonatomic ,retain) IBOutlet RateView *UserRateView;

@property (nonatomic ,retain) IBOutlet UIScrollView *svBack;

@property (nonatomic ,retain) Venue *ven;
//@property (nonatomic ,retain) VenueInfo *venInfo;

@property (weak, nonatomic) IBOutlet UIView *boxView1;
@property (weak, nonatomic) IBOutlet UIView *boxView2;








@end
