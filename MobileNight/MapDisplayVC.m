//
//  MapDisplayVC.m
//  MobileNight
//

#import "MapDisplayVC.h"
#import "KxMenu.h"
#import "EventsVC.h"
#import "LoginVC.h"
#import "ViewController.h"
#import "Venue.h"
#import "VenueDetailVC.h"
#import "ListDisplayVC.h"

#define DEFAULT_DELTA_LATITUDE		0.030092
#define DETAULT_DELTA_LONGITUDE		0.030092

@interface MapDisplayVC ()
{
    AppDelegate *appDelegate;
    NSOperationQueue  *queue;
    UIView *listVc;
    ListDisplayVC *vc;
}

@end

@implementation MapDisplayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"Perform");
     self.navigationController.navigationBarHidden = YES;

    queue = [[NSOperationQueue alloc] init];
    
    [queue addObserver:self forKeyPath:@"operations" options:0 context:nil];
    
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate  = self;
    
    MKCoordinateRegion defaultRegion = MKCoordinateRegionMake([kAPP_DELEGATE userLocation], MKCoordinateSpanMake(DEFAULT_DELTA_LATITUDE, DETAULT_DELTA_LONGITUDE));
    [self.mapView setRegion:defaultRegion];
    
    
    if ([kAPP_DELEGATE checkForInternetConnection]) {
        [kAPP_DELEGATE secheduleTimer];
        [kAPP_DELEGATE ShowLoader];
        [APIClient getVenues:^(NSDictionary *response, NSError *error) {
            [kAPP_DELEGATE stopLoader];
            [[kAPP_DELEGATE Request_timer] invalidate];
            if (error == nil) {
                arrVenues = [Venue getVenues:response];
               // [self getVenueInfo];
                [self Create_Annotation];

            } else {
                [kAPP_DELEGATE stopLoader];
            }
        }];
    } else {
        [[[UIAlertView alloc] initWithTitle:internet_not_available message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
   // [self dismissViewControllerAnimated:NO completion:nil];
//    if (![[self.navigationController viewControllers] containsObject: self])  {
//        [queue removeObserver:self forKeyPath:@"operations" context:nil];
//    }
    //any other hierarchy compare if it contains self or not
    [super viewWillDisappear:animated];
}

//
- (NSString *)tabTitle
{
    return @"Venues";
}

- (NSString *)tabImageName
{
    return @"venue-icon.png";
}

- (NSString *)activeTabImageName
{
    return @"venue-icon.png";
}
//

- (void)getVenueInfo {
    NSMutableArray *marrOperation = [NSMutableArray array];
    
    for (int i = 0; i<arrVenues.count; i++) {
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            Venue *ven = [arrVenues objectAtIndex:i];
            [APIClient getVenueDetailById:ven.venueId with:^(NSDictionary *response, NSError *error) {
                ven.info = [VenueInfo getVenueInfo:response];
            }];
        }];
        [marrOperation addObject:operation];
    }
    [queue addOperations:marrOperation waitUntilFinished:NO];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                         change:(NSDictionary *)change context:(void *)context
{
    if (object == queue && [keyPath isEqualToString:@"operations"]) {
        if ([queue.operations count] == 0) {
            // Do something here when your queue has completed
            NSLog(@"queue has completed %@",arrVenues);
            dispatch_async(dispatch_get_main_queue(), ^{
                [kAPP_DELEGATE stopLoader];
                if(arrVenues.count > 0){
                    [self Create_Annotation];
                }
            });
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object
                               change:change context:context];
    }
}

-(void) Create_Annotation
{
    for (int i =0; i<arrVenues.count; i++) {
        
        Venue *venue = [arrVenues objectAtIndex:i];
        MKPointAnnotation *mapPin = [[MKPointAnnotation alloc] init];
        
        // setup the map pin with all data and add to map view
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(venue.latitude, venue.longitude);
        
        mapPin.title = venue.venueName;
        mapPin.coordinate = coordinate;
        NSString *subtitle = @"";
        if (![Util isNullValue:[venue.info coverCharges]]) {
            subtitle = [NSString stringWithFormat:@"Cover Charge:%@",[venue.info coverCharges]];
        }
        if (![Util isNullValue:[venue.info fastlineCharges]]) {
            if (subtitle.length > 0) {
                subtitle = [subtitle stringByAppendingFormat:@" & Fast Track Charge:%@",venue.info.fastlineCharges];
            } else {
                subtitle = [subtitle stringByAppendingFormat:@"Fast Track Charge:%@",venue.info.fastlineCharges];
            }
        }
        [self.mapView addAnnotation:mapPin];
        
        if (i==0) {
            MKCoordinateRegion defaultRegion = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(DEFAULT_DELTA_LATITUDE, DETAULT_DELTA_LONGITUDE));
            [self.mapView setRegion:defaultRegion];
        }
    }
}

/*
#pragma mark - MapView Delegate
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
   // MKAnnotationView *annotationView = [views objectAtIndex:0];
    //id<MKAnnotation> mp = [annotationView annotation];
    //MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate] ,350,350);
    
    //[mv setRegion:region animated:YES];
    
    //[self.mapView selectAnnotation:mp animated:YES];
    
}*/

/*
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    id myAnnotation = [mapView.annotations objectAtIndex:0];
    [mapView selectAnnotation:myAnnotation animated:YES];
}
*/


/*
-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
 
    for (int i = 0; i < [arrVenues count]; i++)
    {
         [mapView selectAnnotation:[[mapView annotations] objectAtIndex:i] animated:YES];
    }
}
*/


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    static NSString *reuseId = @"StandardPin";
    MKPinAnnotationView *aView = (MKPinAnnotationView *)[mapView
                                                         dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (aView == nil)
    {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                 reuseIdentifier:reuseId];
        aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        aView.canShowCallout = YES;
    }
    
    aView.annotation = annotation;
    
    return aView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    for (int i = 0; i<arrVenues.count; i++) {
        
        double latitude = [[[arrVenues objectAtIndex:i] valueForKey:@"latitude"] doubleValue];
        double longitude = [[[arrVenues objectAtIndex:i] valueForKey:@"longitude"] doubleValue];
        
        // setup the map pin with all data and add to map view
        CLLocationCoordinate2D venueCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
        CLLocationCoordinate2D coordinate = [[(MKPinAnnotationView *)view annotation] coordinate];
        if (kCLCOORDINATES_EQUAL(venueCoordinate, coordinate)) {
            //VenueDetailVC *info = [self.storyboard instantiateViewControllerWithIdentifier:@"VenueDetailVC"];
            VenueDetailVC *info = [[VenueDetailVC alloc]initWithNibName:@"VenueDetailVC" bundle:nil];
            info.ven = [arrVenues objectAtIndex:i];
            [self.navigationController pushViewController:info animated:YES];
            break;
        }
    }
}

- (IBAction)btnListClicked:(id)sender {
    
    //vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ListDisplayVC"];
    vc = [[ListDisplayVC alloc]initWithNibName:@"ListDisplayVC" bundle:nil];
    vc.view.hidden = YES;
    vc.mapVc = self;
    listVc = vc.view;
    listVc.frame = self.view.frame;
    [self.view addSubview:vc.view];
    [self addChildViewController:vc];
   // [self.view addSubview:listVc];
    //[self addChildViewController:vc];
    listVc.hidden = NO;
    
//    ListDisplayVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"navList"];
//    [self.view addSubview:vc.view];
//    [self addChildViewController:vc];
//
//
//    [UIView transitionFromView:self.view
//                        toView:vc.view
//                      duration:1
//                       options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionFlipFromRight
//                    completion:^(BOOL finished) {
//                        // whatever completion code you need
//                        //[self addChildViewController:vc];
//                    }];

//    vc.modalPresentationStyle = UIModalPresentationCurrentContext;
//    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    vc.definesPresentationContext = YES;
//   
//    [self presentViewController:vc animated:YES completion:nil];
}

-  (void)hideList
{
    listVc.hidden = YES;
}

@end