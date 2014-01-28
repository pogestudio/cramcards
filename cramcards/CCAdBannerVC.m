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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CGRect newFrame = CGRectOffset(self.view.bounds, 0, self.view.bounds.size.height);
    self.iBannerView = [[ADBannerView alloc] initWithFrame:newFrame];
    self.iBannerView.delegate = self;
    [self.view addSubview:self.iBannerView];
    [self.iBannerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    self.iBannerShouldBeVisible = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark Banner Delegate
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!self.iBannerShouldBeVisible)
    {
        self.iBannerShouldBeVisible = YES;
        if (self.gBannerView) {
            [self removeGADBannerAndLoadIAdOnCompletion:YES];
        } else {
            [self positionIAdBannerWithAnimation:YES];
        }
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (self.iBannerShouldBeVisible)
    {
        self.iBannerShouldBeVisible = NO;
        [self positionIAdBannerWithAnimation:YES];
    }
    [self addGADBanner];
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
    [self positionIAdBannerWithAnimation:NO];
}

-(void)positionIAdBannerWithAnimation:(BOOL)shouldBeAnimated
{
    shouldBeAnimated = YES;
    CGFloat xPos = 0;
    CGFloat width = self.iBannerView.bounds.size.width;
    CGFloat height = self.iBannerView.bounds.size.height;
    CGFloat yPos;
    
    if (self.iBannerShouldBeVisible)
    {
        yPos = self.view.bounds.size.height - self.iBannerView.bounds.size.height;
    } else {
        yPos = self.view.bounds.size.height;
    }
    
    if (shouldBeAnimated) {
        [UIView animateWithDuration:0.5 animations:^{
            self.iBannerView.frame = CGRectMake(xPos,yPos,width,height);
        }];
    } else {
         self.iBannerView.frame = CGRectMake(xPos,yPos,width,height);
    }
}

#pragma mark Helping parent view with their sizing
-(CGFloat)currentHeightOfAd
{
    return self.iBannerView.frame.size.height;
}

#pragma mark GADBAnner
-(void)addGADBanner
{
    if (self.gBannerView) {
        [self.gBannerView removeFromSuperview];
        self.gBannerView = nil;
    }
    // 2
    CGRect endFrame = CGRectMake(0.0,0.0,
                                       GAD_SIZE_320x50.width,
                                       GAD_SIZE_320x50.height);
    CGRect startFrame = CGRectOffset(endFrame, 0, self.view.bounds.size.height);
    self.gBannerView = [[GADBannerView alloc]
                        initWithFrame:startFrame];
    // 3
    self.gBannerView.adUnitID = @"a15120bb117925d";
    self.gBannerView.rootViewController = self;
    self.gBannerView.delegate = self;
    // 4
    [self.view addSubview:self.gBannerView];
    [self.gBannerView loadRequest:[GADRequest request]];
    
    [UIView animateWithDuration:0.5 animations:^(void){
        self.gBannerView.frame = endFrame;
    }];
}

-(void)removeGADBannerAndLoadIAdOnCompletion:(BOOL)shouldIadLoad
{
    CGFloat newXpos = -(self.gBannerView.frame.size.width + self.gBannerView.frame.origin.x);
    [UIView animateWithDuration:0.5
                     animations:^{
        self.gBannerView.frame = CGRectMake(newXpos,
                                            self.gBannerView.frame.origin.y,
                                            self.gBannerView.frame.size.width,
                                            self.gBannerView.frame.size.height);}
                     completion:^(BOOL finished){
                         [self.gBannerView removeFromSuperview];
                         self.gBannerView = nil;
                         
                         if (shouldIadLoad) {
                             [self positionIAdBannerWithAnimation:YES];
                         }
                     }];
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    [self removeGADBannerAndLoadIAdOnCompletion:NO];
}
@end
