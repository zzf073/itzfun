//
//  EventCell.m
//  MobileNight
//

#import "EventCell.h"

@implementation EventCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCell:(Event *)event with:(NSIndexPath *)indexPath
{
    self.lblTitle.text = event.eventName;
    self.lblTime.text = event.eventTime;
    self.lblDJ.text = [event.performer valueForKey:@"performerName"];
    self.lblEventType.text = event.eventType;
      //date formatter that you want
    NSDateFormatter *dateFormatterNew = [[NSDateFormatter alloc] init];
    [dateFormatterNew setDateFormat:@"MMM dd, yyyy"];
    NSString *stringForNewDate = [dateFormatterNew stringFromDate:event.startDate];
    
    NSString *Date = [NSString stringWithFormat:@"%@",stringForNewDate];
    self.lblDate.text = Date;
}

@end
