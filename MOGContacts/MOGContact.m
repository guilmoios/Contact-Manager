//
//  MOGContact.m
//  MOGContacts
//
//  Created by Guilherme Mogames on 1/11/15.
//  Copyright (c) 2015 Mogames. All rights reserved.
//

#import "MOGContact.h"

@implementation MOGContact

- (void)setUserDefined:(NSDictionary *)userDefined{
    
    if(userDefined){
        _userDefined = userDefined;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDefined options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

        self.userDefinedJSON = jsonString;
    }
}


@end
