//
//  CCCardDataForShow.h
//  cramcards
//
//  Created by CA on 1/25/13.
//  Copyright (c) 2013 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Deck;

@interface CCCardDataForShow : NSObject

@property (strong) NSString *question;
@property (strong) NSString *answer;
@property (assign) NSUInteger correctlyAnswered;

-(id)initWithQuestion:(NSString*)question answer:(NSString*)answer;

@end
