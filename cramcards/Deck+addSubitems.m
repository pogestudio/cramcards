//
//  Deck+addSubitems.m
//  cramcards
//
//  Created by CA on 1/25/13.
//  Copyright (c) 2013 CC. All rights reserved.
//

#import "Deck+addSubitems.h"

@implementation Deck (addSubitems)

- (void)addCardsObject:(Card *)value
{
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.cards];
    [tempSet addObject:value];
    self.cards = tempSet;
}

@end
