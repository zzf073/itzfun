//
//  Visitor.m
//  MobileNight
//
//  Created by Anand Patel on 23/06/15.
//  Copyright (c) 2015 Anand Patel. All rights reserved.
//

#import "Visitor.h"

@implementation Visitor

+ (Visitor*) getVisitor:(NSDictionary *)data
{
    Visitor* visitor = [[Visitor alloc] init];
    if (visitor){
        visitor.active = [[data valueForKey:@"active"] boolValue];
        visitor.loginId = [data valueForKey:@"loginId"];
        visitor.role = [data valueForKey:@"role"];
        visitor.sessionId = [data valueForKey:@"sessionId"];
        visitor.userName = [data valueForKey:@"userName"];
        visitor.userId = [[data valueForKey:@"userId"] integerValue];
    }
    return visitor;
}

- (BOOL) isAdmin
{
    return [@"admin" caseInsensitiveCompare:self.role] == NSOrderedSame;
}
@end
