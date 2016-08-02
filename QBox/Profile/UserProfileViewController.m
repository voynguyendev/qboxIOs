//
//  UserProfileViewController.m
//  QBox
//
//  Created by Tony Truong on 4/3/15.
//  Copyright (c) 2015 iapp. All rights reserved.
//

#import "AddFriendViewController.h"
#import "UserProfileViewController.h"
#import "AppDelegate.h"
#import "SavedPostViewController.h"
#import "QBoxService.h"
#import "UpdatesViewController.h"
#import "AcceptAnswerViewController.h"
#import "QuestionViewController.h"
#import "MessageViewController.h"
#import "UIImageView+WebCache.h"
#import "ActivityView.h"
#import "WebServiceSingleton.h"

@interface UserProfileViewController() <ActivityViewDelegate,UITextViewDelegate>
{
    ActivityView *activity;
}

@end



@implementation UserProfileViewController

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextView *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void) showActivityInView:(UIView *)view
{
    activity = [ActivityView activityView];
   
    [activity setTitle:@"Loading..."];
    
    
    [activity setDelegate:self];
    [activity setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.9]];
    [activity showBorder];
    [activity showActivityInView:view];
    activity.center = view.center;
}

-(void)hideActivity
{
    [activity hideActivity];
}

-(void)tapprofileDetected{
    UserDetailViewController *controller = [[UserDetailViewController alloc]init];
    // Back Button
    controller.messageValue = 50;
    [self.navigationController pushViewController:controller animated:NO];

}

-(void)keyboardDidHide:(NSNotification*) note
{
    CGRect containerFrametext = self.tvStatusText.frame;
    CGRect containerFramepost = self.btpost.frame;
    containerFrametext.origin.y=containerFrametext.origin.y+280;
    containerFramepost.origin.y=containerFramepost.origin.y+280;
    
    self.tvStatusText.frame=containerFrametext;
    self.btpost.frame=containerFramepost;
}

-(void)keyboardDidShow:(NSNotification*) note
{
     CGRect containerFrametext = self.tvStatusText.frame;
     CGRect containerFramepost = self.btpost.frame;
     containerFrametext.origin.y=containerFrametext.origin.y-280;
     containerFramepost.origin.y=containerFramepost.origin.y-280;

     self.tvStatusText.frame=containerFrametext;
     self.btpost.frame=containerFramepost;

    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapprofileDetected)];
    singleTap.numberOfTapsRequired = 1;
    [self.avatarImageView setUserInteractionEnabled:YES];
    [self.avatarImageView addGestureRecognizer:singleTap];
    [self resetData];
   
    [self requestGetUserProfile];
    self.tvStatusText.delegate=self;
    
    if([self.Indexredirect isEqualToString:@"1"])
    {
        UpdatesViewController *updatesView=[[UpdatesViewController alloc]init];
        updatesView.friendID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDetail"][@"id"];
        [self.navigationController pushViewController:updatesView animated:NO];
        
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IBAction

- (IBAction)settingButtonTapped:(id)sender{
    UserDetailViewController *controller = [[UserDetailViewController alloc]init];
    // Back Button
    controller.messageValue = 50;
    [self.navigationController pushViewController:controller animated:NO];
}

- (IBAction)faqButtonTapped:(id)sender{

}

- (IBAction)logoutButtonTapped:(id)sender{
    
    
    UIAlertView *logoutAlertView = [[UIAlertView alloc] initWithTitle:@"Alert!!" message:@"Do you want to log out?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    logoutAlertView.tag = 1;
    [logoutAlertView show];
}

- (IBAction)recentQuestionsButtonTapped:(id)sender{
    UpdatesViewController *updatesView=[[UpdatesViewController alloc]init];
    updatesView.friendID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDetail"][@"id"];
    [self.navigationController pushViewController:updatesView animated:NO];
}

- (IBAction)savedQuestionsButtonTapped:(id)sender{
    SavedPostViewController *controller = [[SavedPostViewController alloc]init];
    
    controller.totalQuesString = [AppDelegate sharedDelegate].userDetail[@"SavedQuestionsCount"];
    controller.friendId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDetail"][@"id"];
    
    [self.navigationController pushViewController:controller animated:NO];
}

- (IBAction)acceptedQuestionsButtonTapped:(id)sender{
    AcceptAnswerViewController *controller = [[AcceptAnswerViewController alloc] init];
    controller.friendId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDetail"][@"id"];

    [self.navigationController pushViewController:controller animated:NO];
}

- (IBAction)postedQuestionsButtonTapped:(id)sender{
    QuestionViewController *controller = [[QuestionViewController alloc] init];
    controller.friendID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDetail"][@"id"];
    [self.navigationController pushViewController:controller animated:NO];
}

- (IBAction)chatButtonTapped:(id)sender{
    MessageViewController *controller = [[MessageViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)ViewProfile:(id)sender {
    AddFriendViewController *controller = [[AddFriendViewController alloc] init];
     NSString *userid=[[NSUserDefaults standardUserDefaults] objectForKey:@"userDetail"][@"id"];
     controller.friendUserId = userid;
    
     [self.navigationController pushViewController:controller animated:NO];
    
}



- (IBAction)SaveStatusText:(id)sender {
    [self showActivityInView:self.view];
}


-(void) activityDidAppear
{
    NSString *statustext=self.tvStatusText.text;
    NSString *userid=[[NSUserDefaults standardUserDefaults] objectForKey:@"userDetail"][@"id"];
    [[WebServiceSingleton sharedMySingleton] saveStatusText:statustext userId:userid];
    
    UIAlertView *sucessUpdateAlert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Successfully updated Statustext" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
   // [sucessUpdateAlert show];
    [self.tvStatusText resignFirstResponder];
    
    [self hideActivity];
}


#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //LogOut Alert View
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            
            
            
            
            LoginViewController_iPhone *loginView = [[LoginViewController_iPhone alloc] init];
            [AppDelegate sharedDelegate].navController = [[[AppDelegate sharedDelegate] navController]
                                                          initWithRootViewController:loginView];
            
                       [AppDelegate sharedDelegate].window.rootViewController=[AppDelegate sharedDelegate].navController;
          

            
        }
    }
}

#pragma mark - Request Service

- (void)requestGetUserProfile{

    [ProgressHUD show:@"Please Wait..." Interaction:NO];
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDetail"][@"id"];
    NSString *url = [NSString stringWithFormat:@"%@/getUserInfoById.php?mobile=%@&friend_id=%@",webserviceBaseUrl, userID, userID];
    
    
    NSString *token=[[NSUserDefaults standardUserDefaults]valueForKey:@"token"];
    NSString *userIdchecktoken=[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"];
    url=[NSString stringWithFormat:@"%@&token=%@&userIdchecktoken=%@",url,token,userIdchecktoken];

    
    __weak typeof(self) weakSelf = self;
    
    [QBoxService   GET:url parameters:nil success:^(id responseObject) {
        
        [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"userdata"][@"id"] forKey:@"userid"];
        [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"userdata"] forKey:@"userDetail"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[AppDelegate sharedDelegate] setUserDetail:responseObject[@"userdata"]];
        
        [weakSelf reloadData];
        
        [ProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSInteger errorCode, NSString *errorMessage) {
        [ProgressHUD showError:errorMessage];
    }];    
}

#pragma mark - Reload Data


- (void)resetData{
    self.navigationController.navigationBarHidden = YES;
    
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = (self.avatarImageView.frame.size.width) / 2;
    self.avatarImageView.layer.borderWidth = 1.0f;
    self.avatarImageView.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.nameLabel.text = nil;
    
    self.messageCountLabel.hidden = YES;
    self.recentQuestionCountLabel.hidden = YES;
    self.savedQuestionCountLabel.hidden = YES;
    self.acceptedQuestionCountLabel.hidden = YES;
    self.postedQuestionCountLabel.hidden = YES;
    
}

- (void)reloadData{
 
    
    
    
    // [self.avatarImageView Ima setImageWithURL:[NSURL URLWithString:profilePic]];
    
   // [self.avatarImageView]=[UIImageView imageWithData:data];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", [AppDelegate sharedDelegate].userDetail[@"name"], [AppDelegate sharedDelegate].userDetail[@"lname"]];
    
    self.messageCountLabel.hidden = NO;
    self.recentQuestionCountLabel.hidden = NO;
    self.savedQuestionCountLabel.hidden = NO;
    self.acceptedQuestionCountLabel.hidden = NO;
    self.postedQuestionCountLabel.hidden = NO;
    
    
   /* NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDetail"][@"id"];
    id messageArray=[[NSArray alloc]init];
    id messageArr=[[WebServiceSingleton sharedMySingleton]receiveMessagenew:userId];
    NSString *status=[[messageArr valueForKey:@"status"]objectAtIndex:0];
    if ([status isEqualToString:@"1"])
    {
        
        messageArray=[[messageArr valueForKey:@"message"]objectAtIndex:0];
        self.messageCountLabel.text = [NSString stringWithFormat:@"%d ", [messageArray count]];
    }*/

    NSString* counttext=[[AppDelegate sharedDelegate].userDetail[@"AllMessagesCount"] description];
    //
    if([counttext isEqualToString:@"0"])
    {
        [self.ContainerMessageCount setHidden:YES];
    }
    
    
    
    self.messageCountLabel.text = counttext;
    
    counttext=[[AppDelegate sharedDelegate].userDetail[@"RecentUpdateCount"] description];
    //
    if([counttext isEqualToString:@"0"])
    {
        [self.ContainerRecentCount setHidden:YES];
    }
    
    self.recentQuestionCountLabel.text = counttext;
    
    
  
    
    counttext=[[AppDelegate sharedDelegate].userDetail[@"SavedQuestionsCount"] description];
    //
    if([counttext isEqualToString:@"0"])
    {
        [self.ContainerSaveCount setHidden:YES];
    }
    
    self.savedQuestionCountLabel.text = counttext;

    
    
    counttext=[[AppDelegate sharedDelegate].userDetail[@"AllAcceptedAnswersCount"] description];
    
    if([counttext isEqualToString:@"0"])
    {
        [self.ContainerAcceptedCount setHidden:YES];
    }
    
    self.acceptedQuestionCountLabel.text = counttext;
    
    
   
    
    self.tvStatusText.text = [[AppDelegate sharedDelegate].userDetail[@"StatusText"] description];;
    
    NSString *profilePic = [AppDelegate sharedDelegate].userDetail[@"profile_pic"];
    if ([profilePic isEqualToString:@""] || [profilePic isEqualToString:@"(null)"])
    {
        id loginDetail = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginDetails"];
        NSString *loginId = [loginDetail valueForKey:@"loginId"];
        if ([loginId isEqualToString:@"3"])
        {
            
        }
        else
        {
            profilePic=[loginDetail valueForKey:@"profileImage"];
            
        }
    }
    else
    {
        
    }
    
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:profilePic] placeholderImage:[UIImage imageNamed:@"pic_upload"]];
    
    
   // self.avatarImageView.frame = CGRectMake(0, 0, 320, 480);
    
    
   /* NSURL *imgURL=[[NSURL alloc]initWithString:profilePic];
    
    NSData *imgdata=[[NSData alloc]initWithContentsOfURL:imgURL];
    UIImage *image=[UIImage imageNamed:@"pic_upload"];
    
    if(imgdata!=nil)
    {
        image=[[UIImage alloc]initWithData:imgdata];
        
        
        
    }
    self.avatarImageView.image=image;*/
    
}



@end
