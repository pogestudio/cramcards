//
//  InAppPurchaseDetails.m
//  cramcards
//
//  Created by CA on 2/2/13.
//  Copyright (c) 2013 CC. All rights reserved.
//

#import "InAppPurchaseDetails.h"
#import "NSDate+Compare.h"

@implementation InAppPurchaseDetails

+(BOOL)shouldAdvertisementsBeRemoved
{
    NSString *transactionId = @"com.pogestudio.cramcards.removeads";
    NSString *dateIdentifier = [NSString stringWithFormat:@"%@.purchaseDate",transactionId];
    NSDate *purchaseDate = [[NSUserDefaults standardUserDefaults] valueForKey:dateIdentifier];
    NSTimeInterval oneDay = 60 * 60 * 24;
    NSTimeInterval sixMonthsTime = 178 * oneDay;
    NSDate *sixMonthsAfterPurchase = [purchaseDate dateByAddingTimeInterval:sixMonthsTime];
    BOOL sixMonthsHasNotPassed = [[NSDate date] isEarlierThan:sixMonthsAfterPurchase];
    return sixMonthsHasNotPassed;
}



@end
