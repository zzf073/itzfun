//
//  Venue.h
//  MobileNight
//

#import <Foundation/Foundation.h>
#import "VenueInfo.h"

@interface Venue : NSObject

@property (nonatomic,assign) int venueId;
@property (nonatomic,assign) double latitude;
@property (nonatomic,assign) double longitude;
@property (nonatomic,assign) int venueNumber;

@property (nonatomic,retain) NSString *href;
@property (nonatomic,retain) NSString *venueName;
@property (nonatomic,retain) NSString *managerName;
@property (nonatomic,retain) NSString *address;
@property (nonatomic,retain) NSString *city;
@property (nonatomic,retain) NSString *state;
@property (nonatomic,retain) NSString *country;
@property (nonatomic,retain) NSString *zip;
@property (nonatomic,retain) NSString *phone;
@property (nonatomic,retain) NSString *mobile;
@property (nonatomic,retain) NSString *email;
@property (nonatomic,retain) NSString *website;
@property (nonatomic,retain) NSString *enabled;
@property (nonatomic,retain) NSString *venueType;
@property (nonatomic,retain) NSString *venueDescription;
@property (nonatomic,retain) NSString *imageURL;
@property (nonatomic,retain) VenueInfo *info;

+ (NSArray *)getVenues:(NSDictionary *)dictResponse;
@end
