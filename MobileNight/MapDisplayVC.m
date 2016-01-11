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

//
#import "JPSThumbnailAnnotation.h"
//

#define DEFAULT_DELTA_LATITUDE		0.030092
#define DETAULT_DELTA_LONGITUDE		0.030092

@interface MapDisplayVC ()
{
    AppDelegate *appDelegate;
    NSOperationQueue  *queue;
    UIView *listVc;
    ListDisplayVC *vc;
    
    //
    NSMutableArray *annoArr;
    //
}

@end

@implementation MapDisplayVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
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
    annoArr=[[NSMutableArray alloc]init];
    
    for (int i =0; i<arrVenues.count; i++) {
        
        Venue *venue = [arrVenues objectAtIndex:i];
        
        //
        JPSThumbnail *empire = [[JPSThumbnail alloc] init];
        //empire.image = [UIImage imageNamed:@"round-blackbg1.png"];
        empire.mainTitle = venue.venueName;
        empire.title = venue.venueName;
        empire.subtitle = @"";
        empire.coordinate = CLLocationCoordinate2DMake(venue.latitude, venue.longitude);
        
        __block JPSThumbnail *empire1 = empire;
        
        empire.disclosureBlock = ^{
            
            NSLog(@"selected pin");
            
            for (int i = 0; i<arrVenues.count; i++) {
                
                double latitude = [[[arrVenues objectAtIndex:i] valueForKey:@"latitude"] doubleValue];
                double longitude = [[[arrVenues objectAtIndex:i] valueForKey:@"longitude"] doubleValue];
                
                // setup the map pin with all data and add to map view
                CLLocationCoordinate2D venueCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
                
                CLLocationCoordinate2D coordinate = empire1.coordinate;
                
                if (kCLCOORDINATES_EQUAL(venueCoordinate, coordinate)) {
                    VenueDetailVC *info = [[VenueDetailVC alloc]initWithNibName:@"VenueDetailVC" bundle:nil];
                    info.ven = [arrVenues objectAtIndex:i];
                    [self.navigationController pushViewController:info animated:YES];
                    break;
                }
            }
        };
        
        [annoArr addObject:[JPSThumbnailAnnotation annotationWithThumbnail:empire]];
        //
    }
    
    [self.mapView addAnnotations:annoArr];
}

#pragma mark - MapView Delegate

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didSelectAnnotationViewInMap:mapView];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)])
    {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didDeselectAnnotationViewInMap:mapView];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation conformsToProtocol:@protocol(JPSThumbnailAnnotationProtocol)]) {
        return [((NSObject<JPSThumbnailAnnotationProtocol> *)annotation) annotationViewInMap:mapView];
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    for (int i = 0; i<arrVenues.count; i++) {
        
        double latitude = [[[arrVenues objectAtIndex:i] valueForKey:@"latitude"] doubleValue];
        double longitude = [[[arrVenues objectAtIndex:i] valueForKey:@"longitude"] doubleValue];
        
        // setup the map pin with all data and add to map view
        CLLocationCoordinate2D venueCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
        CLLocationCoordinate2D coordinate = [[(MKPinAnnotationView *)view annotation] coordinate];
        if (kCLCOORDINATES_EQUAL(venueCoordinate, coordinate)) {
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