//
//  CCDeckFactory.h
//  cramcards
//
//  Created by CA on 1/24/13.
//  Copyright (c) 2013 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCDeckFactory : NSObject

+(CCDeckFactory*)sharedFactory;

-(void)createDeckFromFlashexchangeWithDict:(NSDictionary *)dictWithDeck;
-(void)createDeckFromQuizletWithDict:(NSDictionary *)dictWithDeck;

@end
