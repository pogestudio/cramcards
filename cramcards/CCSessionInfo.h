//
//  CCSessionInfo.h
//  cramcards
//
//  Created by CA on 1/26/13.
//  Copyright (c) 2013 CC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CCCardDealer;

@interface CCSessionInfo : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *numberOfCardsAnswered;
@property (strong, nonatomic) IBOutlet UILabel *currentCardStats;
@property (strong, nonatomic) IBOutlet UILabel *deckPercentage;
@property (strong) CCCardDealer *dealer;

-(void)updateView;
@end
