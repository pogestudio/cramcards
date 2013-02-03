//
//  CCAdBannerVC.h
//  cramcards
//
//  Created by CA on 1/31/13.
//  Copyright (c) 2013 CC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>


#define SHOULD_INCLUDE_BANNER YES

@interface CCAdBannerVC : UIViewController <ADBannerViewDelegate>

@property (strong) IBOutlet ADBannerView *bannerView;
@property (assign) BOOL bannerIsVisible;

@end
