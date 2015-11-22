//
//  Visitor.h
//  MobileNight
//
//  Created by Anand Patel on 23/06/15.
//  Copyright (c) 2015 Anand Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Visitor : NSObject
@property (nonatomic,retain) NSString *loginId;
@property (nonatomic,retain) NSString *role;
@property (nonatomic,retain) NSString *sessionId;
@property (nonatomic,retain) NSString *userName;
@property (nonatomic) NSInteger userId;
@property (nonatomic, getter=isActive) BOOL active;

+ (Visitor*) getVisitor:(NSDictionary*) data;
-(BOOL) isAdmin;
@end
