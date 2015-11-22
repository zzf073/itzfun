//
//  VenueCell.h
//  MobileNight
//

#import <Foundation/Foundation.h>
#import "Venue.h"

@interface VenueCell : UITableViewCell {
    NSIndexPath *index;
}

@property (retain, nonatomic) IBOutlet UILabel *lblVenueName;
@property (retain, nonatomic) IBOutlet UILabel *lblVenueType;
@property (retain, nonatomic) IBOutlet UILabel *lblCity;
@property (retain, nonatomic) IBOutlet UILabel *lblCoverCharges;
@property (retain, nonatomic) IBOutlet UIImageView *imgVenue;
@property (weak, nonatomic) IBOutlet UILabel *lblCulLineCost;
- (void)configureCell:(Venue *)ven with:(NSIndexPath *)indexPath;


@end
