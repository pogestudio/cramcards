//
//  Card.h
//  cramcards
//
//  Created by CA on 1/25/13.
//  Copyright (c) 2013 CC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Deck, Side;

@interface Card : NSManagedObject

@property (nonatomic, retain) Deck *ownerDeck;
@property (nonatomic, retain) NSOrderedSet *sides;
@end

@interface Card (CoreDataGeneratedAccessors)

- (void)insertObject:(Side *)value inSidesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSidesAtIndex:(NSUInteger)idx;
- (void)insertSides:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSidesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSidesAtIndex:(NSUInteger)idx withObject:(Side *)value;
- (void)replaceSidesAtIndexes:(NSIndexSet *)indexes withSides:(NSArray *)values;
- (void)addSidesObject:(Side *)value;
- (void)removeSidesObject:(Side *)value;
- (void)addSides:(NSOrderedSet *)values;
- (void)removeSides:(NSOrderedSet *)values;
@end
