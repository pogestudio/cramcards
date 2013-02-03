//
//  CCCramCardVC.h
//  cramcards
//
//  Created by CA on 1/25/13.
//  Copyright (c) 2013 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CardInteractionDelegate

-(void)showAnswer;
-(void)userKnewAnswer:(BOOL)userKnew;
-(void)presentNextCard;
-(void)userKnowsCard;

@end

@class CCCardDataForShow;

@interface CCCramCardVC : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *cardLabel;
@property (strong, nonatomic) IBOutlet UIButton *skipThisCard;
@property (strong, nonatomic) IBOutlet UILabel *confirmationText;

@property (assign) BOOL shouldShowQuestion;
@property (strong) CCCardDataForShow *dataForView;

@property (weak) id<CardInteractionDelegate> delegate;

@end
