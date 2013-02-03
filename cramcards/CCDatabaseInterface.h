//
//  CCDatabaseInterface.h
//  cramcards
//
//  Created by CA on 1/24/13.
//  Copyright (c) 2013 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Deck;
@class Card;
@class Side;

@interface CCDatabaseInterface : NSObject


@property (strong) NSManagedObjectContext *managedObjectContext;

+(CCDatabaseInterface*)sharedInterface;
+(void)saveDatabase;

-(Deck*)newDeck;
-(Card*)newCard;
-(Side*)newSide;


@end
