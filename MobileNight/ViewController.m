//
//  ViewController.m
//  MobileNight
//

#import "ViewController.h"
#import "MapDisplayVC.h"
#import "ListDisplayVC.h"
#import "FooterView.h"

@interface ViewController () <UISearchBarDelegate,UISearchControllerDelegate,UISearchDisplayDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    
    List_Array = [[NSMutableArray alloc] init];
    
    if ([kAPP_DELEGATE checkForInternetConnection])
    {
        [kAPP_DELEGATE ShowLoader];
        [APIClient getCites:^(NSDictionary *response, NSError *error)
         {
             
             if (error == nil) {
                 [kAPP_DELEGATE stopLoader];
                 
                 NSLog(@"City Response: %@",response);
                 List_Array = [response valueForKey:@"cities"];
                 [self.myTableView reloadData];
                 
                 //success
             } else {
                 [kAPP_DELEGATE stopLoader];
             }
         }];
    } else {
        [[[UIAlertView alloc] initWithTitle:internet_not_available message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil] show];
    }
    
    //[self retriveCurrentlocation];
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    
    self.navigationController.navigationBarHidden = YES;
    
//    UITextField *txfSearchField = [self.searchBar valueForKey:@"_searchField"];
//    [txfSearchField setBackgroundColor:[UIColor colorWithRed:212 green:211 blue:214 alpha:1]];
    
    UITextField *txfSearchField = [self.searchBar valueForKey:@"_searchField"];
    [txfSearchField setBackgroundColor:[UIColor whiteColor]];
    [txfSearchField setLeftViewMode:UITextFieldViewModeNever];
    [txfSearchField setRightViewMode:UITextFieldViewModeNever];
    UIImageView *search = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
    search.image = [UIImage imageNamed:@"search-icon.png"];
    [txfSearchField addSubview:search];
    [txfSearchField setBorderStyle:UITextBorderStyleNone];
    //txfSearchField.layer.borderWidth = 8.0f;
    //txfSearchField.layer.cornerRadius = 10.0f;
    txfSearchField.layer.borderColor = [UIColor clearColor].CGColor;
    txfSearchField.clearButtonMode=UITextFieldViewModeNever;
    
    //[self.searchBar setBarTintColor:[UIColor colorWithRed:46.0/255.0 green:59.0/255.0 blue:79.0/255.0 alpha:100]]
    ;
  //  List_Array = [[NSMutableArray alloc]initWithObjects:@"LOS ANGELES",@"SAN FRANCISCO",@"TEMPE",@"LOS ANGELES",@"SAN FRANCISCO",@"TEMPE", nil];
    
    
    //SubList_Array = [[NSMutableArray alloc]initWithObjects:@"CALIFORNIA",@"CALIFORNIA",@"ARIZONA",@"CALIFORNIA",@"CALIFORNIA",@"ARIZONA", nil];
    //List_Array = [[NSMutableArray alloc]initWithObjects:@"San Francisco",@"San Jose",@"Campbell",@"Mountain View",@"Los Gatos", nil];
    
    Searchd_List_Array = [NSArray array];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchBar setBarTintColor:[UIColor blackColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//
- (NSString *)tabTitle
{
    return @"Home";
}

- (NSString *)tabImageName
{
    return @"home-icon.png";
}

- (NSString *)activeTabImageName
{
    return @"home-icon.png";
}
//

#pragma mark- Get Location

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
//            
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

#pragma mark- UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchDisplayController.searchResultsTableView == tableView) {
        return Searchd_List_Array.count;
    }
    return List_Array.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* selectedRow = [[List_Array objectAtIndex:indexPath.row] mutableCopy];
    NSLog(@"Selected: %@",[List_Array objectAtIndex:indexPath.row]);
    //ListDisplayVC *vc  = [self.storyboard instantiateViewControllerWithIdentifier:@"ListDisplayVC"];
    ListDisplayVC *vc = [[ListDisplayVC alloc]initWithNibName:@"ListDisplayVC" bundle:nil];
    [selectedRow setObject:@"city" forKey:@"type"];
    vc.filterCondition = selectedRow;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:MyIdentifier];
    }
    else
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:MyIdentifier];
    }
    
    
    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, self.myTableView.frame.size.width, 130)];
    //imv.image=[UIImage imageNamed:@"user.jpg"];
    [cell.contentView addSubview:imv];
    
    
    UILabel *StateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 250, 25)];
    StateLabel.font = [UIFont systemFontOfSize:17.0];
    StateLabel.textColor = [UIColor whiteColor];
    [cell.contentView addSubview:StateLabel];
    
    UILabel *CityLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, 250, 25)];
    CityLabel.font = [UIFont systemFontOfSize:14.0];
    CityLabel.textColor = [UIColor whiteColor];
    [cell.contentView addSubview:CityLabel];
    
    UILabel *SepratorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 129, self.myTableView.frame.size.width, 1)];
    SepratorLabel.font = [UIFont systemFontOfSize:14.0];
    SepratorLabel.backgroundColor = [UIColor grayColor];
    [cell.contentView addSubview:SepratorLabel];
    
    NSString *CityImageURL;
    if (self.searchDisplayController.searchResultsTableView == tableView) {
       
        NSString *State = [[Searchd_List_Array objectAtIndex:indexPath.row] valueForKey:@"state"];
        StateLabel.text = State;
        
        NSString *City = [[Searchd_List_Array objectAtIndex:indexPath.row] valueForKey:@"name"];
        CityLabel.text = City;
        
        CityImageURL = [[Searchd_List_Array objectAtIndex:indexPath.row] valueForKey:@"imageUrl"];

    } else {
        
        NSString *State = [[List_Array objectAtIndex:indexPath.row] valueForKey:@"state"];
        StateLabel.text = State;
        
        NSString *City = [[List_Array objectAtIndex:indexPath.row] valueForKey:@"name"];
        CityLabel.text = City;
        
        CityImageURL = [[List_Array objectAtIndex:indexPath.row] valueForKey:@"imageUrl"];
        
    }
        
    if (![Util isNullValue:CityImageURL])
    {
        NSString *StringURL = [[List_Array objectAtIndex:indexPath.row] valueForKey:@"imageUrl"];
        NSURL *url = [NSURL URLWithString:StringURL];
        [imv sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"user.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
        
    } else {
        //self.imgVenue.image = nil;
        [imv setImage:[UIImage imageNamed:@"user.jpg"]];
        //last
    }

    
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark- UISearchBar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    /*NSString* filter = @"SELF CONTAINS[c] %@";
    NSPredicate* predicate = [NSPredicate predicateWithFormat:filter , searchText];
    Searchd_List_Array = [List_Array filteredArrayUsingPredicate:predicate];
    [self.searchDisplayController.searchResultsTableView reloadData];*/
}

//
#pragma mark - UISearchDisplayController Delegate Methods

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    // Update the filtered array based on the search text and scope.

    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name beginswith[c] %@",searchText];
    NSArray *tempArray = [List_Array filteredArrayUsingPredicate:predicate];
    
    Searchd_List_Array = [NSMutableArray arrayWithArray:tempArray];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

//

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.view addGestureRecognizer:tapGesture];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    if (searchBar.text.length == 0) {
        [searchBar setHidden:YES];
    }
    [self.view removeGestureRecognizer:tapGesture];
}

- (void)handleTap:(UIGestureRecognizer *)gesutre {
    [self.view endEditing:YES];
    [self.view removeGestureRecognizer:gesutre];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setHidden:YES];
}

-(IBAction)SearchButtonAction:(id)sender
{
    [self.searchBar setHidden:NO];
    [self.searchBar becomeFirstResponder];
}

@end