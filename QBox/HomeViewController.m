//
//  HomeViewController.m
//  QBox
//
//  Created by iapp on 26/05/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

#import "HomeViewController.h"
#import "PostquestionViewController.h"
#import "PostQuestionDetailViewController.h"
#import "NavigationView.h"
#import "InviteViewController.h"
#import "WebServiceSingleton.h"
#import "AcceptAnswerViewController.h"
#import "UIImageView+WebCache.h"
#import "GeneralViewController.h"
#import "SavedPostViewController.h"
#import "FriendPostViewController.h"
#import "CustomView.h"
#import "AppDelegate.h"
#import "NotificationsData.h"
#import "UserDetailViewController.h"
#import "SearchFriendsViewController.h"
#import "QuestionViewController.h"
#import "TopicViewController.h"
#import "MessageViewController.h"
#import "UpdatesViewController.h"
#import "SPHViewController.h"
#import "AddFriendViewController.h"




@interface HomeViewController ()<HomeViewDelegate,UITabBarDelegate,UITabBarControllerDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>

{
    NSArray *tableArray;
    UITableView *tblView;
    NSArray *personalDetailarray;
    NSString *nameStr;
    UILabel *nameLbl;
    NSString *ques;
    NSString *ids;
    NSArray *totalQuestionCount;
    UIImageView *picImage;
    UITableView *notificationTableView;
   // NSMutableArray *notificationsArray;
    NSMutableArray *notificationsArray;
    NSString *cellTextStr;
    UITableView *notificationsDetailTableView;
    UIView *notificationsView;
    int postQuesValue;
    UIButton *notificationViewBtn;
    UIScrollView *imageScrollView;
    UIImageView *imagePostQuestion;
    UIImage *convertedImage;
    
    UILabel *savedQuesCountLabel;
    UILabel *acceptQuesCountLabel;
    UILabel *messagesCountLabel;
    UILabel *updateCountLabel;
    UILabel *postedCountLabel;
    
    UIButton *profileButton;
    
    UIButton *addFriendBtn;
    UIButton *followBtn;
    UIButton *messageBtn;
    
    BOOL value;
   
   
}

@end

@implementation HomeViewController
@synthesize nameValue;
@synthesize notificationsViewValue;
@synthesize notificationQuesId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    notificationsArray=[[NSMutableArray alloc]init];
    if (notificationsViewValue==1)
    {
        PostQuestionDetailViewController *postQuestion=[[PostQuestionDetailViewController alloc]init];
        postQuestion.notificationQuesId=notificationQuesId;
        postQuestion.generalViewValue=5;
        [self.navigationController pushViewController:postQuestion animated:NO];
    }
    else
    {
    
    }
    
    NSLog(@"%d",nameValue);
   
     self.navigationController.navigationBarHidden=YES;
   
    tblView.delegate=self;
    self.view.backgroundColor=[UIColor clearColor];
     // [self createUI];
   // [self createHomeUI];
    //[self createProfileView];
    [self createProfileScreenUI];
    
   
    notificationTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    tblView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [super viewDidLoad];
    
    
    UITapGestureRecognizer *resignTapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignProfileView)];
    resignTapGesture.delegate=self;
    //[self.view addGestureRecognizer:resignTapGesture];
    
    totalQuestionCount=[[NSArray alloc]init];
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:notificationsDetailTableView]) {
        
        // Don't let selections of auto-complete entries fire the
        // gesture recognizer
        return NO;
    }
    
    return YES;
}
-(void)resignProfileView
{
    [imageScrollView removeFromSuperview];
    [imagePostQuestion removeFromSuperview];
}
-(void)viewWillAppear:(BOOL)animated
{
    
 
    

   [self performSelectorInBackground:@selector(updateUserDetail) withObject:self];
     NSLog(@"%@",personalDetailarray);
    
    [self getNotifications];
     [notificationsView removeFromSuperview];
    
    
    if ([notificationsArray count]>0)
    {
        [self.view addSubview:notificationTableView];
       
    }
    if ([notificationsArray count]>3)
    {
        //[self.view addSubview:loadMoreBtn];
    }
    
    if ([notificationsArray count]>1)
    {
        
    }
    int notificationCount=[notificationsArray count];
    
     [notificationViewBtn setTitle:[NSString stringWithFormat:@"Notifications[%d]",notificationCount] forState:UIControlStateNormal];
    NSArray *userData=[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"];
    if (userData)
    {
        [self performSelectorInBackground:@selector(pushNotificationData) withObject:self];

    }
    
    
   
    
         
}


-(void)updateUserDetail
{
    //http://54.69.127.235/question_app/getUserInfoById.php?mobile=155&friend_id=84
    [WebServiceSingleton sharedMySingleton].homeViewDelegate=self;
    id userDetail=[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"];
    NSString *userID=[userDetail valueForKey:@"id"];
    [[WebServiceSingleton sharedMySingleton]QBoxUserValueWebService:userID friendId:_friendID];
//   id dic=[[WebServiceSingleton sharedMySingleton]getFriendInfo:userID friend:_friendID];
//    if ([[dic objectForKey:@"success"]boolValue])
//    {
//        personalDetailarray=[dic objectForKey:@"userdata"];
//    }
    
}


-(void)createProfileView
{
    UIImageView *backgroundImageView=[[UIImageView alloc]initWithFrame:self.view.frame];
    backgroundImageView.image=[UIImage imageNamed:@"bg"];
    [self.view addSubview:backgroundImageView];
    
    
    UIButton *settingsBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    settingsBtn.frame=CGRectMake(5, 5, 44, 44);
    [settingsBtn setImage:[UIImage imageNamed:@"main_setting_icon"] forState:UIControlStateNormal];
    [settingsBtn addTarget:self action:@selector(settingsBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingsBtn];
    
    
    UIButton *faqBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    faqBtn.frame=CGRectMake(settingsBtn.frame.origin.x+settingsBtn.frame.size.width, 5, 44, 44);
    [faqBtn setImage:[UIImage imageNamed:@"main_top_faq"] forState:UIControlStateNormal];
    [faqBtn addTarget:self action:@selector(faqBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:faqBtn];
    
    
    CGFloat maxXFrame=CGRectGetMaxX(self.view.frame);
    UIButton *logOutBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    logOutBtn.frame=CGRectMake(maxXFrame-54, 5, 44, 44);
    [logOutBtn setImage:[UIImage imageNamed:@"main_top_arrow"] forState:UIControlStateNormal];
    [logOutBtn addTarget:self action:@selector(logOutBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logOutBtn];
    
    //profile_bg_second
    
    //RoundView
    UIView *homeView=[[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-240)/2,10, 240, 240)];
    //[homeView setBackgroundColor:[UIColor redColor]];
   
    [self.view addSubview:homeView];
    
    //RoundImageView
    UIImageView *roundImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 5, homeView.frame.size.width, homeView.frame.size.height)];
    [roundImageView setImage:[UIImage imageNamed:@"profile_bg_second"]];
    [homeView addSubview:roundImageView];
    
    
    //Buttons
    
    //Saved Questions
    CGFloat maxWidth=CGRectGetWidth(homeView.frame);
    UIButton *savedQuesBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    savedQuesBtn.frame=CGRectMake(maxWidth-160,10,100,50);
    [savedQuesBtn addTarget:self action:@selector(savedQuestionBtn:) forControlEvents:UIControlEventTouchUpInside];
    savedQuesBtn.clipsToBounds=YES;
    
    UIImageView *savedImageView=[[UIImageView alloc]initWithFrame:CGRectMake((savedQuesBtn.frame.size.width-50)/2,(savedQuesBtn.frame.size.height-35)/2, 30, 30)];
    [savedImageView setImage:[UIImage imageNamed:@"second_page_notification_icon"]];
    [savedQuesBtn addSubview:savedImageView];
    [homeView addSubview:savedQuesBtn];
    
    
    savedQuesCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(savedImageView.frame.origin.x+savedImageView.frame.size.width-20, savedImageView.frame.origin.y+2,20, 10)];
    [savedQuesCountLabel setText:@"1"];
    savedQuesCountLabel.hidden=YES;
    [savedQuesCountLabel setFont:[UIFont systemFontOfSize:10.0f]];
    [savedQuesCountLabel setFont:[UIFont boldSystemFontOfSize:10.0f]];
    [savedQuesCountLabel setTextAlignment:NSTextAlignmentCenter];
    [savedQuesCountLabel setTextColor:[UIColor whiteColor]];
    [savedQuesCountLabel setBackgroundColor:BUTTONCOLOR];
    [savedQuesBtn addSubview:savedQuesCountLabel];
    
    
    
    //Update Button
    UIButton *updateBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    updateBtn.frame=CGRectMake(10,savedQuesBtn.frame.origin.y
                               +20,70,90);
    [updateBtn addTarget:self action:@selector(updateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    updateBtn.clipsToBounds=YES;
    [homeView addSubview:updateBtn];
    
    //Notification Image
    UIImageView *updateImageView=[[UIImageView alloc]initWithFrame:CGRectMake((updateBtn.frame.size.width-45)/2, (updateBtn.frame.size.height-40)/2, 30, 30)];
    [updateImageView setImage:[UIImage imageNamed:@"second_page_refresh_icon"]];
    [updateBtn addSubview:updateImageView];
    
    updateCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(updateImageView.frame.origin.x+updateImageView.frame.size.width-20, updateImageView.frame.origin.y,20,10)];
    [updateCountLabel setText:@"1"];
    updateCountLabel.hidden=YES;
    [updateCountLabel setFont:[UIFont systemFontOfSize:10.0f]];
    [updateCountLabel setFont:[UIFont boldSystemFontOfSize:10.0f]];
    [updateCountLabel setTextAlignment:NSTextAlignmentCenter];
    [updateCountLabel setTextColor:[UIColor whiteColor]];
    [updateCountLabel setBackgroundColor:BUTTONCOLOR];
    [updateBtn addSubview:updateCountLabel];
    
    
    
    
    
    
    
    
    //Accepted Questions Button
    UIButton *acceptedQuesBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    acceptedQuesBtn.frame=CGRectMake(savedQuesBtn.frame.origin.x+savedQuesBtn.frame.size.width,savedQuesBtn.frame.origin.y+30,70,90);
    [acceptedQuesBtn addTarget:self action:@selector(acceptQuesBtn:) forControlEvents:UIControlEventTouchUpInside];
    acceptedQuesBtn.clipsToBounds=YES;
    [homeView addSubview:acceptedQuesBtn];
    
    UIImageView *acceptedImageView=[[UIImageView alloc]initWithFrame:CGRectMake((acceptedQuesBtn.frame.size.width-42)/2, (acceptedQuesBtn.frame.size.height-30)/2, 30, 30)];
    [acceptedImageView setImage:[UIImage imageNamed:@"second_page_check_icon"]];
    [acceptedQuesBtn addSubview:acceptedImageView];
    
    
    acceptQuesCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(acceptedImageView.frame.origin.x+acceptedImageView.frame.size.width-20, acceptedImageView.frame.origin.y,20,10)];
    [acceptQuesCountLabel setText:@"1"];
    acceptQuesCountLabel.hidden=YES;
    [acceptQuesCountLabel setFont:[UIFont systemFontOfSize:10.0f]];
    [acceptQuesCountLabel setFont:[UIFont boldSystemFontOfSize:10.0f]];
    [acceptQuesCountLabel setTextAlignment:NSTextAlignmentCenter];
    [acceptQuesCountLabel setTextColor:[UIColor whiteColor]];
    [acceptQuesCountLabel setBackgroundColor:BUTTONCOLOR];
    [acceptedQuesBtn addSubview:acceptQuesCountLabel];
    
    
    //Questions Button
    
    
    UIButton *questionsBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    questionsBtn.frame=CGRectMake(acceptedQuesBtn.frame.origin.x,acceptedQuesBtn.frame.origin.y+acceptedQuesBtn.frame.size.height,70,90);
    questionsBtn.clipsToBounds=YES;
    [questionsBtn addTarget:self action:@selector(questionsBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    //[questionsBtn setBackgroundColor:[UIColor redColor]];
    [homeView addSubview:questionsBtn];
    
    UIImageView *questionsImageView=[[UIImageView alloc]initWithFrame:CGRectMake((questionsBtn.frame.size.width-50)/2, (questionsBtn.frame.size.height-30)/2, 30, 30)];
    [questionsImageView setImage:[UIImage imageNamed:@"second_page_question_icon"]];
    [questionsBtn addSubview:questionsImageView];
    
    postedCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(questionsImageView.frame.origin.x+questionsImageView.frame.size.width-20, questionsImageView.frame.origin.y,20,10)];
    [postedCountLabel setText:@"1"];
    postedCountLabel.hidden=YES;
    [postedCountLabel setFont:[UIFont systemFontOfSize:10.0f]];
    [postedCountLabel setFont:[UIFont boldSystemFontOfSize:10.0f]];
    [postedCountLabel setTextAlignment:NSTextAlignmentCenter];
    [postedCountLabel setTextColor:[UIColor whiteColor]];
    [postedCountLabel setBackgroundColor:BUTTONCOLOR];
    [questionsBtn addSubview:postedCountLabel];
    
    

    
    
    
    
    
    
    //Messages Button
    UIButton *messageBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    messageBtn.frame=CGRectMake(0,updateBtn.frame.origin.y+updateBtn.frame.size.height,70, 100);
    messageBtn.clipsToBounds=YES;
    [messageBtn addTarget:self action:@selector(messageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    //[messageBtn setBackgroundColor:[UIColor orangeColor]];
    [homeView addSubview:messageBtn];
    
    UIImageView *messageImageView=[[UIImageView alloc]initWithFrame:CGRectMake((messageBtn.frame.size.width-40)/2, (messageBtn.frame.size.height-40)/2, 30, 30)];
    [messageImageView setImage:[UIImage imageNamed:@"second_page_msg_icon"]];
    [messageBtn addSubview:messageImageView];
    
    messagesCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(messageImageView.frame.origin.x+messageImageView.frame.size.width-20, messageImageView.frame.origin.y+2,20,10)];
    [messagesCountLabel setText:@"1"];
    messagesCountLabel.hidden=YES;
    [messagesCountLabel setFont:[UIFont systemFontOfSize:10.0f]];
    [messagesCountLabel setFont:[UIFont boldSystemFontOfSize:10.0f]];
    [messagesCountLabel setTextAlignment:NSTextAlignmentCenter];
    [messagesCountLabel setTextColor:[UIColor whiteColor]];
    [messagesCountLabel setBackgroundColor:BUTTONCOLOR];
    [messageBtn addSubview:messagesCountLabel];
    
    
    
    
    //Messages Button
    CGFloat maxYCoordinate=CGRectGetHeight(homeView.frame);
    UIButton *webBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    webBtn.frame=CGRectMake((homeView.frame.size.width-100)/2,maxYCoordinate-50,100, 40);
    [webBtn addTarget:self action:@selector(webBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    //[messagesBtn setTitle:@"Web Developer" forState:UIControlStateNormal];
    [homeView addSubview:webBtn];
    

    
    
    
    //Profile Button
    profileButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //profileButton.titleLabel.font=[UIFont fontWithName:@"Avenir" size:12.0f];
    [profileButton setBackgroundColor:[UIColor whiteColor]];
    profileButton.frame=CGRectMake((homeView.frame.size.width-100)/2,(homeView.frame.size.height-100)/2, 100, 100);
    profileButton.layer.cornerRadius=(profileButton.frame.size.width)/2;
    profileButton.titleEdgeInsets=UIEdgeInsetsMake(60.0,-5.0, 0.0, 0.0);
    profileButton.titleLabel.font=[UIFont fontWithName:@"Avenir" size:12.0f];
    [homeView addSubview:profileButton];
    
   
    
    
    
    
    picImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, profileButton.frame.size.width, profileButton.frame.size.height)];
    //[picImage setImage:[UIImage imageNamed:@"pic_upload"]];
    picImage.layer.cornerRadius=picImage.frame.size.width/2;
    picImage.clipsToBounds=YES;
    [profileButton addSubview:picImage];
    
    

    
    
    
    notificationTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, homeView.frame.origin.y+homeView.frame.size.height+10, self.view.frame.size.width,self.view.frame.size.height-(homeView.frame.size.height+70+70))];
    notificationTableView.dataSource=self;
    notificationTableView.delegate=self;
    notificationTableView.bounces=NO;
    notificationTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:notificationTableView];
    
    
    UIView *detailView=[[UIView alloc]initWithFrame:CGRectMake(0, notificationTableView.frame.origin.y+notificationTableView.frame.size.height, self.view.frame.size.width,70)];
    [detailView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:detailView];
    
    UIView *detailData=[[UIView alloc]initWithFrame:CGRectMake(10, 10, detailView.frame.size.width-20, detailView.frame.size.height-20)];
    detailData.layer.borderColor=[UIColor lightGrayColor].CGColor;
    detailData.layer.borderWidth=0.5f;
    detailData.layer.cornerRadius=4.0f;
    [detailView addSubview:detailData];
    
    //second_page_download_icon
    UIImageView *downloadImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5,(detailData.frame.size.height-30)/2, 30, 30)];
    [downloadImageView setImage:[UIImage imageNamed:@"second_page_download_icon"]];
    [detailData addSubview:downloadImageView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(downloadImageView.frame.origin.x+downloadImageView.frame.size.width+10, downloadImageView.frame.origin.y, detailData.frame.size.width-downloadImageView.frame.size.width, detailData.frame.size.width)];
    label.text=@"Label";
    label.textColor=[UIColor blackColor];
    label.font=[UIFont systemFontOfSize:12.0f];
    [detailData addSubview:label];
    
    NSString *relationStr=[[[AppDelegate sharedDelegate]userDetail]valueForKey:@"friendRel"];
    int  relationInt=[relationStr intValue];
    
    
    //If relation is sending request or receive request
    if (relationInt==0)
    {
        
    }
    
    //If User relations is friend
    else  if (relationInt==1)
    {
        [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"User is already friend " delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil]show];
    }
    //if friend request rejected
    else if (relationInt==2)
    {
      
    }
    //If no relation
    else if (relationInt==3)
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Do you want to add Friend" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [alertView show];
        
    }
    
}

#pragma mark Action Methods

-(void)logOutBtnAction:(id)sender
{
    UIAlertView *logoutAlertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Do you want to log out?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    logoutAlertView.tag=1;
    [logoutAlertView show];
    
}
-(void)settingsBtnAction:(id)sender
{
    
}
-(void)faqBtnAction:(id)sender
{
    
}
-(void)savedQuestionBtn:(id)sender
{
    SavedPostViewController *savedPost=[[SavedPostViewController alloc]init];
    NSString *totalQuesString=[[personalDetailarray valueForKey:@"SavedQuestionsCount"]objectAtIndex:0];
    savedPost.totalQuesString=totalQuesString;
    savedPost.friendId=_friendID;
    [self.navigationController pushViewController:savedPost animated:NO];
    
}
-(void)updateBtnAction:(id)sender
{
    UpdatesViewController *updatesView=[[UpdatesViewController alloc]init];
    updatesView.friendID=_friendID;
    [self.navigationController pushViewController:updatesView animated:NO];
//    TopicViewController *topicView=[[TopicViewController alloc]init];
//    [self.navigationController pushViewController:topicView animated:NO];
}
-(void)acceptQuesBtn:(id)sender
{
    AcceptAnswerViewController *acceptAnswer=[[AcceptAnswerViewController alloc]init];
    acceptAnswer.friendId=_friendID;
    //NSString *totalQuesString=[[personalDetailarray valueForKey:@"AllAcceptedAnswersCount"]objectAtIndex:0];
    [self.navigationController pushViewController:acceptAnswer animated:NO];
}
-(void)questionsBtnAction:(id)sender
{
    QuestionViewController *postQuestion=[[QuestionViewController alloc]init];
    postQuestion.friendID=_friendID;
    [self.navigationController pushViewController:postQuestion animated:NO];
}
-(void)messageBtnAction:(id)sender
{
    MessageViewController *messageView=[[MessageViewController alloc]init];
    [self.navigationController pushViewController:messageView animated:YES];
}
-(void)webBtnAction:(id)sender
{
    
}

-(void)followBtnAction:(id)sender
{
    NSString *userId=[[[AppDelegate sharedDelegate]userDetail]valueForKey:@"id"];
    id followDetail=[[[WebServiceSingleton sharedMySingleton]addFollowAccount:_friendID andUserId:userId andStatus:@"1"]objectAtIndex:0];
    
    if ([[followDetail objectForKey:@"success"]boolValue])
    {
        [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Sucessfully inserted in followers" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil]show];
    }
    else
    {
        [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Already inserted in followers" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil]show];
    }
}
-(void)addFriendBtnAction:(id)sender
{
    id userData=[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"];
    NSString *friendRelation=[userData valueForKey:@"friendRel"];
    NSString *userType=[userData valueForKey:@"usertype"];
    int relationInt=[friendRelation intValue];
    //If relation is 0 then sending request or receive request
    if (relationInt==0)
    {
        //If relation is sending request or receive request
        if (relationInt==0)
        {
            //if user receive request
            if ([userType rangeOfString:@"receiver"].location!=NSNotFound)
            {
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Do you want to accept friend request?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
                [alertView show];
                alertView.tag=3;
                //[addFriendBtn setImage:[UIImage imageNamed:@"friend_request_received"] forState:UIControlStateNormal];
            }
            else
            {
                //if user reject request
                
                UIAlertView *friendAlert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Do you want to reject friend request?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
                friendAlert.tag=4;
                [friendAlert show];
                //[addFriendBtn setImage:[UIImage imageNamed:@"friend_request_send"] forState:UIControlStateNormal];
            }
        }

        
    }
    
    //If relation is 1 User relation is friend
    else  if (relationInt==1)
    {
        //Send message to user
       
    }
    //if relation is 2 then friend request rejected
    else if (relationInt==2)
    {
        
    }
    //If relation is 3 then no relation means add friend
    else if (relationInt==3)
    {
        UIAlertView *friendRequest=[[UIAlertView alloc]initWithTitle:@"Friend Request" message:@"Do you want to send friend request?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        friendRequest.tag=2;
        [friendRequest show];
    }
}
-(void)messageView:(id)sender
{
   
    SPHViewController *chatView=[[SPHViewController alloc]initWithNibName:@"SPHViewController" bundle:nil];
    chatView.receiverId=_friendID;
    chatView.senderId=[[[AppDelegate sharedDelegate]userDetail]valueForKey:@"id"];
    chatView.friendArray=personalDetailarray;
    [self.navigationController pushViewController:chatView animated:NO];
}
-(void)bacKBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UIView
-(void)createProfileScreenUI
{
    UIImageView *backgroundImageView=[[UIImageView alloc]initWithFrame:self.view.frame];
    backgroundImageView.image=[UIImage imageNamed:@"bg"];
    [self.view addSubview:backgroundImageView];
    
    
    UIButton *settingsBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    settingsBtn.frame=CGRectMake(10, 10, 30, 28);
    [settingsBtn setImage:[UIImage imageNamed:@"main_setting_icon"] forState:UIControlStateNormal];\
    [settingsBtn addTarget:self action:@selector(bacKBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingsBtn];
    
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(settingsBtn.frame.origin.x+settingsBtn.frame.size.width, 10, 30, 28);
    [backBtn setImage:[UIImage imageNamed:@"main_top_arrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(bacKBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    
    CGFloat maxXFrame=CGRectGetMaxX(self.view.frame);
    UIButton *addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame=CGRectMake(maxXFrame-40, 10, 30, 28);
    [addBtn setImage:[UIImage imageNamed:@"main_top_arrow"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(logOutBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
    
    
    
    
   
   
    
    
    
  
    
    
    //RoundView
    UIView *homeView=[[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-240)/2,10, 240, 240)];
    //[homeView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:homeView];
    
    //RoundImageView
    UIImageView *roundImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, homeView.frame.size.width, homeView.frame.size.height)];
    [roundImageView setImage:[UIImage imageNamed:@"profile_bg"]];
    [homeView addSubview:roundImageView];
    

    //Accepted Button
    CGFloat maxWidth=CGRectGetWidth(homeView.frame);
    UIButton *acceptedBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    acceptedBtn.frame=CGRectMake(maxWidth-110,0,90,90);
    [acceptedBtn addTarget:self action:@selector(acceptQuesBtn:) forControlEvents:UIControlEventTouchUpInside];
    acceptedBtn.clipsToBounds=YES;
    
    UIImageView *acceptedImageView=[[UIImageView alloc]initWithFrame:CGRectMake((acceptedBtn.frame.size.width-30)/2,(acceptedBtn.frame.size.height-30)/2, 30, 30)];
    [acceptedImageView setImage:[UIImage imageNamed:@"second_page_check_icon"]];
    [acceptedBtn addSubview:acceptedImageView];
    [homeView addSubview:acceptedBtn];
    
    
    acceptQuesCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(acceptedImageView.frame.origin.x+acceptedImageView.frame.size.width-20, acceptedImageView.frame.origin.y,20,10)];
    [acceptQuesCountLabel setText:@"1"];
    acceptQuesCountLabel.hidden=YES;
    [acceptQuesCountLabel setFont:[UIFont systemFontOfSize:10.0f]];
    [acceptQuesCountLabel setFont:[UIFont boldSystemFontOfSize:10.0f]];
    [acceptQuesCountLabel setTextAlignment:NSTextAlignmentCenter];
    [acceptQuesCountLabel setTextColor:[UIColor whiteColor]];
    [acceptQuesCountLabel setBackgroundColor:BUTTONCOLOR];
    [acceptedBtn addSubview:acceptQuesCountLabel];

    
    
    //Saved Ques Button
    UIButton *savedQuesBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    savedQuesBtn.frame=CGRectMake(10,10,120,90);
    savedQuesBtn.clipsToBounds=YES;
    [savedQuesBtn addTarget:self action:@selector(savedQuestionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [homeView addSubview:savedQuesBtn];
    
    
    UIImageView *savedImageView=[[UIImageView alloc]initWithFrame:CGRectMake((savedQuesBtn.frame.size.width-45)/2, (savedQuesBtn.frame.size.height-50)/2, 30, 30)];
    [savedImageView setImage:[UIImage imageNamed:@"second_page_notification_icon"]];
    [savedQuesBtn addSubview:savedImageView];
    
    savedQuesCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(savedImageView.frame.origin.x+savedImageView.frame.size.width-20, savedImageView.frame.origin.y+2,20, 10)];
    [savedQuesCountLabel setText:@"1"];
    savedQuesCountLabel.hidden=YES;
    [savedQuesCountLabel setFont:[UIFont systemFontOfSize:10.0f]];
    [savedQuesCountLabel setFont:[UIFont boldSystemFontOfSize:10.0f]];
    [savedQuesCountLabel setTextAlignment:NSTextAlignmentCenter];
    [savedQuesCountLabel setTextColor:[UIColor whiteColor]];
    [savedQuesCountLabel setBackgroundColor:BUTTONCOLOR];
    [savedQuesBtn addSubview:savedQuesCountLabel];
    
    

    //Posted Ques Button
    UIButton *postedQuesBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    postedQuesBtn.frame=CGRectMake(acceptedBtn.frame.origin.x+50, acceptedBtn.frame.origin.y+acceptedBtn.frame.size.height,60,100);
    [postedQuesBtn addTarget:self action:@selector(questionsBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    postedQuesBtn.clipsToBounds=YES;
    [homeView addSubview:postedQuesBtn];
    
    UIImageView *postedImageView=[[UIImageView alloc]initWithFrame:CGRectMake((postedQuesBtn.frame.size.width-30)/2, (postedQuesBtn.frame.size.height-20)/2, 30, 30)];
    [postedImageView setImage:[UIImage imageNamed:@"posted_question"]];
    [postedQuesBtn addSubview:postedImageView];
    
    
    postedCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(postedImageView.frame.origin.x+postedImageView.frame.size.width-20, postedImageView.frame.origin.y,20,10)];
    [postedCountLabel setText:@"1"];
    postedCountLabel.hidden=YES;
    [postedCountLabel setFont:[UIFont systemFontOfSize:10.0f]];
    [postedCountLabel setFont:[UIFont boldSystemFontOfSize:10.0f]];
    [postedCountLabel setTextAlignment:NSTextAlignmentCenter];
    [postedCountLabel setTextColor:[UIColor whiteColor]];
    [postedCountLabel setBackgroundColor:BUTTONCOLOR];
    [postedQuesBtn addSubview:postedCountLabel];
    
    
    
    
    
    //Updates Button
    UIButton *updatesBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    updatesBtn.frame=CGRectMake(savedQuesBtn.frame.origin.x, savedQuesBtn.frame.origin.y+savedQuesBtn.frame.size.height, 50, 100);
     [updatesBtn addTarget:self action:@selector(updateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    updatesBtn.clipsToBounds=YES;
    [homeView addSubview:updatesBtn];
    
    UIImageView *updateImageView=[[UIImageView alloc]initWithFrame:CGRectMake((updatesBtn.frame.size.width-30)/2, (updatesBtn.frame.size.height-40)/2, 30, 30)];
    [updateImageView setImage:[UIImage imageNamed:@"second_page_refresh_icon"]];
    [updatesBtn addSubview:updateImageView];
    
    updateCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(updateImageView.frame.origin.x+updateImageView.frame.size.width-20, updateImageView.frame.origin.y,20,10)];
    [updateCountLabel setText:@"1"];
    updateCountLabel.hidden=YES;
    [updateCountLabel setFont:[UIFont systemFontOfSize:10.0f]];
    [updateCountLabel setFont:[UIFont boldSystemFontOfSize:10.0f]];
    [updateCountLabel setTextAlignment:NSTextAlignmentCenter];
    [updateCountLabel setTextColor:[UIColor whiteColor]];
    [updateCountLabel setBackgroundColor:BUTTONCOLOR];
    [updatesBtn addSubview:updateCountLabel];
    
    
    //WebDeveloper Button
    CGFloat maxYCoordinate=CGRectGetHeight(homeView.frame);
    UIButton *webDeveloperBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    webDeveloperBtn.frame=CGRectMake((homeView.frame.size.width-100)/2,maxYCoordinate-50,100, 40);
    [webDeveloperBtn setTitle:@"Web Developer" forState:UIControlStateNormal];
    [webDeveloperBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    webDeveloperBtn.titleLabel.font=LABELFONT;
    webDeveloperBtn.titleLabel.font=[UIFont boldSystemFontOfSize:12.0f];
    [homeView addSubview:webDeveloperBtn];
    
    UIImageView *webImageView=[[UIImageView alloc]initWithFrame:CGRectMake((webDeveloperBtn.frame.size.width-45)/2, (webDeveloperBtn.frame.size.height-5)/2, 40, 27)];
   // [messageImageView setImage:[UIImage imageNamed:@"main_question_icon"]];
    //[webDeveloperBtn addSubview:webImageView];
    
    
    
    //Profile Button
    profileButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //[profileButton setBackgroundColor:[UIColor redColor]];
    profileButton.frame=CGRectMake((homeView.frame.size.width-100)/2,(homeView.frame.size.height-100)/2, 100, 100);
    profileButton.layer.cornerRadius=(profileButton.frame.size.width)/2;
    [homeView addSubview:profileButton];
    
    
    picImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, profileButton.frame.size.width, profileButton.frame.size.height)];
    //[picImage setImage:[UIImage imageNamed:@"pic_upload"]];
    picImage.layer.cornerRadius=picImage.frame.size.width/2;
    //picImage.contentMode=UIViewContentModeScaleAspectFit;
    picImage.clipsToBounds=YES;
    picImage.userInteractionEnabled=YES;
    [profileButton addSubview:picImage];
    
    
    //CGRectMake(0, homeView.frame.origin.y+homeView.frame.size.height+10, self.view.frame.size.width,self.view.frame.size.height-(homeView.frame.size.height+70+70))
    UIView *detailView=[[UIView alloc]initWithFrame:CGRectMake(0, homeView.frame.origin.y+homeView.frame.size.height+10,self.view.frame.size.width , self.view.frame.size.height-(homeView.frame.size.height+70))];
    [detailView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:detailView];
    
    
//    UIButton *picBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    [picBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    [homeView addSubview:picBtn];
    CGFloat xPos=(self.view.frame.size.width-220)/2;
    
    followBtn=[[UIButton alloc]initWithFrame:CGRectMake(xPos, 5, 62, 15)];
    [followBtn setImage:[UIImage imageNamed:@"follow_button"] forState:UIControlStateNormal];
    [followBtn addTarget:self action:@selector(followBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [detailView addSubview:followBtn];
    
    addFriendBtn=[[UIButton alloc]initWithFrame:CGRectMake(followBtn.frame.origin.x+followBtn.frame.size.width+10, followBtn.frame.origin.y,80, 15)];
    addFriendBtn.hidden=YES;
    [addFriendBtn setImage:[UIImage imageNamed:@"add_friend_button"] forState:UIControlStateNormal];
    [addFriendBtn addTarget:self action:@selector(addFriendBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [detailView addSubview:addFriendBtn];
    
    messageBtn=[[UIButton alloc]initWithFrame:CGRectMake(addFriendBtn.frame.origin.x+addFriendBtn.frame.size.width+10, addFriendBtn.frame.origin.y, 62, 15)];
    [messageBtn addTarget:self action:@selector(messageView:) forControlEvents:UIControlEventTouchUpInside];
    [messageBtn setImage:[UIImage imageNamed:@"message_buttton"] forState:UIControlStateNormal];
    [detailView addSubview:messageBtn];
    
    
    UITextView *descriptionTextView=[[UITextView alloc]initWithFrame:CGRectMake(10, followBtn.frame.origin.y+followBtn.frame.size.height+10, self.view.frame.size.width,detailView.frame.size.height-100)];
    [descriptionTextView setText:@""];
    [detailView addSubview:descriptionTextView];
    
    
    
    UIView *detailData=[[UIView alloc]initWithFrame:CGRectMake(10,detailView.frame.size.height-70, detailView.frame.size.width-20,50)];
    detailData.layer.borderColor=[UIColor lightGrayColor].CGColor;
    detailData.layer.borderWidth=0.5f;
    detailData.layer.cornerRadius=4.0f;
    [detailView addSubview:detailData];
    
    //second_page_download_icon
    UIImageView *downloadImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5,(detailData.frame.size.height-30)/2, 30, 30)];
    [downloadImageView setImage:[UIImage imageNamed:@"second_page_download_icon"]];
    [detailData addSubview:downloadImageView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(downloadImageView.frame.origin.x+downloadImageView.frame.size.width+10, downloadImageView.frame.origin.y, detailData.frame.size.width-downloadImageView.frame.size.width, detailData.frame.size.width)];
    label.text=@"Label";
    label.textColor=[UIColor blackColor];
    label.font=[UIFont systemFontOfSize:12.0f];
    [detailData addSubview:label];
}

-(void)createHomeUI
{
    UIImageView *backgroundImageView=[[UIImageView alloc]initWithFrame:self.view.frame];
    backgroundImageView.image=[UIImage imageNamed:@"bg"];
    [self.view addSubview:backgroundImageView];
    
    
    UIButton *settingsBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    settingsBtn.frame=CGRectMake(10, 10, 44, 44);
    [settingsBtn setImage:[UIImage imageNamed:@"main_setting_icon"] forState:UIControlStateNormal];
    [self.view addSubview:settingsBtn];
    
    
    CGFloat maxXFrame=CGRectGetMaxX(self.view.frame);
    UIButton *addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame=CGRectMake(maxXFrame-54, 10, 44, 44);
    [addBtn setImage:[UIImage imageNamed:@"main_top_arrow"] forState:UIControlStateNormal];
    [self.view addSubview:addBtn];
    
    
    
    //RoundView
    UIView *homeView=[[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-240)/2,10, 240, 240)];
    //[homeView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:homeView];
    
    //RoundImageView
    UIImageView *roundImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, homeView.frame.size.width, homeView.frame.size.height)];
    [roundImageView setImage:[UIImage imageNamed:@"profile_bg"]];
    [homeView addSubview:roundImageView];
    
    
    
    
    //Friends Button
    CGFloat maxWidth=CGRectGetWidth(homeView.frame);
    UIButton *friendsBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    friendsBtn.frame=CGRectMake(maxWidth-110,0,90,90);
    friendsBtn.clipsToBounds=YES;
    
    UIImageView *friendsImageView=[[UIImageView alloc]initWithFrame:CGRectMake((friendsBtn.frame.size.width-30)/2,(friendsBtn.frame.size.height-25)/2, 40, 27)];
    [friendsImageView setImage:[UIImage imageNamed:@"main_user_group_icon"]];
    [friendsBtn addSubview:friendsImageView];
    [homeView addSubview:friendsBtn];
    
    
    
    //Notifications Button
    UIButton *notificationBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    notificationBtn.frame=CGRectMake(10,10,120,90);
    notificationBtn.clipsToBounds=YES;
    [homeView addSubview:notificationBtn];
    
    //Notification Image
    UIImageView *notificationImageView=[[UIImageView alloc]initWithFrame:CGRectMake((notificationBtn.frame.size.width-45)/2, (notificationBtn.frame.size.height-50)/2, 40, 27)];
    [notificationImageView setImage:[UIImage imageNamed:@"main_notification_icon"]];
    [notificationBtn addSubview:notificationImageView];
    
   
    
    
    
    
    //Cart Button
    UIButton *cartBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    cartBtn.frame=CGRectMake(friendsBtn.frame.origin.x+50, friendsBtn.frame.origin.y+friendsBtn.frame.size.height,60,100);
    cartBtn.clipsToBounds=YES;
    [homeView addSubview:cartBtn];
    
    UIImageView *cartImageView=[[UIImageView alloc]initWithFrame:CGRectMake((cartBtn.frame.size.width-40)/2, (cartBtn.frame.size.height-20)/2, 40, 27)];
    [cartImageView setImage:[UIImage imageNamed:@"main_cart_icon"]];
    [cartBtn addSubview:cartImageView];
    
    
    
    
    
    //FriendRequest Button
    UIButton *friendsRequestBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    friendsRequestBtn.frame=CGRectMake(notificationBtn.frame.origin.x, notificationBtn.frame.origin.y+notificationBtn.frame.size.height, 50, 100);
    friendsRequestBtn.clipsToBounds=YES;
    [homeView addSubview:friendsRequestBtn];
    
    UIImageView *friendRequestImageView=[[UIImageView alloc]initWithFrame:CGRectMake((friendsRequestBtn.frame.size.width-45)/2, (friendsRequestBtn.frame.size.height-40)/2, 40, 27)];
    [friendRequestImageView setImage:[UIImage imageNamed:@"main_user_question_icon"]];
    [friendsRequestBtn addSubview:friendRequestImageView];
     
    
    //Messages Button
    CGFloat maxYCoordinate=CGRectGetHeight(homeView.frame);
    UIButton *messagesBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    messagesBtn.frame=CGRectMake((homeView.frame.size.width-100)/2,maxYCoordinate-60,100, 40);
    [homeView addSubview:messagesBtn];
    
    UIImageView *messageImageView=[[UIImageView alloc]initWithFrame:CGRectMake((messagesBtn.frame.size.width-45)/2, (messagesBtn.frame.size.height-5)/2, 40, 27)];
    [messageImageView setImage:[UIImage imageNamed:@"main_question_icon"]];
    [messagesBtn addSubview:messageImageView];
    
    
    
    //Profile Button
    profileButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //[profileButton setBackgroundColor:[UIColor redColor]];
    profileButton.frame=CGRectMake((homeView.frame.size.width-100)/2,(homeView.frame.size.height-100)/2, 100, 100);
    profileButton.layer.cornerRadius=(profileButton.frame.size.width)/2;
    [homeView addSubview:profileButton];
    
    
    picImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, profileButton.frame.size.width, profileButton.frame.size.height)];
    //[picImage setImage:[UIImage imageNamed:@"pic_upload"]];
    picImage.layer.cornerRadius=picImage.frame.size.width/2;
    picImage.contentMode=UIViewContentModeScaleAspectFit;
    picImage.clipsToBounds=YES;
    picImage.userInteractionEnabled=YES;
    [profileButton addSubview:picImage];
    
    
    UIButton *picBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [picBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [homeView addSubview:picBtn];
}


-(void)createUI
{

    NavigationView *nav = [[NavigationView alloc] init];
    nav.titleView.text=@"HOME";
    [self.view addSubview:nav.navigationView];
    
    picImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 60, 80,70)];
   
    //[picImage setImage:[UIImage imageNamed:@"pic_upload"]];
    [self.view addSubview:picImage];
    

    int notificationCount=[notificationsArray count];
  
  
  
    notificationViewBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    notificationViewBtn.frame=CGRectMake(10, picImage.frame.origin.y+picImage.frame.size.height-10, 120, 40);
    notificationViewBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0f];
    [notificationViewBtn setTitle:@"Notifications" forState:UIControlStateNormal];
    [notificationViewBtn setTitle:[NSString stringWithFormat:@"Notifications[%d]",notificationCount] forState:UIControlStateNormal];
    [notificationViewBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    if (notificationCount>0)
//    {
//        [notificationViewBtn addTarget:self action:@selector(notificationsView) forControlEvents:UIControlEventTouchUpInside];
//    }
//    else
//    {
//        
//    }
    [self.view addSubview:notificationViewBtn];
    
    notificationTableView=[[UITableView alloc]init];
    notificationTableView.layer.borderColor=[UIColor blackColor].CGColor;
    notificationTableView.layer.borderWidth=1.0f;
    notificationTableView.frame=CGRectMake(10, notificationViewBtn.frame.origin.y+notificationViewBtn.frame.size.height-10, 300,100);
    notificationTableView.dataSource=self;
    notificationTableView.delegate=self;
    notificationTableView.userInteractionEnabled=YES;
  
    
   
    
   

   

  
    
    nameLbl=[[UILabel alloc]initWithFrame:CGRectMake(100, picImage.frame.origin.y, 200, 50)];
    [nameLbl setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];


    
   
 
    
  
  

   
    
    
    
    
   tableArray=[[NSArray alloc]initWithObjects:@"General",@"Private/Friend's Posts",@"Posted Questions",@"Saved Posts",@"Accepted Answers", nil];
    
    tblView=[[UITableView alloc]init];
    CGSize result=[[UIScreen mainScreen]bounds].size;
    if (result.height==480)
    {
         tblView.frame=CGRectMake(0, notificationTableView.frame.origin.y+notificationTableView.frame.size.height+10, 320, self.view.frame.size.height-(picImage.frame.size.height+notificationTableView.frame.size.height+110+40));
    }
    else
    {
   tblView.frame=CGRectMake(0, notificationTableView.frame.origin.y+notificationTableView.frame.size.height+10, 320, self.view.frame.size.height-(picImage.frame.size.height+notificationTableView.frame.size.height+80));
        
    }

   
    tblView.delegate=self;
    tblView.dataSource=self;
    [self.view addSubview:tblView];
    
    
    if ([notificationsArray count]>0)
    {
        [self.view addSubview:notificationTableView];
     
    }
    if ([notificationsArray count]>3)
    {
          // [self.view addSubview:loadMoreBtn];
    }
    
 
 
       
   
  
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==notificationTableView)
    {
        return 30;
    }
    else
    {
        return 60;
    }
}

-(void) pushNotificationData
{
    [[AppDelegate sharedDelegate] setPushNotificationFetching:YES];
    NSArray *userData=[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil];
    NSString *userId=[userData valueForKey:@"id"];
    id pushNotificationData =[[WebServiceSingleton sharedMySingleton]pushNotificationData:userId];
    
    NSString *success=[[pushNotificationData valueForKey:@"success"] objectAtIndex:0];
    if ([success boolValue])
    {
  
        NSMutableArray *alldateArray=[[NSMutableArray alloc]init];
        
        NSMutableArray *messageNotification=[[pushNotificationData valueForKey:@"message_data"]objectAtIndex:0];
        
        if (![messageNotification isKindOfClass:[NSNull class]])
        {
            alldateArray=[[alldateArray arrayByAddingObjectsFromArray:messageNotification]mutableCopy];
        }
        
        NSMutableArray *addAnswerNotification=[[pushNotificationData valueForKey:@"add_answer_data"]objectAtIndex:0];
        
        if (![addAnswerNotification isKindOfClass:[NSNull class]])
        {
            alldateArray=[[alldateArray arrayByAddingObjectsFromArray:addAnswerNotification]mutableCopy];
        }
        
        NSMutableArray *acceptAnswersNotification=[[pushNotificationData valueForKey:@"accept_answer_data"]objectAtIndex:0];
        
        if (![acceptAnswersNotification isKindOfClass:[NSNull class]])
        {
            alldateArray=[[alldateArray arrayByAddingObjectsFromArray:acceptAnswersNotification]mutableCopy];
        }
        NSMutableArray *friendsNotification=[[pushNotificationData valueForKey:@"friend_data"]objectAtIndex:0];
        if (![friendsNotification isKindOfClass:[NSNull class]])
        {
            alldateArray=[[alldateArray arrayByAddingObjectsFromArray:friendsNotification]mutableCopy];
        }
        
        
        
        NSMutableArray *newArray = [[NSMutableArray alloc] init];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
        for (id obj in alldateArray) {
            
            NSMutableDictionary *dict = [obj mutableCopy];
            NSDate *date = [df dateFromString:[dict objectForKey:@"date"]];
            NSTimeInterval interval = [date timeIntervalSince1970];
            [dict setObject:@(interval) forKey:@"date"];
            [newArray addObject:dict];
        }
    
    
        NSLog(@"%@", newArray);
        
    NSMutableArray *sortedArray;
    NSSortDescriptor *descriptor=[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    sortedArray=[[newArray sortedArrayUsingDescriptors:@[descriptor]]mutableCopy];
    
    
    
    NSMutableArray *notificationArray=[[NSMutableArray alloc]init];
    for (int i=0; i<[sortedArray count]; i++)
    {
        [notificationArray insertObject:[sortedArray objectAtIndex:i] atIndex:i];
        if (notificationArray.count==10)
        {
            break;
        }
    }
    

    
    
    
    
    
    NSString *messageData;
    NSString *questionId;
    NSString *value=@"0";
    NSManagedObject *message;
    
    
    for (int i=0; i<[notificationArray count]; i++)
    {
        NSString *category=[[notificationArray valueForKey:@"type"]objectAtIndex:i];
        NSArray *notifyArray=[notificationArray objectAtIndex:i];
        if ([category isEqualToString:@"message_data"])
        {
            NSString *userName=[notifyArray valueForKey:@"sender_name"];
            messageData=[NSString stringWithFormat:@"%@ sent you a message",userName];
            questionId=[notifyArray valueForKey:@"sender_id"];
        }
        else if ([category isEqualToString:@"accept_answer_data"])
        {
            NSString *userName=[notifyArray valueForKey:@"name"];
            questionId=[notifyArray valueForKey:@"questionId"];
            messageData=[NSString stringWithFormat:@"%@ your answer accepted",userName];
            
        }
        else if ([category isEqualToString:@"add_answer_data"])
        {
            NSString *userName=[notifyArray valueForKey:@"who_answer_name"];
            questionId=[notifyArray valueForKey:@"questionId"];
            messageData=[NSString stringWithFormat:@"%@ answered a question",userName];
        }
        else if ([category isEqualToString:@"friend_request_data"])
        {
            questionId=[notifyArray valueForKey:@"receiver_id"];
            NSString *userName=[notifyArray valueForKey:@"name"];
            NSString *status=[notifyArray valueForKey:@"status "];
            if ([status isEqualToString:@"0"])
            {
                messageData=[NSString stringWithFormat:@"%@  you have one friend request",userName];
            }
            else
            {
                messageData=[NSString stringWithFormat:@"%@  your friend request accepted",userName];
            }
            
            
        }
      
    
        
        
        
        NSManagedObjectContext *context = [[AppDelegate sharedDelegate]managedObjectContext];
        message = [NSEntityDescription insertNewObjectForEntityForName:@"NotificationsData" inManagedObjectContext:context];
        
        [message setValue:messageData forKeyPath:@"message"];
        [message setValue:questionId forKeyPath:@"questionId"];
        [message setValue:value forKeyPath:@"status"];
        
        NSError *error;
        [context save:&error];
        
        }
        
         [self getNotifications];
         NSLog(@"%@",notificationsArray);
        [[AppDelegate sharedDelegate] setPushNotificationFetching:NO];
        
        
        
        
        
    }
    else
    {
        
    }
    
}




-(void) getNotifications
{
    
    notificationsArray=[[NSMutableArray alloc]init];
   NSArray *arrayObjects=[[NSArray alloc]init];
    AppDelegate *appDelegate =[AppDelegate sharedDelegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"NotificationsData" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    //[request setFetchLimit:10];
  
    
    NSError *error;
  
   // NSArray *array=[context executeFetchRequest:request error:&error];
    
//    if (array.count>10)
//    {
//        for (int i=0; i<[array count]-10; i++)
//        {
//            [context deleteObject:[array objectAtIndex:i]];
//            [context save:nil];
//        }
//    
//    }
//    NSLog(@"%@",array);
    
   arrayObjects = [context executeFetchRequest:request error:&error];
   // arrayObjects = [[arrayObjects reverseObjectEnumerator] allObjects];
    
  
    
  
    
    for (int i=[arrayObjects count]-1; i>=0; i--)
    {
        
        //NotificationsData *not = arrayObjects[i];
        
        
        if ([notificationsArray count] < 10)
        {
            [notificationsArray addObject:[arrayObjects objectAtIndex:i]];
        }
        else {
            [context deleteObject:[arrayObjects objectAtIndex:i]];
        }
    }
   
    
    [context save:nil];
    
    notificationsArray = [[[notificationsArray reverseObjectEnumerator] allObjects] mutableCopy];

    

    
  
   [notificationTableView reloadData];
    NSLog(@"%@",notificationsArray);
    
    
    
}




-(void)notificationsView
{
        notificationsView=[[UIView alloc]init];
        notificationsView.frame=CGRectMake(0, 44,self.view.frame.size.width, self.view.frame.size.height);
        notificationsView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        [self.view addSubview:notificationsView];
        
        
        notificationsDetailTableView=[[UITableView alloc]init];
        notificationsDetailTableView.frame=CGRectMake(20, (self.view.frame.size.height-300)/2, (self.view.frame.size.width-40), 250);
        [notificationsDetailTableView setBackgroundColor:[UIColor grayColor]];
        notificationsDetailTableView.dataSource=self;
        notificationsDetailTableView.delegate=self;
        
        [[notificationsDetailTableView layer] addAnimation:[AppDelegate popupAnimation] forKey:@"popupAnimation"];
        [notificationsView addSubview:notificationsDetailTableView];
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignView)];
        tapGesture.delegate=self;
        //tapGesture.numberOfTapsRequired=2;
        [notificationsView addGestureRecognizer:tapGesture];
    
    
    
}

-(void) resignView
{
    [notificationsView removeFromSuperview];
    
    
}

-(void)userValueSet
{

//    personalDetailarray=[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil];
//    NSLog(@"%@",personalDetailarray);
    
    NSArray *userId=[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"], nil];
    NSLog(@"%@",userId);
    [nameLbl setFont:[UIFont fontWithName:@"Helvetica" size:20.0f]];
    nameStr=[[personalDetailarray objectAtIndex:0]valueForKey:@"name"];
    
    if (nameValue==0)
    {
        //[nameLbl setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
        
         //nameLbl=[[UILabel alloc]initWithFrame:CGRectMake(150, picImage.frame.origin.y-10, 200, 100)];
         nameLbl.text=[NSString stringWithFormat:@"%@",nameStr];
    }
    else
    {
         nameLbl.text=[NSString stringWithFormat:@"Welcome %@",nameStr];
    }
   
    ids=[[personalDetailarray objectAtIndex:0]valueForKey:@"id"];
 
    [self.view addSubview:nameLbl];
    
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(profileImageAction)];
    tapGesture.numberOfTapsRequired=1;
    picImage.userInteractionEnabled=YES;
   
    
    NSString *profilePic=[[personalDetailarray valueForKey:@"profile_pic"]objectAtIndex:0];
    if ([profilePic isEqualToString:@""] || [profilePic isEqualToString:@"(null)"])
    {
        id loginDetail=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginDetails"];
        NSString *loginId=[loginDetail valueForKey:@"loginId"];
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
    NSString *lastName=[[personalDetailarray valueForKey:@"lname"]objectAtIndex:0];
    NSString *fullName=[NSString stringWithFormat:@"%@%@",nameStr,lastName];
    //[profileButton setTitle:fullName forState:UIControlStateNormal];
    
    
    [picImage setImageWithURL:[NSURL URLWithString:profilePic] placeholderImage:[UIImage imageNamed:@"pic_upload"]];
    convertedImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profilePic]]];
    [picImage addGestureRecognizer:tapGesture];
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,profileButton.frame.size.height-40, profileButton.frame.size.width, 30)];
    [nameLabel setText:fullName];
    //[profileButton addSubview:nameLabel];
    [nameLabel setFont:LABELFONT];
    [nameLabel setTextColor:[UIColor whiteColor]];
    
   
    
    
    NSString  *acceptedAnswersCount=[[personalDetailarray valueForKey:@"AllAcceptedAnswersCount"]objectAtIndex:0];
    NSString *generalQuestionCount=[[personalDetailarray valueForKey:@"AllQuestionsCount"]objectAtIndex:0];
    NSString *savedQuestionCount=[[personalDetailarray valueForKey:@"SavedQuestionsCount"]objectAtIndex:0];
    ques=[[personalDetailarray objectAtIndex:0]valueForKey:@"no_of_ques"];
    int postedQuesCount=[ques intValue];
    NSString *updateCountStr=[[personalDetailarray valueForKey:@"RecentUpdateCount"]objectAtIndex:0];
    int updateCount=[updateCountStr intValue];
    
    
    if ([acceptedAnswersCount isEqualToString:@"0"])
    {
        acceptQuesCountLabel.hidden=YES;
    }
    else
    {
        acceptQuesCountLabel.hidden=NO;
        acceptQuesCountLabel.text=acceptedAnswersCount;
    }
    
    if ([savedQuestionCount isEqualToString:@"0"])
    {
        savedQuesCountLabel.hidden=YES;
    }
    else
    {
        savedQuesCountLabel.hidden=NO;
        savedQuesCountLabel.text=savedQuestionCount;
    }
    
    if (postedQuesCount==0)
    {
        postedCountLabel.hidden=YES;
    }
    else
    {
        postedCountLabel.hidden=NO;
        postedCountLabel.text=[NSString stringWithFormat:@"%d",postedQuesCount];
    }
    
    if (updateCount==0)
    {
        updateCountLabel.hidden=YES;
    }
    else
    {
        updateCountLabel.hidden=NO;
        updateCountLabel.text=[NSString stringWithFormat:@"%d",updateCount];
    }
    
    
    
    id userData=[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"];
    NSString *friendRelation=[userData valueForKey:@"friendRel"];
    NSString *userType=[userData valueForKey:@"usertype"];
    
    int relationInt=[friendRelation intValue];
   
    
    //If relation is sending request or receive request
    if (relationInt==0)
    {
        if ([userType rangeOfString:@"receiver"].location!=NSNotFound)
        {
            [addFriendBtn setImage:[UIImage imageNamed:@"friend_request_received"] forState:UIControlStateNormal];
        }
        else
        {
           [addFriendBtn setImage:[UIImage imageNamed:@"friend_request_send"] forState:UIControlStateNormal];
        }
    }
    
    //If User relation is friend
    else  if (relationInt==1)
    {
    
        //Send message to user
        addFriendBtn.hidden=YES;
        
        if (!value)
        {
            CGRect followBtnFrame=followBtn.frame;
            followBtnFrame.origin.x=followBtnFrame.origin.x+45;
            followBtn.frame=followBtnFrame;
            
            CGRect messageFrame=messageBtn.frame;
            messageFrame.origin.x=messageFrame.origin.x-45;
            messageBtn.frame=messageFrame;
            value=YES;
        }
    
    }
    //if friend request rejected
    else if (relationInt==2)
    {
        
    }
    //If no relation
    else if (relationInt==3)
    {
        addFriendBtn.hidden=NO;
//        UIAlertView *friendRequest=[[UIAlertView alloc]initWithTitle:@"Friend Request" message:@"Do you want to send friend request?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
//        friendRequest.tag=2;
//        [friendRequest show];
    }

 
    
    
   
    

    
    
    
    //To Do
    NSString *friendsPostCount=[[personalDetailarray valueForKey:@"AllQuestionsByFriendsCount"]objectAtIndex:0];
    
    
    totalQuestionCount=[[NSArray alloc]initWithObjects:generalQuestionCount,friendsPostCount,ques,savedQuestionCount,acceptedAnswersCount,nil];
    
    [tblView reloadData];
    
}

-(void) profileImageAction
{
    
//    AddFriendViewController *addFriend=[[AddFriendViewController alloc]init];
//    addFriend.friendUserId=_friendID;
//    [self.navigationController pushViewController:addFriend animated:NO];
    
      [[AppDelegate sharedDelegate].TabBarView gotoFriendProfileScreenWithFriendID:_friendID];
    
    
//    UserDetailViewController *userDetail=[[UserDetailViewController alloc]init];
//    userDetail.messageValue=50;
//    [self.navigationController pushViewController:userDetail animated:NO];
//    imageScrollView=[[UIScrollView alloc]init];
//    imageScrollView.delegate=self;
//    imageScrollView.frame=CGRectMake(0,0, 320, self.view.frame.size.height-44);
//    imageScrollView.maximumZoomScale=5.0;
//    imageScrollView.minimumZoomScale=1.0;
//    
//    if (imageScrollView.minimumZoomScale)
//    {
//        imagePostQuestion.frame=CGRectMake(100, 100, 320, self.view.frame.size.height-44);
//    }
//    else
//    {
//        imagePostQuestion.frame=CGRectMake(0, 0, 320, self.view.frame.size.height-44);
//    }
//    
//    
//    
//    
//    [self.view addSubview:imageScrollView];
//    
//    imagePostQuestion=[[UIImageView alloc]init];
//    imagePostQuestion.frame=CGRectMake(0, 0, 320, self.view.frame.size.height-44);
// 
//    if (convertedImage)
//    {
//    imagePostQuestion.image=convertedImage;
//    }
//    [imageScrollView addSubview:imagePostQuestion];
//
//
//    UITapGestureRecognizer *imageGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignImageView)];
//    imageGesture.numberOfTapsRequired=1;
//    [imageScrollView addGestureRecognizer:imageGesture];
//    
//    
//    
//    UIPinchGestureRecognizer *pinchGesture=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchImageGesture:)];
//    [pinchGesture setDelegate:self];
//    [imageScrollView addGestureRecognizer:pinchGesture];
//    
//    
//    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
//    [rotationRecognizer setDelegate:self];
//    [imageScrollView addGestureRecognizer:rotationRecognizer];
}

-(void) resignImageView
{
    [imageScrollView removeFromSuperview];
}



- (void)handleRotate:(UIRotationGestureRecognizer *)recognizer
{
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    recognizer.rotation = 0;
}

-(void) pinchImageGesture:(UIPinchGestureRecognizer*)recognizer
{
    UIGestureRecognizerState state = [recognizer state];
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGFloat scale = [recognizer scale];
        [recognizer.view setTransform:CGAffineTransformScale(recognizer.view.transform, scale, scale)];
        [recognizer setScale:1.0];
    }
}

-(BOOL) prefersStatusBarHidden
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [[[SDWebImageManager sharedManager] imageCache] clearDisk];
    [[[SDWebImageManager sharedManager] imageCache] clearMemory];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView Methods
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==notificationTableView)
    {
        //return ([notificationsArray count] <= 3) ? [notificationsArray count] : 3;
        return notificationsArray.count;
    }
    else if(tableView==tblView)
    {
        return [tableArray count];
    }
    else
    {
        return [notificationsArray count];
    }
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
//        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 59.5, self.view.frame.size.height, 0.5)];
//        [lineView setBackgroundColor:[UIColor lightGrayColor]];
//        [cell.contentView addSubview:lineView];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
   // cell.textLabel.text=[tableArray objectAtIndex:indexPath.row];
    
    //
          NSLog(@"%lu",(unsigned long)[notificationsArray count]);
    
    if (tableView==notificationTableView)
    {
    cell.textLabel.font=[UIFont fontWithName:@"Helvetica" size:12.0f];
    
    NotificationsData *notificationsData=(NotificationsData*)[notificationsArray objectAtIndex:indexPath.row];
        NSLog(@"%@",notificationsData.message);
   cellTextStr=notificationsData.message;
   cell.textLabel.text=notificationsData.message;
   NSString *questionID=notificationsData.questionId;
   notificationsData.status=@"1";
   NSString *status=notificationsData.status;
        
        if ([status isEqualToString:@"0"])
        {
            
        }
        else
        {
            
        }
        
        NSLog(@"%@",cellTextStr);
        //cell.textLabel.text=[notificationsArray objectAtIndex:indexPath.row];
       
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 29.5, self.view.frame.size.height, 0.5)];
        [lineView setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:lineView];
     
    

    }
    else if(tableView==tblView)
    {
        cell.textLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0f];
        if (totalQuestionCount.count==0)
        {
           cell.textLabel.text=[NSString stringWithFormat:@"%@ [0]",[tableArray objectAtIndex:indexPath.row]];
        }
        else
        {
            cell.textLabel.text=[NSString stringWithFormat:@"%@ %@",[tableArray objectAtIndex:indexPath.row],[totalQuestionCount objectAtIndex:indexPath.row]];
        }
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else
    {
        NotificationsData *notificationsData=(NotificationsData*)[notificationsArray objectAtIndex:indexPath.row];
        
        
        
        cellTextStr=notificationsData.message;
        cell.textLabel.text=notificationsData.message;
        cell.textLabel.textColor=[UIColor whiteColor];
        cell.backgroundColor=[UIColor grayColor];
        cell.textLabel.font=[UIFont fontWithName:@"Helvetica" size:12.0f];
        cell.textLabel.numberOfLines=1;
        
    }
  
    
   

   
     return cell;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%@",notificationsArray);
  if(tableView==tblView)
    {
        
    
    if (indexPath.row==0)
    {
        
        GeneralViewController *generalView=[[GeneralViewController alloc]init];
        NSString *totalQuesString=[[personalDetailarray valueForKey:@"AllQuestionsCount"]objectAtIndex:0];
        generalView.totalQuesString=totalQuesString;
        [self.navigationController pushViewController:generalView animated:NO];
    }
    else if (indexPath.row==1)
    {
        FriendPostViewController *friendPost=[[FriendPostViewController alloc]init];
        NSString *totalQuesString=[[personalDetailarray valueForKey:@"AllQuestionsByFriendsCount"]objectAtIndex:0];
        friendPost.totalQuesString=totalQuesString;
        [self.navigationController pushViewController:friendPost animated:NO];
    }
   
    else if (indexPath.row==2)
    {
        QuestionViewController *questionView=[[QuestionViewController alloc]init];
        [self.navigationController pushViewController:questionView animated:NO];
//        PostQuestionDetailViewController *profile=[[PostQuestionDetailViewController alloc]init];
//        profile.ques=ques;
//        profile.ids=ids;
//        [self.navigationController pushViewController:profile animated:NO];
      
    }
    else if (indexPath.row==3)
    {
        SavedPostViewController *savedPost=[[SavedPostViewController alloc]init];
        NSString *totalQuesString=[[personalDetailarray valueForKey:@"SavedQuestionsCount"]objectAtIndex:0];
        savedPost.totalQuesString=totalQuesString;
        [self.navigationController pushViewController:savedPost animated:NO];
    }
    
   else if (indexPath.row==4)
    {
        AcceptAnswerViewController *acceptAnswer=[[AcceptAnswerViewController alloc]init];
        //NSString *totalQuesString=[[personalDetailarray valueForKey:@"AllAcceptedAnswersCount"]objectAtIndex:0];
        [self.navigationController pushViewController:acceptAnswer animated:NO];
    }
    }
    //Notification
   else
   {
       NotificationsData *notificationsData=(NotificationsData*)[notificationsArray objectAtIndex:indexPath.row];
       cellTextStr=notificationsData.message;
       NSString *questionId=notificationsData.questionId;
       
       //Send Message
       if ([cellTextStr rangeOfString:@"message"].location!=NSNotFound)
       {
           UserDetailViewController *userDetail=[[UserDetailViewController alloc]init];
           userDetail.messageValue=3;
           NSString *sender_id=[[personalDetailarray valueForKey:@"id"]objectAtIndex:0];
           NSString *receiver_id=questionId;
           userDetail.senderId=sender_id;
           userDetail.receiverId=receiver_id;
           [self.navigationController pushViewController:userDetail animated:NO];
       }
       //Answer accepted and add answer
       
       else if([cellTextStr rangeOfString:@"answer"].location!=NSNotFound)
       {
           PostQuestionDetailViewController *postQuestion=[[PostQuestionDetailViewController alloc]init];
           postQuestion.notificationQuesId=questionId;
           postQuestion.generalViewValue=5;
           [self.navigationController pushViewController:postQuestion animated:NO];
       }
       
       //Friend Request Accepted
    
       else if ([cellTextStr rangeOfString:@"request accepted"].location!=NSNotFound)
       {
           UserDetailViewController *userDetail=[[UserDetailViewController alloc]init];
           userDetail.messageValue=2;
           
//           userDetail.senderId=sender_id;
//           userDetail.receiverId=receiver_id;
           userDetail.user_id=questionId;
           [self.navigationController pushViewController:userDetail animated:NO];
           
           
       }
       
       //Search friends
       else
       {
          
        SearchFriendsViewController *searchFriends=[[SearchFriendsViewController alloc]init];
        [searchFriends viewFriends];
               
        searchFriends.friendsValue=0;
       [self.navigationController pushViewController:searchFriends animated:NO];
           
       }
       
       
       
       
       
       
       
      

   }
    
    
 
  
}




//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    if ([touch.view isDescendantOfView:notificationsDetailTableView]) {
//        
//        // Don't let selections of auto-complete entries fire the
//        // gesture recognizer
//        return NO;
//    }
//    
//    return YES;
//}

//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section==0)
//    {
//        
//    }
//    else
//    {
//        
//    }
//}

-(void)navigateToGenralQuestion
{
    
    GeneralViewController *generalView=[[GeneralViewController alloc]init];
    NSString *totalQuesString=[[personalDetailarray valueForKey:@"AllQuestionsCount"]objectAtIndex:0];
    generalView.totalQuesString=totalQuesString;
    [self.navigationController pushViewController:generalView animated:NO];
   
}

#pragma  mark Home Delegate Methods

-(void) success
{
    NSArray *userid=[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"], nil];
    NSLog(@"%@",userid);
    [self successFullyUpdated:userid];
}



-(void)successFullyUpdated :(NSArray *)array
{
    //personalDetailarray=array;
    personalDetailarray=[[NSArray alloc]initWithObjects:array, nil];
    
    [self userValueSet];
    
    
    
}
-(void)failedToupdate
{
    
    UIView *messageView=[[UIView alloc]init];
    messageView.frame=self.view.bounds;
    messageView.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:messageView];

    UIAlertView *errorAlertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"User data is not available" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [errorAlertView show];
    

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *sender_Id=[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"];
    // NSString *receiverId=[[friendsData valueForKey:@"id"]objectAtIndex:acceptRequestAlert.tag];
    NSString *receiver_Id=_friendID;
    
    //LogOut Alert View
    if (alertView.tag==1)
    {
        if (buttonIndex==1)
        {
            LoginViewController_iPhone *loginView=[[LoginViewController_iPhone alloc]init];
            [AppDelegate sharedDelegate].navController=[[[AppDelegate sharedDelegate]navController]initWithRootViewController:loginView];
        }
  
    }
    //Friend Request Send AlertView
    else if (alertView.tag==2)
    {
        if (buttonIndex==1)
        {
//               NSString *sender_Id=[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"];
//                // NSString *receiverId=[[friendsData valueForKey:@"id"]objectAtIndex:acceptRequestAlert.tag];
//                NSString *receiver_Id=_friendID;
                NSArray *requestArray=[[[WebServiceSingleton sharedMySingleton]sendFriendRequest:sender_Id receiverId:receiver_Id]objectAtIndex:0];
                NSString *successArray=[requestArray valueForKey:@"success"];
                if (successArray)
                {
                    
                    
                    int success=[successArray intValue];
                    if (success==0)
                    {
                        UIAlertView *msg=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"You have already send friend request to this user" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                        [msg show];
                    }
                    else
                    {
                        NSString *message=[requestArray valueForKey:@"message"];
                        UIAlertView *msg1=[[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                        [msg1 show];
                        [addFriendBtn setImage:[UIImage imageNamed:@"friend_request_send"] forState:UIControlStateNormal];
                        
                        
                    }
                }
                
            
        }
    }
    // Friend Request Accepted
    else if (alertView.tag==3)
    {
       
        if (buttonIndex==1)
        {
            /*NSArray *rejectData=[[WebServiceSingleton sharedMySingleton]acceptRequest:receiver_Id senderId:sender_Id];
            int rejectStatus=[[[rejectData valueForKey:@"success"]objectAtIndex:0]intValue];
            if (rejectStatus==1)
            {
                UIAlertView *successMessage=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Friend Request Accepted" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [successMessage show];
                addFriendBtn.hidden=YES;
                //[addFriendBtn setImage:[UIImage imageNamed:@"add_friend_button"] forState:UIControlStateNormal];
            }*/
        }
     

    }
    
    
    //Friend Request Rejected
    else if (alertView.tag==4)
    {
        if (buttonIndex==1)
        {
           /* NSArray *rejectData=[[WebServiceSingleton sharedMySingleton]rejectFriendRequestSent:sender_Id receiverId:receiver_Id];
            int rejectStatus=[[[rejectData valueForKey:@"success"]objectAtIndex:0]intValue];
            if (rejectStatus==1)
            {
                UIAlertView *successMessage=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Friend Request Deleted" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [successMessage show];
                [addFriendBtn setImage:[UIImage imageNamed:@"add_friend_button"] forState:UIControlStateNormal];
                
            }
            else
            {
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Friend Request Deletion Failed" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alertView show];
            }
            */
  
        }
        
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
