//
//  CreateContact.m
//  ContactsManager
//
//  Created by Guilherme Mogames on 1/11/15.
//  Copyright (c) 2015 Mogames. All rights reserved.
//

#import "CreateContact.h"
#import "MOGContacts.h"

@implementation CreateContact

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.formController.form = [[ContactForm alloc] init];
    
    if(self.isEditing)
        [self editContact:self.userId];
}

- (void)editContact:(int)userId{
    
    MOGContact *contact = [[MOGContacts sharedManager] getUserWithId:userId];
    
    if(contact){
        
        ContactForm *contactFormData = self.formController.form;
        
        contactFormData.firstName = contact.firstName;
        contactFormData.lastName = contact.lastName;
        contactFormData.company = contact.company;
        contactFormData.title = contact.title;
        contactFormData.phoneNumber = contact.phoneNumber;
        contactFormData.email = contact.email;
        contactFormData.userDefined = contact.userDefinedJSON;
        
    }
    
}

- (void)saveContact{
    
    ContactForm *contactFormData = self.formController.form;
    
    MOGContact *contact = [[MOGContact alloc] init];
    contact.firstName = contactFormData.firstName;
    contact.lastName = contactFormData.lastName;
    contact.company = contactFormData.company;
    contact.title = contactFormData.title;
    contact.phoneNumber = contactFormData.phoneNumber;
    contact.email = contactFormData.email;
    
    // Check if JSON is correctly formatted before adding to database
    
    if(![contactFormData.userDefined isEqualToString:@""]){
        id json;
        
        NSData *data = [contactFormData.userDefined dataUsingEncoding:NSUTF8StringEncoding];
        
        if([NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil] != nil){
            json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            // If JSON is correctly formatted, transform into NSDictionary
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            contact.userDefined = responseDict;
            
        } else{
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"The JSON format is wrong, please check and try again" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
            
            return;
        }
    }
    
    if(self.isEditing){
        
        // Set User ID
        contact.userId = self.userId;
        
        if([[MOGContacts sharedManager] updateUserWithObject:contact]){
            [[[UIAlertView alloc] initWithTitle:@"Success" message:@"User updated" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } else{
            
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Error saving user data, please try again." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        }
        
        
    } else{
        
        if([[MOGContacts sharedManager] creatUserWithObject:contact]){
            [[[UIAlertView alloc] initWithTitle:@"Success" message:@"User added to the list" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
            
            [self.navigationController popViewControllerAnimated:YES];
        } else{
            
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Error saving user data, please try again." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
            
        }
    }
    
}


@end
