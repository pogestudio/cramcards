//
//  CCServerInterface.m
//  cramcards
//
//  Created by CA on 1/24/13.
//  Copyright (c) 2013 CC. All rights reserved.
//

#import "CCServerInterface.h"
#import "CCDeckFactory.h"

#import "NSDictionary+JSON.h"

@implementation CCServerInterface

dispatch_queue_t queue;

-(id)init
{
    self = [super init];
    if (self) {
        queue = dispatch_queue_create("com.pogestudio.queue", nil);
    }
    return self;
}


-(NSDictionary*)getSetFromFlashcardExchangeWithId:(NSUInteger)setId;
{
    static NSString *CLIENT_ID = @"5484e9e4a6755ea35212a2565465ecb8";
    NSString *urlForPull = [NSString stringWithFormat:@"https://api.flashcardexchange.com/v2/sets/%d?client_id=%@",setId,CLIENT_ID];
    NSArray *dataFromPull = (NSArray*)[NSDictionary dictionaryWithContentsOfJSONURLString:urlForPull];
    NSDictionary *extractedData = (NSDictionary*)[dataFromPull objectAtIndex:0];
    return extractedData;
}

-(NSDictionary*)getSetFromQuizletWithId:(NSUInteger)setId
{
    static NSString *CLIENT_ID = @"aU9X5aSAQv";
    NSString *urlForPull = [NSString stringWithFormat:@"https://api.quizlet.com/2.0/sets/%d?client_id=%@",setId,CLIENT_ID];
    NSDictionary *dataFromPull = [NSDictionary dictionaryWithContentsOfJSONURLString:urlForPull];
    return dataFromPull;
}

-(NSDictionary*)getSetId:(NSUInteger)setId fromSite:(SiteToUse)siteToUse
{
    NSDictionary *results;
    switch (siteToUse) {
        case SiteToUseFlashCardExchange:
        {
            results = [self getSetFromFlashcardExchangeWithId:setId];
            break;
        }
        case SiteToUseQuizlet:
        {
            results = [self getSetFromQuizletWithId:setId];
            break;
        }
        default:
            NSAssert1(nil, @"we have errors in which site to use, in serverinterface", nil);
            break;
    }
    return results;
}

-(void)turnIntoDeckInDatabase:(NSDictionary*)data ForSiteData:(SiteToUse)siteToUse
{
    switch (siteToUse) {
        case SiteToUseFlashCardExchange:
        {
            [[CCDeckFactory sharedFactory] createDeckFromFlashexchangeWithDict:data];
            break;
        }
        case SiteToUseQuizlet:
        {
            [[CCDeckFactory sharedFactory] createDeckFromQuizletWithDict:data];
            break;
        }
        default:
            NSAssert1(nil, @"we have errors in which site to use, in serverinterface", nil);
            break;
    }
}


-(void)pullSetWithId:(NSUInteger)setId ofSite:(SiteToUse)siteToUse andPresentResultsIn:(id<ServerProtocol>)delegate
{
    dispatch_async(queue, ^{
        NSDictionary *dictOfPull = [self getSetId:setId fromSite:siteToUse];
           dispatch_async(dispatch_get_main_queue(), ^{
               if (dictOfPull) {
                   [self turnIntoDeckInDatabase:dictOfPull ForSiteData:siteToUse];
               } else {
                   [delegate serverFetchFailed];
               }
    });
    });
}

-(NSDictionary*)postToServer:(NSDictionary*)dictToPost toURL:(NSString*)url
{
    NSURL *postUrl = [NSURL URLWithString:url];
    NSData *JSONData = [dictToPost toJSON];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [JSONData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:JSONData];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary* resultFromServer;
    
    if (result != nil) {
        resultFromServer = [NSJSONSerialization
                            JSONObjectWithData:result
                            options:kNilOptions
                            error:nil];
    }
    
    if (error != nil) {
        NSLog(@"ERROR: %@",error);
    }
    
    return resultFromServer;
}


@end
