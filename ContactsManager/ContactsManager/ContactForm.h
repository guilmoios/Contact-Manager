//
//  ContactForm.h
//  ContactsManager
//
//  Created by Guilherme Mogames on 1/11/15.
//  Copyright (c) 2015 Mogames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FXForms/FXForms.h>

@interface ContactForm : NSObject <FXForm>

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *userDefined;

@end
