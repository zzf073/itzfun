//
//  Event.m
//  MobileNight
//

#import "Event.h"

@implementation Event


+ (NSArray *)getEvents:(NSDictionary *)dictResponse {
    
    NSMutableArray *marrEvents = [NSMutableArray array];
    NSArray *arrEnents = [dictResponse valueForKey:@"venue-events"];
    
    for (int i=0; i<arrEnents.count; i++) {
        [marrEvents addObject:[self getEvent:[arrEnents objectAtIndex:i]]];
    }
    return marrEvents;
}

+ (Event *)getEvent:(NSDictionary *)dictResponse {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
     NSLog(@"Response: %@",dictResponse);
    Event *event = [[Event alloc] init];
    event.eventId = [[dictResponse valueForKey:@"id"] intValue];
    event.href = [dictResponse valueForKey:@"href"];
    event.eventName = [dictResponse valueForKey:@"eventName"];
    event.eventType = [dictResponse valueForKey:@"eventType"];
    event.eventTime = [dictResponse valueForKey:@"eventTime"];
    event.performanceGroup = [dictResponse valueForKey:@"performance-group"];
    event.performer = [dictResponse valueForKey:@"performer"];
    event.startDate = [formatter dateFromString:[dictResponse valueForKey:@"startDate"]];
    event.endDate = [formatter dateFromString:[dictResponse valueForKey:@"endDate"]];
    event.eventDescription = [dictResponse valueForKey:@"description"];
    event.imageURL = [dictResponse valueForKey:@"imageURL"];
    
    NSLog(@"EVENT DATE: %@",event.startDate);
    NSLog(@"TIME : %@",event.eventTime);
    
    return event;
}

@end
