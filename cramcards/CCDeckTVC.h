//
//  CCDeckTVC.h
//  cramcards
//
//  Created by CA on 1/24/13.
//  Copyright (c) 2013 CC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@interface CCDeckTVC : UITableViewController <NSFetchedResultsControllerDelegate>
{
    NSDateFormatter *_tableDateFormatter;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end