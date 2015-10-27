//
// Copyright (C) 2003-2015 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
//


#import "AccountViewController.h"
#import "share_extension-Swift.h"
#import "AccountManager.h"

#define SELECTED_ACCOUNT_BG_COLOR [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0]
#define EDITING_ACCOUNT_BG_COLOR [UIColor colorWithRed:250.0/255.0 green:193.0/255.0 blue:0.0/255.0 alpha:1.0]

#define EDIT_ACCOUNT_SEGUE @"ShowAccountInfo"
#define kTableCellHeight 50.0
@interface AccountViewController ()

@end

@implementation AccountViewController
@synthesize delegate;


- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewWillAppear:(BOOL)animated {
    self.navigationItem.title = NSLocalizedString(@"Select an account",nil);
}

-(void) viewWillDisappear:(BOOL)animated {
 
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([AccountManager sharedManager].allAccount){
        return [AccountManager sharedManager].allAccount.count;
    }
    return 0;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return kTableCellHeight;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Account * account = [AccountManager sharedManager].allAccount[indexPath.row];
    if (account == [AccountManager sharedManager].selectedAccount) {
        ((AccountCell*)cell).selectedAccountIndicator.hidden = NO;
        cell.backgroundColor = SELECTED_ACCOUNT_BG_COLOR;
    } else {
        ((AccountCell*)cell).selectedAccountIndicator.hidden = YES;
        cell.backgroundColor = [UIColor whiteColor];

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AccountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountCell" forIndexPath:indexPath];
    Account * account = [AccountManager sharedManager].allAccount[indexPath.row];
    cell.serverNameLabel.text = account.natureName;
    
    NSString * detailText = @"";

    if (account.userName.length > 0) {
        detailText = [NSString stringWithFormat:@"%@: '%@' ", NSLocalizedString(@"Username", nil), account.userName];
        if (account.password.length == 0) {
            detailText = [detailText stringByAppendingString:NSLocalizedString(@"Password: Unknown", nil)];
        }
    } else {
        detailText = NSLocalizedString(@"Needed username & password", nil);
    }
    
    cell.usernameDetailLabel.text = detailText;// [NSString stringWithFormat:@"Username: %@", account.userName];


    //add edit button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0f, 0.0f, 50.0f, 30.0f);
    [button setTitle:NSLocalizedString(@"Edit",nil) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    button.layer.cornerRadius = 5.0;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.borderWidth = 0.5;
    button.titleLabel.font = [UIFont systemFontOfSize:12.0];
    
    [button addTarget:self action:@selector(performEditAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.accessoryType =UITableViewCellAccessoryNone; // UITableViewCellAccessoryDetailButton;
//    cell.accessoryView = button;
    
    return cell;
}

-(void) performEditAction:(UIButton* ) sender {
    
    UITableViewCell *ownerCell = (UITableViewCell*)sender.superview;
    while (![ownerCell isKindOfClass:[UITableViewCell class]]){
        ownerCell =(UITableViewCell*)ownerCell.superview;
    }
    if (ownerCell!=nil){
        [self performSegueWithIdentifier:EDIT_ACCOUNT_SEGUE sender: ownerCell];
    }
    
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"Edit",nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [self performSegueWithIdentifier:EDIT_ACCOUNT_SEGUE sender: [tableView cellForRowAtIndexPath:indexPath]];
    }];
    editAction.backgroundColor = EDITING_ACCOUNT_BG_COLOR;
    return @[editAction];
}
-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Account * account = [AccountManager sharedManager].allAccount[indexPath.row];
    // The account is selected, if this account have a password configured: go back to ShareVC, if not: Popup a message alert to ask user to configure the password for this account. 
    if (account.userName.length > 0 && account.password.length >0){
        if (delegate && [delegate respondsToSelector:@selector(accountSelector:didSelectAccount:)]) {
            [delegate accountSelector:self didSelectAccount:account];
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        [self performSegueWithIdentifier:EDIT_ACCOUNT_SEGUE sender:indexPath];
    }
}

/*
 */
#pragma mark - Navigation

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:EDIT_ACCOUNT_SEGUE]){
        NSIndexPath * indexPath = self.tableView.indexPathForSelectedRow;
        if (!indexPath){
            indexPath = [self.tableView indexPathForCell:sender];
        }
        InputAccountViewController * inputAccoutVC = (InputAccountViewController*) segue.destinationViewController;
        inputAccoutVC.account = [AccountManager sharedManager].allAccount[indexPath.row];
        inputAccoutVC.delegate = self.delegate;
    }
}

@end
