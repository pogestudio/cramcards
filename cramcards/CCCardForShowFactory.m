//
//  CCCardForShowFactory.m
//  cramcards
//
//  Created by CA on 1/25/13.
//  Copyright (c) 2013 CC. All rights reserved.
//

#import "CCCardForShowFactory.h"

#import "CCCardDataForShow.h"
#import "Deck.h"
#import "Card.h"
#import "Side.h"

@implementation CCCardForShowFactory

-(NSArray*)createDataFromDeck:(Deck *)deck settings:(NSDictionary *)settings
{
    self.settings = settings;
    
    NSMutableArray *newData = [[NSMutableArray alloc] init];
    if ([self shouldCramFrontToBack]) {
        [self dataToArray:newData fromDeck:deck reverseFrontAndBack:NO];
    }

    if ([self shouldCramBackToFront]) {
        [self dataToArray:newData fromDeck:deck reverseFrontAndBack:YES];
    }
    
    if ([self shouldReverseOrder]) {
        newData = [NSMutableArray arrayWithArray:[[newData reverseObjectEnumerator] allObjects]];
    } else if ([self shouldRandomizeOrder]) {
        [self doTheKnuthShuffleOn:newData];
    }
    return newData;
}

-(void)dataToArray:(NSMutableArray*)data fromDeck:(Deck*)deck reverseFrontAndBack:(BOOL)reverseFrontAndBack
{
    for (Card *card in deck.cards) {
        NSUInteger indexOfFront = reverseFrontAndBack ? 1 : 0;
        NSUInteger indexOfBack = 1 - indexOfFront;
        Side *frontSide = [card.sides objectAtIndex:indexOfFront];
        Side *backSide = [card.sides objectAtIndex:indexOfBack];
        NSString *question = frontSide.text;
        NSString *answer = backSide.text;
        CCCardDataForShow *dataForCard = [[CCCardDataForShow alloc] initWithQuestion:question answer:answer];
        [data addObject:dataForCard];
    }
    
}

-(void)doTheKnuthShuffleOn:(NSMutableArray*)arrayToWorkWith
{
    // the Knuth shuffle
    
    for (NSInteger i = [arrayToWorkWith count]-1; i > 0; i--)
    {
        [arrayToWorkWith exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform(i+1)];
    }
}

#pragma mark Settings
-(BOOL)shouldCramFrontToBack
{
    NSNumber *frontSide = [self.settings valueForKey:@"askFront"];
    BOOL shouldCramFrontToBack = [frontSide boolValue];
    return shouldCramFrontToBack;
}

-(BOOL)shouldCramBackToFront
{
    NSNumber *backSide = [self.settings valueForKey:@"askBack"];
    BOOL shouldCramBackToFront = [backSide boolValue];
    return shouldCramBackToFront;
}

-(BOOL)shouldReverseOrder
{
    NSNumber *shouldReverseOrder = [self.settings valueForKey:@"order"];
    NSUInteger reverseId = 2;
    BOOL shouldReverse = [shouldReverseOrder intValue] == reverseId;
    return shouldReverse;
}

-(BOOL)shouldRandomizeOrder
{
    NSNumber *shouldRandomizeOrder = [self.settings valueForKey:@"order"];
    NSUInteger randomiseId = 1;
    BOOL shouldRandomize = [shouldRandomizeOrder intValue] == randomiseId;
    return shouldRandomize;
}
@end
