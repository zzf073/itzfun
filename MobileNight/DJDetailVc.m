//
//  DJDetailVc.m
//  MobileNight
//
//  Created by Anand Patel on 23/06/15.
//  Copyright (c) 2015 Anand Patel. All rights reserved.
//

#import "DJDetailVc.h"
#import "EventDetailVC.h"

@implementation DJDetailVc
@synthesize PerformerDetail;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *perfromerDescription = [[PerformerDetail valueForKey:@"performer"] valueForKey:@"description"];
    NSString *performerVideoUrl = [[PerformerDetail valueForKey:@"performer"] valueForKey:@"performanceURL"];
    NSString *performerName = [[PerformerDetail valueForKey:@"performer"] valueForKey:@"performerName"];
    NSString *performerImageUrl = [[PerformerDetail valueForKey:@"performer"] valueForKey:@"imageURL"];
    
    
    self.performerName.text = performerName;
    
    self.performerDescription.text = perfromerDescription;
    
    
    NSString *EventDate = [PerformerDetail valueForKey:@"startDate"];
    NSDateFormatter *dateFormatterNew = [[NSDateFormatter alloc] init];
    [dateFormatterNew setDateFormat:@"MMM dd, yyyy"];
    NSString *stringForNewDate = EventDate;
    NSString *Date = [NSString stringWithFormat:@"%@",stringForNewDate];

    self.eventTime.text = [PerformerDetail valueForKey:@"eventTime"];
    self.eventDate.text = Date;
    self.eventAddress.text = @"";
    

    if (![Util isNullValue:performerImageUrl])
    {
        NSURL *url = [NSURL URLWithString:performerImageUrl];
        [self.performerPhoto sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
        
    } else {
        [self.performerPhoto setImage:[UIImage imageNamed:@"user.jpg"]];
    }

    
    
    //NSString *fileUrl = [[NSBundle mainBundle] pathForResource:@"Movie" ofType:@"m4v"];
    //NSURL *movieURL = [NSURL fileURLWithPath:fileUrl];
    NSURL *movieURL = [NSURL URLWithString:performerVideoUrl];
    player = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    player.view.frame = CGRectMake(0, 0, self.vwPlayer.frame.size.width, self.vwPlayer.frame.size.height);
  //  [player.view setTranslatesAutoresizingMaskIntoConstraints:NO];
   // player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //player.controlStyle = MPMovieControlStyleFullscreen;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doneButtonClick:)
                                                 name:MPMoviePlayerWillExitFullscreenNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didEnterFullScreen:)
                                                 name:MPMoviePlayerDidEnterFullscreenNotification
                                               object:nil];
    
    
    [self.vwPlayer addSubview:player.view];

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    player.view.frame = CGRectMake(0, 0, self.vwPlayer.frame.size.width, self.vwPlayer.frame.size.height);

    [player prepareToPlay];
    [player play];
}
- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)didEnterFullScreen:(NSNotification*)aNotification {
    [kAPP_DELEGATE setIsFullScreen:YES];
}

-(void)doneButtonClick:(NSNotification*)aNotification{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [kAPP_DELEGATE setIsFullScreen:NO];

    });

    NSNumber *reason = [aNotification.userInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    if ([reason intValue] == MPMovieFinishReasonUserExited) {
        // Your done button action here
    }
}@end
