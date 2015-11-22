//
//  FooterView.m
//  MobileNight
//
//  Created by Anand Patel on 10/07/15.
//  Copyright (c) 2015 Anand Patel. All rights reserved.
//

#import "FooterView.h"

@implementation FooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
       
        
        [self setImages];
        
        
    }
    return self;
}
- (void)setImages {
    UIImage * image;
    
    image = [UIImage imageNamed:@"home-icon.png"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.imgTabIcon1 setImage:image];
    image = [UIImage imageNamed:@"home.png"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.imgTabText1 setImage:image];
    
    image = [UIImage imageNamed:@"venue-icon.png"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.imgTabIcon2 setImage:image];
    image = [UIImage imageNamed:@"venues.png"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.imgTabText2 setImage:image];
    
    
    image = [UIImage imageNamed:@"event-icon.png"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.imgTabIcon3 setImage:image];
    image = [UIImage imageNamed:@"events.png"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.imgTabText3 setImage:image];
    
    
    image = [UIImage imageNamed:@"setting-icon.png"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.imgTabIcon4 setImage:image];
    image = [UIImage imageNamed:@"settings.png"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.imgTabText4 setImage:image];
    
    
    image = [UIImage imageNamed:@"reward-icon.png"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.imgTabIcon5 setImage:image];
    image = [UIImage imageNamed:@"vip.png"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.imgTabText5 setImage:image];
}
@end
