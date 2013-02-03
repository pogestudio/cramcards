//
//  Card+addSubitems.m
//  cramcards
//
//  Created by CA on 1/25/13.
//  Copyright (c) 2013 CC. All rights reserved.
//

#import "Card+addSubitems.h"

@implementation Card (addSubitems)

- (void)addSidesObject:(Side *)value
{
    NSMutableOrderedSet* tempSet = [NSMutableOrderedSet orderedSetWithOrderedSet:self.sides];
    [tempSet addObject:value];
    self.sides = tempSet;
}
@end
