//
//  Side.h
//  cramcards
//
//  Created by CA on 1/25/13.
//  Copyright (c) 2013 CC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Card;

@interface Side : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) Card *ownerCard;

@end
