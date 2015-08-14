//
//  CreateContact.h
//  ContactsManager
//
//  Created by Guilherme Mogames on 1/11/15.
//  Copyright (c) 2015 Mogames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactForm.h"

@interface CreateContact : FXFormViewController

@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, assign) int userId;

@end
