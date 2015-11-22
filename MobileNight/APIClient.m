//
//  APIClient.m
//  MobileNight
//

#import "APIClient.h"

@implementation APIClient

+ (void)getNotificationsWithVenueId:(NSString *)venueId withRoleCode:(NSString *)roleCode with:(APICompletionBlock)completionBlock
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"venue/services/notifications/%@/%@/active",venueId,roleCode] relativeToURL:kBASE_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self callAPI:request with:completionBlock];
}

+ (void)getVenues:(APICompletionBlock)completionBlock {//OK
    //http://54.67.118.119:8280/WebServices/mobin/venue/services/venues
    NSURL *url = [NSURL URLWithString:@"venue/services/venues" relativeToURL:kBASE_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self callAPI:request with:completionBlock];
    
}
+ (void)getVenuesByCity:(NSDictionary*)params with:(APICompletionBlock)completionBlock {//OK
    //http://54.67.118.119:8280/WebServices/mobin/venue/services/venues
    NSString* url = @"venue/services/venues";
   
    if ([@"city" caseInsensitiveCompare:[params valueForKey:@"type"] ] == NSOrderedSame) {
        NSString *strParam =[NSString stringWithFormat:@"state=%@&city=%@",[params valueForKey:@"state"], [[params valueForKey:@"name"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
        url = [NSString stringWithFormat:@"venue/services/venues/q?%@",strParam];
    }
    NSURL *nsURL = [NSURL URLWithString:url relativeToURL:kBASE_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:nsURL];
    [self callAPI:request with:completionBlock];
    
}
+ (void)getStates:(APICompletionBlock)completionBlock {
    NSURL *url = [NSURL URLWithString:@"venue/services/states" relativeToURL:kBASE_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self callAPI:request with:completionBlock];
}


+ (void)getCites:(APICompletionBlock)completionBlock {
    NSURL *url = [NSURL URLWithString:@"venue/services/venues/cities" relativeToURL:kBASE_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self callAPI:request with:completionBlock];
}
+ (void)getSensors:(APICompletionBlock)completionBlock {
    NSURL *url = [NSURL URLWithString:@"venue/services/sensors" relativeToURL:kBASE_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self callAPI:request with:completionBlock];
}
+ (void)getSensorsByVenueId:(int)venueId with:(APICompletionBlock)completionBlock {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"venue/services/venues/%d/sensors",venueId] relativeToURL:kBASE_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self callAPI:request with:completionBlock];
}

+ (void)getVenuesByQuery:(NSDictionary *)dictParams with:(APICompletionBlock)completionBlock {
    
    NSString *strParam =[NSString stringWithFormat:@"lat=%f&long=%f&dist=%d",[[dictParams valueForKey:@"lat"] doubleValue],[[dictParams valueForKey:@"long"] doubleValue],kDISTANCE];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"venue/services/venues/q?%@",strParam] relativeToURL:kBASE_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self callAPI:request with:completionBlock];
}

+ (void)getVenueDetailById:(int)venueId with:(APICompletionBlock)completionBlock {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"venue/services/venues/%d/info",venueId] relativeToURL:kBASE_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self callAPI:request with:completionBlock];
}

+ (void)getEventsByVenueId:(int)venueId with:(APICompletionBlock)completionBlock {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"venue/services/venues/%d/events",venueId] relativeToURL:kBASE_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self callAPI:request with:completionBlock];
}
+ (void)getEventsByType:(NSString *)eventType with:(APICompletionBlock)completionBlock {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"venue/services/venueevents/%@",eventType] relativeToURL:kBASE_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self callAPI:request with:completionBlock];
}
+ (void)getEventsByType:(NSString *)eventType withQuery:(NSString *)query with:(APICompletionBlock)completionBlock {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"venue/services/venueevents/%@?q=%@",eventType,query] relativeToURL:kBASE_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self callAPI:request with:completionBlock];
}
+ (void)callAPI:(NSURLRequest *)request with:(APICompletionBlock)completionBlock {
    NSLog(@"request = %@", request);
   NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSError *parseError;
        if (error == nil) {
            NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parseError];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"response = %@",dictResponse);
                completionBlock(dictResponse,error);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil,error);
            });
        }
    }];
    [task resume];
}

+ (void)loginWith:(NSDictionary *)parameters with:(APICompletionBlock)completionBlock {
    NSURL *url = [NSURL URLWithString:@"venue/services/auth/login" relativeToURL:kBASE_URL];
    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
   
//    NSString *loginId = [parameters valueForKey:@"loginId"];
//    NSString *password = [parameters valueForKey:@"password"];
//    NSString *loginType = [parameters valueForKey:@"loginType"];
//
//    NSString *postString = [NSString stringWithFormat:@"loginId=%@&password=%@&loginType=%@",loginId,password,loginType];
//    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];

    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:jsondata];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsondata length]] forHTTPHeaderField:@"Content-Length"];
    [self callAPI:request with:completionBlock];
}

+ (void)signUpWithEmail:(NSString *)email withFirstName:(NSString *)firstName withLastName:(NSString *)lastName with:(APICompletionBlock )completionBlock {
    NSURL *url = [NSURL URLWithString:@"signup" relativeToURL:kBASE_URL];
    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *postString = [NSString stringWithFormat:@"email=%@&firstName=%@,&lastName=%@",email,firstName,lastName];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [self callAPI:request with:completionBlock];
}

+ (void)forgotPassword:(NSString *)email with:(APICompletionBlock)completionBlock {
    NSURL *url = [NSURL URLWithString:@"forgotPassword" relativeToURL:kBASE_URL];
    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *postString = [NSString stringWithFormat:@"email=%@",email];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [self callAPI:request with:completionBlock];
}

+ (void)changePassword:(NSDictionary *)parameters with:(APICompletionBlock)completionBlock {
    
}

+ (void)signupUserViaFB:(NSString *)fbId with:(APICompletionBlock)completionBlock {
    NSURL *url = [NSURL URLWithString:@"fbLogin" relativeToURL:kBASE_URL];
    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *postString = [NSString stringWithFormat:@"fbId=%@",fbId];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [self callAPI:request with:completionBlock];
}

+ (void)createVisitor:(NSDictionary *)parameters with:(APICompletionBlock)completionBlock {
    
    NSURL *url = [NSURL URLWithString:@"venue/services/visitors" relativeToURL:kBASE_URL];
    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody:jsondata];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsondata length]] forHTTPHeaderField:@"Content-Length"];
    
    [self callAPI:request with:completionBlock];
}

/* Old Method
+ (void)updateVenueInfo:(NSDictionary *)parameters with:(APICompletionBlock)completionBlock {
    
    NSMutableDictionary *mdictParams = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [mdictParams removeObjectForKey:@"venueId"];
    
    NSString *queryString = [mdictParams urlEncodedString];
    NSData *postData = [queryString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];


    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"venue/services/venueadm/%@/info",[parameters valueForKey:@"venueId"]] relativeToURL:kBASE_URL];
    
    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];

    [self callAPI:request with:completionBlock];
    
    
    
   // NSData *jsondata = [NSJSONSerialization dataWithJSONObject:mdictParams options:NSJSONWritingPrettyPrinted error:nil];
    
   // [request setHTTPBody:jsondata];
    //[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsondata length]] forHTTPHeaderField:@"Content-Length"];
    
}
*/

//below is the new method
+ (void)updateVenueInfo:(NSDictionary *)parameters with:(APICompletionBlock)completionBlock
{
    NSMutableDictionary *mdictParams = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [mdictParams removeObjectForKey:@"venueId"];
   
    //NSData *postData = [queryString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"venue/services/venueadm/%@/info",[parameters valueForKey:@"venueId"]] relativeToURL:kBASE_URL];
    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:url];
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:mdictParams options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsondata];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsondata length]] forHTTPHeaderField:@"Content-Length"];
    // [request setHTTPBody:postData];
    [self callAPI:request with:completionBlock];
}


+ (void)getVenueRatingAndReviewsWithVenueName:(NSString *)venueName withLatitude:(NSString *)latitude withLongitude:(NSString *)longitude  with:(APICompletionBlock)completionBlock
{
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.yelp.com/v2/search?term=%@&ll=%@,%@",venueName,latitude,longitude];
    
    NSString *escapedUrlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *aUrl = [NSURL URLWithString:escapedUrlString];

    NSURLRequest *request = [NSURLRequest requestWithURL:aUrl];
    [self callAPI:request with:completionBlock];
}


+ (void)orderServiceWithParameter:(NSDictionary *)parameter withVenueId:(NSString *)venueId with:(APICompletionBlock)completionBlock
{
    
    if([kAPP_DELEGATE isLogin])
    {
        Visitor* visitor = [kAPP_DELEGATE visitor];
        
        NSMutableDictionary *mdictParams = [NSMutableDictionary dictionaryWithDictionary:parameter];
        [mdictParams setValue:venueId forKey:@"venueNumber"];
    //NSString *queryString = [mdictParams urlEncodedString];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"venue/services/visitors/%ld/service",visitor.userId] relativeToURL:kBASE_URL];
        NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:url];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:mdictParams options:NSJSONWritingPrettyPrinted error:nil];
        request.HTTPMethod = @"POST";
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:visitor.sessionId forHTTPHeaderField:@"X-XSRF-TOKEN"];
        [request setHTTPBody:jsondata];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsondata length]] forHTTPHeaderField:@"Content-Length"];
        [self callAPI:request with:completionBlock];
    }
    
}
+ (void) processServiceWithParameter:dictParams forVenue: (NSInteger)venueNumber forNotification:(NSInteger) notificationId with:(APICompletionBlock)completionBlock
{
    if([[kAPP_DELEGATE visitor] isAdmin])
    {
        Visitor* visitor = [kAPP_DELEGATE visitor];
        
        NSMutableDictionary *mdictParams = [NSMutableDictionary dictionaryWithDictionary:dictParams];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"venue/services/notifications/%ld/%ld",venueNumber, notificationId] relativeToURL:kBASE_URL];
        NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:url];
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:mdictParams options:NSJSONWritingPrettyPrinted error:nil];
        request.HTTPMethod = @"POST";
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:visitor.sessionId forHTTPHeaderField:@"X-XSRF-TOKEN"];
        [request setHTTPBody:jsondata];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsondata length]] forHTTPHeaderField:@"Content-Length"];
        [self callAPI:request with:completionBlock];
    }

}
@end
