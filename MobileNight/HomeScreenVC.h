//
//  HomeScreenVC.h
//  MobileNight
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class AKTabBarController;

@interface HomeScreenVC : HeaderVC <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    BOOL callflag;
    NSTimer *LoadingTimer;
}

@property (nonatomic, strong) AKTabBarController *tabBarController;

@end
