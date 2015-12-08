//
//  EventsVC.h
//  MobileNight
//

#import <UIKit/UIKit.h>

@interface EventsVC : HeaderVC <UITableViewDataSource,UITableViewDelegate> {
    
    IBOutlet UITableView *tblEvents;
    NSArray *arrEvents;
    UITapGestureRecognizer *tapGesture;
}

@property(nonatomic,retain) IBOutlet UIButton *segmtDJ;
@property(nonatomic,retain) IBOutlet UIButton *segmtComedy;
@property(nonatomic,retain) IBOutlet UIButton *segmtKaroke;
@property(nonatomic,retain) IBOutlet UIButton *segmtAll;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end
