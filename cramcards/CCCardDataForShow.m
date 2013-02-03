//
//  CCCardDataForShow.m
//  cramcards
//
//  Created by CA on 1/25/13.
//  Copyright (c) 2013 CC. All rights reserved.
//

#import "CCCardDataForShow.h"

@implementation CCCardDataForShow

-(id)initWithQuestion:(NSString *)question answer:(NSString *)answer
{
    self = [super init];
    if (self) {
        self.question = question;
        self.answer = answer;
        self.correctlyAnswered = 0;
    }
    
    return self;
}

@end
