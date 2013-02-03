//
//  CCCramSettingsTVC.m
//  cramcards
//
//  Created by CA on 1/24/13.
//  Copyright (c) 2013 CC. All rights reserved.
//

#import "CCCramSettingsTVC.h"
#import "CCCramContainerVC.h"

typedef enum {
    SettingToolSliceSizeStepper = 0,
    SettingToolSliceCorrectStepper,
    SettingToolFrontSwitch,
    SettingToolBackSwitch,
    SettingToolOrderSeg,
} SettingToolTag;

@interface CCCramSettingsTVC ()

@end

@implementation CCCramSettingsTVC

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateValuesInLabels];
}

#pragma mark Layout
-(void)updateValuesInLabels
{
    self.sliceSize.text = [NSString stringWithFormat:@"%0.0f",self.sizeStepper.value];
    self.correctAmount.text = [NSString stringWithFormat:@"%0.0f",self.correctStepper.value];
}

#pragma mark Data Catching
-(IBAction)valueChangedForTool:(id)sender
{
    NSAssert([sender isKindOfClass:[UIControl class]], @"weird item calling value-changed function");
    UIControl *senderControl = (UIControl*)sender;
    SettingToolTag senderType = senderControl.tag;
    switch (senderType) {
        case SettingToolSliceSizeStepper:
        {
            
        }
        case SettingToolSliceCorrectStepper:
        {
            [self updateValuesInLabels];
            break;
        }
        default:
            NSAssert1(nil,@"Should never be here, something is wrong with valueChanged", nil);
            break;
    }
}
#pragma mark Value handling
-(NSDictionary*)dictOfSettings
{
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    NSNumber *sliceSize = [NSNumber numberWithInt:[self.sizeStepper value]];
    [settings setValue:sliceSize forKey:@"sliceSize"];
    NSNumber *correctAmount = [NSNumber numberWithInt:[self.correctStepper value]];
    [settings setValue:correctAmount forKey:@"requiredCorrects"];
    NSNumber *showFront = [NSNumber numberWithBool:self.frontSide.isOn];
    [settings setValue:showFront forKey:@"askFront"];
    NSNumber *showBack = [NSNumber numberWithBool:self.backSide.isOn];
    [settings setValue:showBack forKey:@"askBack"];
    NSNumber *order = [NSNumber numberWithInt:self.order.selectedSegmentIndex];
    [settings setValue:order forKey:@"order"];
    return settings;
}

-(IBAction)switchValueChanged:(id)sender
{
    NSAssert([sender isKindOfClass:[UISwitch class]], @"arong sender to switch-value-checking");
    UISwitch *switchWhichWasChanged = (UISwitch*)sender;
    //make sure that at least one of them is on, so the deck isn't empty.
    if (switchWhichWasChanged == self.frontSide && !self.backSide.isOn) {
        [self.backSide setOn:YES animated:YES];
    }
    if (switchWhichWasChanged == self.backSide && !self.frontSide.isOn) {
        [self.frontSide setOn:YES animated:YES];
    }
}


#pragma mark Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"startCrammingSegue"]) {
        CCCramContainerVC *destinationVC = segue.destinationViewController;
        [destinationVC setUpCramForDeck:self.deckToCram withSettings:[self dictOfSettings]];
    }
}

@end
