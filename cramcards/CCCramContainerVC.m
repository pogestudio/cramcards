//
//  CCCramContainerVC.m
//  cramcards
//
//  Created by CA on 1/25/13.
//  Copyright (c) 2013 CC. All rights reserved.
//

#import "CCCramContainerVC.h"

#import "CCCardDataForShow.h"
#import "CCCardDealer.h"
#import "Deck.h"
#import "CCSessionInfo.h"
#import "CCAdBannerVC.h"

#import "CCInAppPurchaseManager.h"
#import "InAppPurchaseDetails.h"

@interface CCCramContainerVC ()

@end

@implementation CCCramContainerVC

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self removeAdsIfUserHasPaid];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CCCramCardVC *firstVC = [self getCurrentCramCardVC];
    firstVC.dataForView = [self.dealer nextCard];
    firstVC.shouldShowQuestion = YES;
    firstVC.delegate = self;
    
    CCSessionInfo *sessionVC = [self getCurrentSessionVC];
    sessionVC.dealer = self.dealer;
    [sessionVC updateView];
    
    [self setUpFlashView];
    
//    CGFloat heightOfAdView = self.adView.frame.size.height;
//    CGFloat currentCramHeight = self.cramView.frame.size.height;
//    CGFloat newHeightOfCramFrame = currentCramHeight - heightOfAdView;
//    self.cramView.bounds = CGRectMake(0,0,self.cramView.frame.size.width,newHeightOfCramFrame);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpCramForDeck:(Deck *)deckToCram withSettings:(NSDictionary *)settings
{
    self.cramSettings = settings;
    self.dealer = [[CCCardDealer alloc] initWithDeck:deckToCram settings:settings];

}

-(void)setUpFlashView
{
    self.flashColorView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.flashColorView setBackgroundColor:[UIColor clearColor]];
    self.flashColorView.userInteractionEnabled = NO;
    CGFloat alpha = 0.5;
    [self.flashColorView setAlpha:alpha];
    [self.view addSubview:self.flashColorView];
}

-(void)viewDidLayoutSubviews
{
    self.flashColorView.frame = [self getCurrentSessionVC].view.frame;
    
}

#pragma mark InAppPurchase
-(void)removeAdsIfUserHasPaid
{

    BOOL shouldRemoveAds = [InAppPurchaseDetails shouldAdvertisementsBeRemoved];
    if (shouldRemoveAds) {
        [UIView animateWithDuration:0.5
                         animations:^{
            self.adView.frame = CGRectOffset(self.adView.frame, 0, self.adView.frame.size.height); }
                         completion:^(BOOL finished){
                             [self.adView removeFromSuperview];
                                 self.adView = nil;
                             [[self getCurrentBanner] removeFromParentViewController];
                         }];

    }
        self.adsAreShown = !shouldRemoveAds;
}

#pragma mark Transitions
- (void)showNewViewController:(UIViewController*)newVC
{
    UIViewController *oldVC = [self getCurrentCramCardVC];
    
    [oldVC willMoveToParentViewController:nil];                        // 1
    [self addChildViewController:newVC];
    
    [self flipTransitionFrom:oldVC to:newVC];
}

-(void)flipTransitionFrom:(UIViewController*)oldVC to:(UIViewController*)newVC
{
    [self transitionFromViewController:oldVC
                      toViewController:newVC
                              duration:0.15
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:nil
                            completion:^(BOOL finished)
     {
         if (self.adsAreShown) {
             CGFloat heightOfAd = [[self getCurrentBanner] currentHeightOfAd];
             [((CCCramCardVC*)newVC) adjustViewForBottombarOfHeight:heightOfAd];
         }
         [oldVC removeFromParentViewController];
     }];
}

-(void)flipToAnswer
{
    CCCramCardVC *cramVC = [self newCramCardVC];
    cramVC.dataForView = self.dealer.currentCard;
    cramVC.shouldShowQuestion = NO;
    [self showNewViewController:cramVC];
}

-(CCCramCardVC*)newCramCardVC
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    // Must match the controller's Storyboard ID
    CCCramCardVC *controller = [storyboard instantiateViewControllerWithIdentifier:@"CramCardVC"];
    controller.delegate = self;

    return controller;
}

-(CCCramCardVC*)getCurrentCramCardVC
{
    CCCramCardVC *cramVC;
    for (UITableViewController *VC in self.childViewControllers) {
        if ([VC isKindOfClass:[CCCramCardVC class]]) {
            cramVC = (CCCramCardVC*)VC;
        }
    }
    return cramVC;
}

-(CCSessionInfo*)getCurrentSessionVC
{
    CCSessionInfo *sessionVC;
    for (UITableViewController *VC in self.childViewControllers) {
        if ([VC isKindOfClass:[CCSessionInfo class]]) {
            sessionVC = (CCSessionInfo*)VC;
        }
    }
    return sessionVC;
}

-(CCAdBannerVC*)getCurrentBanner
{
    CCAdBannerVC *bannerVC;
    for (UITableViewController *VC in self.childViewControllers) {
        if ([VC isKindOfClass:[CCAdBannerVC class]]) {
            bannerVC = (CCAdBannerVC*)VC;
        }
    }
    return bannerVC;
}

#pragma mark Navigation
-(void)deckIsFinished
{
    [self.dealer deckIsComplete];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Card Logic
-(void)showNextCard
{
    CCCardDataForShow *nextCard = [self.dealer nextCard];
    if (!nextCard) {
        [self deckIsFinished];
        return;
    }
    CCCramCardVC *cramVC = [self newCramCardVC];
    cramVC.dataForView = nextCard;
    cramVC.shouldShowQuestion = YES;
    [self showNewViewController:cramVC];
    [[self getCurrentSessionVC] updateView];

}

-(void)flashColorForUserAnswerCorrectOrNot:(BOOL)userKnewAnser
{
    UIColor *colorToFlash = userKnewAnser ? [UIColor greenColor] : [UIColor redColor];
    NSTimeInterval flashDuration = 0.2;
    [UIView animateWithDuration:flashDuration
                     animations:^{
                         [self.flashColorView setBackgroundColor:colorToFlash];
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:flashDuration
                                          animations:^{
                             [self.flashColorView setBackgroundColor:[UIColor clearColor]];
                         }];
                         
                     }];
}

#pragma mark CardInteractionDelegate
-(void)showAnswer
{
    [self flipToAnswer];
}

-(void)userKnewAnswer:(BOOL)userKnew
{
    [self flashColorForUserAnswerCorrectOrNot:userKnew];
    [self.dealer userKnewAnswer:userKnew];
    
    if ([self.dealer isCurrentCardDone]) {
        [self flashDoneOnScreen];
    }
    
}

-(void)presentNextCard
{
    [self showNextCard];
}

-(void)userKnowsCard
{
    [self.dealer markCardAsKnown];
}

#pragma mark Card Screen Related
-(void)flashDoneOnScreen
{
    self.cardDone.font = [UIFont boldSystemFontOfSize:30];
    self.cardDone.transform = CGAffineTransformScale(self.cardDone.transform, 0.25, 0.25);
    self.cardDone.alpha = 1;
    [self.view addSubview:self.cardDone];
    [UIView animateWithDuration:0.5 animations:^{
        self.cardDone.alpha = 0.2;
        self.cardDone.transform = CGAffineTransformScale(self.cardDone.transform, 4, 4);
    } completion:^(BOOL finished){
        self.cardDone.alpha = 0;
        
    }];
    
}


@end
