//
//  CCAdBannerVC.m
//  cramcards
//
//  Created by CA on 1/31/13.
//  Copyright (c) 2013 CC. All rights reserved.
//

#import "CCAdBannerVC.h"

@interface CCAdBannerVC ()

@end

@implementation CCAdBannerVC

static BOOL _isABannerLoaded;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.bannerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.bannerIsVisible = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Ad Logic
+(BOOL)shouldLoadBanner
{
    BOOL shouldWeLoadBanner = _isABannerLoaded;
    return shouldWeLoadBanner;
}


#pragma mark Banner Delegate
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        // Assumes the banner view is just off the bottom of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        [UIView commitAnimations];
        self.bannerIsVisible = YES;
        CGRect frame = banner.frame;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        // Assumes the banner view is placed at the bottom of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        [UIView commitAnimations];
        self.bannerIsVisible = NO;
    }
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
//    BOOL shouldExecuteAction = [self allowActionToRun]; // your application implements this method
//    if (!willLeave && shouldExecuteAction)
//    {
//        // insert code here to suspend any services that might conflict with the advertisement
//    }
    return willLeave;
}

#pragma mark Handling banner sizing


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    CGFloat xPos = 0;
    CGFloat width = self.bannerView.bounds.size.width;
    CGFloat height = self.bannerView.bounds.size.height;
    CGFloat yPos;
    
    if (self.bannerIsVisible)
    {
        yPos = self.view.bounds.size.height - self.bannerView.bounds.size.height;
    } else {
        yPos = self.view.bounds.size.height;
    }
    self.bannerView.frame = CGRectMake(xPos,yPos,width,height);
}
@end
