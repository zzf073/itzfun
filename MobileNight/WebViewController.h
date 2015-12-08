//
//  WebViewController.h
//  MobileNight
//
//  Created by Swayam on 08/12/15.
//  Copyright (c) 2015 Anand Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : HeaderVC <UIWebViewDelegate>
{
    IBOutlet UIWebView *webviewLink;
}

@property (nonatomic,strong)NSString *strLink;

@end