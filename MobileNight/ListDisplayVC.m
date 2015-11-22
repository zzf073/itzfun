//
//  ListDisplayVC.m
//  MobileNight
//

#import "ListDisplayVC.h"
#import "VenueDetailVC.h"
#import "AppDelegate.h"
#import "ListDisplayVC.h"
#import "MapDisplayVC.h"
#import "AppDelegate.h"
#import "Venue.h"
#import "VenueCell.h"
#import "MapDisplayVC.h"
#define PAGING 10

@interface ListDisplayVC () <UISearchBarDelegate>
{
    AppDelegate *appDelegate;
    NSOperationQueue  *queue;
    NSMutableArray *marrOperation;
    NSInteger counter;
    BOOL isPagingCalled;
}
@end

@implementation ListDisplayVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrVenues = [NSArray array];
    queue = [[NSOperationQueue alloc] init];
    [queue addObserver:self forKeyPath:@"operations" options:0 context:nil];
    self.navigationController.navigationBarHidden = YES;
    
    [self.ListTableView registerNib:[UINib nibWithNibName:@"VenueCell" bundle:nil] forCellReuseIdentifier:@"VenueCell"];
    
    if ([kAPP_DELEGATE checkForInternetConnection])
    {
        [kAPP_DELEGATE secheduleTimer];
        [kAPP_DELEGATE ShowLoader];
        [APIClient getVenuesByCity:self.filterCondition with:^(NSDictionary *response, NSError *error) {

            [kAPP_DELEGATE stopLoader];

            [[kAPP_DELEGATE Request_timer] invalidate];
            if (error == nil) {
                arrVenues = [Venue getVenues:response];
                [self.ListTableView reloadData];

                //[self getVenueInfo];
     
            }else {
                [kAPP_DELEGATE stopLoader];
            }
        }];
     } else {
        [[[UIAlertView alloc] initWithTitle:internet_not_available message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
     }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark- Get Venue Info

- (void)getVenueInfo
{
    marrOperation = [NSMutableArray array];
    
    for (int i = 0; i<arrVenues.count; i++)
    {
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            Venue *ven = [arrVenues objectAtIndex:i];
            [APIClient getVenueDetailById:ven.venueId with:^(NSDictionary *response, NSError *error) {
                ven.info = [VenueInfo getVenueInfo:response];
            }];
        }];
        [marrOperation addObject:operation];
    }
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                         change:(NSDictionary *)change context:(void *)context
{
    if (object == queue && [keyPath isEqualToString:@"operations"])
    {
        if ([queue.operations count] == 0) {
            isPagingCalled = NO;
            counter += PAGING;
            // Do something here when your queue has completed
            NSLog(@"queue has completed %@",arrVenues);
            dispatch_async(dispatch_get_main_queue(), ^{
                [kAPP_DELEGATE stopLoader];
                [self.ListTableView reloadData];
            });
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark- UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrVenues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VenueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VenueCell"];
    Venue *ven = [arrVenues objectAtIndex:indexPath.row];
    [cell configureCell:ven with:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.navigationController) {
        //VenueDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VenueDetailVC"];
        VenueDetailVC *vc = [[VenueDetailVC alloc]initWithNibName:@"VenueDetailVC" bundle:nil];
        vc.ven = [arrVenues objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark- Get Current Location

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
        [locationManager startUpdatingLocation];
        NSLog(@"%@", [self deviceLocation]);
        
        callflag = YES;
    }
    else
    {
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
        {
        }
        else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined)
        {
            callflag = NO;
        }
        else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse)
        {
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (!callflag)
    {
        NSLog(@"Map");
        callflag = YES;
    }
    else
    {
        //NSLog(@"Menu");
        if ([appDelegate.ISFirst isEqualToString:@"YES"]) {
            [locationManager stopUpdatingLocation];
            callflag = YES;
        }
        appDelegate.ISFirst=@"NO";
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

#pragma mark- UISearchBar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
}

#pragma mark- Click Map Button

- (IBAction)btnMapClicked:(id)sender
{
    //self.view.hidden = YES;
    [self.mapVc hideList];
    
    if (self.mapVc == nil)
    {
        //self.mapVc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapDisplayVC"];
        self.mapVc = [[MapDisplayVC alloc]initWithNibName:@"MapDisplayVC" bundle:nil];
        self.mapVc.view.frame = self.view.frame;
        [self.view addSubview:self.mapVc.view];
        [self addChildViewController:self.mapVc];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == arrVenues.count - 5 && !isPagingCalled)  {
        [self getNextPageVenusInfo];
    }
}
- (void)getNextPageVenusInfo {
    isPagingCalled = YES;
    if (counter < arrVenues.count) {
        [queue addOperations:[marrOperation subarrayWithRange:NSMakeRange(0, PAGING)] waitUntilFinished:NO];

    }
}


@end