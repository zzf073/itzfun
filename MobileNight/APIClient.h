//
//  APIClient.h
//  MobileNight
//

#import <Foundation/Foundation.h>

typedef void (^APICompletionBlock)(NSDictionary *response, NSError *error);
typedef void (^APIResultBlock)(BOOL SUCCESS ,NSError *error);


@interface APIClient : NSObject

+ (void)getNotificationsWithVenueId:(NSString *)venueId withRoleCode:(NSString *)roleCode with:(APICompletionBlock)completionBlock;

+ (void)getVenues:(APICompletionBlock)completionBlock;
+ (void)getStates:(APICompletionBlock)completionBlock;
+ (void)getCites:(APICompletionBlock)completionBlock;
+ (void)getSensors:(APICompletionBlock)completionBlock;
+ (void)getSensorsByVenueId:(int)venueId with:(APICompletionBlock)completionBlock;
+ (void)getVenuesByCity:(NSDictionary*)params with:(APICompletionBlock)completionBlock;
+ (void)getVenuesByQuery:(NSDictionary *)dictParams with:(APICompletionBlock)completionBlock;
+ (void)getVenueDetailById:(int)venueId with:(APICompletionBlock)completionBlock;
+ (void)getEventsByVenueId:(int)venueId with:(APICompletionBlock)completionBlock;
+ (void)getEventsByType:(NSString *)eventType with:(APICompletionBlock)completionBlock;
+ (void)getEventsByType:(NSString *)eventType withQuery:(NSString *)query with:(APICompletionBlock)completionBlock;


+ (void)loginWith:(NSDictionary *)parameters with:(APICompletionBlock)completionBlock;

+ (void)signUpWithEmail:(NSString *)email withFirstName:(NSString *)firstName withLastName:(NSString *)lastName with:(APICompletionBlock )completionBlock;
+ (void)forgotPassword:(NSString *)email with:(APICompletionBlock)completionBlock;
+ (void)changePassword:(NSDictionary *)parameters with:(APICompletionBlock)completionBlock;

+ (void)signupUserViaFB:(NSString *)fbId with:(APICompletionBlock)completionBlock;
+ (void)createVisitor:(NSDictionary *)parameters with:(APICompletionBlock)completionBlock;
+ (void)updateVenueInfo:(NSDictionary *)parameters with:(APICompletionBlock)completionBlock;

+ (void)getVenueRatingAndReviewsWithVenueName:(NSString *)venueName withLatitude:(NSString *)latitude withLongitude:(NSString *)longitude  with:(APICompletionBlock)completionBlock;

+ (void)orderServiceWithParameter:(NSDictionary *)parameter withVenueId:(NSString *)venueId with:(APICompletionBlock)completionBlock;
+ (void) processServiceWithParameter:dictParams forVenue: (NSInteger)venueNumber  forNotification:(NSInteger) notificationId with:(APICompletionBlock)completionBlock;

@end
