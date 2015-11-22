//
//  Event.h
//  MobileNight
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (nonatomic,assign) int       eventId;
@property (nonatomic,retain) NSString *href;
@property (nonatomic,retain) NSString *eventName;
@property (nonatomic,retain) NSString *eventType;
@property (nonatomic,retain) NSString *eventTime;
@property (nonatomic,retain) NSString *durationInMinutes;
@property (nonatomic,retain) NSString *performanceGroup;
@property (nonatomic,retain) NSString *performer;
@property (nonatomic,retain) NSDate *startDate;
@property (nonatomic,retain) NSDate *endDate;
@property (nonatomic,retain) NSString *eventDescription;
@property (nonatomic,retain) NSString *imageURL;

+ (NSArray *)getEvents:(NSDictionary *)dictResponse;

@end
