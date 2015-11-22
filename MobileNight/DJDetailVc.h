//
//  DJDetailVc.h
//  MobileNight
//
//  Created by Anand Patel on 23/06/15.
//  Copyright (c) 2015 Anand Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderVC.h"
#import <MediaPlayer/MediaPlayer.h>

@interface DJDetailVc : HeaderVC {
    MPMoviePlayerController *player;
    NSTimer *playbackTimer;
}
@property (nonatomic, retain) IBOutlet UIView *vwPlayer;
@property (nonatomic, retain) NSDictionary *PerformerDetail;

@property (nonatomic, retain) IBOutlet UILabel *performerName;
@property (nonatomic, retain) IBOutlet UILabel *performerDescription;
@property (nonatomic, retain) IBOutlet UIImageView *performerPhoto;
@property (nonatomic, retain) IBOutlet UILabel *eventTime;
@property (nonatomic, retain) IBOutlet UILabel *eventDate;
@property (nonatomic, retain) IBOutlet UILabel *eventAddress;

@end
