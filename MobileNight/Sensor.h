//
//  Sensor.h
//  MobileNight
//

#import <Foundation/Foundation.h>

@interface Sensor : NSObject

@property (nonatomic,assign) int sensorId;
@property (nonatomic,assign) int major;
@property (nonatomic,assign) int minor;
@property (nonatomic,assign) int venueNumber;


@property (nonatomic,retain) NSString *href;
@property (nonatomic,retain) NSString *sensorName;
@property (nonatomic,retain) NSString *sectionName;
@property (nonatomic,retain) NSString *aisleName;
@property (nonatomic,retain) NSString *udid;
@property (nonatomic,retain) NSString *enabled;
@property (nonatomic,retain) NSString *sensorDescription;

+ (NSArray *)getSensors:(NSDictionary *)dictResponse;


@end
