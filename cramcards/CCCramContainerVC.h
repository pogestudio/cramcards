//
//  CCCramContainerVC.h
//  cramcards
//
//  Created by CA on 1/25/13.
//  Copyright (c) 2013 CC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCCramCardVC.h"
@class Deck;
@class CCCardDataForShow;
@class CCCardDealer;

@interface CCCramContainerVC : UIViewController <CardInteractionDelegate>
{
    
}

@property (strong) NSArray *cardsInDataFormat;
@property (strong) NSDictionary *cramSettings;
@property (strong) CCCardDealer *dealer;

@property (strong) IBOutlet UIView *adView;
@property (strong) IBOutlet UIView *cramView;
@property (strong) IBOutlet UIView *flashColorView;
@property (assign) BOOL adsAreShown;

#pragma mark View Related, refactor if anything else is added
@property (strong) IBOutlet UILabel *cardDone;

-(void)setUpCramForDeck:(Deck*)deckToCram withSettings:(NSDictionary*)settings;


@end
