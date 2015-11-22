//
//  FooterView.h
//  MobileNight
//
//  Created by Anand Patel on 10/07/15.
//  Copyright (c) 2015 Anand Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FooterView : UIView

@property (nonatomic, retain) IBOutlet UIView *tab1;
@property (nonatomic, retain) IBOutlet UIView *tab2;
@property (nonatomic, retain) IBOutlet UIView *tab3;
@property (nonatomic, retain) IBOutlet UIView *tab4;
@property (nonatomic, retain) IBOutlet UIView *tab5;

@property (nonatomic, retain) IBOutlet UIImageView *imgTabIcon1;
@property (nonatomic, retain) IBOutlet UIImageView *imgTabIcon2;
@property (nonatomic, retain) IBOutlet UIImageView *imgTabIcon3;
@property (nonatomic, retain) IBOutlet UIImageView *imgTabIcon4;
@property (nonatomic, retain) IBOutlet UIImageView *imgTabIcon5;


@property (nonatomic, retain) IBOutlet UIImageView *imgTabText1;
@property (nonatomic, retain) IBOutlet UIImageView *imgTabText2;
@property (nonatomic, retain) IBOutlet UIImageView *imgTabText3;
@property (nonatomic, retain) IBOutlet UIImageView *imgTabText4;
@property (nonatomic, retain) IBOutlet UIImageView *imgTabText5;

@property (nonatomic, retain) IBOutlet UILabel *lblTab1;
@property (nonatomic, retain) IBOutlet UILabel *lblTab2;
@property (nonatomic, retain) IBOutlet UILabel *lblTab3;
@property (nonatomic, retain) IBOutlet UILabel *lblTab4;
@property (nonatomic, retain) IBOutlet UILabel *lblTab5;



- (void)setImages;





@end
