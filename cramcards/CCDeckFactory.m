//
//  CCDeckFactory.m
//  cramcards
//
//  Created by CA on 1/24/13.
//  Copyright (c) 2013 CC. All rights reserved.
//

#import "CCDeckFactory.h"
#import "CCDatabaseInterface.h"

#import "Deck+addSubitems.h"
#import "Card+addSubitems.h"
#import "Side.h"

@implementation CCDeckFactory

static CCDeckFactory *_sharedFactory;

+(CCDeckFactory*)sharedFactory
{
    if (!_sharedFactory) {
        _sharedFactory = [[CCDeckFactory alloc] init];
    }
    return _sharedFactory;
}


#pragma mark FlashExchange
-(void)createDeckFromFlashexchangeWithDict:(NSDictionary *)dictWithDeck
{
    Deck *deck = [[CCDatabaseInterface sharedInterface] newDeck];
    
    NSArray *fetchedCards = [dictWithDeck objectForKey:@"cards"];
    for (NSDictionary *fetchedCard in fetchedCards) {
        Card *newCard = [self getCardWithFlashExchangeInfo:fetchedCard];
        [deck addCardsObject:newCard];
    }
    
    NSUInteger numberOfCardsAdded = [deck.cards count];
    deck.numberOfCards = [NSNumber numberWithInt:numberOfCardsAdded];
    deck.title = [dictWithDeck objectForKey:@"title"];
    [CCDatabaseInterface saveDatabase];
}

-(Card*)getCardWithFlashExchangeInfo:(NSDictionary*)cardInfo
{
    Card *card = [[CCDatabaseInterface sharedInterface] newCard];
    Side *front = [[CCDatabaseInterface sharedInterface] newSide];
    Side *back = [[CCDatabaseInterface sharedInterface] newSide];
    front.text = [cardInfo objectForKey:@"front"];
    back.text = [cardInfo objectForKey:@"back"];
    [card addSidesObject:front];
    [card addSidesObject:back];
    return card;
}

#pragma mark Quizlet
-(void)createDeckFromQuizletWithDict:(NSDictionary *)dictWithDeck
{
    Deck *deck = [[CCDatabaseInterface sharedInterface] newDeck];
    
    NSArray *fetchedCards = [dictWithDeck objectForKey:@"terms"];
    for (NSDictionary *fetchedCard in fetchedCards) {
        Card *newCard = [self getCardWithQuizletInfo:fetchedCard];
        [deck addCardsObject:newCard];
    }
    
    NSUInteger numberOfCardsAdded = [deck.cards count];
    deck.numberOfCards = [NSNumber numberWithInt:numberOfCardsAdded];
    deck.title = [dictWithDeck objectForKey:@"title"];
    [CCDatabaseInterface saveDatabase];
}

-(Card*)getCardWithQuizletInfo:(NSDictionary*)cardInfo
{
    Card *card = [[CCDatabaseInterface sharedInterface] newCard];
    Side *front = [[CCDatabaseInterface sharedInterface] newSide];
    Side *back = [[CCDatabaseInterface sharedInterface] newSide];
    front.text = [cardInfo objectForKey:@"term"];
    back.text = [cardInfo objectForKey:@"definition"];
    [card addSidesObject:front];
    [card addSidesObject:back];
    return card;
}


@end
