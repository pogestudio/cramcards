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
    @private
    UIView *_flashColorView;
    IBOutlet UIView *_adView;
    
}

@property (strong) NSArray *cardsInDataFormat;
@property (strong) NSDictionary *cramSettings;
@property (strong) CCCardDealer *dealer;

-(void)presentNextCardWithCurrentCardBeingCorrectlyAnswered:(BOOL)userKnewAnser;
-(void)setUpCramForDeck:(Deck*)deckToCram withSettings:(NSDictionary*)settings;


@end
