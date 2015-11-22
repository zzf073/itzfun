//
//  VenueInfo.h
//  MobileNight
//

#import <Foundation/Foundation.h>

@interface VenueInfo : NSObject

@property (nonatomic,retain) NSString *href;
@property (nonatomic,retain) NSString *male;
@property (nonatomic,retain) NSString *female;
@property (nonatomic,retain) NSString *kids;
@property (nonatomic,retain) NSString *maleRatio;
@property (nonatomic,retain) NSString *femaleRatio;
@property (nonatomic,retain) NSString *waitTime;
@property (nonatomic,retain) NSString *waitTimeUnit;
@property (nonatomic,retain) NSString *coverCharges;
@property (nonatomic,retain) NSString *fastlineCharges;
@property (nonatomic,retain) NSString *priceUnit;
@property (nonatomic,retain) NSString *availableTables;
@property (nonatomic,retain) NSString *pricePerTable;



+ (VenueInfo *)getVenueInfo:(NSDictionary *)dictResponse;
@end
