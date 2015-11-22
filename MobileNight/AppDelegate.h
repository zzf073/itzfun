//
//  AppDelegate.h
//  MobileNight
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <CoreLocation/CoreLocation.h>
#import "ESTBeaconManager.h"
#import "TTLocationHandler.h"
#import "CustomTabController.h"
#import "Visitor.h"

typedef NS_ENUM(NSUInteger, EventType) {
    EventTypeAll,
    EventTypeBar,
    EventTypeClub,
    EventTypeLong,
    EventTypeConcert,
};

@class HomeScreenVC;

@class AKTabBarController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,ESTBeaconManagerDelegate>
{
    MBProgressHUD *HUD;
     BOOL internetConn;
    UIAlertView *beaconAlertView;
    NSDate *_mostRecentUploadDate;
    
    BOOL nearbyNotificationRequestOutstanding;
}

@property (nonatomic,retain)UINavigationController *navigationController;
@property (strong,nonatomic)HomeScreenVC *homeScreenController;

@property (nonatomic ,retain)NSString *ISFirst;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *DeviceToken;
@property (strong, nonatomic) NSArray *menuIcons;
@property (strong, nonatomic) NSArray *menuText;

@property (nonatomic, retain) NSString *CurrentLatitude;
@property (nonatomic, retain) NSString *CurrentLongitude;

//@property (nonatomic ,assign)BOOL internet;
@property (nonatomic ,assign)BOOL isLogin;
@property (nonatomic, retain) Visitor* visitor;
@property (nonatomic ,assign) CLLocationCoordinate2D userLocation;

@property (strong, nonatomic) CLBeaconRegion*   beaconRegion;
@property (strong, nonatomic) CLLocationManager*locationManager;

@property (nonatomic, strong) ESTBeaconManager* beaconManager;
@property(nonatomic)NSTimeInterval uploadInterval;


@property (nonatomic,retain) NSTimer *Request_timer;

@property (nonatomic,assign) BOOL isFullScreen;

@property (nonatomic, retain) AKTabBarController *tabBarController;

- (BOOL)checkForInternetConnection;
- (void)ShowLoader;
- (void)stopLoader;
- (BOOL)validateEmail:(NSString *)inputText;
- (void)RequestTimeOut;
- (void)secheduleTimer;
- (void)stopTimer;
- (void) setVisitor:(Visitor *)visitor;
@end