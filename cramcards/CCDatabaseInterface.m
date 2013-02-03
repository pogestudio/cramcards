//
//  CCDatabaseInterface.m
//  cramcards
//
//  Created by CA on 1/24/13.
//  Copyright (c) 2013 CC. All rights reserved.
//

#import "CCDatabaseInterface.h"
#import "CCAppDelegate.h"

#import "Deck.h"
#import "Card.h"
#import "Side.h"

@implementation CCDatabaseInterface

static CCDatabaseInterface *_sharedInterface;

+(CCDatabaseInterface*)sharedInterface
{
    if (_sharedInterface == nil) {
        _sharedInterface = [[CCDatabaseInterface alloc] init];
    }
    return _sharedInterface;
}

+(void)saveDatabase
{
    CCAppDelegate *delegate = (CCAppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate saveContext];
}

#pragma mark Create Objects To CD
-(Deck*)newDeck
{
    Deck *newDeck = [NSEntityDescription
                     insertNewObjectForEntityForName:@"Deck"
                     inManagedObjectContext:self.managedObjectContext];
    return newDeck;
}

-(Card*)newCard
{
    Card *newCard = [NSEntityDescription
                     insertNewObjectForEntityForName:@"Card"
                     inManagedObjectContext:self.managedObjectContext];
    return newCard;
}

-(Side*)newSide
{
    Side *newSide = [NSEntityDescription
                     insertNewObjectForEntityForName:@"Side"
                     inManagedObjectContext:self.managedObjectContext];
    return newSide;
}



@end
