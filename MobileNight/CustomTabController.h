//
//  CustomTabController.h
//  MobileNight
//
//  Created by Anand Patel on 10/07/15.
//  Copyright (c) 2015 Anand Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHCustomTabBarController.h"
#import "FooterView.h"
#import "RNFrostedSidebar.h"

@interface CustomTabController : MHCustomTabBarController<RNFrostedSidebarDelegate>

@property (nonatomic, retain) IBOutlet FooterView *footerView;

@end
