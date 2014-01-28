//
//  CCCramCardVC.m
//  cramcards
//
//  Created by CA on 1/25/13.
//  Copyright (c) 2013 CC. All rights reserved.
//

#import "CCCramCardVC.h"

#import "CCCardDataForShow.h"
#import "UILabel+sizeToFit.h"

#define MAX_QUESTION_FONT_SIZE 30
#define MAX_ANSWER_FONT_SIZE 22
#define DEAD_ZONE_IN_MIDDLE 40

typedef enum {
    TapLocationINVALID = 0,
    TapLocationLeft,
    TapLocationRight,
    TapLocationPassButton,
} TapLocation;

@interface CCCramCardVC ()

@end

@implementation CCCramCardVC

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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupView];
}

-(void)viewDidLayoutSubviews
{
    CGFloat maxFontSize;
    if (self.shouldShowQuestion) {
        maxFontSize = MAX_QUESTION_FONT_SIZE;
    } else {
        maxFontSize = MAX_ANSWER_FONT_SIZE;
    }
    [self.cardLabel sizeFontToFitCurrentFrameStartingAt:maxFontSize];
}
#pragma mark UI Interaction
-(IBAction)answerButtonWasPressed:(id)sender
{
    NSAssert([sender isKindOfClass:[UIButton class]],@"wrong control trying to access answerbyttonwaspressed");
    UIButton *pressedButton = (UIButton*)sender;
    NSUInteger knewAnswerTag = 1;
    BOOL userKnewAnswer;
    if (pressedButton.tag == knewAnswerTag) {
        userKnewAnswer = YES;
    } else {
        userKnewAnswer = NO;
    }
    [self.delegate userKnewAnswer:userKnewAnswer];
    [self.delegate presentNextCard];
}

#pragma mark Set Up View
-(void)setupView
{
    [self setUpTextLabel];
    
    if (!self.shouldShowQuestion) {
        [self.skipThisCard setHidden:NO];
        self.cardLabel.font = [UIFont fontWithName:@"Helvetica" size:19];
        
    } else {
        self.cardLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:19];
    }
}

-(void)setUpTextLabel
{
    NSString *textForView;
    if (self.shouldShowQuestion) {
        textForView = self.dataForView.question;
    } else {
        textForView = self.dataForView.answer;
    }
    self.cardLabel.text = textForView;
}

-(IBAction)skipThisCard:(id)sender
{
    NSAssert1([sender isKindOfClass:[UIButton class]], @"wrong sender to skipcard", nil);
    UIButton *skip = (UIButton*)sender;
    NSUInteger skipTag = 99;
    if (skip.tag == skipTag) {
        [self.delegate userKnowsCard];
        [self.delegate presentNextCard];
    } else {
        skip.tag = skipTag;
        [self slideInConfirmationText];
    }
}

-(void)slideInConfirmationText
{
    CGFloat bounceDistance = 20;
    CGRect newFrame = CGRectMake(self.confirmationText.frame.origin.x - (self.confirmationText.frame.size.width + bounceDistance + 20),
                                 self.confirmationText.frame.origin.y,
                                 self.confirmationText.frame.size.width,
                                 self.confirmationText.frame.size.height);
    CGRect bounceBackFrame = CGRectMake(newFrame.origin.x + bounceDistance,
                                        newFrame.origin.y,
                                        newFrame.size.width,
                                        newFrame.size.height);
    [UIView animateWithDuration:0.1
                     animations:^(void) {
                         [self.confirmationText setAlpha:1];
                         self.confirmationText.frame = newFrame; }
                     completion:^(BOOL finished) {
                         [self.skipThisCard setTitle:@"YES" forState:UIControlStateNormal];
                         [UIView animateWithDuration:0.1 animations:^(void){
                             self.confirmationText.frame = bounceBackFrame;
                         }];
                     }];
}

-(void)adjustViewForBottombarOfHeight:(CGFloat)pixelsToMoveContentUp
{
    [UIView animateWithDuration:0.5 animations:^{
        self.skipThisCard.frame = CGRectOffset(self.skipThisCard.frame, 0, -pixelsToMoveContentUp);
        self.confirmationText.frame = CGRectOffset(self.confirmationText.frame, 0, -pixelsToMoveContentUp);
    }];
}

#pragma mark Handle Screen Taps
-(IBAction)screenWasTapped:(id)sender
{
    NSAssert1([sender isKindOfClass:[UITapGestureRecognizer class]], @"wrong sender to screentap", nil);
    if (self.shouldShowQuestion) {
        [self.delegate showAnswer];
    } else {
        UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
        [self interpretTapAndTakeAction:tap];
    }
}

-(void)interpretTapAndTakeAction:(UITapGestureRecognizer*)tap
{
    TapLocation locationOfTap = [self tapWasRightSideOfScreen:tap];
    switch (locationOfTap) {
        case TapLocationINVALID:
        {
            //Do nothing
            break;
        }
        case TapLocationLeft:
        {
            [self.delegate userKnewAnswer:NO];
            [self.delegate presentNextCard];
            break;
        }
        case TapLocationRight:
        {
            [self.delegate userKnewAnswer:YES];
            [self.delegate presentNextCard];
            break;
        }
        case TapLocationPassButton:
        {
            [self.skipThisCard sendActionsForControlEvents:UIControlEventTouchUpInside];
            break;
        }
        default:
            NSAssert1(nil, @"received weird taplocation from tapinterpreter", nil);
            break;
    }
}

-(TapLocation)tapWasRightSideOfScreen:(UITapGestureRecognizer*)tap
{
    CGPoint locationOfTap = [tap locationInView:self.view];
    
    TapLocation location;
    if (CGRectContainsPoint(self.skipThisCard.frame, locationOfTap)) {
//        [self slideInConfirmationText];
        location = TapLocationPassButton;
    } else if (locationOfTap.x >= (self.view.frame.size.width + DEAD_ZONE_IN_MIDDLE)/2) {
        location = TapLocationRight;
    } else if (locationOfTap.x <= (self.view.frame.size.width - DEAD_ZONE_IN_MIDDLE)/2)
    {
        location = TapLocationLeft;
    } else {
        location = TapLocationINVALID;
    }
    return location;
}

@end
