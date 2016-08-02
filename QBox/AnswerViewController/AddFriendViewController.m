//
//  AddFriendViewController.m
//  QBox
//
//  Created by iApp1 on 16/01/15.
//  Copyright (c) 2015 iapp. All rights reserved.
//

#import "AddFriendViewController.h"
#import "CustomTableViewCell.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "WebServiceSingleton.h"
#import "ProgressHUD.h"
#import "NavigationView.h"
#import "PostQuestionDetailViewController.h"
#import "SPHViewController.h"
#import "QBoxService.h"
#import "QuestionTableViewCell.h"
#import "AboutUserTableViewCell.h"
#import "ImagesUserTableViewCell.h"
#import "MWPhotoBrowser.h"
#import <Photos/Photos.h>
#import "SDImageCache.h"
#import "MWCommon.h"
#define KDataType_Question  @"Question"
#define KDataType_Answer    @"Answer"
#define KDataType_About   @"About"





@interface AddFriendViewController ()<MWPhotoBrowserDelegate>
{
    UITableView *imagesuserTableView;
    NSArray *imagesuser;
    UIScrollView *imageScrollView;
    UIView *popImageView;
    UIImageView *ImagePostQuestion ;
    NSMutableArray *_photos;
    NSMutableArray *imagesQuestionViews;
}
@property(assign, nonatomic) int followValue;
@property(strong, nonatomic) NSArray *postedQuesArray;
@property(strong, nonatomic) NSArray *acceptedAnswersArray;
@property(strong, nonatomic) NSArray *globalArray;
@property(strong, nonatomic) id userInfo;
@property(strong, nonatomic) NSString *dataType;
@property(assign, nonatomic) int relationInt;



@end

@implementation AddFriendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    [self requestGetAllPostQuestionandAcceptedAnswer];
    
        [[AppDelegate sharedDelegate].TabBarView  showtabar];
    NSString *userid=[[NSUserDefaults standardUserDefaults] objectForKey:@"userDetail"][@"id"];
    if([userid isEqualToString:self.friendUserId]==YES)
    {
        [self.addFriendButton setHidden:YES];
        [self.btfollow setHidden:YES];
        [self.btmessage setHidden:YES];

        
    }
    
}
- (IBAction)aboutClick:(id)sender {
    self.dataType = KDataType_About;

}

- (void)initData{
    
    [self.contentTableView registerNib:[UINib nibWithNibName:@"QuestionTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"QuestionCellIdentifier"];
    
    [self.userImageView setImage:[UIImage imageNamed:@"placeholder"]];
    self.userImageView.clipsToBounds = YES;
    self.userImageView.layer.cornerRadius=(self.userImageView.frame.size.width)/2;
    self.userImageView.layer.borderWidth=1.0f;
    self.userImageView.layer.borderColor=[UIColor grayColor].CGColor;
    
    self.userNameLabel.text = nil;
    self.userStatusLabel.text = nil;
    self.numberOfFollowLabel.text = [NSString stringWithFormat:@"Follow %@", @"0"];
    self.numberOfFollowersLabel.text = [NSString stringWithFormat:@"Followers %@", @"0"];
   
    self.dataType = KDataType_About;
}

-(void)reloadData
{
    
    self.followValue=1;
    
    //User Image
    imagesuser=[self.userInfo valueForKey:@"imagesuser"];
    NSString *userImageStr=[self.userInfo valueForKey:@"user_image_thumb"];
    if (  userImageStr==(id)[NSNull null] || [userImageStr rangeOfString:@"http://"].location==NSNotFound)
    {
        userImageStr=[NSString stringWithFormat:@"http://%@",userImageStr];
    }
    NSURL *imageUrl=[NSURL URLWithString:userImageStr];
    [self.userImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    [self.userNameLabel setText:[self.userInfo valueForKey:@"name"]];
    
    [self.lbltitle setText:[self.userInfo valueForKey:@"name"]];
    [self.userStatusLabel setText:[self.userInfo valueForKey:@"StatusText"]];

    NSString *relationStr=[self.userInfo valueForKey:@"relation"];
    self.relationInt=[relationStr intValue];
    NSString *userType=[self.userInfo valueForKey:@"usertype"];
    
    NSString *statusfollow=[self.userInfo valueForKey:@"statusfollow"];
    
    if ([statusfollow isEqualToString:@"1"])
    {
        [self.self.btfollow setImage:[UIImage imageNamed:@"btFollowing_new"] forState:UIControlStateNormal];
    }

    
    //[self.postsButton]
     
    [self.btmessage setHidden:YES];
    //If relation is sending request or receive request
    if (self.relationInt==1)
    {
        
        
        [self.self.addFriendButton setImage:[UIImage imageNamed:@"btFriend_new"] forState:UIControlStateNormal];
        [self.btmessage setHidden:NO];
    }
    
    
    
    
    
    //If User relation is friend
    else  if (self.relationInt==0)
    {
        
        //User receiving request
        if ([userType rangeOfString:@"receiver"].location!=NSNotFound)
        {
            [self.self.addFriendButton setImage:[UIImage imageNamed:@"friend_request_received"] forState:UIControlStateNormal];
        }
        //User sending request
        else
        {
            [self.self.addFriendButton setImage:[UIImage imageNamed:@"friend_request_send"] forState:UIControlStateNormal];
        }
        
        
        
        
    }
    //if friend request rejected
    else if (self.relationInt==2)
    {
        
    }
    //If no relation
    else if (self.relationInt==3)
    {
        
         [self.self.addFriendButton setImage:[UIImage imageNamed:@"add_friend_button"] forState:UIControlStateNormal];
    }

    //self.userStatusLabel.text = @"";

    NSString *follow_count=[self.userInfo valueForKey:@"follow_count"];
    self.numberOfFollowLabel.text = [NSString stringWithFormat:@"Follow %@", follow_count];
  
    NSString *followersCount=[self.userInfo valueForKey:@"follower_count"];
    self.numberOfFollowersLabel.text = [NSString stringWithFormat:@"Followers %@", followersCount];
    
    self.dataType = KDataType_About;
  
    [self.contentTableView reloadData];
    
}

#pragma mark Action Methods

-(IBAction)addFriendButtonTapped:(id)sender
{
    
    NSString *userType=[self.userInfo valueForKey:@"usertype"];
    
     if (self.relationInt==1)
     {
         
         UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Do you want to  unfriend this user?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
         [alertView show];
         alertView.tag=4;
         
                 return;
     }
    
//    id userData=[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"];
//    NSString *friendRelation=[userData valueForKey:@"friendRel"];
//    NSString *userType=[userData valueForKey:@"usertype"];
//    int self.relationInt=[friendRelation intValue];
    //If relation is 0 then sending request or receive request
    
        //If relation is sending request or receive request
        if (self.relationInt==0)
        {
            //if user receive request
            if ([userType rangeOfString:@"receiver"].location!=NSNotFound)
            {
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Do you want to accept friend request?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
                [alertView show];
                alertView.tag=3;
                [self.addFriendButton setImage:[UIImage imageNamed:@"friend_request_received"] forState:UIControlStateNormal];
            }
            else
            {
                //if user reject request
                
                UIAlertView *friendAlert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Do you want to reject friend request?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
                friendAlert.tag=2;
                [friendAlert show];
                [self.addFriendButton setImage:[UIImage imageNamed:@"friend_request_send"] forState:UIControlStateNormal];
            }
        }
    //If relation is 1 User relation is friend
    else  if (self.relationInt==1)
    {
        //Send message to user
        
       /* SPHViewController *chatView=[[SPHViewController alloc]initWithNibName:@"SPHViewController" bundle:nil];
        chatView.receiverId=_friendUserId;
        chatView.senderId=[[[AppDelegate sharedDelegate]userDetail]valueForKey:@"id"];
        chatView.friendArray=self.userInfo;
        [self.navigationController pushViewController:chatView animated:NO];*/
        
    }
    //if relation is 2 then friend request rejected
    else if (self.relationInt==2)
    {
        
    }
    //If relation is 3 then no relation means add friend
    else if (self.relationInt==3)
    {
        UIAlertView *friendRequest=[[UIAlertView alloc]initWithTitle:@"Friend Request" message:@"Do you want to send friend request?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        friendRequest.tag=1;
        [friendRequest show];
    }
    


}
-(IBAction)acceptedAnswersButtonTapped:(id)sender
{
    self.dataType = KDataType_Answer;
}

- (IBAction)postButtonTapped:(id)sender {
    self.dataType = KDataType_Question;
}


-(IBAction)backButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

-(IBAction)followButtonTapped:(id)sender
{
    
    
    //NSString *statusfollow=[self.userInfo valueForKey:@"statusfollow"];
    
  //  if ([statusfollow isEqualToString:@"1"])
    //{
      //  return;
    //}

    
    NSString *userId=[[[AppDelegate sharedDelegate]userDetail]valueForKey:@"id"];
    id followDetail=[[[WebServiceSingleton sharedMySingleton]addFollowAccount:_friendUserId andUserId:userId andStatus:@"1"]objectAtIndex:0];
    
    NSString *success=[followDetail objectForKey:@"success"];
    
    int successValue=[success intValue];
    if (successValue==1)
    {
        [self.btfollow setImage:[UIImage imageNamed:@"btFollowing_new"] forState:UIControlStateNormal];

        [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Sucessfully inserted in followers" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil]show];
    }
    else if(successValue==2)
    {
        [self.btfollow setImage:[UIImage imageNamed:@"follow_button.png"] forState:UIControlStateNormal];
        
        [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Sucessfully unfollow" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil]show];

    }
    else
    {
         [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Already inserted in followers" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil]show]; 
    }
}

-(IBAction)messageButtonTapped:(id)sender
{
  
    SPHViewController *chatView=[[SPHViewController alloc]initWithNibName:@"SPHViewController" bundle:nil];
    chatView.receiverId=self.friendUserId;
    chatView.senderId=[[[AppDelegate sharedDelegate]userDetail]valueForKey:@"id"];
   
    chatView.friendArray=self.userInfo;
    
    [self.navigationController pushViewController:chatView animated:NO];
}

#pragma mark - Setter

- (void)setDataType:(NSString *)dataType{
   
    if ([_dataType isEqualToString:dataType]) {
        return;
    }
    
    
    _dataType = dataType;
    
    
    if ([_dataType isEqualToString:KDataType_Question]) {
        [self.postsButton setBackgroundImage:[UIImage imageNamed:@"bg_btn_posts.png"] forState:UIControlStateNormal];
       // [self.postsButton setImage:[UIImage imageNamed:@"icon_question_active"] forState:UIControlStateNormal];
        [self.postsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.acceptedAnswersButton setBackgroundImage:nil forState:UIControlStateNormal];
        [self.acceptedAnswersButton setTitleColor:TEXTCOLOR forState:UIControlStateNormal];
        //[self.acceptedAnswersButton setImage:[UIImage imageNamed:@"icon_answer_inactive"] forState:UIControlStateNormal];
        
        [self.aboutButton setBackgroundImage:nil forState:UIControlStateNormal];
        [self.aboutButton setTitleColor:TEXTCOLOR forState:UIControlStateNormal];

        
        
        
    } else if([_dataType isEqualToString:KDataType_Answer]) {
        
        [self.postsButton setBackgroundImage:nil forState:UIControlStateNormal];
        [self.postsButton setTitleColor:TEXTCOLOR forState:UIControlStateNormal];
        //[self.postsButton setImage:[UIImage imageNamed:@"icon_question_inactive"] forState:UIControlStateNormal];
        
        [self.acceptedAnswersButton setBackgroundImage:[UIImage imageNamed:@"bg_btn_accepted_answers.png"] forState:UIControlStateNormal];
        [self.acceptedAnswersButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       // [self.acceptedAnswersButton setImage:[UIImage imageNamed:@"icon_answer_active"] forState:UIControlStateNormal];
        
        [self.aboutButton setBackgroundImage:nil forState:UIControlStateNormal];
        [self.aboutButton setTitleColor:TEXTCOLOR forState:UIControlStateNormal];

    }else
    {
        [self.postsButton setBackgroundImage:nil forState:UIControlStateNormal];
        [self.postsButton setTitleColor:TEXTCOLOR forState:UIControlStateNormal];
        //[self.postsButton setImage:[UIImage imageNamed:@"icon_question_inactive"] forState:UIControlStateNormal];
        
        [self.acceptedAnswersButton setBackgroundImage:nil forState:UIControlStateNormal];
        [self.acceptedAnswersButton setTitleColor:TEXTCOLOR forState:UIControlStateNormal];
        //[self.acceptedAnswersButton setImage:[UIImage imageNamed:@"icon_answer_inactive"] forState:UIControlStateNormal];
        
        [self.aboutButton setBackgroundImage:[UIImage imageNamed:@"bg_btn_posts.png"] forState:UIControlStateNormal];
        
         [self.aboutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    
    }
    
  
    [self.contentTableView reloadData];

}

#pragma mark webervice Method

-(void) resignImageView
{
    [imageScrollView removeFromSuperview];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    
    return nil;
}



-(void) popQuestionImageViewFriend:(UITapGestureRecognizer *)recognizer
{
    
    
    imagesQuestionViews= [[NSMutableArray alloc] init];
    //[imagesQuestionViews addObject:@"http://54.69.127.235/question_app/question_images/1467103364_image.png" ];
    ///  [imagesQuestionViews addObject:@"http://54.69.127.235/question_app/////question_images/1467103389_image.png" ];
    
    // NSArray *questionInfo=[questionArray objectAtIndex:recognizer.view.tag];
    NSArray *imagesuserinfor=[imagesuser objectAtIndex:(recognizer.view.tag)];
    NSString *urlString = [imagesuserinfor valueForKey:@"thumb"];
    if ([urlString rangeOfString:@"http://"].location == NSNotFound)
    {
        urlString = [NSString stringWithFormat:@"http://%@", urlString];
    }
    [ imagesQuestionViews addObject:urlString];
    int i=0;
    for (id imagesuserinfor1 in imagesuser)
    {
        
        if(i==recognizer.view.tag)
        {
            i++;
            continue;

        }
        i++;
        urlString = [imagesuserinfor1 valueForKey:@"attachment"];
        if ([urlString rangeOfString:@"http://"].location == NSNotFound)
        {
            urlString = [NSString stringWithFormat:@"http://%@", urlString];
        }
        [ imagesQuestionViews addObject:urlString];
        
    }
    if(imagesQuestionViews.count<=0)
        return;
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    
    //MWPhoto *photosds;
    MWPhoto *photo;
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    BOOL autoPlayOnAppear = NO;
    
    for(int i=0;i<imagesQuestionViews.count;i++)
    {
        photo = [MWPhoto photoWithURL:[[NSURL alloc] initWithString:imagesQuestionViews[i]]];
        
        [photos addObject:photo];
    }
    _photos=photos;
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = NO;
    browser.autoPlayOnAppear = autoPlayOnAppear;
    [browser setCurrentPhotoIndex:0];
    [self.navigationController pushViewController:browser animated:YES];
}


-(void)requestGetAllPostQuestionandAcceptedAnswer
{
    [ProgressHUD show:@"Please Wait..." Interaction:NO];
    
    NSArray *userArray =[[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil]objectAtIndex:0];
    NSString *loginId=[userArray valueForKey:@"id"];
    
   // NSString *loginId = [[[AppDelegate sharedDelegate]userDetail]valueForKey:@"id"];
    NSString *url = [NSString stringWithFormat:@"%@getAllPostQuestionandAcceptedAnswer.php?user_id=%@&login_id=%@",webserviceBaseUrl, self.friendUserId, loginId];
    
    
    NSString *token=[[NSUserDefaults standardUserDefaults]valueForKey:@"token"];
    NSString *userIdchecktoken=[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"];
    url=[NSString stringWithFormat:@"%@&token=%@&userIdchecktoken=%@",url,token,userIdchecktoken];
    

    
    __weak typeof(self) weakSelf = self;
    
    [QBoxService GET:url parameters:nil success:^(id responseObject) {

        weakSelf.postedQuesArray = responseObject[@"questions"];

        weakSelf.acceptedAnswersArray=responseObject[@"answer"];
      
        weakSelf.userInfo=responseObject[@"userinfo"];
        
        
        [weakSelf reloadData];
        
        [ProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSInteger errorCode, NSString *errorMessage) {
        [ProgressHUD showError:errorMessage];
    }];
    
}

#pragma mark -------------Delegates------------------

#pragma mark AlertView

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //SEnd Friend Request
    if (alertView.tag==1)
    {
        if (buttonIndex==1)
        {
          NSArray * personalDetailarray=[[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil]objectAtIndex:0];
            NSString *sender_Id=[personalDetailarray valueForKey:@"id"];
            // NSString *receiverId=[[friendsData valueForKey:@"id"]objectAtIndex:acceptRequestAlert.tag];
            NSString *receiver_Id=_friendUserId;
            NSArray *requestArray=[[[WebServiceSingleton sharedMySingleton]sendFriendRequest:sender_Id receiverId:receiver_Id]objectAtIndex:0];
            NSString *successArray=[requestArray valueForKey:@"status"];
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
                    
                    
                }
            }
            
        }
    }
    
    //Reject Friend Request
    else if (alertView.tag==2)
    {
        if (buttonIndex==1)
        {
           NSArray *personalDetailarray=[[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil]objectAtIndex:0];
            NSString *sender_Id=[personalDetailarray valueForKey:@"id"];
            // NSString *receiverId=[[friendsData valueForKey:@"id"]objectAtIndex:acceptRequestAlert.tag];
            NSString *receiver_Id=_friendUserId;
            
            NSArray *rejectData=[[WebServiceSingleton sharedMySingleton]rejectFriendRequestSent:sender_Id receiverId:receiver_Id];
            int rejectStatus=[[[rejectData valueForKey:@"success"]objectAtIndex:0]intValue];
            if (rejectStatus==1)
            {
                UIAlertView *successMessage=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Friend Request Deleted" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [successMessage show];
               
            }
            else
            {
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Friend Request Deletion Failed" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alertView show];
            }
            
            
        }
    }
    //Accept Friend Request
    else if (alertView.tag==3)
    {
        if (buttonIndex==1)
        {
            
            
           NSArray *personalDetailarray=[[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil]objectAtIndex:0];
            NSString *sender_Id= _friendUserId;
            // NSString *receiverId=[[friendsData valueForKey:@"id"]objectAtIndex:acceptRequestAlert.tag];
            NSString *receiver_Id=[personalDetailarray valueForKey:@"id"];;
            
            NSArray *rejectData=[[WebServiceSingleton sharedMySingleton]acceptRequest:receiver_Id senderId:sender_Id pushnotifycationid:@"0" ];
            int rejectStatus=[[[rejectData valueForKey:@"status"]objectAtIndex:0]intValue];
            if (rejectStatus==1)
            {
                UIAlertView *successMessage=[[UIAlertView alloc]initWithTitle:@"status" message:@"Friend Request Accepted" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [successMessage show];
            }
        }
    }
    else if (alertView.tag==4)
    {
        if (buttonIndex==1)
        {
            NSArray *personalDetailarray=[[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil]objectAtIndex:0];
            NSString *sender_Id=[personalDetailarray valueForKey:@"id"];
            // NSString *receiverId=[[friendsData valueForKey:@"id"]objectAtIndex:acceptRequestAlert.tag];
            NSString *receiver_Id=_friendUserId;
            
            NSArray *rejectData=[[WebServiceSingleton sharedMySingleton]rejectFriendRequestSent:sender_Id receiverId:receiver_Id];
            int rejectStatus=[[[rejectData valueForKey:@"success"]objectAtIndex:0]intValue];
            if (rejectStatus==1)
            {
                UIAlertView *successMessage=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Unfriend  success" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [self.addFriendButton setImage:[UIImage imageNamed:@"add_friend_button"] forState:UIControlStateNormal];

                [successMessage show];
                
            }
            else
            {
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Unfriend Request Deletion Failed" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alertView show];
            }
            
            
        }
    }
    

}



#pragma mark Table View Delegate Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.dataType isEqualToString:KDataType_About])

    {
        return 2;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    if ([self.dataType isEqualToString:KDataType_Question])
    {
        return [self.postedQuesArray count];
    }
    else if([self.dataType isEqualToString:KDataType_Answer])
    {
        return [self.acceptedAnswersArray count];
    }
    else
    {
        if(section==0)
         return 1;
            else
        {
           // NSString* m= imagesuser[1];
            if(imagesuser!=nil)
                return((imagesuser.count%3)==0?(imagesuser.count/3):(imagesuser.count/3+1));
            else
            return 0;
        }
    }
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
   
    
    
    static NSString *cellIdentifier = @"QuestionCellIdentifier";
    
    //if(
    
    
    if ([self.dataType isEqualToString:KDataType_Question])
    {
        
        
       // questionTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        
        //////////////////
        
      /*  QuestionTableViewCell *cell=(QuestionTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        id dictionary = [self.postedQuesArray objectAtIndex:indexPath.row];
        
        cell.questionContentLabel.text = [dictionary valueForKey:@"question"];
        
        NSString *quesDate = [dictionary valueForKey:@"question_date"];
        NSString *dateStr = [[AppDelegate sharedDelegate] localDateFromDate:quesDate];
        NSString *finalDateStr = [dateStr substringWithRange:NSMakeRange(0, 10)];
        cell.questionDateLabel.text = finalDateStr;
        
        NSString *finalTimeStr = [dateStr substringWithRange:NSMakeRange(11, dateStr.length - 11)];
        cell.questionTimeLabel.text = finalTimeStr;
        
        NSString *totalAnswers = [dictionary valueForKey:@"totalAnswers"];
        cell.answerCountLabel.text = totalAnswers;
        cell.replyLabel.text = [totalAnswers integerValue] > 1 ? @"Replies" : @"Reply";
        
       // NSString *userImage = [dictionary valueForKey:@"thumb"];
       // NSURL *imageUrl = [NSURL URLWithString:userImage];
     //   [cell.questionImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        cell.answerCountLabel.hidden = NO;
        cell.replyLabel.hidden = NO;
         return cell;*/
        
        
        ///////////////////////////////
        
        static NSString *cellIdentifier = @"Cell";
        CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        id dictionary = [self.postedQuesArray objectAtIndex:indexPath.row];
        
         if (cell == nil)
         {
         NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
         cell=[nib objectAtIndex:0];
         
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,80, self.contentTableView.frame.size.width, 1.0f)];
         [lineView setBackgroundColor:[UIColor lightGrayColor]];
         [cell.contentView addSubview:lineView];
         cell.selectionStyle=UITableViewCellSelectionStyleNone;
         }
        
        //NSArray *questionInfo=[questionArray objectAtIndex:indexPath.row];
        
        //QuestionImage
        NSString *urlString = [dictionary valueForKey:@"thumb"];
        if ([urlString rangeOfString:@"http://"].location == NSNotFound)
        {
            urlString = [NSString stringWithFormat:@"http://%@", urlString];
        }
        NSURL *imageUrl=[NSURL URLWithString:urlString];
        [cell.questionImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"name_icon"]];
        
        
        //Question Label
        [cell.questionLabel setText:[dictionary valueForKey:@"question"]];
        
        
        NSRange rangeimagepng = [urlString rangeOfString:@".png" options:NSCaseInsensitiveSearch];
        NSRange rangeimagejpg = [urlString rangeOfString:@".jpg" options:NSCaseInsensitiveSearch];
        //if (range.location != NSNotFound) {
        
        if(rangeimagepng.location != NSNotFound || rangeimagejpg.location != NSNotFound)
        
        {
            [cell.questionImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"name_icon"]];
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popquestiondetail:)];
            [cell.questionLabel addGestureRecognizer:singleTap];
            [cell.questionLabelNoImage removeFromSuperview];
            cell.questionLabel.tag=indexPath.row;
        }
        else
        {
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popquestiondetail:)];
             [cell.questionLabelNoImage addGestureRecognizer:singleTap];
            [cell.questionImageView removeFromSuperview];
            
            [cell.questionLabel removeFromSuperview];
            cell.questionLabelNoImage.tag=indexPath.row;
            [cell.questionLabelNoImage setText:[dictionary valueForKey:@"question"]];
            
        }

        
        
        //[cell.userImageView
        
        NSString *urlString1 = [self.userInfo valueForKey:@"user_image_thumb"];
        if ([urlString1 rangeOfString:@"http://"].location == NSNotFound)
        {
            urlString1 = [NSString stringWithFormat:@"http://%@", urlString1];
        }
        NSURL *imageUrl1=[NSURL URLWithString:urlString1];
        [cell.userImageView setImageWithURL:imageUrl1 placeholderImage:[UIImage imageNamed:@"name_icon"]];
        cell.userImageView.layer.cornerRadius=cell.userImageView.frame.size.width/2;
        cell.userImageView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        cell.userImageView.layer.borderWidth=1.0f;
        cell.userImageView.clipsToBounds=YES;
        
        
        
        
        [cell.ReliesLabel setText:@"Replies"];
        //Total Answers
        [cell.totalAnswersLabel setText:[NSString stringWithFormat:@"%@",[dictionary valueForKey:@"totalAnswers"]]];
        //[cell.totalAnswersLabel
        //User Name
        
          NSString *userName=[NSString stringWithFormat:@"%@",  [self.userInfo valueForKey:@"name"]];
        
        //NSString *user_name=[self.userInfo valueForKey:@"name"];
        [cell.userNameBtn setTitle:userName forState:UIControlStateNormal];
        //[cell.userNameBtn addTarget:self action:@selector(profileView:) forControlEvents:UIControlEventTouchUpInside];
        cell.userNameBtn.tag=indexPath.row;
        
        //Question Date
        NSString *timeStampString=[NSString stringWithFormat:@"%@",[dictionary valueForKey:@"question_date"]];
       /* NSString *dateStr=[[AppDelegate sharedDelegate]localDateFromDate:timeStampString];
        NSString *resultString=[dateStr substringWithRange:NSMakeRange(0, 10)];
        NSString *yearString=[resultString substringWithRange:NSMakeRange(6, 4)];
        NSString *monthString=[resultString substringWithRange:NSMakeRange(3, 2)];
        NSString *date=[resultString substringWithRange:NSMakeRange(0, 2)];
        resultString= [NSString stringWithFormat:@"%@/%@/%@",monthString,date,yearString];*/
        [cell.dateLabel setText:timeStampString];
        
        //Time Label
       // NSString *resultTime=[dateStr substringWithRange:NSMakeRange(11, dateStr.length-11)];
        //[cell.timeLabel setText:resultTime];
        
      
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
      /*  UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 100.0, cell.frame.size.width,1.0)];
        [lineView setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:lineView];*/
        
        return cell;
        
    }
    else if([self.dataType isEqualToString:KDataType_Answer])
    {
        
        
        
        
        id dictionary = [self.acceptedAnswersArray objectAtIndex:indexPath.row];

        
        
        static  NSString *cellIdentifier=@"CellIdentifier";
        CustomTableViewCell *cell=(CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil)
        {
            
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
            
        }
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        
        NSString *urlString = [dictionary valueForKey:@"thumb"];

        if ([urlString rangeOfString:@"http://"].location == NSNotFound) {
            urlString = [NSString stringWithFormat:@"http://%@", urlString];
        }
        
        NSURL *imageUrl=[NSURL URLWithString:urlString];
        NSRange rangeimagepng = [urlString rangeOfString:@".png" options:NSCaseInsensitiveSearch];
        NSRange rangeimagejpg = [urlString rangeOfString:@".jpg" options:NSCaseInsensitiveSearch];
        //if (range.location != NSNotFound) {
        
        if(rangeimagepng.location != NSNotFound || rangeimagejpg.location != NSNotFound)
        {

            [cell.questionImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"name_icon"]];
            [cell.questionLabelNoImage removeFromSuperview];
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popanswerdetail:)];
            [cell.questionLabel addGestureRecognizer:singleTap];
            cell.questionLabel.tag=indexPath.row;

            
        }
        else
        {
            [cell.questionImageView removeFromSuperview];
            
            [cell.questionLabel removeFromSuperview];
            
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popanswerdetail:)];
            [cell.questionLabelNoImage addGestureRecognizer:singleTap];
            cell.questionLabelNoImage.tag=indexPath.row;
            [cell.questionLabelNoImage setText:[dictionary valueForKey:@"answer"]];
            
        }
       
        NSString *urlString1 = [self.userInfo valueForKey:@"user_image_thumb"];
        if ([urlString1 rangeOfString:@"http://"].location == NSNotFound)
        {
            urlString1 = [NSString stringWithFormat:@"http://%@", urlString1];
        }
        NSURL *imageUrl1=[NSURL URLWithString:urlString1];
        [cell.userImageView setImageWithURL:imageUrl1 placeholderImage:[UIImage imageNamed:@"name_icon"]];
        cell.userImageView.layer.cornerRadius=cell.userImageView.frame.size.width/2;
        cell.userImageView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        cell.userImageView.layer.borderWidth=1.0f;
        cell.userImageView.clipsToBounds=YES;
        
        
        
        
        
        [cell.questionLabel setText:[dictionary valueForKey:@"answer"]];
        
        
        NSString *userName=[self.userInfo valueForKey:@"name"];
        
        [cell.userNameBtn setTitle:userName forState:UIControlStateNormal];
        cell.userNameBtn.tag=indexPath.row;
        [cell.userNameBtn addTarget:self action:@selector(userProfileBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        
        NSString *timeStampString=[NSString stringWithFormat:@"%@",[dictionary valueForKey:@"answer_date"]];
        //NSString *dateStr=[[AppDelegate sharedDelegate]localDateFromDate:timeStampString];
        //NSString *resultString=[dateStr substringWithRange:NSMakeRange(0, 10)];
        [cell.dateLabel setText:timeStampString];
        
        //Time Label
        //NSString *resultTime=[dateStr substringWithRange:NSMakeRange(11, dateStr.length-11)];
        //[cell.timeLabel setText:resultTime];
        
        UIView *lineView=[[UIView alloc]init];
        lineView.frame=CGRectMake(0, 78.0,cell.frame.size.width, 2.0);
        lineView.backgroundColor=[UIColor lightGrayColor];
        [cell.contentView addSubview:lineView];
        
        
        return cell;
        
        
        
                
        
        
        
        
        
    }
    else
    {
        
      if(indexPath.section==0)
      {
        static  NSString *cellIdentifier=@"CellIdentifier";
        AboutUserTableViewCell *cell=(AboutUserTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil)
        {
            
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"AboutUserTableViewCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
            
        }
         // return cell;
        //NSString * text=
       
        cell.lblbth.text=[self.userInfo valueForKey:@"dob"];
        cell.lblcity.text=[NSString stringWithFormat:@"%@,%@",    [self.userInfo valueForKey:@"city"],[self.userInfo valueForKey:@"state"]];
        cell.lblskill.text=[self.userInfo valueForKey:@"skill_and_interest"];
        //cell.lblstate.text=[self.userInfo valueForKey:@"state"];
        cell.lblschool.text=[self.userInfo valueForKey:@"school"];
        cell.lblworkat.text=[self.userInfo valueForKey:@"workat"];
        cell.tvabout.text=[NSString stringWithFormat:@"About Me: %@",[self.userInfo valueForKey:@"aboutme"]];
          //;


          //cell.lblbth.text=@"dsad";
        return cell;
      }
      else
        {
            static NSString *cellIdentifier = @"Cell";
            ImagesUserTableViewCell *cell = (ImagesUserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (cell == nil)
            {
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ImagesUserTableViewCell" owner:self options:nil];
                cell=[nib objectAtIndex:0];
                //UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,99.0, imagesuserTableView.frame.size.width, 0.5f)];
                //[lineView setBackgroundColor:[UIColor lightGrayColor]];
                //[cell.contentView addSubview:lineView];
                //cell.selectionStyle=UITableViewCellSelectionStyleNone;
                // imagesuserTableView.
                
            }
            
         //   return cell;
           // imagesuser=[self.userInfo valueForKey:@"imagesuser"];
             if(imagesuser==nil || imagesuser.count==0)
                return cell;
            
            //images 0
                         if(indexPath.row*3<=imagesuser.count-1)
            {
                UITapGestureRecognizer *tapGesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popQuestionImageViewFriend:)];

                NSArray *imagesuserinfor=[imagesuser objectAtIndex:indexPath.row*3];
                NSString *urlString = [imagesuserinfor valueForKey:@"thumb"];
                if ([urlString rangeOfString:@"http://"].location == NSNotFound)
                {
                    urlString = [NSString stringWithFormat:@"http://%@", urlString];
                }
                NSURL *imageUrl=[NSURL URLWithString:urlString];
                [cell.imageuserone setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"name_icon"]];
                cell.imageuserone.userInteractionEnabled = YES;
                [cell.imageuserone addGestureRecognizer:tapGesture1];
                cell.imageuserone.tag=indexPath.row*3;
                [cell.imageselectedone setHidden:YES];
                
                
                
            }
            else
            {
                
                [cell.imageselectedone removeFromSuperview];
                [cell.imageuserone removeFromSuperview];
                
                
            }
            
            //images 1
            if((indexPath.row*3+1)<=imagesuser.count-1)
            {
                NSArray *imagesuserinfor=[imagesuser objectAtIndex:(indexPath.row*3 +1)];
                NSString *urlString = [imagesuserinfor valueForKey:@"thumb"];
                if ([urlString rangeOfString:@"http://"].location == NSNotFound)
                {
                    urlString = [NSString stringWithFormat:@"http://%@", urlString];
                }
                UITapGestureRecognizer *tapGesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popQuestionImageViewFriend:)];

                NSURL *imageUrl=[NSURL URLWithString:urlString];
                [cell.imageusertwo setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"name_icon"]];
                cell.imageusertwo.tag=indexPath.row*3+1;
                cell.imageusertwo.userInteractionEnabled = YES;

                [cell.imageusertwo addGestureRecognizer:tapGesture1];
                [cell.imageselectedtwo setHidden:YES];
                
               
                
            }
            else
            {
                [cell.imageselectedtwo removeFromSuperview];
                [cell.imageusertwo removeFromSuperview];
                
            }
            
            if((indexPath.row*3+2)<=imagesuser.count-1)
            {
                UITapGestureRecognizer *tapGesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popQuestionImageViewFriend:)];

                NSArray *imagesuserinfor=[imagesuser objectAtIndex:(indexPath.row*3 +2)];
                NSString *urlString = [imagesuserinfor valueForKey:@"thumb"];
                if ([urlString rangeOfString:@"http://"].location == NSNotFound)
                {
                    urlString = [NSString stringWithFormat:@"http://%@", urlString];
                }
                NSURL *imageUrl=[NSURL URLWithString:urlString];
                [cell.imageuserthree setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"name_icon"]];
                [cell.imageuserthree addGestureRecognizer:tapGesture1];
                 [cell.imageselectedthree setHidden:YES];
                  cell.imageuserthree.userInteractionEnabled = YES;
                cell.imageuserthree.tag=indexPath.row*3+2;
                
            }
            else
            {
                [cell.imageselectedthree removeFromSuperview];
                [cell.imageuserthree removeFromSuperview];
            }
            return cell;

            
            
       
        }
       
    }
    
   
    
    /*
    if (cell==nil)
    {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 79, self.view.frame.size.width, 1.0)];
        [lineView setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:lineView];
        
        cell.timeImageView.hidden=YES;
        cell.dateImageView.hidden=YES;
        cell.dateLabel.hidden=YES;
        cell.timeLabel.hidden=YES;
        cell.self.userImageView.hidden=YES;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        
        
        CGRect calenderImageFrame=cell.dateImageView.frame;
        
        UIImageView *calenderImageView=[[UIImageView alloc]initWithFrame:CGRectMake(cell.questionLabel.frame.origin.x,calenderImageFrame.origin.y,calenderImageFrame.size.width,calenderImageFrame.size.height)];
        [calenderImageView setImage:[UIImage imageNamed:@"small_calendar_icon"]];
        [calenderImageView setContentMode:UIViewContentModeScaleAspectFit];
        [cell.contentView addSubview:calenderImageView];
        
        CGRect dateLabelFrame=cell.dateLabel.frame;
        UILabel *dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(calenderImageView.frame.origin.x+calenderImageView.frame.size.width+2, dateLabelFrame.origin.y, dateLabelFrame.size.width, dateLabelFrame.size.height)];
        [dateLabel setTag:1];
        
       
        
       
        [dateLabel setTextColor:cell.dateLabel.textColor];
        [dateLabel setFont:cell.dateLabel.font];
        [cell.contentView addSubview:dateLabel];
        
        
        CGRect timeImageFrame=cell.timeImageView.frame;
        
        UIImageView *dateImageView=[[UIImageView alloc]initWithFrame:CGRectMake(dateLabel.frame.origin.x+dateLabel.frame.size.width+5,timeImageFrame.origin.y,timeImageFrame.size.width,timeImageFrame.size.height)];
        [dateImageView setImage:[UIImage imageNamed:@"small_clock_icon"]];
        [dateImageView setContentMode:UIViewContentModeScaleAspectFit];
        [cell.contentView addSubview:dateImageView];
        
        CGRect timeLabelFrame=cell.timeLabel.frame;
        UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(dateImageView.frame.origin.x+dateImageView.frame.size.width+2, timeLabelFrame.origin.y, timeLabelFrame.size.width, timeLabelFrame.size.height)];
        [timeLabel setTextColor:cell.dateLabel.textColor];
        [timeLabel setFont:cell.dateLabel.font];
        [timeLabel setTag:2];
        [cell.contentView addSubview:timeLabel];
        
        
        
        CGRect totalAnswersFrame=cell.totalAnswersLabel.frame;
        UILabel *totalAnswersLabel=[[UILabel alloc]initWithFrame:CGRectMake(timeLabel.frame.origin.x+timeLabel.frame.size.width+2, timeLabelFrame.origin.y, timeLabelFrame.size.width, timeLabelFrame.size.height)];
       
        //[totalAnswersLabel setTextColor:cell.dateLabel.textColor];
        [totalAnswersLabel setFont:cell.dateLabel.font];
        [totalAnswersLabel setTag:3];
        [cell.contentView addSubview:totalAnswersLabel];
        
        
    }
    
    return
    if ([self.dataType isEqualToString:@"Question"])
    {
        id dictionary=[self.postedQuesArray objectAtIndex:indexPath.row];
        
        cell.questionLabel.text=[dictionary valueForKey:@"question"];
        
        UILabel *dateLabel=(UILabel*)[cell viewWithTag:1];
        NSString *quesDate=[dictionary valueForKey:@"question_date"];
     
        
        NSString *dateStr=[[AppDelegate sharedDelegate]localDateFromDate:quesDate];
        NSString *finalDateStr=[dateStr substringWithRange:NSMakeRange(0, 10)];
        dateLabel.text=finalDateStr;
    
        NSString *finalTimeStr=[dateStr substringWithRange:NSMakeRange(11, dateStr.length-11)];
        
        UILabel *timeLabel=(UILabel*)[cell viewWithTag:2];
        [timeLabel setText:finalTimeStr];
        
        UILabel *totalAnswerLabel=(UILabel*)[cell viewWithTag:3];
       
        NSString *totalAnswers=[dictionary valueForKey:@"totalAnswers"];
        NSString *totalAnswersStr=[NSString stringWithFormat:@"%@ Replies",totalAnswers];
        NSInteger totalStrLength=totalAnswers.length;
        NSMutableAttributedString *attribStr=[[NSMutableAttributedString alloc]initWithString:totalAnswersStr];
        [attribStr addAttributes:@{NSFontAttributeName:totalAnswerLabel.font} range:NSMakeRange(0, totalAnswersStr.length
                                                                                                     -1)];
        [attribStr addAttributes:@{NSForegroundColorAttributeName:BUTTONCOLOR} range:NSMakeRange(0,totalStrLength)];
        [attribStr addAttributes:@{NSForegroundColorAttributeName:TEXTCOLOR} range:NSMakeRange(totalStrLength, totalAnswersStr.length-totalStrLength)];
        totalAnswerLabel.attributedText=attribStr;
       // totalAnswerLabel.text=totalAnswersStr;
        
         NSString *userImage=[dictionary valueForKey:@"thumb"];
         NSURL *imageUrl=[NSURL URLWithString:userImage];
       // [cell.self.userImageView setImageWithURL:imageUrl placeholderImage:nil];
        [cell.questionImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
    }
    else
    {
        id dictionary=[self.acceptedAnswersArray objectAtIndex:indexPath.row];
       
        cell.questionLabel.text=[dictionary valueForKey:@"answer"];
        
        UILabel *dateLabel=(UILabel*)[cell viewWithTag:1];
        NSString *quesDate=[dictionary valueForKey:@"answer_date"];
      
        NSString *dateStr=[[AppDelegate sharedDelegate]localDateFromDate:quesDate];
        NSString *finalDateStr=[dateStr substringWithRange:NSMakeRange(0, 10)];
        dateLabel.text=finalDateStr;
        
        NSString *finalTimeStr=[dateStr substringWithRange:NSMakeRange(11, dateStr.length-11)];
        
        UILabel *timeLabel=(UILabel*)[cell viewWithTag:2];
        [timeLabel setText:finalTimeStr];
        
//        UILabel *totalAnswerLabel=(UILabel*)[cell viewWithTag:3];
//        NSString *totalAnswersStr=[dictionary valueForKey:@"totalAnswers"];
//        totalAnswerLabel.text=totalAnswersStr;
        
        NSString *userImage=[dictionary valueForKey:@"thumb"];
        NSURL *imageUrl=[NSURL URLWithString:userImage];
        [cell.questionImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        cell.totalAnswersLabel.hidden=YES;
        
    }
    */
  
   
}
-(void) popanswerdetail:(UITapGestureRecognizer *)recognizer{
    NSMutableArray *arr;
    
    arr=[self.acceptedAnswersArray objectAtIndex:recognizer.view.tag];
    
    
    PostQuestionDetailViewController *postQues=[[PostQuestionDetailViewController alloc]init];
    
    postQues.ids=self.friendUserId;
    //profileView.value=true;
    postQues.generalViewValue=1;
    postQues.acceptQuestId=[arr valueForKey:@"questionId"];
    
    [self.navigationController pushViewController:postQues animated:NO];
    
}



-(void) popquestiondetail:(UITapGestureRecognizer *)recognizer{
    NSMutableArray *arr;
   
        arr=[self.postedQuesArray objectAtIndex:recognizer.view.tag];
    
    
    PostQuestionDetailViewController *postQues=[[PostQuestionDetailViewController alloc]init];
    
    postQues.ids=self.friendUserId;
    //profileView.value=true;
    postQues.generalViewValue=1;
    postQues.acceptQuestId=[arr valueForKey:@"questionId"];
    
     [self.navigationController pushViewController:postQues animated:NO];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.dataType isEqualToString:KDataType_About])
        return;

    NSMutableArray *arr;
    
    if ([self.dataType isEqualToString:KDataType_Question])
    {
      arr=[self.postedQuesArray objectAtIndex:indexPath.row];
    }
    else
    {
      arr=[self.acceptedAnswersArray objectAtIndex:indexPath.row];
    }
    
    PostQuestionDetailViewController *postQues=[[PostQuestionDetailViewController alloc]init];
    
    postQues.ids=self.friendUserId;
    //profileView.value=true;
    postQues.generalViewValue=1;
    postQues.acceptQuestId=[arr valueForKey:@"questionId"];
    
  
    
    //[dictionary valueForKey:@"questionId"];
    //postQues.generalQuestionArray=arr;
    //postQues.generalViewValue=7;
    [self.navigationController pushViewController:postQues animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==imagesuserTableView)
    {
        return 80.0f;
    }
    
    if ([self.dataType isEqualToString:KDataType_Question])
    {
    
    return 82.0f;
    }
    else if([self.dataType isEqualToString:KDataType_Answer])
    {
     return 80.0f;
    }
    else
    {
        if(indexPath.section==0)
            return 170.0f;
        else
            return 80.0f;
    }
    
}

-(BOOL)prefersStatusBarHidden
{
    return NO;
}


- (void)didReceiveMemoryWarning
{
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

- (IBAction)aboutButton:(id)sender {
}
@end
