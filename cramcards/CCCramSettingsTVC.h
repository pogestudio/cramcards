//
//  CCCramSettingsTVC.h
//  cramcards
//
//  Created by CA on 1/24/13.
//  Copyright (c) 2013 CC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CCCramSettingsTVC : UITableViewController

@property (strong) Deck *deckToCram;

@property (strong) IBOutlet UILabel *sliceSize;
@property (strong) IBOutlet UILabel *correctAmount;

@property (strong) IBOutlet UIStepper *sizeStepper;
@property (strong) IBOutlet UIStepper *correctStepper;
@property (strong) IBOutlet UISwitch *frontSide;
@property (strong) IBOutlet UISwitch *backSide;
@property (strong) IBOutlet UISegmentedControl *order;

@end
