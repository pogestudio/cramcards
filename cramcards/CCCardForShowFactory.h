//
//  CCCardForShowFactory.h
//  cramcards
//
//  Created by CA on 1/25/13.
//  Copyright (c) 2013 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Deck;

@interface CCCardForShowFactory : NSObject

@property (strong) NSDictionary *settings;

-(NSArray*)createDataFromDeck:(Deck *)deck settings:(NSDictionary *)settings;

@end
