//
//  SMRotaryWheel.m
//  RotaryWheelProject
//
//  Created by cesarerocchi on 2/10/12.
//  Copyright (c) 2012 studiomagnolia.com. All rights reserved.

#import <UIKit/UIKit.h>
#import "SMClove.h"

@interface HPieChartView : UIView 

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) NSMutableArray *cloves;
@property CGAffineTransform startTransform;
@property CGPoint wheelCenter;
@property (nonatomic ,retain) NSMutableArray * pie;

- (id) initWithFrame:(CGRect)frame withNum:(int)num withArray:(NSMutableArray *)array;
- (void) initWheel;
- (void) buildClovesOdd;
- (float) calculateDistanceFromCenter:(CGPoint)point;


@end
