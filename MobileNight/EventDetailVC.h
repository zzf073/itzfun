//
//  EventDetailVC.h
//  MobileNight
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"
#import <QuartzCore/QuartzCore.h>
#import "RateView.h"
#import <MapKit/MapKit.h>

#import "Venue.h"
#import "VenueInfo.h"
@interface EventDetailVC : UIViewController<XYPieChartDelegate, XYPieChartDataSource> {
    RateView *UserRateView;
    
    IBOutlet UIImageView *CoverImageView;
    IBOutlet UIImageView *ProfileImageView;
    
    VenueInfo *venInfo;
    
}
//Detail Display Outlets.
@property (weak, nonatomic) IBOutlet UILabel *lblEventName;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblPerformerName;
@property (weak, nonatomic) IBOutlet UIImageView *PerformerImage;
@property (weak, nonatomic) IBOutlet UIImageView *EventImage;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (nonatomic, retain) NSMutableDictionary *EventDetail;

@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblVenueName;
@property (weak, nonatomic) IBOutlet UILabel *lblMalePercentage;
@property (weak, nonatomic) IBOutlet UILabel *lblFemalePercentage;
@property (weak, nonatomic) IBOutlet UILabel *lblSinglePercentage;
@property (weak, nonatomic) IBOutlet UILabel *lblWaitTime;
@property (weak, nonatomic) IBOutlet UIView *vwReview;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *heightLineUpView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@property (strong, nonatomic) IBOutlet XYPieChart *pieChartRight;
@property(nonatomic, strong) NSArray        *sliceColors;
//@property (strong, nonatomic) IBOutlet UILabel *percentageLabel;
//@property (strong, nonatomic) IBOutlet UILabel *selectedSliceLabel;
//@property (strong, nonatomic) IBOutlet UITextField *numOfSlices;
//@property (strong, nonatomic) IBOutlet UISegmentedControl *indexOfSlices;

@property (nonatomic ,retain) IBOutlet RateView *UserRateView;

@property (nonatomic ,retain) IBOutlet UIScrollView *svBack;

@property (nonatomic ,retain) Venue *ven;
@end




