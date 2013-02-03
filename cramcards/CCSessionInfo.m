//
//  CCSessionInfo.m
//  cramcards
//
//  Created by CA on 1/26/13.
//  Copyright (c) 2013 CC. All rights reserved.
//

#import "CCSessionInfo.h"
#import "CCCardDealer.h"
#import "CCCardDataForShow.h"

@interface CCSessionInfo ()

@end

@implementation CCSessionInfo

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutoRotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark CONTAINER interaction
-(IBAction)cancelCram
{
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)updateView
{
    [self fillInDeckStats];
    [self fillInCurrentCard];
}

#pragma mark Layout
-(void)fillInDeckStats
{
    NSUInteger numberOfCardsInDeck = [self.dealer.cardsInDataFormat count];
    NSUInteger numberOfCardsAnswered = [self.dealer numberOfCompletedCards];
    NSString *noOfCards = [NSString stringWithFormat:@"Completed: %d/%d",numberOfCardsAnswered,numberOfCardsInDeck];
    self.numberOfCardsAnswered.text = noOfCards;
    
    CGFloat allDeck = numberOfCardsInDeck;
    CGFloat answered = numberOfCardsAnswered;
    CGFloat percentage = answered/allDeck * 100;
    NSString *deckProgress = [NSString stringWithFormat:@"%0.0f%%",percentage];
    self.deckPercentage.text = deckProgress;
}

-(void)fillInCurrentCard
{
    NSUInteger correctReq = [self.dealer userPrefCorrectRequirement];
    NSUInteger cardPoints = self.dealer.currentCard.correctlyAnswered;
    NSString *noOfCards = [NSString stringWithFormat:@"Current card: %d/%d",cardPoints,correctReq];
    self.currentCardStats.text = noOfCards;
}

@end
