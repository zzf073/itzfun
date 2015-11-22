//
//  Util.m
//  MobileNight
//
//  Created by Anand Patel on 09/07/15.
//  Copyright (c) 2015 Anand Patel. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (BOOL)isNullValue:(NSString *)string {
    if (string == nil || string == (id)[NSNull null] ||[string isKindOfClass:[NSNull class]] ||[string isEqualToString:@"<null>"]||[string isEqualToString:@"(null)"]||string.length==0 || [string isEqualToString:@"null"] || [string isEqualToString:@"N/A"])
    {
        return YES;
    }
    return NO;
}

@end
