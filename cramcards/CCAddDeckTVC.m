//
//  CCAddDeckTVC.m
//  cramcards
//
//  Created by CA on 1/30/13.
//  Copyright (c) 2013 CC. All rights reserved.
//

#import "CCAddDeckTVC.h"


@interface CCAddDeckTVC ()

@end

@implementation CCAddDeckTVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)askForIdToSite:(SiteToUse)siteToUse
{
    NSString *site = siteToUse == SiteToUseFlashCardExchange ? @"FlashcardExchange" : @"Quizlet";
    NSString *wholeString = [NSString stringWithFormat:@"Add the ID from %@",site];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter ID" message:wholeString
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
	alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    [alert show];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SiteToUse rowWhichWasPressed = indexPath.row;
    _siteToUse = rowWhichWasPressed;
    [self askForIdToSite:_siteToUse];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //we clicked cancel
        return;
    }
    NSString *userInput = [alertView textFieldAtIndex:0].text;
    NSUInteger setId = [userInput intValue];
    [self downloadSetWithId:setId siteType:_siteToUse];

}

#pragma mark Data Related
-(void)downloadSetWithId:(NSUInteger)setId siteType:(SiteToUse)siteToUse
{
    CCServerInterface *server = [[CCServerInterface alloc] init];
    [server pullSetWithId:setId ofSite:siteToUse andPresentResultsIn:self];
}

#pragma mark Server Protocol
-(void)serverFetchFailed
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"The fetch did not succeed, either it timed out or the SetId was incorrect/not public"
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];
}
@end
