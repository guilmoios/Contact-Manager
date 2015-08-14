//
//  ContactForm.m
//  ContactsManager
//
//  Created by Guilherme Mogames on 1/11/15.
//  Copyright (c) 2015 Mogames. All rights reserved.
//

#import "ContactForm.h"

@implementation ContactForm

- (NSArray *)extraFields
{
    return @[
             
             @{FXFormFieldTitle: @"Submit", FXFormFieldHeader: @"", FXFormFieldAction: @"saveContact"},
             
             ];
}

- (NSDictionary *)userDefinedField{
    
    return @{FXFormFieldType: FXFormFieldTypeLongText, FXFormFieldPlaceholder: @"{\"id\":\"value\"}"};
    
}

@end
