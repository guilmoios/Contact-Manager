//
//  ViewController.m
//  ContactsManager
//
//  Created by Guilherme Mogames on 1/11/15.
//  Copyright (c) 2015 Mogames. All rights reserved.
//

#import "ViewController.h"
#import "MOGContacts.h"
#import "CreateContact.h"

@interface ViewController (){
    NSMutableArray *_users;
    UITableView *_tableView;
}
@end

static NSString *cellIdentifier;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"Contacts";
    
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    
    cellIdentifier = @"item";
    
    _users = [[MOGContacts sharedManager] getUsers];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    _tableView.allowsMultipleSelectionDuringEditing = NO;
    
    UIBarButtonItem *addNewContact = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addContact)];
    
    self.navigationItem.rightBarButtonItem = addNewContact;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    _users = [[MOGContacts sharedManager] getUsers];
    [_tableView reloadData];
}

- (void)addContact{
    
    CreateContact *createContact = [[CreateContact alloc] init];
    [self.navigationController pushViewController:createContact animated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[_users objectAtIndex:indexPath.row][@"firstName"],[_users objectAtIndex:indexPath.row][@"lastName"]];;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CreateContact *editUser = [[CreateContact alloc] init];
    editUser.isEditing = YES;
    editUser.userId = [[_users objectAtIndex:indexPath.row][@"id"] intValue];
    [self.navigationController pushViewController:editUser animated:YES];
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if([[MOGContacts sharedManager] deleteUserWithID:[[_users objectAtIndex:indexPath.row][@"id"] intValue]]){
            _users = [[MOGContacts sharedManager] getUsers];
            [_tableView reloadData];
            [[[UIAlertView alloc] initWithTitle:@"Success" message:@"User deleted" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
            
        } else{
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Error saving user data, please try again." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        }
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
