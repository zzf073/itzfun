//
//  Sensor.m
//  MobileNight
//

#import "Sensor.h"

@implementation Sensor

@synthesize sensorId;
@synthesize venueNumber;
@synthesize major;
@synthesize minor;
@synthesize href;
@synthesize sensorName;
@synthesize sectionName;
@synthesize aisleName;
@synthesize udid;
@synthesize enabled;
@synthesize sensorDescription;

+ (NSArray *)getSensors:(NSDictionary *)dictResponse {
    NSMutableArray *marrSensors= [NSMutableArray array];
    NSArray *arrSensors= [dictResponse valueForKey:@"sensors"];
    for (int i=0; i<arrSensors.count; i++) {;
        [marrSensors addObject:[self getSensor:[arrSensors objectAtIndex:i]]];
    }
    return marrSensors;
}
+ (Sensor *)getSensor:(NSDictionary *)dictSensor {
    Sensor *sen             = [[Sensor alloc] init];
    sen.sensorId            = [[dictSensor valueForKey:@"id"] intValue];
    sen.venueNumber         = [[dictSensor valueForKey:@"venueNumber"] intValue];
    sen.major               = [[dictSensor valueForKey:@"major"] intValue];
    sen.minor               = [[dictSensor valueForKey:@"minor"] intValue];
    sen.sensorName          = [dictSensor valueForKey:@"sensorName"];
    sen.sectionName         = [dictSensor valueForKey:@"sectionName"];
    sen.aisleName           = [dictSensor valueForKey:@"aisleName"];
    sen.udid                = [dictSensor valueForKey:@"udid"];
    sen.enabled             = [dictSensor valueForKey:@"enabled"];
    sen.sensorDescription   = [dictSensor valueForKey:@"description"];
    sen.href                = [dictSensor valueForKey:@"href"];
    return sen;
}

@end
