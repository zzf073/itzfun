//
//  AppDelegate.m
//  MobileNight
//

#import "AppDelegate.h"
#import "Reachability.h"
#import "KxMenu.h"
#import <CoreLocation/CoreLocation.h>
#import "MapDisplayVC.h"
#import "SecureUDID.h"
#import "HomeScreenVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize ISFirst,CurrentLatitude,CurrentLongitude;
@synthesize navigationController,homeScreenController;

static AppDelegate* instance = nil;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [KxMenu setTitleFont:[UIFont systemFontOfSize:24]];
    ISFirst = @"YES";
    
    //*******for pushnotification *******
    if(IS_OS_8_OR_LATER)
    {
        //Right, that is the point
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                             |UIRemoteNotificationTypeSound
                                                                                             |UIRemoteNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else
    {
        //#else
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert ];
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert ];
    
    //By akshay add observer for location   change(for new location classes)
    NSNotificationCenter *defaultNotificatoinCenter = [NSNotificationCenter defaultCenter];
    [defaultNotificatoinCenter addObserver:self selector:@selector(handleLocationUpdate) name:LocationHandlerDidUpdateLocation object:nil];
    
    // create singltone intance for new location
    TTLocationHandler *sharedHandler = [TTLocationHandler sharedLocationHandler];
    sharedHandler=nil;
    
    //    [self startBeaconFound];
    [self startAirLocationFound];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.homeScreenController = [[HomeScreenVC alloc] initWithNibName:@"HomeScreenVC" bundle:nil];
    self.navigationController=[[UINavigationController alloc]initWithRootViewController:self.homeScreenController];
    
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"])
    {
    }
    else if ([identifier isEqualToString:@"answerAction"])
    {
    }
}

#endif
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self handleRemoteNotificationWithUserInfo:userInfo];
}
- (void) setVisitor:(Visitor *)visitor
{
    _visitor = visitor;
}
-(void)handleRemoteNotificationWithUserInfo:(NSDictionary *)userInfo
{
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:nil delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
    alert.tag = 0001;
    [alert show];*/
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    
    NSString *userId=@"";
    NSString *objId=(NSString *)[userInfo objectForKey:@"couponId"];
   /* if([LoginModel shared].facebookUserId)
        userId=[LoginModel shared].facebookUserId;
    else  if([LoginModel shared].fashionClypUserId)
        userId=[LoginModel shared].fashionClypUserId;*/
    
    [params setObject:[NSDate date] forKey:@"time"];
    [params setObject:userId forKey:@"visitorId"];
    [params setObject:[userInfo objectForKey:@"couponId"] forKey:@"objId"];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *dt = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    dt = [dt stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.DeviceToken=dt;
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken=%@",dt);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                    fallbackHandler:^(FBAppCall *call) {
                        NSLog(@"In fallback handler");
                    }];
}
#pragma mark - ESTBeaconManager start
- (void)startBeaconFound{
    
    // craete manager instance
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    self.beaconManager.avoidUnknownStateBeacons = YES;
    
    // create sample region with major value defined
    ESTBeaconRegion* region = [[ESTBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"] major:1 minor:1 identifier: @"EstimoteSampleRegion"];
    
    [self.beaconManager startMonitoringForRegion:region];
    [self.beaconManager requestStateForRegion:region];
}
#pragma mark - Beacon Alert View

- (void)showNotificationView:(NSString *)msgStr{
    
    if (beaconAlertView != nil) {
        [beaconAlertView dismissWithClickedButtonIndex:0 animated:NO];
        beaconAlertView = nil;
    }
    
    beaconAlertView = [[UIAlertView alloc]initWithTitle:msgStr message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [beaconAlertView show];
    [self performSelector:@selector(hideBeaconNotificationView) withObject:nil afterDelay:2.0];
}
- (void)hideBeaconNotificationView{
    
    [beaconAlertView dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - ESTBeaconManagerDelegate


-(void)beaconManager:(ESTBeaconManager *)manager didDetermineState:(CLRegionState)state forRegion:(ESTBeaconRegion *)region {
    if(state == CLRegionStateInside){
        
        [self showNotificationView:@"Found a Beacon"];
    }
    else{
        
        [self showNotificationView:@"Beacon Lost"];
    }
}

-(void)beaconManager:(ESTBeaconManager *)manager didEnterRegion:(ESTBeaconRegion *)region {
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"Found a Beacon";
    notification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

-(void)beaconManager:(ESTBeaconManager *)manager didExitRegion:(ESTBeaconRegion *)region {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"Beacon Lost";
    notification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

#pragma mark - AirLocation

- (void)startAirLocationFound {
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self initRegion];
    [self locationManager:self.locationManager didStartMonitoringForRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)initRegion {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"ACD6EFA7-8056-466C-9FBB-2D3A14851B3B"];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"com.domainforclient.mobinite"];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"Beacon Found");
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"Found a Beacon";
    notification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
    [self showNotificationView:@"Found a Beacon"];
    
    
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"Left Region");
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"Beacon Lost";
    notification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
    [self showNotificationView:@"Beacon Lost"];
    
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    CLBeacon *beacon = [[CLBeacon alloc] init];
    beacon = [beacons lastObject];
    //    NSLog(@"------------------------");
    //    NSLog(@"Beacon Found: YES");
    //    NSLog(@"UDID: %@", beacon.proximityUUID.UUIDString);
    //    NSLog(@"Major: %@", beacon.major);
    //    NSLog(@"Minor: %@", beacon.minor);
    //    NSLog(@"Accuracty: %f", beacon.accuracy);edited by akshay
    
    if (beacon.proximity == CLProximityUnknown) {
        //NSLog(@"Distance: Unknown Proximity");
        
    } else if (beacon.proximity == CLProximityImmediate) {
        //  NSLog(@"Distance: Immediate");
        
    } else if (beacon.proximity == CLProximityNear) {
        // NSLog(@"Distance: Near");
        
    } else if (beacon.proximity == CLProximityFar) {
        // NSLog(@"Distance: Far");
    }
    //    NSLog(@"RSSI: %@",[NSString stringWithFormat:@"%i", beacon.rssi]);
}
#pragma mark--By Akshay---
#pragma mark for location change
-(void)storeMostRecentLocationInfo
{
    static int locationIndex = 0;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *lastKnowLocationInfo = [defaults objectForKey:@"LAST_KNOWN_LOCATION"];
    if (!lastKnowLocationInfo) {
        return;
    }
    
    // store the location info
    NSString *theKey = [NSString stringWithFormat:@"location%i", locationIndex];
    [defaults setObject:[NSDictionary dictionaryWithDictionary:lastKnowLocationInfo] forKey:theKey];
    
    int numberOfPinsSaved = [defaults integerForKey:@"NUMBER_OF_PINS_SAVED"];
    
    if (locationIndex == numberOfPinsSaved) {
        locationIndex = 0;
        return;
    }
    
    locationIndex++;
}


-(void)handleLocationUpdate
{
    UIApplication *app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier locationUpdateTaskID = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (locationUpdateTaskID != UIBackgroundTaskInvalid) {
                // *** CONSIDER MORE APPROPRIATE RESPONSE TO EXPIRATION *** //
                [app endBackgroundTask:locationUpdateTaskID];
                locationUpdateTaskID = UIBackgroundTaskInvalid;
            }
        });
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Enter Background Operations here
        [self storeMostRecentLocationInfo];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *lastKnowLocationInfo = [defaults objectForKey:@"LAST_KNOWN_LOCATION"];
        
        // Alternately, lastKnownLocation could be obtained directly like so:
        CLLocation *lastKnownLocation = [[TTLocationHandler sharedLocationHandler] lastKnownLocation];
        NSLog(@"Alternate location object directly from handler is \n%@",lastKnownLocation);
        
        if (!lastKnowLocationInfo) {
            return;
        }
        
        // Store the location into your sqlite database here
        NSLog(@"Retrieved from defaults location info: \n%@ \n Ready for store to database",lastKnowLocationInfo);
        
        NSTimeInterval timeSinceLastUpload = [_mostRecentUploadDate timeIntervalSinceNow] * -1;
        
        if (timeSinceLastUpload == 0 || timeSinceLastUpload >= self.uploadInterval) {
            [self uploadCurrentData];
        }
        
        // Close out task Idenetifier on main queue
        dispatch_async(dispatch_get_main_queue(), ^{
            // Send notification for any class that needs to know
            // NSNotification *aNotification = [NSNotification notificationWithName:PinLoggerDidSaveNewLocation object:[lastKnownLocation copy]];
            //[[NSNotificationCenter defaultCenter] postNotification:aNotification];
            
            if (locationUpdateTaskID != UIBackgroundTaskInvalid) {
                [app endBackgroundTask:locationUpdateTaskID];
                locationUpdateTaskID = UIBackgroundTaskInvalid;
            }
        });
    });
}


/*
//For getting Current Location.
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        NSString *CurrentLongitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        NSString *CurrentLatitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
}*/


-(void)uploadCurrentData
{
    
    NSLog(@"Upload data to the server");
    //This is replecement of  Globel "pollForNearbyNotifications" method
    // Do your upload to web operations here
    
    //Run this in the background.
    //		UIBackgroundTaskIdentifier bgTask = UIBackgroundTaskInvalid;
    //		bgTask = [[UIApplication sharedApplication]
    //				  beginBackgroundTaskWithExpirationHandler:^{
    //					  instance->nearbyNotificationRequestOutstanding = NO;
    //					  [[UIApplication sharedApplication] endBackgroundTask:bgTask];
    //				  }];
    //        bgTask = UIBackgroundTaskInvalid;
    
    self->nearbyNotificationRequestOutstanding = YES;
    
    // [instance->downloader requestJSON:@"mobile_local_store_fetch_ajax.php?ver=undefined&app=SZ_RALEY&context=notification&isDemo=1"];
    
    //		[ClypAnalytics getLocalStores];
    
    
    // For Raley's demo, to be removed after
    /*NSString *adURL = [NSString stringWithFormat:@"http://www.clypit.com/raley/v2/services/mobile_get_cm_ad.php?secure_udid=%@",[LoginModel shared].secureUDID];
     NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:adURL]];
     
     NSOperationQueue * operationQueue = [[NSOperationQueue alloc] init];
     [operationQueue setMaxConcurrentOperationCount:2];
     
     [NSURLConnection sendAsynchronousRequest:request queue:operationQueue completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error) {
     if (!error) {
     NSData *responseData = [[NSData alloc] initWithData:data];
     NSError *error = nil;
     
     id response = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error];
     
     BOOL isValid = [NSJSONSerialization isValidJSONObject:response];
     
     if (isValid) {
     NSLog(@"ResponseValid");
     }
     else
     {
     NSLog(@"ResponseInvalid");
     }
     }
     else
     {
     NSLog(@"Error:%@",error);
     }
     }];
     
     
     //		if (bgTask != UIBackgroundTaskInvalid)
     //		{
     //			[[UIApplication sharedApplication] endBackgroundTask:bgTask];
     //		}
     
     */
    //******Set Flurry object*************//
    TTLocationHandler *handler=[TTLocationHandler sharedLocationHandler];
    handler=nil;
    
}
#pragma mark - Loader
-(void)ShowLoader
{
    /*if(iOs7)
     {
     [SVProgressHUD show];
     
     [self insertSpinner:[[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleCircleFlip color:RealStirColor]
     atIndex:1
     backgroundColor:[UIColor clearColor]];
     }
     else
     {*/
    [HUD removeFromSuperview];
    [HUD hide:YES];
    HUD = [[MBProgressHUD alloc] initWithView:self.window];
    [self.window addSubview:HUD];
    HUD.tag=9999998;
    HUD.hidden = false;
    //HUD.color = [UIColor clearColor];
    HUD.labelText = @"";
    [HUD show:YES];
    //}
}

-(void)stopLoader
{
    /*if(iOs7)
     {
     [SVProgressHUD dismiss];
     [panel removeFromSuperview];
     }
     else
     {*/
    [[[[[UIApplication sharedApplication] delegate] window] viewWithTag:9999998]removeFromSuperview];
    [HUD removeFromSuperview];
    [HUD hide:YES];
    //}
}
-(BOOL)checkForInternetConnection
{
    Reachability *reach = [Reachability reachabilityForInternetConnection] ;
    
    NetworkStatus status = [reach currentReachabilityStatus];
    
    [self stringFromStatus:status];
    
    if (internetConn)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
    return NO;
    
}
#pragma Mark Check Network Status

-(void)stringFromStatus:(NetworkStatus)status
{
    NSString *string=@"Not Reachable";
    switch(status)
    {
        case NotReachable:
            //string =NSLocalizedString(@"Not Reachable", nil) ;
            internetConn=NO;
            break;
        case ReachableViaWiFi:
            //string = NSLocalizedString(@"Reachable via WiFi",nil);
            internetConn=YES;
            break;
        case ReachableViaWWAN:
            //string =NSLocalizedString(@"Reachable via WWAN",nil);
            internetConn=YES;
            break;
        default:
            string =NSLocalizedString(@"Unknown",nil);
            internetConn=YES;
            break;
    }
}

#pragma mark - Check EmailValidation
- (BOOL)validateEmail:(NSString *)inputText
{
    NSString *emailRegex = @"[A-Z0-9a-z][A-Z0-9a-z._%+-]*@[A-Za-z0-9][A-Za-z0-9.-]*\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    NSRange aRange;
    if([emailTest evaluateWithObject:inputText])
    {
        aRange = [inputText rangeOfString:@"." options:NSBackwardsSearch range:NSMakeRange(0, [inputText length])];
        NSInteger indexOfDot = aRange.location;
        if(aRange.location != NSNotFound)
        {
            NSString *topLevelDomain = [inputText substringFromIndex:indexOfDot];
            topLevelDomain = [topLevelDomain lowercaseString];
            NSSet *TLD;
            TLD = [NSSet setWithObjects:@".aero", @".asia", @".biz", @".cat", @".com", @".coop", @".edu", @".gov", @".info", @".int", @".jobs", @".mil", @".mobi", @".museum", @".name", @".net", @".org", @".pro", @".tel", @".travel", @".ac", @".ad", @".ae", @".af", @".ag", @".ai", @".al", @".am", @".an", @".ao", @".aq", @".ar", @".as", @".at", @".au", @".aw", @".ax", @".az", @".ba", @".bb", @".bd", @".be", @".bf", @".bg", @".bh", @".bi", @".bj", @".bm", @".bn", @".bo", @".br", @".bs", @".bt", @".bv", @".bw", @".by", @".bz", @".ca", @".cc", @".cd", @".cf", @".cg", @".ch", @".ci", @".ck", @".cl", @".cm", @".cn", @".co", @".cr", @".cu", @".cv", @".cx", @".cy", @".cz", @".de", @".dj", @".dk", @".dm", @".do", @".dz", @".ec", @".ee", @".eg", @".er", @".es", @".et", @".eu", @".fi", @".fj", @".fk", @".fm", @".fo", @".fr", @".ga", @".gb", @".gd", @".ge", @".gf", @".gg", @".gh", @".gi", @".gl", @".gm", @".gn", @".gp", @".gq", @".gr", @".gs", @".gt", @".gu", @".gw", @".gy", @".hk", @".hm", @".hn", @".hr", @".ht", @".hu", @".id", @".ie", @" No", @".il", @".im", @".in", @".io", @".iq", @".ir", @".is", @".it", @".je", @".jm", @".jo", @".jp", @".ke", @".kg", @".kh", @".ki", @".km", @".kn", @".kp", @".kr", @".kw", @".ky", @".kz", @".la", @".lb", @".lc", @".li", @".lk", @".lr", @".ls", @".lt", @".lu", @".lv", @".ly", @".ma", @".mc", @".md", @".me", @".mg", @".mh", @".mk", @".ml", @".mm", @".mn", @".mo", @".mp", @".mq", @".mr", @".ms", @".mt", @".mu", @".mv", @".mw", @".mx", @".my", @".mz", @".na", @".nc", @".ne", @".nf", @".ng", @".ni", @".nl", @".no", @".np", @".nr", @".nu", @".nz", @".om", @".pa", @".pe", @".pf", @".pg", @".ph", @".pk", @".pl", @".pm", @".pn", @".pr", @".ps", @".pt", @".pw", @".py", @".qa", @".re", @".ro", @".rs", @".ru", @".rw", @".sa", @".sb", @".sc", @".sd", @".se", @".sg", @".sh", @".si", @".sj", @".sk", @".sl", @".sm", @".sn", @".so", @".sr", @".st", @".su", @".sv", @".sy", @".sz", @".tc", @".td", @".tf", @".tg", @".th", @".tj", @".tk", @".tl", @".tm", @".tn", @".to", @".tp", @".tr", @".tt", @".tv", @".tw", @".tz", @".ua", @".ug", @".uk", @".us", @".uy", @".uz", @".va", @".vc", @".ve", @".vg", @".vi", @".vn", @".vu", @".wf", @".ws", @".ye", @".yt", @".za", @".zm", @".zw", nil];
            if(topLevelDomain != nil && ([TLD containsObject:topLevelDomain]))
            {
                return TRUE;
            }
            /*else
             {
             NSLog(@"TLD DOEST NOT contains topLevelDomain:%@",topLevelDomain);
             }*/
        }
    }
    return FALSE;
}
#pragma mark - Request TimeOut 
- (void)secheduleTimer {

    if(self.Request_timer)
    {
        [self.Request_timer invalidate];
        self.Request_timer=nil;
    }
    
    self.Request_timer=[NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(RequestTimeOut) userInfo:nil repeats:NO];
}

-(void)RequestTimeOut
{
    if(self.Request_timer)
    {
        [self.Request_timer invalidate];
        self.Request_timer=nil;
    }
    
    [self stopLoader];
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:request_timeout delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
    [alert show];
}
- (void)stopTimer {
    if(self.Request_timer)
    {
        [self.Request_timer invalidate];
        self.Request_timer=nil;
    }
}

@end
