//
//  VenueCell.m
//  MobileNight
//

#import "VenueCell.h"

@implementation VenueCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)configureCell:(Venue *)ven with:(NSIndexPath *)indexPath {
    
    index = indexPath;
    self.lblVenueName.text  = ven.venueName;
    self.lblVenueType.text  = ven.venueType;
    self.lblCity.text       = ven.city;
    [self bringSubviewToFront:self.lblVenueType];
    NSLog(@"frame = %@",NSStringFromCGRect(self.lblVenueType.frame));
    
    if (![Util isNullValue:ven.imageURL])
    {
        NSURL *url = [NSURL URLWithString:ven.imageURL];
        [self.imgVenue sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
      
    } else {
        //self.imgVenue.image = nil;
        [self.imgVenue setImage:[UIImage imageNamed:@"user.jpg"]];
        //last
    }
    if (![Util isNullValue:[ven.info coverCharges]])
    {
        self.lblCoverCharges.text = [NSString stringWithFormat:@"$%@",[ven.info coverCharges]];

    }
    if (![Util isNullValue:[ven.info fastlineCharges]])
    {
        self.lblCulLineCost.text = [NSString stringWithFormat:@"$%@",[ven.info fastlineCharges]];
        
    }
    
}
@end
