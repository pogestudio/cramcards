//
//  NSDictionary+JSON.h
//  ATC
//
//  Created by CA on 11/20/12.
//  Copyright (c) 2012 CA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSON)

+(NSDictionary*)dictionaryWithContentsOfJSONURLString:(NSString*)urlAddress;                            //fetch dictionary of data from the URL address using built in JSON
-(NSData*)toJSON;                                                                                       //if we have NSData, turn it into a NSJSONSERIALIZE OBject.

@end
