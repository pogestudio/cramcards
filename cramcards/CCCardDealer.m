//
//  CCCardDealer.m
//  cramcards
//
//  Created by CA on 1/26/13.
//  Copyright (c) 2013 CC. All rights reserved.
//

#import "CCCardDealer.h"
#import "CCCardForShowFactory.h"
#import "CCCardDataForShow.h"
#import "CCDatabaseInterface.h"

#import "Deck.h"
#import "Card.h"

@implementation CCCardDealer

-(id)initWithDeck:(Deck*)deck settings:(NSDictionary*)settings
{
    self = [super init];
    if (self) {
        self.deckWhichIsBeingCrammed = deck;
        self.cramSettings = settings;
        [self fillData];
    }
    return self;
}


-(void)fillData
{
    CCCardForShowFactory *factory = [[CCCardForShowFactory alloc] init];
    self.cardsInDataFormat = [factory createDataFromDeck:self.deckWhichIsBeingCrammed settings:self.cramSettings];
}

-(void)deckIsComplete
{
    self.deckWhichIsBeingCrammed.mostRecentCompletionDate = [NSDate date];
    [CCDatabaseInterface saveDatabase];
}

#pragma mark Settings
-(NSUInteger)userPrefSliceSize
{
    NSUInteger sliceSize = [[self.cramSettings objectForKey:@"sliceSize"] intValue];
    return sliceSize;
}

-(NSUInteger)userPrefCorrectRequirement
{
    return [[self.cramSettings objectForKey:@"requiredCorrects"] intValue];
}

#pragma mark Interaction With Cram Container
-(CCCardDataForShow*)nextCard
{
    CCCardDataForShow *nextCard;
    if (!self.currentCard && [self.cardsInDataFormat count] > 0) {
        nextCard = [self.cardsInDataFormat objectAtIndex:0];
    }
    else if([self.cardsInDataFormat count] > 0) {
        nextCard = [self calculateNextCard];
    }
    self.currentCard = nextCard;
    return nextCard;
}

-(void)userKnewAnswer:(BOOL)userKnew
{
    if (userKnew) {
        self.currentCard.correctlyAnswered++;
    } else {
        self.currentCard.correctlyAnswered = 0;
    }
}


-(void)markCardAsKnown
{
    NSUInteger numberOfCorrectAnswersReq = [self userPrefCorrectRequirement];
    self.currentCard.correctlyAnswered = numberOfCorrectAnswersReq;
}

#pragma mark CCSessionInfo
-(NSUInteger)numberOfCompletedCards
{
    NSUInteger numberOfCards = [self.cardsInDataFormat count];
    CCCardDataForShow *lastobject = [self.cardsInDataFormat lastObject];
    NSUInteger numberOfIncorrectCards = [self numberOfUnansweredCardsBeforeAndIncluding:lastobject];
    NSUInteger numberOfCorrectCards = numberOfCards - numberOfIncorrectCards;
    return numberOfCorrectCards;
}

#pragma mark Card Logic
-(CCCardDataForShow*)calculateNextCard
{    
    //check how many cards there are who is not "complete" before the current card
    NSUInteger numberOfUnanswered = [self numberOfUnansweredCardsBeforeAndIncluding:self.currentCard];

    CCCardDataForShow *returnCard;
    NSUInteger sliceSize = [self userPrefSliceSize];
    //if there are less than the sliceSize'
    //and it's not the last one
    //then present the next unanswered card after the current card
    BOOL thisIsTheLastObject = self.currentCard == [self.cardsInDataFormat lastObject];
    if (numberOfUnanswered < sliceSize && !thisIsTheLastObject) {
        returnCard = [self firstIncompleteCardFrom:self.currentCard];
    } else {
        returnCard = [self firstIncompleteCardFrom:nil];
    }
    //if there are the same number as the slicesize, then present the first unanswered card
    //if we meet the end, present the first unanswered card
    if (!returnCard) {
        [self firstIncompleteCardFrom:nil];
    }
    return returnCard;

}

-(NSUInteger)numberOfUnansweredCardsBeforeAndIncluding:(CCCardDataForShow*)card
{
    NSUInteger numberOfUnanswered = 0;
    for (CCCardDataForShow *cardFromStack in self.cardsInDataFormat) {
        
        if (![self isCardCorrectlyAnswered:cardFromStack]) {
            numberOfUnanswered++;
        }
        if (cardFromStack == card) {
            break;
        }
    }
    return numberOfUnanswered;
}

-(CCCardDataForShow*)firstIncompleteCardFrom:(CCCardDataForShow*)startingPoint
{
    NSUInteger indexOfStartingPoint;
    if (startingPoint) {
        indexOfStartingPoint = [self.cardsInDataFormat indexOfObject:startingPoint] + 1;
    } else {
        indexOfStartingPoint = 0;
    }    
    CCCardDataForShow *incompletlyAnswered;
    for (NSUInteger index = indexOfStartingPoint; index < [self.cardsInDataFormat count]; index++)
    {
        CCCardDataForShow *card = [self.cardsInDataFormat objectAtIndex:index];
        if (![self isCardCorrectlyAnswered:card]) {
            incompletlyAnswered = card;
            break;
        } 
    }
    return incompletlyAnswered;
    
}
-(BOOL)isCardCorrectlyAnswered:(CCCardDataForShow*)card
{
    NSUInteger numberOfTimesEachCardShouldBeAnswered = [self userPrefCorrectRequirement];
    BOOL isCorrectlyAnswered = card.correctlyAnswered == numberOfTimesEachCardShouldBeAnswered;
    return isCorrectlyAnswered;
}

-(BOOL)isCurrentCardDone
{
    BOOL currentCardIsDone = [self isCardCorrectlyAnswered:self.currentCard];
    return currentCardIsDone;
}


@end
