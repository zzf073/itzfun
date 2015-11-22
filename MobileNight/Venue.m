//
//  Venue.m
//  MobileNight
//

#import "Venue.h"


@implementation Venue



+ (NSArray *)getVenues:(NSDictionary *)dictResponse {
    NSMutableArray *marrVenues = [NSMutableArray array];
    NSArray *arrVenues = [dictResponse valueForKey:@"venues"];
    
    for (int i=0; i<arrVenues.count; i++) {;
        [marrVenues addObject:[self getVenue:[arrVenues objectAtIndex:i]]];
    }
    return marrVenues;
}
+ (Venue *)getVenue:(NSDictionary *)dictVenue {
    
    Venue *ven          = [[Venue alloc] init];
    ven.venueId         = [[dictVenue valueForKey:@"id"] intValue];
    ven.latitude        = [[dictVenue valueForKey:@"latitude"] doubleValue];
    ven.longitude       = [[dictVenue valueForKey:@"longitude"] doubleValue];
    ven.venueNumber     = [[dictVenue valueForKey:@"venueNumber"] intValue];
    
    ven.href            = [dictVenue valueForKey:@"href"];
    ven.venueName       = [dictVenue valueForKey:@"venueName"];
    ven.managerName     = [dictVenue valueForKey:@"managerName"];
    ven.address         = [dictVenue valueForKey:@"address"];
    ven.city            = [dictVenue valueForKey:@"city"];
    ven.state           = [dictVenue valueForKey:@"state"];
    ven.country         = [dictVenue valueForKey:@"country"];
    ven.zip             = [dictVenue valueForKey:@"zip"];
    ven.phone           = [dictVenue valueForKey:@"phone"];
    ven.mobile          = [dictVenue valueForKey:@"mobile"];
    ven.email           = [dictVenue valueForKey:@"email"];
    ven.website         = [dictVenue valueForKey:@"website"];
    ven.enabled         = [dictVenue valueForKey:@"enabled"];
    ven.venueType       = [dictVenue valueForKey:@"venueType"];
    ven.imageURL        = [NSString stringWithFormat:@"%@",[dictVenue valueForKey:@"imageURL"]];
    ven.venueDescription = [dictVenue valueForKey:@"description"];
    NSDictionary* info = [dictVenue valueForKey:@"info"];
    if (info) {
        ven.info = [VenueInfo getVenueInfo:info];
    }
    return ven;
}


@end
