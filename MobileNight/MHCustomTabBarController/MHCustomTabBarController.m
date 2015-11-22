/*
 * Copyright (c) 2015 Martin Hartl
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "MHCustomTabBarController.h"
#import "MHTabBarSegue.h"
#import "ViewController.h"
#import "MapDisplayVC.h"

NSString *const MHCustomTabBarControllerViewControllerChangedNotification = @"MHCustomTabBarControllerViewControllerChangedNotification";
NSString *const MHCustomTabBarControllerViewControllerAlreadyVisibleNotification = @"MHCustomTabBarControllerViewControllerAlreadyVisibleNotification";

@interface MHCustomTabBarController ()

@property (nonatomic, strong) NSMutableDictionary *viewControllersByIdentifier;
@property (strong, nonatomic) NSString *destinationIdentifier;

@end

@implementation MHCustomTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewControllersByIdentifier = [NSMutableDictionary dictionary];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
      if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
          
          //[self performSegueWithIdentifier:@"viewController2" sender:[self.buttons objectAtIndex:1]];
          
          MapDisplayVC *vc = [[MapDisplayVC alloc]initWithNibName:@"MapDisplayVC" bundle:nil];
          UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
          [self.navigationController pushViewController:nav animated:YES];

      } else {
          //[self performSegueWithIdentifier:@"viewController1" sender:[self.buttons objectAtIndex:0]];

          ViewController *vc = [[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
          UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
          [self.navigationController pushViewController:nav animated:YES];
      }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    self.destinationViewController.view.frame = self.container.bounds;
}



#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    if ([kAPP_DELEGATE isFullScreen]) {
        return;
    }
    if (![segue isKindOfClass:[MHTabBarSegue class]]) {
        [super prepareForSegue:segue sender:sender];
        return;
    }
    if (self.childViewControllers.count > 0) {
        [[self.childViewControllers objectAtIndex:0] dismissViewControllerAnimated:NO completion:nil];
       
        [[self.childViewControllers objectAtIndex:0] popToRootViewControllerAnimated:NO];
    }
    self.oldViewController = self.destinationViewController;
    
    //if view controller isn't already contained in the viewControllers-Dictionary
    if (![self.viewControllersByIdentifier objectForKey:segue.identifier]) {
        [self.viewControllersByIdentifier setObject:segue.destinationViewController forKey:segue.identifier];
    }
    [self.buttons setValue:@NO forKeyPath:@"selected"];
    [sender setSelected:YES];
    self.selectedIndex = [self.buttons indexOfObject:sender];
    
    if(self.selectedIndex == 3)
    {
        if (![kAPP_DELEGATE isLogin])
        {
            NSLog(@"LOG: %@",[(UINavigationController *)self.oldViewController topViewController]);
        }
    }
    
    NSLog(@"Outside LOG: %@",[(UINavigationController *)self.destinationViewController topViewController]);
    
    self.destinationIdentifier = segue.identifier;
    self.destinationViewController = [self.viewControllersByIdentifier objectForKey:self.destinationIdentifier];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MHCustomTabBarControllerViewControllerChangedNotification object:nil]; 
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([self.destinationIdentifier isEqual:identifier]) {
        //Dont perform segue, if visible ViewController is already the destination ViewController
        [[NSNotificationCenter defaultCenter] postNotificationName:MHCustomTabBarControllerViewControllerAlreadyVisibleNotification object:nil];
        return NO;
    }
    
    return YES;
}

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [[self.viewControllersByIdentifier allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        if (![self.destinationIdentifier isEqualToString:key]) {
            [self.viewControllersByIdentifier removeObjectForKey:key];
        }
    }];
    [super didReceiveMemoryWarning];
}

@end
