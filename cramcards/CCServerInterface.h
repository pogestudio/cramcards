//
//  CCServerInterface.h
//  cramcards
//
//  Created by CA on 1/24/13.
//  Copyright (c) 2013 CC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SiteToUseQuizlet = 0,
    SiteToUseFlashCardExchange,
} SiteToUse;

@protocol ServerProtocol

-(void)serverFetchFailed;

@end


@interface CCServerInterface : NSObject

-(void)pullSetWithId:(NSUInteger)setId ofSite:(SiteToUse)siteToUse andPresentResultsIn:(id<ServerProtocol>)delegate;
-(NSDictionary*)postToServer:(NSDictionary*)dictToPost toURL:(NSString*)url;

@end
