//
//  MapDisplayVC.h
//  MobileNight
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapDisplayVC : HeaderVC<MKMapViewDelegate>
{
    NSArray *arrVenues;
    
    //
    int tagggs;
    //
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

-  (void)hideList;
@end
