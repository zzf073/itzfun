//
//  RNFrostedMenu.m
//  RNFrostedMenu
//
//  Created by Ryan Nystrom on 8/13/13.
//  Copyright (c) 2013 Ryan Nystrom. All rights reserved.
//

#define  kMENU_FONT  [UIFont fontWithName:@"Montserrat-Regular" size:15]

#define __IPHONE_OS_VERSION_SOFT_MAX_REQUIRED __IPHONE_7_0

#import "RNFrostedSidebar.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

#pragma mark - Categories

@implementation UIView (rn_Screenshot)

- (UIImage *)rn_screenshot
{
    UIGraphicsBeginImageContext(self.bounds.size);
    if([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    }
    else{
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(image, 0.75);
    image = [UIImage imageWithData:imageData];
    return image;
}

@end

#import <Accelerate/Accelerate.h>

@implementation UIImage (rn_Blur)

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage
{
    // Check pre-conditions.
    if (self.size.width < 1 || self.size.height < 1) {
        NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
        return nil;
    }
    if (!self.CGImage) {
        NSLog (@"*** error: image must be backed by a CGImage: %@", self);
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        NSLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    
    CGRect imageRect = { CGPointZero, self.size };
    UIImage *effectImage = self;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        if (hasBlur) {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            uint32_t radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);

        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    
    // Draw effect image.
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

@end

#pragma mark - Private Classes

@interface RNCalloutItemView : UIView

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) NSInteger itemIndex;
@property (nonatomic, strong) UIColor *originalBackgroundColor;

@end

@implementation RNCalloutItemView

- (instancetype)init {
    if (self = [super init]) {
        self.label = [[UILabel alloc] init];
        self.label.font = kMENU_FONT;
        self.label.textColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.hidden = YES;
        //_imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        [self addSubview:self.label];
        
    }
    return self;
}

#pragma mark - LayoutSubView Main Size
- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (IS_IPHONE_6_PLUS) {
        self.imageView.frame = CGRectMake(35, 2, 110, 23);
    }else if (IS_IPHONE_6){
        self.imageView.frame = CGRectMake(35, 2, 95, 20);
    }else{
        self.imageView.frame = CGRectMake(35, 2, 85, 17);
    }
    self.label.frame = self.imageView.frame;
    //self.backgroundColor = [UIColor yellowColor];

}

- (void)setOriginalBackgroundColor:(UIColor *)originalBackgroundColor {
    _originalBackgroundColor = originalBackgroundColor;
    self.backgroundColor = originalBackgroundColor;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    CGFloat r, g, b, a;
    CGFloat darkenFactor = 0.3f;
    UIColor *darkerColor;
    if ([self.originalBackgroundColor getRed:&r green:&g blue:&b alpha:&a]) {
        darkerColor = [UIColor colorWithRed:MAX(r - darkenFactor, 0.0) green:MAX(g - darkenFactor, 0.0) blue:MAX(b - darkenFactor, 0.0) alpha:a];
    }
    else if ([self.originalBackgroundColor getWhite:&r alpha:&a]) {
        darkerColor = [UIColor colorWithWhite:MAX(r - darkenFactor, 0.0) alpha:a];
    }
    else {
        @throw @"Item color should be RGBA or White/Alpha in order to darken the button color.";
    }
    self.backgroundColor = darkerColor;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.backgroundColor = self.originalBackgroundColor;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.backgroundColor = self.originalBackgroundColor;
}

@end

#pragma mark - Public Classes

@interface RNFrostedSidebar ()

@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) UIImageView *blurView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGesture;

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *borderColors;
@property (nonatomic, strong) NSMutableArray *itemViews;
@property (nonatomic, strong) NSMutableIndexSet *selectedIndices;

@end

static RNFrostedSidebar *rn_frostedMenu;

@implementation RNFrostedSidebar

+ (instancetype)visibleSidebar {
    return rn_frostedMenu;
}
#pragma mark - Initilization subviews
- (instancetype)initWithImages:(NSArray *)images selectedIndices:(NSIndexSet *)selectedIndices borderColors:(NSArray *)colors {
    if (self = [super init])
    {
        _isSingleSelect = NO;
        _contentView = [[UIScrollView alloc] init];
        _contentView.alwaysBounceHorizontal = NO;
        _contentView.alwaysBounceVertical = YES;
        _contentView.bounces = YES;
        _contentView.clipsToBounds = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.showsVerticalScrollIndicator = NO;
        
        CGFloat OneThird=(128*screenWidth)/320;
        
        _width = OneThird *2;
        _animationDuration = 0.25f;
        _itemSize = CGSizeMake(_width, 45);
        _itemViews = [NSMutableArray array];
        _tintColor = [UIColor colorWithWhite:0.1 alpha:0.73];
        _borderWidth = 2;
        _itemBackgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
        
        if (colors) {
            NSAssert([colors count] == [images count], @"Border color count must match images count. If you want a blank border, use [UIColor clearColor].");
        }
        
        _selectedIndices = [selectedIndices mutableCopy] ?: [NSMutableIndexSet indexSet];
        _borderColors = colors;
        _images = images;
        
        [_images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop)
         {
            RNCalloutItemView *view = [[RNCalloutItemView alloc] init];
            view.itemIndex = idx;
            //view.clipsToBounds = YES;
            view.imageView.image = image;
             
             UIImageView *icon = [[UIImageView alloc] initWithImage:[[kAPP_DELEGATE menuIcons] objectAtIndex:idx]];
             [view addSubview:icon];
             
             view.label.text = [[kAPP_DELEGATE menuText] objectAtIndex:idx];
             
            [_contentView addSubview:view];
             
            [_itemViews addObject:view];
            
            if (_borderColors && _selectedIndices && [_selectedIndices containsIndex:idx])
            {
                UIColor *color = _borderColors[idx];
                view.layer.borderColor = color.CGColor;
            }
            else {
                view.layer.borderColor = [UIColor clearColor].CGColor;
            }
        }];
        
        UIButton *btnClose=[UIButton buttonWithType:UIButtonTypeCustom];
        btnClose.frame=CGRectMake(20, screenHeight-40, 100, 27);
        [btnClose addTarget:self action:@selector(CloseSideBar:) forControlEvents:UIControlEventTouchUpInside];
        [btnClose setTitle:@"Logout" forState:UIControlStateNormal];
        [btnClose.titleLabel setFont:kMENU_FONT];
        [btnClose setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        AppDelegate *apDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
        if ([apDelegate isLogin]) {
            [_contentView addSubview:btnClose];
        }
        
        CGRect logo_size;
        if (IS_IPHONE_6_PLUS) {
            logo_size=CGRectMake(20, 30, 100, 20);
        }else if (IS_IPHONE_6){
            logo_size=CGRectMake(20, 32, 100, 18);
        }else{
            logo_size=CGRectMake(20, 35, 100, 18);
        }
        
//        UIImageView *imageLogo=[[UIImageView alloc]initWithFrame:logo_size];
//        imageLogo.image=[UIImage imageNamed:@"White-logo.png"];
//        [_contentView addSubview:imageLogo];
        
        UILabel *lblLogoName = [[UILabel alloc] initWithFrame:logo_size];
        lblLogoName.text = @"ItzFun";
        lblLogoName.textColor = [UIColor whiteColor];
        //[lblLogoName sizeToFit];
        lblLogoName.font = [UIFont fontWithName:kFONT_HELVETICANEUE_MEDIUM size:21];
        [_contentView addSubview:lblLogoName];
        
        UIImageView *imageSep=[[UIImageView alloc]initWithFrame:CGRectMake(20, 63, _width-40, 1)];
        imageSep.image=[UIImage imageNamed:@"Head-Nsep.png"];
        //[_contentView addSubview:imageSep];
        
        /*NSString *yearString = [[kAppDelegate Currentformatter] stringFromDate:[NSDate date]];
        
        UILabel *copyrightLbl=[[UILabel alloc]initWithFrame:CGRectMake(15, [UIScreen mainScreen].bounds.size.height-40, 290, 25)];
        copyrightLbl.backgroundColor=[UIColor clearColor];
        copyrightLbl.textAlignment=NSTextAlignmentCenter;
        copyrightLbl.font=[UIFont fontWithName:@"GothamCondensed-Medium" size:13.0];
        copyrightLbl.text=[NSString stringWithFormat:@"RealStir ©Copyright %@ -Made in Sunny San Diego",yearString];
        copyrightLbl.textColor=[UIColor whiteColor];
        //[_contentView addSubview:copyrightLbl];
        [self.view addSubview:copyrightLbl];
        [self.view bringSubviewToFront:copyrightLbl];*/
    }
    return self;
}

-(IBAction)CloseSideBar:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:m_logout_conform message:nil delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    alert.tag=501;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 501)
    {
        if (buttonIndex==0) {
            
            NSLog(@"Start logout process");
            [self didTapItemAtIndex:555];
            [self dismissAnimated:YES completion:nil];
        }
    }
}

- (instancetype)initWithImages:(NSArray *)images selectedIndices:(NSIndexSet *)selectedIndices {
    return [self initWithImages:images selectedIndices:selectedIndices borderColors:nil];
}

- (instancetype)initWithImages:(NSArray *)images {
    return [self initWithImages:images selectedIndices:nil borderColors:nil];
}

- (instancetype)init {
    NSAssert(NO, @"Unable to create with plain init.");
    return nil;
}

- (void)loadView {
    [super loadView];
    [self.view addSubview:self.contentView];
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    self.swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    self.swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:self.swipeGesture];

    [self.view addGestureRecognizer:self.tapGesture];
}
- (void)handleSwipe:(UISwipeGestureRecognizer *)gesure {
    [self dismissAnimated:YES];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if ([self isViewLoaded] && self.view.window != nil) {
        self.view.alpha = 0;
        UIImage *blurImage = [self.parentViewController.view rn_screenshot];
        blurImage = [blurImage applyBlurWithRadius:5 tintColor:self.tintColor saturationDeltaFactor:1.8 maskImage:nil];
        self.blurView.image = blurImage;
        self.view.alpha = 1;
        
        [self layoutSubviews];
    }
}

#pragma mark - Show

- (void)animateSpringWithView:(RNCalloutItemView *)view idx:(NSUInteger)idx initDelay:(CGFloat)initDelay {
#if __IPHONE_OS_VERSION_SOFT_MAX_REQUIRED
    [UIView animateWithDuration:0
                          delay:(initDelay + idx*0)
         usingSpringWithDamping:50
          initialSpringVelocity:50
                        options:0
                     animations:^{
                         view.layer.transform = CATransform3DIdentity;
                         view.alpha = 1;
                     }
                     completion:nil];
#endif
}

- (void)animateFauxBounceWithView:(RNCalloutItemView *)view idx:(NSUInteger)idx initDelay:(CGFloat)initDelay {
    [UIView animateWithDuration:0.2
                          delay:(initDelay + idx*0.1f)
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseInOut
                     animations:^{
                         view.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1);
                         view.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1 animations:^{
                             view.layer.transform = CATransform3DIdentity;
                         }];
                     }];
}

- (void)showInViewController:(UIViewController *)controller animated:(BOOL)animated {
    
    if (rn_frostedMenu != nil) {
        [rn_frostedMenu dismissAnimated:NO completion:nil];
    }
    
    if ([self.delegate respondsToSelector:@selector(sidebar:willShowOnScreenAnimated:)]) {
        [self.delegate sidebar:self willShowOnScreenAnimated:animated];
    }
    
    rn_frostedMenu = self;
    
    UIImage *blurImage = [controller.view rn_screenshot];
    blurImage = [blurImage applyBlurWithRadius:5 tintColor:self.tintColor saturationDeltaFactor:1.8 maskImage:nil];
    
    [self rn_addToParentViewController:controller callingAppearanceMethods:YES];
    self.view.frame = controller.view.bounds;
    
    CGFloat parentWidth = self.view.bounds.size.width;
    
    CGRect contentFrame = self.view.bounds;
    contentFrame.origin.x = _showFromRight ? parentWidth : -_width;
    contentFrame.size.width = _width;
    self.contentView.frame = contentFrame;
    
    [self layoutItems];
    
    CGRect blurFrame = CGRectMake(_showFromRight ? self.view.bounds.size.width : 0, 0, 0, self.view.bounds.size.height);
    
    self.blurView = [[UIImageView alloc] initWithImage:blurImage];
    self.blurView.frame = blurFrame;
    self.blurView.contentMode = _showFromRight ? UIViewContentModeTopRight : UIViewContentModeTopLeft;
    self.blurView.clipsToBounds = YES;
    [self.view insertSubview:self.blurView belowSubview:self.contentView];
    
    contentFrame.origin.x = _showFromRight ? parentWidth - _width : 0;
    blurFrame.origin.x = contentFrame.origin.x;
    blurFrame.size.width = _width;
    
    void (^animations)() = ^{
        self.contentView.frame = contentFrame;
        self.blurView.frame = blurFrame;
    };
    
    void (^completion)(BOOL) = ^(BOOL finished) {
        if (finished && [self.delegate respondsToSelector:@selector(sidebar:didShowOnScreenAnimated:)]) {
            [self.delegate sidebar:self didShowOnScreenAnimated:animated];
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:kNilOptions
                         animations:animations
                         completion:completion];
    }
    else{
        animations();
        completion(YES);
    }
    
    CGFloat initDelay = 0.0f;
    SEL sdkSpringSelector = NSSelectorFromString(@"animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:");
    BOOL sdkHasSpringAnimation = [UIView respondsToSelector:sdkSpringSelector];
    
    [self.itemViews enumerateObjectsUsingBlock:^(RNCalloutItemView *view, NSUInteger idx, BOOL *stop) {
        view.layer.transform = CATransform3DMakeScale(0.3, 0.3, 1);
        view.alpha = 0;
        view.originalBackgroundColor = self.itemBackgroundColor;
        view.layer.borderWidth = self.borderWidth;
        
        //view.backgroundColor=[UIColor redColor];
        
        if (sdkHasSpringAnimation) {
            [self animateSpringWithView:view idx:idx initDelay:initDelay];
        }
        else {
            [self animateFauxBounceWithView:view idx:idx initDelay:initDelay];
        }
    }];
}

- (void)showAnimated:(BOOL)animated {
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (controller.presentedViewController != nil) {
        controller = controller.presentedViewController;
    }
    [self showInViewController:controller animated:animated];
}

- (void)show {
    [self showAnimated:YES];
}

#pragma mark - Dismiss

- (void)dismiss {
    [self dismissAnimated:YES completion:nil];
}

- (void)dismissAnimated:(BOOL)animated {
    [self dismissAnimated:animated completion:nil];
}

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    void (^completionBlock)(BOOL) = ^(BOOL finished){
        [self rn_removeFromParentViewControllerCallingAppearanceMethods:YES];
      
        if ([self.delegate respondsToSelector:@selector(sidebar:didDismissFromScreenAnimated:)]) {
            [self.delegate sidebar:self didDismissFromScreenAnimated:YES];
        }
        
        rn_frostedMenu = nil;
        
		if (completion) {
			completion(finished);
		}
    };
    
    if ([self.delegate respondsToSelector:@selector(sidebar:willDismissFromScreenAnimated:)]) {
        [self.delegate sidebar:self willDismissFromScreenAnimated:YES];
    }
    
    if (animated) {
        CGFloat parentWidth = self.view.bounds.size.width;
        CGRect contentFrame = self.contentView.frame;
        contentFrame.origin.x = self.showFromRight ? parentWidth : -_width;
        
        CGRect blurFrame = self.blurView.frame;
        blurFrame.origin.x = self.showFromRight ? parentWidth : 0;
        blurFrame.size.width = 0;
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.contentView.frame = contentFrame;
                             self.blurView.frame = blurFrame;
                         }
                         completion:completionBlock];
    }
    else {
        completionBlock(YES);
    }
}

#pragma mark - Gestures

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self.view];
    if (! CGRectContainsPoint(self.contentView.frame, location)) {
        [self dismissAnimated:YES completion:nil];
    }
    else {
        NSInteger tapIndex = [self indexOfTap:[recognizer locationInView:self.contentView]];
        if (tapIndex != NSNotFound) {
            [self didTapItemAtIndex:tapIndex];
        }
    }
}

#pragma mark - Private

- (void)didTapItemAtIndex:(NSUInteger)index {
    BOOL didEnable = ! [self.selectedIndices containsIndex:index];
    
    if (self.borderColors) {
        UIColor *stroke = self.borderColors[index];
        UIView *view = self.itemViews[index];
        
        if (didEnable) {
            if (_isSingleSelect){
                [self.selectedIndices removeAllIndexes];
                [self.itemViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    UIView *aView = (UIView *)obj;
                    [[aView layer] setBorderColor:[[UIColor clearColor] CGColor]];
                }];
            }
            view.layer.borderColor = stroke.CGColor;
            
            CABasicAnimation *borderAnimation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
            borderAnimation.fromValue = (id)[UIColor clearColor].CGColor;
            borderAnimation.toValue = (id)stroke.CGColor;
            borderAnimation.duration = 0.5f;
            [view.layer addAnimation:borderAnimation forKey:nil];
            
            [self.selectedIndices addIndex:index];
        }
        else {
            if (!_isSingleSelect){
                view.layer.borderColor = [UIColor clearColor].CGColor;
                [self.selectedIndices removeIndex:index];
            }
        }
        
        CGRect pathFrame = CGRectMake(-CGRectGetMidX(view.bounds), -CGRectGetMidY(view.bounds), view.bounds.size.width, view.bounds.size.height);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pathFrame cornerRadius:view.layer.cornerRadius];
        
        // accounts for left/right offset and contentOffset of scroll view
        CGPoint shapePosition = [self.view convertPoint:view.center fromView:self.contentView];
        
        CAShapeLayer *circleShape = [CAShapeLayer layer];
        circleShape.path = path.CGPath;
        circleShape.position = shapePosition;
        circleShape.fillColor = [UIColor clearColor].CGColor;
        circleShape.opacity = 0;
        circleShape.strokeColor = stroke.CGColor;
        circleShape.lineWidth = self.borderWidth;
        
        [self.view.layer addSublayer:circleShape];
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.5, 2.5, 1)];
        
        CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        alphaAnimation.fromValue = @1;
        alphaAnimation.toValue = @0;
        
        CAAnimationGroup *animation = [CAAnimationGroup animation];
        animation.animations = @[scaleAnimation, alphaAnimation];
        animation.duration = 0.5f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [circleShape addAnimation:animation forKey:nil];
    }
    
    if ([self.delegate respondsToSelector:@selector(sidebar:didTapItemAtIndex:)]) {
        [self.delegate sidebar:self didTapItemAtIndex:index];
    }
    if ([self.delegate respondsToSelector:@selector(sidebar:didEnable:itemAtIndex:)]) {
        [self.delegate sidebar:self didEnable:didEnable itemAtIndex:index];
    }
}

#pragma mark - Set Inner SubItems
- (void)layoutSubviews {
    CGFloat x = self.showFromRight ? self.parentViewController.view.bounds.size.width - _width : 0;
    self.contentView.frame = CGRectMake(x, 0, _width, self.parentViewController.view.bounds.size.height);
    self.blurView.frame = self.contentView.frame;
    
    [self layoutItems];
}

- (void)layoutItems {
    CGFloat leftPadding =20;//(self.width - self.itemSize.width)/2;
    CGFloat topPadding = 10;
    [self.itemViews enumerateObjectsUsingBlock:^(RNCalloutItemView *view, NSUInteger idx, BOOL *stop)
    {
        CGFloat TopSpace=70;
        /*if (IS_IPHONE_6_PLUS) {
            TopSpace=240;
        }else if(IS_IPHONE_6) {
            TopSpace=200;
        }else if (IS_IPHONE_5) {
            TopSpace=170;
        }*/
        CGRect frame = CGRectMake(leftPadding, TopSpace+topPadding*idx + (self.itemSize.height)*idx + topPadding, self.itemSize.width, self.itemSize.height+20);
        view.frame = frame;
       

        //view.layer.cornerRadius = frame.size.width/2.f;
    }];
    
    NSInteger items = [self.itemViews count];
    //AppDelegate *apDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    /*if(apDelegate.AccessToken.length==0)
    {
        self.contentView.contentSize = CGSizeMake(0, items * ((self.itemSize.height) + topPadding) + topPadding);
    }
    else
    {
        self.contentView.contentSize = CGSizeMake(0, items * ((self.itemSize.height) + topPadding) + topPadding+100);
    }*/
    self.contentView.contentSize = CGSizeMake(0, items * ((self.itemSize.height) + topPadding) + topPadding+100);

}

- (NSInteger)indexOfTap:(CGPoint)location
{
    __block NSUInteger index = NSNotFound;
    
    [self.itemViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop)
    {
        CGRect rect = view.frame;
        rect.origin.y -= 20;
        rect.origin.x -= 25;


        if (CGRectContainsPoint(rect, location))
        {
            index = idx;
            *stop = YES;
        }
    }];
    
    return index;
}

- (void)rn_addToParentViewController:(UIViewController *)parentViewController callingAppearanceMethods:(BOOL)callAppearanceMethods {
    
    
    if (self.parentViewController != nil) {
        [self rn_removeFromParentViewControllerCallingAppearanceMethods:callAppearanceMethods];
    }
    
    if (callAppearanceMethods) [self beginAppearanceTransition:YES animated:NO];
    [parentViewController addChildViewController:self];
    [parentViewController.view addSubview:self.view];
    [self didMoveToParentViewController:self];
    if (callAppearanceMethods) [self endAppearanceTransition];
}

- (void)rn_removeFromParentViewControllerCallingAppearanceMethods:(BOOL)callAppearanceMethods {
    if (callAppearanceMethods) [self beginAppearanceTransition:NO animated:NO];
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    if (callAppearanceMethods) [self endAppearanceTransition];
}

@end
