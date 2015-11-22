//
//  EventCell.h
//  MobileNight
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventCell : UITableViewCell {
    NSIndexPath *index;
}


@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;

@property (strong, nonatomic) IBOutlet UILabel *lblDJ;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblEventType;

- (void)configureCell:(Event *)event with:(NSIndexPath *)indexPath;

@end
