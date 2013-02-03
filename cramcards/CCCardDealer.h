//
//  CCCardDealer.h
//  cramcards
//
//  Created by CA on 1/26/13.
//  Copyright (c) 2013 CC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Deck;
@class CCCardDataForShow;

@interface CCCardDealer : NSObject

@property (strong) Deck *deckWhichIsBeingCrammed;
@property (strong) NSArray *cardsInDataFormat;
@property (strong) NSDictionary *cramSettings;
@property (strong) CCCardDataForShow *currentCard;


-(id)initWithDeck:(Deck*)deck settings:(NSDictionary*)settings;
-(CCCardDataForShow*)nextCard;
-(void)userKnewAnswer:(BOOL)userKnew;
-(void)markCardAsKnown;

-(void)deckIsComplete;

-(NSUInteger)userPrefCorrectRequirement;
-(NSUInteger)numberOfCompletedCards;

@end
