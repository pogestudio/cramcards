//
//  CCAddDeckTVC.h
//  cramcards
//
//  Created by CA on 1/30/13.
//  Copyright (c) 2013 CC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCServerInterface.h"


@interface CCAddDeckTVC : UITableViewController <UIAlertViewDelegate,ServerProtocol>
{
    @private
    SiteToUse _siteToUse;
}

-(void)downloadSetWithId:(NSUInteger)setId siteType:(SiteToUse)siteToUse;

@end
