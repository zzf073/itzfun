//
//  ViewController.h
//  MobileNight
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : HeaderVC <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    BOOL callflag;
    
    NSMutableArray *List_Array;
    NSMutableArray *SubList_Array;
    
    NSArray *Searchd_List_Array;

    
    UITapGestureRecognizer *tapGesture;
    
}

@property (nonatomic, retain) IBOutlet UIButton *SearchButton;
-(IBAction)SearchButtonAction:(id)sender;

@property (nonatomic, retain) IBOutlet NSLayoutConstraint *SearchBarHide;

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;


@end

