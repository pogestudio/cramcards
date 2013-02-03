//
//  SKProduct+LocalizedPrice.h
//  cramcards
//
//  Created by CA on 2/2/13.
//  Copyright (c) 2013 CC. All rights reserved.
//

#import <StoreKit/StoreKit.h>

@interface SKProduct (LocalizedPrice)

@property (nonatomic, readonly) NSString *localizedPrice;

@end
