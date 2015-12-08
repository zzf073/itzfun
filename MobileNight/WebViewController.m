//
//  WebViewController.m
//  MobileNight
//
//  Created by Swayam on 08/12/15.
//  Copyright (c) 2015 Anand Patel. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController
@synthesize strLink;

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (strLink.length!=0)
    {
        [kAPP_DELEGATE ShowLoader];
        NSURL *targetURL=[[NSURL alloc]initWithString:strLink];
        NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
        webviewLink.scalesPageToFit = YES;
        [webviewLink loadRequest:request];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    [kAPP_DELEGATE stopLoader];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
{
    [kAPP_DELEGATE stopLoader];
}

-(IBAction)clickBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end