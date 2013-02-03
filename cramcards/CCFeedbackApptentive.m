//
//  CCFeedbackApptentive.m
//  cramcards
//
//  Created by CA on 2/4/13.
//  Copyright (c) 2013 CC. All rights reserved.
//

#import "CCFeedbackApptentive.h"
#import "ATConnect.h"

@interface CCFeedbackApptentive ()

@end

@implementation CCFeedbackApptentive

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)showFeedback:(id)sender
{
    ATConnect *connection = [ATConnect sharedConnection];
    [connection presentFeedbackControllerFromViewController:self];
}

@end
