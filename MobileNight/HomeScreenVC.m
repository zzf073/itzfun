//
//  HomeScreenVC.m
//  MobileNight
//

#import "HomeScreenVC.h"
#import <CoreLocation/CoreLocation.h>
#import "MapDisplayVC.h"

#import "AKTabBarController.h"
#import "ViewController.h"
#import "VIPVc.h"
#import "MapDisplayVC.h"
#import "EventsVC.h"
#import "ProfileVC.h"

@interface HomeScreenVC ()

@end

@implementation HomeScreenVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self retriveCurrentlocation];
    
    LoadingTimer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(GotoMainScreen_Method)
                                   userInfo:nil
                                    repeats:NO];
    
}

-(void)GotoMainScreen_Method
{
    [LoadingTimer invalidate];
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        [kAPP_DELEGATE setISFirst:@"NO"];

        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[MapDisplayVC class]]) {
                [self.navigationController popToViewController:vc animated:YES];
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        return;
            }
        }
        //[self performSegueWithIdentifier:@"gotomain" sender:nil];

        //MapDisplayVC *vc  = [self.storyboard instantiateViewControllerWithIdentifier:@"MapDisplayVC"];
        [self setTabController];
    }
    else
    {
        //[self performSegueWithIdentifier:@"gotomain" sender:nil];

        //MapDisplayVC *vc  = [self.storyboard instantiateViewControllerWithIdentifier:@"MapDisplayVC"];
        [self setTabController];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)retriveCurrentlocation
{
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
    
    if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorized)
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
        locationManager.delegate = self;
        [locationManager startUpdatingLocation];
        NSLog(@"%@", [self deviceLocation]);
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLocationAuthorized"];
        callflag = YES;
    }
    else
    {
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
        {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLocationAuthorized"];
            
        }
        else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined)
        {
            callflag = NO;
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLocationAuthorized"];
            
        }
        else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse)
        {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLocationAuthorized"];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
     CLLocation *lastLocation = [locations lastObject];
    // CLLocationAccuracy accuracy = [lastLocation horizontalAccuracy];
    [kAPP_DELEGATE setUserLocation:lastLocation.coordinate];
    
    if (!callflag)
    {
        NSLog(@"Map");
        callflag = YES;
    }
    else
    {
        //NSLog(@"Menu");
        if ([[kAPP_DELEGATE ISFirst] isEqualToString:@"YES"]) {
            [locationManager stopUpdatingLocation];
            callflag = YES;
            
//            for (UIViewController *vc in self.navigationController.viewControllers) {
//                if ([vc isKindOfClass:[MapDisplayVC class]]) {
//                    [self.navigationController popToViewController:vc animated:YES];
//                    return;
//                }
//            }
//            MapDisplayVC *vc  = [self.storyboard instantiateViewControllerWithIdentifier:@"MapDisplayVC"];
//            [self.navigationController pushViewController:vc animated:YES];
        }
        [kAPP_DELEGATE setISFirst:@"NO"];
    }
    
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (callflag)
    {
        
    }
}

- (NSString *)deviceLocation
{
    return [NSString stringWithFormat:@"latitude: %f longitude: %f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
}

-(void)setTabController
{    
    _tabBarController = [[AKTabBarController alloc] initWithTabBarHeight:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 70 : 50];
    
    ViewController *first = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    
    VIPVc *second = [[VIPVc alloc] initWithNibName:@"VIPVc" bundle:nil];
    
    MapDisplayVC *thrid = [[MapDisplayVC alloc] initWithNibName:@"MapDisplayVC" bundle:nil];
    EventsVC *fourth = [[EventsVC alloc] initWithNibName:@"EventsVC" bundle:nil];
    ProfileVC *fifth = [[ProfileVC alloc] initWithNibName:@"ProfileVC" bundle:nil];
    
    UINavigationController *firstNavController = [[UINavigationController alloc] initWithRootViewController:first];
    UINavigationController *secondNavController = [[UINavigationController alloc] initWithRootViewController:second];
    UINavigationController *thridNavController = [[UINavigationController alloc] initWithRootViewController:thrid];
    UINavigationController *fourthNavController = [[UINavigationController alloc] initWithRootViewController:fourth];
    UINavigationController *fifthNavController = [[UINavigationController alloc] initWithRootViewController:fifth];
    
   
    [_tabBarController setViewControllers:[NSMutableArray arrayWithObjects:firstNavController,secondNavController,thridNavController,fourthNavController,fifthNavController,nil]];
    
    //[_tabBarController setBackgroundImageName:@"noise-dark-gray.png"];
    //[_tabBarController setSelectedBackgroundImageName:@"noise-dark-blue.png"];
    
    [_tabBarController setBackgroundImageName:nil];
    [_tabBarController setSelectedBackgroundImageName:nil];

    
    //
    [_tabBarController setTabColors:@[[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0], [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0],[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0],[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0],[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]]];
    //
    [_tabBarController setSelectedIndex:2];
    [kAPP_DELEGATE setTabBarController:_tabBarController];
    [self.navigationController pushViewController:_tabBarController animated:YES];
}

@end