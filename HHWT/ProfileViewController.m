//
//  ProfileViewController.m
//  
//
//  Created by sampath kumar on 25/03/16.
//
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "ProfileTableViewCell.h"
#import "LogoutTableViewCell.h"
#import "ViewController.h"
#import "EditProfile.h"
#import <MessageUI/MessageUI.h>

@interface ProfileViewController ()<MFMailComposeViewControllerDelegate>
{
    NSString *domainString;
    int totalCell;
}
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Profile";
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"UserProfilePic"] length]>0 && ![[[NSUserDefaults standardUserDefaults] valueForKey:@"UserProfilePic"] isEqualToString:@""]){
        showProgress(YES);
        [self performSelector:@selector(delay) withObject:nil afterDelay:0.2f];
    }
    
    
    domainString = [[NSUserDefaults standardUserDefaults] valueForKey:@"LoginFrom"];
    
    _profileImg.layer.borderWidth = 1.0f;
    _profileImg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _profileImg.layer.cornerRadius = 100/2;
    _profileImg.layer.masksToBounds = YES;
    
    if([domainString isEqualToString:@"Local"])
        totalCell = 6;
    else
        totalCell = 4;
    
    _tblView.scrollEnabled = NO;
    
    int defaultCellHeight = 85;
    float tableHeight = defaultCellHeight * totalCell;
    _tblViewHeightConstraint.constant = tableHeight;
    _baseViewHeightConstrant.constant = 310 + tableHeight;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _txtName.text =[AppDelegate isEmpty:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"]] ? @"UserName" :  [[NSUserDefaults standardUserDefaults] valueForKey:@"UserName"];;

    [_tblView reloadData];
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return totalCell;

}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Last cell
    if(indexPath.row == (totalCell - 1)) {
        LogoutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"logoutCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell"];
        
        if([domainString isEqualToString:@"Local"]) {
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            if(indexPath.row == 0) {
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.lblConstant.text = @"Email Address";
                cell.lblData.text = [AppDelegate isEmpty:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserEmail"]] ? cell.lblConstant.text :  [[NSUserDefaults standardUserDefaults] valueForKey:@"UserEmail"];
            }
            else if(indexPath.row == 1)
            {
                cell.lblConstant.text = @"Password";
                cell.lblData.text = [AppDelegate isEmpty:[[NSUserDefaults standardUserDefaults] valueForKey:@"Password"]] ? cell.lblConstant.text :  [[NSUserDefaults standardUserDefaults] valueForKey:@"Password"];
            }
            else if(indexPath.row == 2)
            {
                cell.lblConstant.text = @"Date of Birth";
                cell.lblData.text = [AppDelegate isEmpty:[[NSUserDefaults standardUserDefaults] valueForKey:@"DOB"]] ? cell.lblConstant.text :  [[NSUserDefaults standardUserDefaults] valueForKey:@"DOB"];;
            }
            else if(indexPath.row == 3)
            {
                cell.lblConstant.text = @"Phone Number";
                cell.lblData.text =  [AppDelegate isEmpty:[[NSUserDefaults standardUserDefaults] valueForKey:@"PhoneNumber"]] ? cell.lblConstant.text :  [[NSUserDefaults standardUserDefaults] valueForKey:@"PhoneNumber"];
            }
            else if(indexPath.row == 4)
            {
                cell.lblConstant.text = @"Country";
                cell.lblData.text = [AppDelegate isEmpty:[[NSUserDefaults standardUserDefaults] valueForKey:@"Country"]] ? cell.lblConstant.text :  [[NSUserDefaults standardUserDefaults] valueForKey:@"Country"];            }
        }
        else {
             if(indexPath.row == 0)
            {
                cell.lblConstant.text = @"Date of Birth";
                cell.lblData.text = [AppDelegate isEmpty:[[NSUserDefaults standardUserDefaults] valueForKey:@"DOB"]] ? cell.lblConstant.text :  [[NSUserDefaults standardUserDefaults] valueForKey:@"DOB"];;
            }
            else if(indexPath.row == 1)
            {
                cell.lblConstant.text = @"Phone Number";
                cell.lblData.text =  [AppDelegate isEmpty:[[NSUserDefaults standardUserDefaults] valueForKey:@"PhoneNumber"]] ? cell.lblConstant.text :  [[NSUserDefaults standardUserDefaults] valueForKey:@"PhoneNumber"];
            }
            else if(indexPath.row == 2)
            {
                cell.lblConstant.text = @"Country";
                cell.lblData.text = [AppDelegate isEmpty:[[NSUserDefaults standardUserDefaults] valueForKey:@"Country"]] ? cell.lblConstant.text :  [[NSUserDefaults standardUserDefaults] valueForKey:@"Country"];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
 
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Last cell
    if(indexPath.row == (totalCell - 1)) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ISUserLogined"];
        
        //  Clear user data's here...
        
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
        
        
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else{
        
        if([domainString isEqualToString:@"Local"] && indexPath.row == 0){
            //nothing do here...
        }else {
            
            EditProfile *edit = [self.storyboard instantiateViewControllerWithIdentifier:EditProfile_STORYBOARD_ID];

            if([domainString isEqualToString:@"Local"]) {
                if(indexPath.row == 1){
                    edit.editType = @"Password";
                    [self.navigationController pushViewController:edit animated:YES];
                }
                else if(indexPath.row == 2){
                    edit.editType = @"DOB";
                    [self.navigationController pushViewController:edit animated:YES];
                }
                else if(indexPath.row == 3){
                    edit.editType = @"PhoneNumber";
                    [self.navigationController pushViewController:edit animated:YES];
                }
                else if(indexPath.row == 4){
                    edit.editType = @"Country";
                    [self.navigationController pushViewController:edit animated:YES];
                }
            }
            else{
                
                if(indexPath.row == 0){
                    edit.editType = @"DOB";
                    [self.navigationController pushViewController:edit animated:YES];
                }
                else if(indexPath.row == 1){
                    edit.editType = @"PhoneNumber";
                    [self.navigationController pushViewController:edit animated:YES];
                }
                else if(indexPath.row == 2){
                    edit.editType = @"Country";
                    [self.navigationController pushViewController:edit animated:YES];
                }
            }
        }
    }
}

//EDIT NAME HERE...
- (IBAction)editImage:(id)sender {
    EditProfile *edit = [self.storyboard instantiateViewControllerWithIdentifier:EditProfile_STORYBOARD_ID];
    edit.editType = @"Name";
    [self.navigationController pushViewController:edit animated:YES];
}

- (IBAction)contactUs:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        [composeViewController setMailComposeDelegate:self];
        [composeViewController setToRecipients:@[@"hello@havehalalwilltravel.com"]];
        [composeViewController setSubject:@"Feedback"];
        [self presentViewController:composeViewController animated:YES completion:nil];
    }
    else{
        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"Info" message:@"Mail not configured!" delegate:nil cancelButtonTitle:@"" otherButtonTitles:nil, nil];
        [alrt show];
        
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if(error)
    {
        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:@"" otherButtonTitles:nil, nil];
        [alrt show];
        [self dismissModalViewControllerAnimated:YES];
    }
    else{
        [self dismissModalViewControllerAnimated:YES];
    }
    
}
@end
