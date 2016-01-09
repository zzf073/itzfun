#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CalloutMapAnnotation : NSObject <MKAnnotation>
{
	CLLocationDegrees _latitude;
	CLLocationDegrees _longitude;
    NSString *_txtAddress,*_txtPhone;
}

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;

//@property (nonatomic,retain) NSString *txtAddress,*txtPhone;


- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude;

@end
