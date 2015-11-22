//
//  VenueInfo.m
//  MobileNight
//

#import "VenueInfo.h"

@implementation VenueInfo


+ (VenueInfo *)getVenueInfo:(NSDictionary *)dictVenue {
    
    VenueInfo *ven      = [[VenueInfo alloc] init];
    ven.href            = [dictVenue valueForKey:@"href"];
    ven.male            = [NSString stringWithFormat:@"%@", [dictVenue valueForKey:@"male"]];
    ven.female          = [NSString stringWithFormat:@"%@", [dictVenue valueForKey:@"female"]];
    ven.kids            = [NSString stringWithFormat:@"%@", [dictVenue valueForKey:@"kids"]];
    ven.maleRatio       = [NSString stringWithFormat:@"%@", [dictVenue valueForKey:@"male-ratio"]];
    ven.femaleRatio     = [NSString stringWithFormat:@"%@", [dictVenue valueForKey:@"female-ratio"]];
    ven.waitTime        = [NSString stringWithFormat:@"%@", [dictVenue valueForKey:@"wait-time"]];
    ven.waitTimeUnit    = [dictVenue valueForKey:@"wait-time-unit"];
    ven.coverCharges    = [dictVenue valueForKey:@"cover-charges"];
    ven.fastlineCharges = [dictVenue valueForKey:@"fastline-charges"];
    ven.priceUnit       = [dictVenue valueForKey:@"price-unit"];
    ven.availableTables = [dictVenue valueForKey:@"available-tables"];
    ven.pricePerTable   = [dictVenue valueForKey:@"price-per-table"];
    
    return ven;
}

@end
