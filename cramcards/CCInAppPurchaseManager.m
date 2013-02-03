//
//  CCInAppPurchaseManager.m
//  cramcards
//
//  Created by CA on 2/2/13.
//  Copyright (c) 2013 CC. All rights reserved.
//

#import "CCInAppPurchaseManager.h"
#import "CCServerInterface.h"

#import "NSData+Base64.h"

@implementation CCInAppPurchaseManager

+ (CCInAppPurchaseManager *)sharedInstance {
    static dispatch_once_t once;
    static CCInAppPurchaseManager * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"com.pogestudio.cramcards.removeads",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

#pragma mark Overriding

-(void)completeTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"completeTransaction...");
    
    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [self storeExpirationDateInUserDefaultsForTransaction:transaction];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"restoreTransaction...");
    
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [self storeExpirationDateInUserDefaultsForTransaction:transaction.originalTransaction];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    
    [_purchasedProductIdentifiers addObject:productIdentifier];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
    
}

#pragma mark Get Receipt
-(void)storeExpirationDateInUserDefaultsForTransaction:(SKPaymentTransaction*)transaction;
{
//    NSData *transactionReceipt = transaction.transactionReceipt;
//    NSString *encodedReceipt = [transactionReceipt base64EncodedString];
//    NSString *urlToPost = @"https://buy.itunes.apple.com/verifyReceipt";
//    NSString *sandboxurl = @"https://sandbox.itunes.apple.com/verifyReceipt";
//    NSDictionary *dictToPost = [NSDictionary dictionaryWithObject:encodedReceipt forKey:@"receipt-data"];
//    NSDictionary *response = [[[CCServerInterface alloc] init] postToServer:dictToPost toURL:sandboxurl];
//    NSLog(@"%@",response);
//    NSNumber *statusOfResponse = [response valueForKey:@"status"];
//    if ([statusOfResponse intValue] != 0) {
//        NSLog(@"Something is wrong! The receipt is invalid!");
//        return;
//    }
//    
//    NSDictionary *receipt = [response valueForKey:@"receipt"];
//    NSLog(@"%@",receipt);
    
    NSString *productId = transaction.payment.productIdentifier;
    NSString *dateIdentifier = [NSString stringWithFormat:@"%@.purchaseDate",productId];
    NSDate *transactionDate = transaction.transactionDate;
    [[NSUserDefaults standardUserDefaults] setObject:transactionDate forKey:dateIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    
}


@end
