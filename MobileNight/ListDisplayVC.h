//
//  ListDisplayVC.h
//  MobileNight
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapDisplayVC.h"

@interface ListDisplayVC : HeaderVC<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
   

    CLLocationManager *locationManager;
    BOOL callflag;
    
    
    NSArray *arrVenues;

}
@property (strong, nonatomic) IBOutlet UITableView *ListTableView;
@property (strong, nonatomic) MapDisplayVC *mapVc;
@property (strong, nonatomic) NSDictionary* filterCondition;

@end
