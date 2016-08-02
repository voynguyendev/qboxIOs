//
//  PostquestionViewController.m
//  QBox
//
//  Created by iapp on 29/05/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//
#import "TopicViewController.h"
#import "QuestionDetailViewCell.h"
#import "NoImageQuestionDetailViewCell.h"
#import "NoImageAnswerTableViewCell.h"
#import "CCHLinkTextView.h"
#import "PostquestionViewController.h"
#import "InviteViewController.h"
#import "NavigationView.h"
#import "WebServiceSingleton.h"
#import "HPGrowingTextView.h"
#import "HPTextViewInternal.h"
#import "CustomView.h"
#import "AppDelegate.h"
#import "AcceptAnswerViewController.h"
#import "ActivityView.h"
#import "ShareViewController.h"
#import <Social/Social.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImageView+WebCache.h"
#import "SavedPostViewController.h"
#import "NSData+Base64.h"
#import "Base64.h"
#import "ASStarRatingView.h"
#import "SDWebImageManager.h"
#import "SDImageCache.h"
#import "UIImagefixOrientation.h"
#import "UIImage+fixOrientation.h"
#import "GADBannerView.h"
#import "GADRequest.h"
#import "SampleConstants.h"
#import "CustomTableViewCell.h"
#import <iAd/iAd.h>
#import "AnswerTableViewCell.h"
#import "ACEViewController.h"
#import "ProgressHUD.h"
#import "AddFriendViewController.h"
#import "MWPhotoBrowser.h"
#import <Photos/Photos.h>
#import "SDImageCache.h"
#import "MWCommon.h"





@interface PostQuestionDetailViewController ()<CCHLinkTextViewDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,HPGrowingTextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate, ActivityViewDelegate,UIActionSheetDelegate,SDWebImageManagerDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,GADBannerViewDelegate,MWPhotoBrowserDelegate>
{
    
    NSMutableArray *questionArray;
    NSMutableArray * filteredResults;
    
    UIView *activityView;
    //NSMutableArray *categoryTblArray;
    NSArray *categoryTblArray;
    NSMutableArray *answerID;
    NSMutableArray *postData;
    NSMutableArray *questionInfo;
    NSMutableArray *answersViewArray;
    NSMutableArray *answerData;
    NSArray *questionArrayInfo;
    UIScrollView *imageScrollView;
    UIView *questionView;
    UIView *question;
    UIView* transparentView;
    UIView *viewPicker;
    UIView *popImageView;
    UIView *backgroundTextView;
    UIView *ratingView;
    UIView *searchView;
    
    UIImageView *ImagePostQuestion;
    UITextView *postTextView;
    UITextView *popUptxt;
    
    UITextField *searchTextField;
    NSArray *questionID;
    NavigationView *nav;
    NSString *postStatus;
    NSString *postText;
    NSString *favouriteID;
    NSString *status;
    NSString *questionImageStr;
    NSString *thumbUrlString;
    NSString *answerImageStr;
    NSString *questionNameStr;
    NSString *questionDateStr;
    NSString *titleString;
    
    UIAlertView *saveAlert;
    UIAlertView *unrateAlert;
    UIAlertView *favoriteAlert;
    UIAlertView *UnfavAlert;
    UIAlertView *deleteSaveAlert;
    UIAlertView *UnAcceptAlert;
    UIAlertView *acceptAlert;
    UIAlertView *ratingAlert;
    UIAlertView *likeAnswerAlertView;
    UIAlertView *dislikeAnswerAlertView;
    UIAlertView *deletequestionAlertView;
    UIAlertView *deleteanswerAlertView;
    UIAlertView *reportadminAlert;
    
    NSLayoutConstraint *centreHorizontallyConstraint;
    UIButton *saveBtn;
    UIButton *favouriteBtn;
    UIButton *ratingBtn;
    UIButton *acceptBtn;
    UIButton *ViewAllBtn;
    UIButton  *backImageBtn;
    UIButton *titleBckBtn;
    UIButton *queslikeBtn;
    UIButton *quesDislikeBtn;
    
    UILabel *likeCountLabel;
  
    int favouriteVal;
    int statusVal;
    int saveVal;
    int rateVal;
    int backBtnValue;
    int searchValue;
    int rateIndexValue;
    int profileViewVal;
   
    UISearchBar *searchBar;
    UIPickerView *pickerView;
    ActivityView *activity;
    ASStarRatingView *starRatingView;
    
    UITableView *answersTableView;
    UITableView *questionTableView;
    UITableView *categoryTblView;
    
    UILabel *likecount;
    NSArray *userData;
    NSArray *favouriteInfo;
    
    UIActionSheet *shareActionSheet;
    UIActionSheet *cameraActionSheet;
    
    UIImage *convertedImage;
    BOOL answerViewAppear;
    
    UIScrollView *answersScrollView;
    BOOL searchBarSelected;
    
    UIImageView *entryImageView;
    UIImageView *messageImageView;
    UIImageView *answerImageView;
    int postValue;
    int popValue;
    NSString *answerDescriptionString;
    
    BOOL ratingValue;
    
    BOOL isKeyboardUp;
    UIButton *postedFriends;
    
    NSString *searchTextStr;
    
    NSMutableArray *imagesQuestionViews;
    NSMutableArray *_photos;
    
    UIScrollView *menuactionSubview;
    
    UIScrollView *menuactionSubviewAnswer;
}
@end

@implementation PostQuestionDetailViewController
@synthesize ques,ids,userIdlogin;
@synthesize nameImg;
@synthesize acceptQuestId;
@synthesize generalQuestionArray;
@synthesize generalViewValue;
@synthesize notificationQuesId;
@synthesize ViewAllTitle;
@synthesize userIdGeneral;



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
    [[AppDelegate sharedDelegate].TabBarView  showtabar];

    searchTextStr=[[NSString alloc]init];
    userData=[[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil]objectAtIndex:0];
    
    userIdlogin=[userData valueForKey:@"id"];
    
    answerID=@"";
  
    searchBarSelected=YES;
    
    self.navigationController.navigationBarHidden=YES;
   // [self createUI];
    
    if (generalViewValue==0)
    {
        //[self createUI];
    }
    else
    {
        [self generalView];
    }
    
   
    
    
    
    //categoryTblArray=[NSMutableArray arrayWithObjects:@"All",@"Science",@"Math",@"Arts" ,nil];
    categoryTblArray=[NSArray arrayWithObjects:@"All",@"Science",@"Math",@"Arts", nil];
    answersTableView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectZero];
    answersTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    questionTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    
    
    SDWebImageManager.sharedManager.delegate = self;
    [super viewDidLoad];
    
    if (activityView)
    {
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyboard)];
        tapGesture.numberOfTapsRequired=1;
        tapGesture.delegate=self;
        [self.viewmenu addGestureRecognizer:tapGesture];
        
    }
    
  
    
   
    
    [[AppDelegate sharedDelegate] setActivityText:@"Loading..."];
    [[AppDelegate sharedDelegate] showActivityInView:self.viewmenu withBlock:^{
        
        if (generalViewValue ==0)
        {
            [self fetchData];
        }
       
        
        [[AppDelegate sharedDelegate]hideActivity];
        
    }];
    //[[AppDelegate sharedDelegate]hideActivity];
   // CGRect answerframe=answersTableView.frame;
    
    //answerframe.origin.y=answerframe.origin.y-50;
    
 //   answersTableView.frame=answerframe;
  
  //  answersTableView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectZero];
    
  //  answersTableView.tableHeaderView.frame=CGRectMake(0, 0,0, 0);
   // answersTableView.tableHeaderView.frame.size.height;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)answersView
{
    
}







- (GADRequest *)createRequest {
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for the simulator as
    // well as any devices you want to receive test ads.
    request.testDevices =
    [NSArray arrayWithObjects:
     // TODO: Add your device/simulator test identifiers here. They are
     // printed to the console when the app is launched.
     nil];
    return request;
}

-(void) generalView
{
    
   
    
   //Accepted Answers
    if (generalViewValue==1)
    {
        questionID=[[NSArray arrayWithObject:acceptQuestId]objectAtIndex:0];
        [self postFetchData];
        if(postData==nil)
        {
            UIAlertView *successFavouriteAlertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"this question has been deleted" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [successFavouriteAlertView show];
            return;
        }
        [questionView removeFromSuperview];
        [self.viewmenu addSubview:question];
        [self.viewmenu addSubview:ViewAllBtn];
        [ViewAllBtn addTarget:self action:@selector(ViewAllClick:) forControlEvents:UIControlEventTouchUpInside];
        [question addSubview:answersTableView];
        [nav.iconImageView setImage:[UIImage imageNamed:@"nav_accepted_question_icon"]];
        NSLog(@"%@",postData);
        NSLog(@"%@",questionInfo);
        NSLog(@"%@",favouriteInfo);
        //[postedFriends setTitle:[NSString stringWithFormat:@"Posted Question[%@]",ques] forState:UIControlStateNormal];
        
        questionID=[[questionInfo valueForKey:@"id"]objectAtIndex:0];
        postText= [[questionInfo valueForKey:@"question"]objectAtIndex:0];
        favouriteID=[NSString stringWithFormat:@"%@",favouriteInfo];
        //favouriteID=[generalQuestionArray valueForKey:@"favourite"];
        saveVal=[[[questionInfo objectAtIndex:0]valueForKey:@"questionSaved"]intValue];
        ids=[[questionInfo valueForKey:@"userId"]objectAtIndex:0];
        questionImageStr=[[questionInfo valueForKey:@"attachment"]objectAtIndex:0];
        thumbUrlString=[[questionInfo valueForKey:@"thumb"]objectAtIndex:0];
        questionNameStr=[[questionInfo valueForKey:@"name"]objectAtIndex:0];
        questionDateStr=[[questionInfo valueForKey:@"question_date"]objectAtIndex:0];
        
        
       titleString=@"ACCEPTED ANSWERS";
        
        userIdGeneral=[[questionInfo valueForKey:@"userId"]objectAtIndex:0];
        [self postedAnswersSubview];
        
        
        
        
    }
    //General View
    else if (generalViewValue==2)
    {
        
        titleString= @"GENERAL";
        
        //[questionView removeFromSuperview];
       // [self.viewmenu addSubview:question];
       // [question addSubview:answersTableView];
        int totalQues=[[generalQuestionArray objectAtIndex:1]intValue];
       // [postedFriends setTitle:[NSString stringWithFormat:@"Posted Question[%d]",totalQues] forState:UIControlStateNormal];
        generalQuestionArray=[generalQuestionArray objectAtIndex:0];
        
        ids=[generalQuestionArray valueForKey:@"userid"];
        questionID=[generalQuestionArray valueForKey:@"questionId"];
        postText= [generalQuestionArray valueForKey:@"question"];
        favouriteID=[generalQuestionArray valueForKey:@"favourite"];
        saveVal=[[generalQuestionArray valueForKey:@"questionSaved"]intValue];
        questionImageStr=[generalQuestionArray valueForKey:@"attachment"];
        thumbUrlString=[generalQuestionArray valueForKey:@"thumb"];
        questionNameStr=[generalQuestionArray valueForKey:@"name"];
        questionDateStr=[generalQuestionArray valueForKey:@"question_date"];
        userIdGeneral=[generalQuestionArray valueForKey:@"userid"];
        [ViewAllBtn setTitle:ViewAllTitle forState:UIControlStateNormal];
        [self postedAnswersSubview];
    }
    
    //saved post
    else if(generalViewValue==3)
    {
        //
        //        ids=[generalQuestionArray valueForKey:@"userId"];
        
         titleString = @"SAVED POSTS";
        NSLog(@"%@",generalQuestionArray);
       // [postedFriends setTitle:[NSString stringWithFormat:@"Posted Question[%@]",[generalQuestionArray objectAtIndex:1]] forState:UIControlStateNormal];
        [questionView removeFromSuperview];
        [self.viewmenu addSubview:question];
        [question addSubview:answersTableView];
        NSLog(@"%@",generalQuestionArray);
        generalQuestionArray=[generalQuestionArray objectAtIndex:0];
        questionID=[generalQuestionArray valueForKey:@"id"];
        postText= [generalQuestionArray valueForKey:@"question"];
        favouriteID=[generalQuestionArray valueForKey:@"fvtStatus"];
        saveVal=[[generalQuestionArray valueForKey:@"questionSaved"]intValue];
        ids=[generalQuestionArray valueForKey:@"userId"];
        questionImageStr=[generalQuestionArray valueForKey:@"attachment"];
        thumbUrlString=[generalQuestionArray valueForKey:@"thumb"];
        questionNameStr=[generalQuestionArray valueForKey:@"name"];
        questionDateStr=[generalQuestionArray valueForKey:@"question_date"];
        [ViewAllBtn setTitle:ViewAllTitle forState:UIControlStateNormal];
        nav.iconImageView.image=[UIImage imageNamed:@"nav_saved_question_icon"];
        userIdGeneral=[generalQuestionArray valueForKey:@"userId"];
        [self postedAnswersSubview];
    }
    //private friend post
    else if (generalViewValue==4)
    {
            titleString = @"FRIEND'S POSTS";
        NSLog(@"%@",generalQuestionArray);
        //[postedFriends setTitle:[NSString stringWithFormat:@"Posted Question[%@]",[generalQuestionArray objectAtIndex:1]] forState:UIControlStateNormal];
        [questionView removeFromSuperview];
        [self.viewmenu addSubview:question];
        [question addSubview:answersTableView];
        NSLog(@"%@",generalQuestionArray);
        generalQuestionArray=[generalQuestionArray objectAtIndex:0];
        questionID=[generalQuestionArray valueForKey:@"questionId"];
        postText= [generalQuestionArray valueForKey:@"question"];
        favouriteID=[generalQuestionArray valueForKey:@"favourite"];
        saveVal=[[generalQuestionArray valueForKey:@"questionSaved"]intValue];
        ids=[[userData valueForKey:@"id"]objectAtIndex:0];
        questionImageStr=[generalQuestionArray valueForKey:@"attachment"];
        thumbUrlString=[generalQuestionArray valueForKey:@"thumb"];
        questionNameStr=[generalQuestionArray valueForKey:@"name"];
        questionDateStr=[generalQuestionArray valueForKey:@"question_date"];
        [ViewAllBtn setTitle:ViewAllTitle forState:UIControlStateNormal];
        [self postedAnswersSubview];
        
    }
    //notifications
    else if (generalViewValue==5)
    {
         titleString = @"POSTED QUESTIONS";
        NSLog(@"%@",notificationQuesId);
        // notificationQuesId=[questionID objectAtIndex:0];
        questionID=[NSArray arrayWithObject:notificationQuesId];
        questionID=[questionID objectAtIndex:0];
        [self postFetchData];
        [questionView removeFromSuperview];
        [self.viewmenu addSubview:question];
        [self.viewmenu addSubview:ViewAllBtn];
        [ViewAllBtn addTarget:self action:@selector(ViewAllClick:) forControlEvents:UIControlEventTouchUpInside];
        [question addSubview:answersTableView];
        NSLog(@"%@",postData);
        NSLog(@"%@",questionInfo);
        NSLog(@"%@",favouriteInfo);
       // [postedFriends setTitle:[NSString stringWithFormat:@"Posted Question[%@]",ques] forState:UIControlStateNormal];
        
        questionID=[[questionInfo valueForKey:@"id"]objectAtIndex:0];
        postText= [[questionInfo valueForKey:@"question"]objectAtIndex:0];
        favouriteID=[NSString stringWithFormat:@"%@",favouriteInfo];
        //favouriteID=[generalQuestionArray valueForKey:@"favourite"];
        saveVal=[[[questionInfo objectAtIndex:0]valueForKey:@"questionSaved"]intValue];
        ids=[[questionInfo valueForKey:@"userId"]objectAtIndex:0];
        questionImageStr=[[questionInfo valueForKey:@"attachment"]objectAtIndex:0];
        thumbUrlString=[[questionInfo valueForKey:@"thumb"]objectAtIndex:0];
        questionNameStr=[[questionInfo valueForKey:@"name"]objectAtIndex:0];
        questionDateStr=[[questionInfo valueForKey:@"question_date"]objectAtIndex:0];
        [self postedAnswersSubview];
        
        //[self postedAnswersSubview];
        
    }
    //Posted Question
    else if (generalViewValue==6)
    {
        titleString = @"POSTED QUESTIONS";
        NSLog(@"%@",notificationQuesId);
        
        questionID=[generalQuestionArray valueForKey:@"questionId"];
        postText= [generalQuestionArray valueForKey:@"question"];
        favouriteID=[generalQuestionArray valueForKey:@"favourite"];
        saveVal=[[generalQuestionArray valueForKey:@"questionSaved"]intValue];
        questionImageStr=[generalQuestionArray valueForKey:@"attachment"];
        thumbUrlString=[generalQuestionArray valueForKey:@"thumb"];
        NSArray *userInfo=[[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil]objectAtIndex:0];
        questionNameStr=[userInfo valueForKey:@"name"];
        //questionNameStr=[generalQuestionArray valueForKey:@"name"];
        questionDateStr=[generalQuestionArray valueForKey:@"question_date"];
        nav.iconImageView.image=[UIImage imageNamed:@"nav_posted_question"];
          userIdGeneral=[generalQuestionArray valueForKey:@"userId"];
        [self postedAnswersSubview];
        
        
        
   
    }
    
    else if (generalViewValue==7)
    {
        titleString = @"QUESTIONS";
        NSLog(@"%@",notificationQuesId);
        
        questionID=[generalQuestionArray valueForKey:@"questionId"];
        postText= [generalQuestionArray valueForKey:@"question"];
        favouriteID=[generalQuestionArray valueForKey:@"favourite"];
        saveVal=[[generalQuestionArray valueForKey:@"questionSaved"]intValue];
        questionImageStr=[generalQuestionArray valueForKey:@"attachment"];
        thumbUrlString=[generalQuestionArray valueForKey:@"thumb"];
        NSArray *userInfo=[[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"]objectAtIndex:0];
        questionNameStr=[userInfo valueForKey:@"name"];
        //questionNameStr=[generalQuestionArray valueForKey:@"name"];
        questionDateStr=[generalQuestionArray valueForKey:@"question_date"];
        nav.iconImageView.image=[UIImage imageNamed:@"nav_posted_question"];
          userIdGeneral=[generalQuestionArray valueForKey:@"userId"];
        [self postedAnswersSubview];
  
    }
    
    
    else if (generalViewValue==8)
    {
        titleString = @"QUESTIONS";
        NSLog(@"%@",notificationQuesId);
        
        questionID=[generalQuestionArray valueForKey:@"id"];
        postText= [generalQuestionArray valueForKey:@"question"];
        favouriteID=[generalQuestionArray valueForKey:@"favourite"];
        saveVal=[[generalQuestionArray valueForKey:@"questionSaved"]intValue];
        questionImageStr=[generalQuestionArray valueForKey:@"attachment"];
        thumbUrlString=[generalQuestionArray valueForKey:@"thumb"];
        NSArray *userInfo=[[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"]objectAtIndex:0];
        questionNameStr=[userInfo valueForKey:@"name"];
        //questionNameStr=[generalQuestionArray valueForKey:@"name"];
        questionDateStr=[generalQuestionArray valueForKey:@"question_date"];
          userIdGeneral=[generalQuestionArray valueForKey:@"userId"];
        //nav.iconImageView.image=[UIImage imageNamed:@"nav_posted_question"];
        [self postedAnswersSubview];
        
    }
    //Home View
    else if (generalViewValue==9)
    {
        titleString = @"QUESTIONS";
        NSLog(@"%@",notificationQuesId);
        questionInfo=generalQuestionArray;
        questionID=[generalQuestionArray valueForKey:@"id"];
        if(!questionID)
        {
         questionID=[generalQuestionArray valueForKey:@"questionId"];
        }
        postText= [generalQuestionArray valueForKey:@"question"];
        favouriteID=[generalQuestionArray valueForKey:@"favourite"];
        saveVal=[[generalQuestionArray valueForKey:@"questionSaved"]intValue];
        questionImageStr=[generalQuestionArray valueForKey:@"attachment"];
        thumbUrlString=[generalQuestionArray valueForKey:@"thumb"];
        //NSArray *userInfo=[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"];
        questionNameStr=[generalQuestionArray valueForKey:@"name"];
        //questionNameStr=[generalQuestionArray valueForKey:@"name"];
        questionDateStr=[generalQuestionArray valueForKey:@"question_date"];
        userIdGeneral=[generalQuestionArray valueForKey:@"userId"];
        if (!userIdGeneral)
        {
            userIdGeneral=[generalQuestionArray valueForKey:@"userid"];
        }
        
       
        //nav.iconImageView.image=[UIImage imageNamed:@"nav_posted_question"];
        [self postedAnswersSubview];
        
        
        
    }
 
}

-(void) resignKeyboard
{
    [textView resignFirstResponder];
    [searchBar resignFirstResponder];
    [viewPicker removeFromSuperview];
    searchBarSelected=YES;
    [activityView removeFromSuperview];
    [categoryTblView removeFromSuperview];
    
       
  
   
    
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:questionTableView] || [touch.view isDescendantOfView:categoryTblView])
    {
        
        // Don't let selections of auto-complete entries fire the
        // gesture recognizer
        return NO;
    }
    
    return YES;
}



-(void) viewWillAppear:(BOOL)animated
{
    UIImage *postImage=[[AppDelegate sharedDelegate]answersPostImage];
    if (postImage)
    {
        convertedImage=postImage;
    }
    
    
    
    if (convertedImage)
    {
        [answerImageView setImage:convertedImage];
        
        answerImageView.layer.borderWidth=0.5f;
        
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popImage)];
        [answerImageView addGestureRecognizer:tapGesture];
        tapGesture.numberOfTapsRequired=1;
        answerImageView.userInteractionEnabled=YES;
        [answerImageView setBackgroundColor:[UIColor lightGrayColor]];
    }
        
    
    //[messageImageView setImage:_postImage];
    
  
   
    CGSize result=[[UIScreen mainScreen]bounds].size;
    
    if (generalViewValue==0)
    {
        
    }
    else
    {
    if (result.height==568)
    {
        
      answersTableView.frame=CGRectMake(0, 44, 320,  self.viewmenu.frame.size.height-(containerView.frame.size.height));
        
        
    }
    else
    {
       answersTableView.frame=CGRectMake(0, 44, 320, self.viewmenu.frame.size.height-(containerView.frame.size.height));
        
        
    }
    }
    
    
    NSLog(@"%@",NSStringFromCGRect( answersTableView.frame));
    
   [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(keyboardDidShow:)
                                                name:UIKeyboardWillShowNotification
                                              object:nil];
   
   [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(keyboardDidHide:)
                                                name:UIKeyboardWillHideNotification
                                              object:nil];
    
    
    
   
   
    
    
    
}


-(void)postAnswerAPI
{
    
   
    
     [textView resignFirstResponder];
   
//    if ([self validationCheck])
//    {
    NSString *imageString;
    if (convertedImage)
    {
        convertedImage=[self fixrotation:convertedImage];
        
        convertedImage=[self resizeimage:convertedImage];
        
        
        convertedImage = [UIImage imageWithData:UIImageJPEGRepresentation(convertedImage, 0)];
        
        imageString=[self encodeToBase64String:convertedImage];
       
    }
    else
    {
    
   imageString=@"";
    }
   

    //NSDate *date = [NSDate dateWithTimeIntervalSince1970:[unixFormat intValue]];
    NSDate *date=[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy-h:mm"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    //NSDate *date = [dateFormatter dateFromString:publicationDate];
    NSString *dte=[dateFormatter stringFromDate:date];
    
   // NSString * timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];

        // [self showActivtyIndicator];
        int timestamp = [[NSDate date] timeIntervalSince1970];
    
    
    
        
        NSMutableArray *questionArray1=[[NSMutableArray alloc]initWithObjects:answerDescriptionString,questionID,ids,@""/*[NSString stringWithFormat:@"%d",timestamp]*/,@"pending",@"yes",answerID,@"",nil];
        
        [[WebServiceSingleton sharedMySingleton]addAnswer:questionArray1 imageBase64String:imageString];
    [answerImageView setImage:[UIImage imageNamed:@""]];
    answerImageView.layer.borderWidth=0.0f;
    answerImageView.backgroundColor=[UIColor clearColor];
    convertedImage=nil;
    [[AppDelegate sharedDelegate]setAnswersPostImage:nil];
    
    [self hideActivity];
    
   
        //[self postFetchData];
        [self performSelectorOnMainThread:@selector(postFetchData) withObject:nil waitUntilDone:YES];
        
    
        // [self performSelectorInBackground:@selector(postFetchData) withObject:nil];
       
        
        
    
//    else
//    {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Enter the answer" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
//        [alert show];
//        //[answerImageView setImage:convertedImage];
//        //[self.viewmenu addSubview:answerImageView];
//        //
//        
//        
//    }
      //[self hideActivity];
    

}


-(void) activityDidAppear
{
    switch (postValue) {
        case 1:
        {
            textView.text=@"";
                textView.delegate=self;
        }
            break;
            
            case 2:
        {
            NSString *ansID=[[postData valueForKey:@"id"]objectAtIndex:rateIndexValue];
                   float starRating=starRatingView.rating;
           
                   NSArray *mainArray=[[WebServiceSingleton sharedMySingleton]answerRate:ansID userId:ids rating:starRating];
            NSString *ratingStatus=[[mainArray valueForKey:@"status"]objectAtIndex:0];
            if ([ratingStatus isEqualToString:@"0"])
            {
                
            }
            
        else
            {
                       UIAlertView *rateAlert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Rating Updated" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                       [rateAlert show];
                
                NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                NSDictionary *oldDict = (NSDictionary *)[postData objectAtIndex:rateIndexValue];
                [newDict addEntriesFromDictionary:oldDict];
                [newDict setObject:[NSString stringWithFormat:@"%f",starRating] forKey:@"rating"];
                [postData replaceObjectAtIndex:rateIndexValue withObject:newDict];
                [answersTableView reloadData];
                
                
                
                      // [self postFetchData];
           
                   }
                   [self removeView];
                   [self hideActivity];
                }
            break;
            case 3:
            {
            
                NSLog(@"%d",favouriteVal);
                favouriteVal=1;
                        NSString *favoriteid=[NSString stringWithFormat:@"%d",favouriteVal];
                        NSArray *questionArray1=[[NSArray alloc]initWithObjects:questionID,ids,favoriteid,nil];
                
                
                        [[WebServiceSingleton sharedMySingleton]addFavorite:questionArray1 favouriteValue:favouriteVal];
                        [favouriteBtn setBackgroundImage:[UIImage imageNamed:@"star01"] forState:UIControlStateNormal];
                        [self hideActivity];
                
                        UIAlertView *successFavouriteAlertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Successfully added in favourites" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                        [successFavouriteAlertView show];
            
        }
             break;
            
            case 4:
        {
            NSLog(@"%d",favouriteVal);
                  favouriteVal=0;
                  NSString *favoriteid=[NSString stringWithFormat:@"%d",favouriteVal];
                  NSArray *questionArray1=[[NSArray alloc]initWithObjects:questionID,ids,favoriteid,nil];
                  // favouriteVal=0;
                  [[WebServiceSingleton sharedMySingleton]addFavorite:questionArray1 favouriteValue:favouriteVal];
                  [favouriteBtn setBackgroundImage:[UIImage imageNamed:@"star_black01"] forState:UIControlStateNormal];
                  [self hideActivity];
           
                  UIAlertView *successFavouriteAlertView=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Successfully deleted from favourites" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                  [successFavouriteAlertView show];
        }
             break;
            
            case 5:
        {
            //[self acceptAnswer];
            NSArray *mainArray=[[WebServiceSingleton sharedMySingleton]acceptAnswer:[NSString stringWithFormat:@"%@",answerID]];
            status=[NSString stringWithFormat:@"%@",[mainArray objectAtIndex:0]];
                   // [self postFetchData];
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            NSDictionary *oldDict = (NSDictionary *)[postData objectAtIndex:rateIndexValue];
            [newDict addEntriesFromDictionary:oldDict];
            [newDict setObject:@"accepted" forKey:@"status"];
            [postData replaceObjectAtIndex:acceptAlert.tag withObject:newDict];
            [answersTableView reloadData];
            
            
            
                    UIAlertView *successPost=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Successfully accepted this answer" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [successPost show];
        }
             break;
            case 6:
        {
            //[self unacceptAnswer];
            NSArray *mainArray=[[WebServiceSingleton sharedMySingleton]unacceptAnswer:[NSString stringWithFormat:@"%@",answerID]];
            status=[NSString stringWithFormat:@"%@",[mainArray objectAtIndex:0]];
            
                    [acceptBtn setBackgroundImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
                   // [self postFetchData];
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            NSDictionary *oldDict = (NSDictionary *)[postData objectAtIndex:rateIndexValue];
            [newDict addEntriesFromDictionary:oldDict];
            [newDict setObject:@"rejected" forKey:@"status"];
            [postData replaceObjectAtIndex:UnAcceptAlert.tag withObject:newDict];
            [answersTableView reloadData];
                    
                    UIAlertView *successPost=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Successfully deleted from accepted answers" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [successPost show];
        }
         break;
     
            
            
        default:
            
            
            if (generalViewValue ==0)
                        {
                            [self fetchData];
                        }
                        else
                        {
                            
                            [self hideActivity];
                        }
            break;
    }
    
    [self hideActivity];
}



-(BOOL) prefersStatusBarHidden
{
    return YES;
}











#pragma mark Action Methods
-(void)postAction:(id)sender
{
    
    if (textView.text.length==0)
    {
        UIAlertView *answerAlert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Write a comment" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [answerAlert show];
        [textView resignFirstResponder];
        
    }
    else
    {
        
       // [self showActivity:self.viewmenu];
        //[self postAnswerAPI];
       
       [textView resignFirstResponder];
    answerDescriptionString=textView.text;
     [textView setText:@""];
        
        activityView=[[UIView alloc]init];
        activityView.frame=self.viewmenu.bounds;
        [activityView setBackgroundColor:[UIColor clearColor]];
        [self.viewmenu addSubview:activityView];
        [[AppDelegate sharedDelegate]setActivityText:@"Sending..."];
        [[AppDelegate sharedDelegate]showActivityInView:activityView withBlock:^{
          [self postAnswerAPI];
            [[AppDelegate sharedDelegate]hideActivity];
        }];
        
        
     //[self showActivity:activityView];
    
//  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    [self postAnswerAPI];
//  });
    }
   
   

   
    
  
}

- (NSString *)encodeToBase64String:(UIImage *)image
{
   // return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
     return [UIImagePNGRepresentation(image) base64EncodedString];
    
}



-(IBAction)cancelAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}


-(BOOL)validationCheck
{
    
    int validateNumber=0;
    if (!answerDescriptionString.length)
    {
        validateNumber++;
    }
      
    if (validateNumber==0)
    {
        return YES;
    }
    else
    {
        return NO;
        
    }
    
}




#pragma mark Text Field Delegate Methods

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)url inRange:(NSRange)characterRange
{
    
    NSString *strurl= [url absoluteString];
    
    NSRange range = [strurl rangeOfString:@"#" options:NSCaseInsensitiveSearch];
    
    if (range.location != NSNotFound) {
        //[self searchtagfriend:strurl];
        
        TopicViewController *addFriend=[[TopicViewController alloc]init];
        addFriend.hashtag=[strurl stringByReplacingOccurrencesOfString:@"#"
                                                            withString:@""];
        [self.navigationController pushViewController:addFriend animated:NO];
        

        
       
        
    }
    
    
    range = [strurl rangeOfString:@"@" options:NSCaseInsensitiveSearch];
    
    if (range.location != NSNotFound) {
        NSString* userid=[strurl stringByReplacingOccurrencesOfString:@"@"
                                                           withString:@""];
        AddFriendViewController *addFriend=[[AddFriendViewController alloc]init];
        addFriend.friendUserId=userid;
        [self.navigationController pushViewController:addFriend animated:NO];
        
      
        
    }
    
    
    
    
    
    //[[[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]show];
    return YES;
}
- (void)linkTextView:(CCHLinkTextView *)linkTextView didTapLinkWithValue:(id)value
{
    NSString *strurl= value;
    
    NSRange range = [strurl rangeOfString:@"#" options:NSCaseInsensitiveSearch];
    
    if (range.location != NSNotFound) {
        //[self searchtagfriend:strurl];
        
        TopicViewController *addFriend=[[TopicViewController alloc]init];
        addFriend.hashtag=[strurl stringByReplacingOccurrencesOfString:@"#"
                                                            withString:@""];
        [self.navigationController pushViewController:addFriend animated:NO];
        return;
        
    }
    
    
    range = [strurl rangeOfString:@"@" options:NSCaseInsensitiveSearch];
    
    if (range.location != NSNotFound) {
        NSString* userid=[strurl stringByReplacingOccurrencesOfString:@"@"
                                                           withString:@""];
        AddFriendViewController *addFriend=[[AddFriendViewController alloc]init];
        addFriend.friendUserId=userid;
        [self.navigationController pushViewController:addFriend animated:NO];
        return;
        
        
    }
    
    
    
    
    
    //[[[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]show];
   
    
    
    
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    searchBarSelected=NO;
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
   // [postLabel resignFirstResponder];
    
    searchBarSelected=YES;
    [textField resignFirstResponder];
    [searchBar resignFirstResponder];
   
    return YES;
}

-(BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
    searchBarSelected=NO;
    [textField resignFirstResponder];
     [answersTableView reloadData];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    searchTextStr=string;
    if (searchValue==0)
    {
        if (string.length==0)
        {
            
            NSString *viewTitle=ViewAllBtn.titleLabel.text;
            NSString *stringValue;
            if ([viewTitle rangeOfString:@"Filter:"].location!=NSNotFound)
            {
                filteredResults=questionArray;
                //filteredResults=[[mainArray valueForKey:@"data"]objectAtIndex:0];
                stringValue=[viewTitle substringWithRange:NSMakeRange(7, viewTitle.length-7)];
            }
            else
            {
                
                int intValue=(int)[categoryTblArray indexOfObject:viewTitle];
                NSString *pickerValue=[NSString stringWithFormat:@"%d",(intValue-1)];
                NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF.categoryId contains[c] %@",pickerValue]; // Creating filter condition
                //questionArray=[questionArray filteredArrayUsingPredicate:filterPredicate];
                filteredResults=[NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:filterPredicate]];
            }
            
            //filteredResults=[NSMutableArray arrayWithArray:questionArray];
            [postedFriends setTitle:[NSString stringWithFormat:@"Posted Questions[%lu]",(unsigned long)filteredResults.count] forState:UIControlStateNormal];
        }
        else
        {
            NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF.question contains [c]%@",string
                                    ];
            //filteredResults=[NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:predicate]];
            filteredResults=[NSMutableArray arrayWithArray:[filteredResults filteredArrayUsingPredicate:predicate]];
            [postedFriends setTitle:[NSString stringWithFormat:@"Posted Questions[%lu]",(unsigned long)filteredResults.count] forState:UIControlStateNormal];
            NSLog(@"%@",filteredResults);
        }
        
        [questionTableView reloadData];
    }
    else
    {
        NSLog(@"%@",postData);
        if (postData)
        {
            if (string.length==0)
            {
                postData=[NSMutableArray arrayWithArray:answerData];
            }
            else
            {
                NSPredicate *filterPredicate=[NSPredicate predicateWithFormat:@"SELF.answer contains[c] %@",string];
                postData=[NSMutableArray arrayWithArray:[answerData filteredArrayUsingPredicate:filterPredicate]];
            }
            [answersTableView reloadData];
        }
        else
        {
            
        }
        
    }
    

    
    
    return YES;
}


#pragma mark  TextView Methods
-(BOOL) textViewShouldEndEditing:(UITextView *)textView1
{
    [textView resignFirstResponder];
    return YES;
    searchBarSelected=NO;
}
-(BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    searchBarSelected=YES;
    return YES;
}

-(void) growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView
{
    searchBarSelected=YES;
}
-(void) growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView
{
    
}
-(BOOL) growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
       // [self postAction:self];
    }
    return YES;
}


-(void) updateTextViewChange
{
    CGRect rect = textView.frame;
    //rect.size.width = textView.contentSize.width;
    //rect.size.height = textView.contentSize.height;
    textView.frame = rect;
    UIScrollView *scrollView;
    scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, textView.frame.origin.y );
}


-(void)textViewDidChange:(UITextView*)textView
{
    [self updateTextViewChange];
}

-(BOOL) textView:(UITextView *)textView1 shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [textView resignFirstResponder];
    return YES;
}

#pragma mark custom View
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	containerView.frame = r;
    //containerView.frame=rect;
    // containerView.frame=r;
    
}


- (void)keyboardDidShow: (NSNotification *) notif
{
    isKeyboardUp=YES;
    [ImagePostQuestion removeFromSuperview];
    NSDictionary *userInfo = [notif userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    if (searchBarSelected)
    {
        
        
        CGRect keyboardBounds;
        [[notif.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
        NSNumber *duration = [notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [notif.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        
        // Need to translate the bounds to account for rotation.
        keyboardBounds = [self.viewmenu convertRect:keyboardBounds toView:nil];
        
        centreHorizontallyConstraint.constant+=(kbSize.height-50);
        
        CGRect questionframe=question.frame;
        CGRect containerFrame = containerView.frame;
        CGRect answerframe=answersTableView.frame;
        CGRect answerImageFrame=answerImageView.frame;
        CGRect bannerFrame=self.adBanner.frame;
        
        NSLog(@"%@",NSStringFromCGRect(keyboardBounds));
        float systemVersion=[[[UIDevice currentDevice]systemVersion]floatValue];
        int val=self.viewmenu.frame.size.height;
        if (val>=519)
        {
            //
            containerFrame.origin.y = self.viewmenu.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
            
            int mmm=[[UIScreen mainScreen] nativeScale];
            if(mmm==3)
            {
                 containerFrame.origin.y = self.viewmenu.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height)+50;
                
            }
            
            bannerFrame.origin.y=containerFrame.origin.y-90;
            
            
            
            answerframe.size.height=answerframe.size.height-162;
           // answerImageFrame.origin.y=textView.frame.origin.y-30;
           
            
        }
        else
        {
            containerFrame.origin.y = (self.viewmenu.bounds.size.height+50) - (keyboardBounds.size.height + containerFrame.size.height+50);
            bannerFrame.origin.y=containerFrame.origin.y-90;
            // questionframe.size.height=250;
            answerframe.size.height=answerframe.size.height-162;
            //questionframe.origin.y=questionframe.origin.y-100;
            // questionframe.origin.y=44;
            //answerframe.size.height=answerframe.size.height-70;
            // answerframe.size.height=answerframe.size.height-70;
            //  answerImageFrame.origin.y=containerFrame.origin.y-containerFrame.size.height+10;
           // answerImageFrame.origin.y=textView.frame.origin.y-30;
            
            
        }
        
        if (generalViewValue==0)
        {
            bannerFrame.origin.y=containerFrame.origin.y+40;
        }
        else
        {
            bannerFrame.origin.y=containerFrame.origin.y+40;
        }
        // animations settings
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:[duration doubleValue]];
        [UIView setAnimationCurve:[curve intValue]];
        
        //containerView.frame = containerFrame;
        answersTableView.frame=answerframe;
        // question.frame=questionframe;
        answerImageView.frame=answerImageFrame;
        self.adBanner.frame=bannerFrame;
        
        
        
        [UIView commitAnimations];
    }
    else
    {
        CGRect  answerFrame=answersTableView.frame;
        
        answerFrame.size.height=answerFrame.size.height-90;
        answersTableView.frame=answerFrame;
        
    }
    
    if (questionView)
    {
        CGRect questionframe=questionTableView.frame;
        questionframe.size.height=questionView.frame.size.height-162;
        questionTableView.frame=questionframe;
    }
    
    
    
    
}




- (void)keyboardDidHide: (NSNotification *) notif
{
    isKeyboardUp=NO;
    
    NSLog(@"Keyboard hide");
    NSDictionary *userInfo = [notif userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    if (searchBarSelected)
    {
        
        
        CGRect keyboardBounds;
        [[notif.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
        NSNumber *duration = [notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [notif.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        
        // Need to translate the bounds to account for rotation.
        keyboardBounds = [self.viewmenu convertRect:keyboardBounds toView:nil];
        
        centreHorizontallyConstraint.constant-=(kbSize.height-50);
        
        
        CGRect questionframe=question.frame;
        CGRect containerFrame = containerView.frame;
        CGRect answerframe=answersTableView.frame;
        CGRect answerImageFrame=answerImageView.frame;
        CGRect bannerFrame=self.adBanner.frame;
        
        float systemVersion=[[[UIDevice currentDevice]systemVersion]floatValue];
        int val=self.viewmenu.frame.size.height;

        if (val>=519)
        {
            //containerFrame.origin.y = self.viewmenu.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height+30);
            containerFrame.origin.y = self.viewmenu.bounds.size.height - containerFrame.size.height-50;
            
            int mmm=[[UIScreen mainScreen] nativeScale];
            if(mmm==3)
            {
               containerFrame.origin.y = self.viewmenu.bounds.size.height - containerFrame.size.height;
                
            }
            
            answerframe.size.height=answerframe.size.height+162;
            //answerImageFrame.origin.y=textView.frame.origin.y-100;
            
            
            
        }
        else
        {
            containerFrame.origin.y = containerFrame.origin.y+200;
            
            
            answerframe.size.height=answerframe.size.height+162;
            //answerImageFrame.origin.y=textView.frame.origin.y-100;
            
            
        }
        
        if (generalViewValue==0)
        {
            bannerFrame.origin.y=containerFrame.origin.y+40;
        }
        else
        {
            bannerFrame.origin.y=containerFrame.origin.y+40;
        }
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:[duration doubleValue]];
        [UIView setAnimationCurve:[curve intValue]];
        
        
       // containerView.frame = containerFrame;
        answersTableView.frame=answerframe;
        //question.frame=questionframe;
       // answerImageView.frame=answerImageFrame;
        self.adBanner.frame=bannerFrame;
        // searchBar.hidden=NO;
        
        [UIView commitAnimations];
    }
    else
    {
        CGRect  answerFrame=answersTableView.frame;
        answerFrame.size.height=answerFrame.size.height+90;
        answersTableView.frame=answerFrame;
        searchBarSelected=YES;
    }
    
    
    if (questionView)
    {
        CGRect questionframe=questionTableView.frame;
        questionframe.size.height=questionView.frame.size.height;
        questionTableView.frame=questionframe;
    }
    
    
    
    
}


-(void) commentView
{
    UIScreen *MainScreen = [UIScreen mainScreen];
    UIScreenMode *ScreenMode = [MainScreen currentMode];
    CGSize Size = [ScreenMode size];
    NSLog(@"width %f, height %f",Size.width,Size.height);
    
    containerView=[[UIView alloc]init];
    textView=[[HPGrowingTextView alloc]init];
    //int val=self.viewmenu.frame.size.height;
    textView.frame=CGRectMake(0, 5,200, 40);
    
    //  containerView.backgroundColor=[UIColor whiteColor];
    textView.isScrollable = NO;
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    textView.minNumberOfLines = 1;
    textView.maxNumberOfLines = 6;
    
    
    
    
    
    //[textView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
    // [textView observeValueForKeyPath:@"contentSize" ofObject:textView change:nil context:NULL];
    textView.returnKeyType=UIReturnKeyDone;
    textView.font = [UIFont systemFontOfSize:15.0f];
    textView.delegate = self;
    
    
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5,0);
    
    textView.backgroundColor = [UIColor whiteColor];
    
    textView.placeholder = @"Write a comment ";
    
    [self.viewmenu addSubview:containerView];
    containerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    centreHorizontallyConstraint = [NSLayoutConstraint
                                                        constraintWithItem: self.viewmenu
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                        toItem:containerView
                                                        attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                        constant:70];
    
[self.viewmenu addConstraint:centreHorizontallyConstraint];

    
    
    
    NSLayoutConstraint *centreHorizontallyConstraint1 = [NSLayoutConstraint
                                                         constraintWithItem: self.viewmenu
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                         toItem:containerView
                                                         attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                         constant:0];

    [self.viewmenu addConstraint:centreHorizontallyConstraint1];
   /// containerView.frame=CGRectMake(0, 200, 320, 40);
  //  containerView.frame=CGRectMake(0, 200, 320, 40);
[self.viewmenu addConstraint:[NSLayoutConstraint constraintWithItem:containerView attribute: NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute: NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:320]];
    [self.viewmenu addConstraint:[NSLayoutConstraint constraintWithItem:containerView attribute: NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute: NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40]];
    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    
    //  entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    // entryImageView.frame = CGRectMake(5, 0, 248, 40);
    
    
    entryImageView.frame = CGRectMake(5, textView.frame.origin.y, 200, 40);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    messageImageView = [[UIImageView alloc] initWithImage:background];
    messageImageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
    messageImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    //textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    
    
    // view hierachy
    [containerView addSubview:messageImageView];
    [containerView addSubview:textView];
    [containerView addSubview:entryImageView];
    
    
    UIButton *cameraBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    //cameraBtn.frame=CGRectMake(containerView.frame.size.width-115, -5, 50, 50);
    // cameraBtn.frame=CGRectMake(containerView.frame.size.width-115, textView.frame.origin.y
    //    +5, 40,30);
    cameraBtn.frame=CGRectMake(textView.frame.origin.x+textView.frame.size.width+5, textView.frame.origin.y,40,35);
    [cameraBtn addTarget:self action:@selector(cameraClick) forControlEvents:UIControlEventTouchUpInside];
    //    cameraBtn.layer.borderColor=[UIColor blackColor].CGColor;
    //    cameraBtn.layer.borderWidth=1.0f;
    //    cameraBtn.layer.cornerRadius=4.0f;
   // cameraBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    //[cameraBtn setImage:[UIImage imageNamed:@"gallery_icon"] forState:UIControlStateNormal];
    [cameraBtn setImage:[UIImage imageNamed:@"gallery_image"] forState:UIControlStateNormal];
    
    [containerView addSubview:cameraBtn];
    
    
    // MessageEntrySendButton.png
    
    
    
    //UIButton *sendBtn=[[UIButton buttonWithType:UIButtonTypeCustom]]
    UIImage *sendBtnBackground = [[UIImage imageNamed:@""] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@""] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
    UIButton *doneBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    //doneBtn1.frame = CGRectMake(containerView.frame.size.width - 69, 8, 63, 27);
    //containerView.frame.size.width - 69
    //doneBtn1.frame = CGRectMake(containerView.frame.size.width - 69, textView.frame.origin.y+5, 63, 30);
    doneBtn1.frame=CGRectMake(cameraBtn.frame.origin.x+cameraBtn.frame.size.width+5, textView.frame.origin.y,40,35);
   // doneBtn1.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    //[doneBtn1 setTitle:@"Send" forState:UIControlStateNormal];
    //
    //    doneBtn1.layer.borderColor=[UIColor blackColor].CGColor;
    //    doneBtn1.layer.borderWidth=1.0f;
    //    doneBtn1.layer.cornerRadius=4.0f;
    //[doneBtn1 setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    [doneBtn1 setImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
    doneBtn1.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn1.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    
    [doneBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneBtn1 addTarget:self action:@selector(postAction:) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn1 setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
    [doneBtn1 setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
    //[doneBtn1 setImage:[UIImage imageNamed:@"gallery_icon"] forState:UIControlStateNormal];
    [containerView addSubview:doneBtn1];
    
    
    answerImageView=[[UIImageView alloc]init];
    // answerImageView.frame=CGRectMake(0,textView.frame.origin.y-30, 30, 30);
    answerImageView.frame=CGRectMake(doneBtn1.frame.origin.x+doneBtn1.frame.size.width, textView.frame.origin.y, 30, 30);
    answerImageView.layer.borderWidth=0.0f;
    answerImageView.image=convertedImage;
    [containerView addSubview:answerImageView];
    
    
    
    
    
    /*if (generalViewValue==0)
    {
        //self.adBanner.frame=CGRectMake(0, containerView.frame.origin.y-90, self.viewmenu.frame.size.width, 50);
        self.adBanner.frame=CGRectMake(0, self.viewmenu.frame.size.height-140, self.viewmenu.frame.size.width, 50);
    }
    else
    {
        self.adBanner.frame=CGRectMake(0, self.viewmenu.frame.size.height-95, self.viewmenu.frame.size.width, 50);
    }*/
    
    CGRect rect=self.adBanner.frame;
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    CGSize result=[[UIScreen mainScreen]bounds].size;
    if (result.height==568)
    {
        
        
        // answersTableView.frame=CGRectMake(0, 0, 320, (self.viewmenu.frame.size.height-(question.frame.origin.y+90)));
      //  answersTableView.frame=CGRectMake(0,nav.navigationView.frame.size.height, 320, self.viewmenu.frame.size.height-(containerView.frame.size.height+85+self.adBanner.frame.size.height));
        
        
    }
    else
    {
        //answersTableView.frame=CGRectMake(0, 0, 320, (self.viewmenu.frame.size.height-(question.frame.origin.y+90)));
        //answersTableView.frame=CGRectMake(0,nav.navigationView.frame.size.height, 320,  self.viewmenu.frame.size.height-(containerView.frame.size.height+85+self.adBanner.frame.size.height));
    }
    
    CGRect answer=answersTableView.frame;
    

 
   
    
    
    
    
    
    
    
    
    
}



-(void) viewWillDisappear:(BOOL)animated
{
    
   
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}













#pragma mark View Methods
-(void) createUI
{
    
    //Navigation View
    nav = [[NavigationView alloc] init];
    nav.titleView.text = @"Posted Questions";
    [self.viewmenu addSubview:nav.navigationView];
    
    titleBckBtn=[[UIButton alloc]init];
    titleBckBtn.frame=CGRectMake(0,(nav.navigationView.frame.size.height)/2,45,30);
    [titleBckBtn setImage:[UIImage imageNamed:@"back_blue"] forState:UIControlStateNormal];
    backBtnValue=0;
    nav.iconImageView.image=[UIImage imageNamed:@"nav_posted_question"];
    //if (backBtnValue==0)
    //{
        [titleBckBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    //}
    // [self.viewmenu addSubview:titleBckBtn];
    
    
    
    
    //Custom Search Field
    searchView=[[UIView alloc]initWithFrame:CGRectMake(5,nav.navigationView.frame.size.height+5, self.viewmenu.frame.size.width-10, 30)];
    searchView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    searchView.layer.borderWidth=0.5f;
    searchView.layer.cornerRadius=4.0f;
    [self.viewmenu addSubview:searchView];
    
    UIImageView *searchImageView=[[UIImageView alloc]init];
    searchImageView.frame=CGRectMake(0,(searchView.frame.size.height-25)/2, 25, 25);
    [searchImageView setImage:[UIImage imageNamed:@"search_icon"]];
    [searchView addSubview:searchImageView];
    
    searchTextField=[[UITextField alloc]initWithFrame:CGRectMake(searchImageView.frame.origin.x+searchImageView.frame.size.width, 0, searchView.frame.size.width-40,30)];
    searchTextField.delegate=self;
    searchTextField.font=TEXTFIELDFONT;
    searchTextField.returnKeyType=UIReturnKeySearch;
    searchTextField.font=[UIFont italicSystemFontOfSize:15.0f];
    [searchTextField setPlaceholder:@"Search Filter"];
    [searchView addSubview:searchTextField];
    
    UIButton *filterButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [filterButton setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
    [filterButton addTarget:self action:@selector(filterBtn:) forControlEvents:UIControlEventTouchUpInside];
    [filterButton setFrame:CGRectMake(searchView.frame.size.width-40,(searchView.frame.size.height-25)/2, 25, 25)];
    [searchView addSubview:filterButton];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [searchView addSubview:btn];
    
    
    
    
    
  
    
    
  
    //Search Bar
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 44, 320, 44)];
    searchBar.delegate=self;
    searchBar.tintColor=[UIColor whiteColor];
    //[self.viewmenu addSubview:searchBar];
    
    UITextField *searchBarTextField = nil;
    for (UIView *searchBarSubview in [searchBar subviews]) {
        if ( [searchBarSubview isKindOfClass:[UITextField class] ] ) {
            // ios 6 and earlier
            searchBarTextField = (UITextField *)searchBarSubview;
            searchBarTextField.delegate = self;
            
        } else
        {
            // for ios 7 what we need is nested inside another container
            for (UIView *subSubView in [searchBarSubview subviews]) {
                if ( [subSubView isKindOfClass:[UITextField class] ] ) {
                    searchBarTextField = (UITextField *)subSubView;
                    searchBarTextField.delegate = self;
                }
            }
        }
    }
    if (searchBarTextField)
    {
        //[searchBarTextField setReturnKeyType:UIReturnKeyDone];
        [searchBarTextField setReturnKeyType:UIReturnKeySearch];
    }
 
   
    
    postedFriends=[[UIButton alloc]init];
    postedFriends.frame=CGRectMake(0, searchBar.frame.origin.y+44, 200, 50);
    //postedFriends.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0f];
    [postedFriends setTitle:[NSString stringWithFormat:@"Posted Questions[%@]",ques] forState:UIControlStateNormal];
    [postedFriends setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[postedFriends addTarget:self action:@selector(postedQuestion) forControlEvents:UIControlEventTouchUpInside];
    //[self.viewmenu addSubview:postedFriends];
    
    UIButton *arrowBtn=[[UIButton alloc]init];
    arrowBtn.frame=CGRectMake(postedFriends.frame.origin.x+postedFriends.frame.size.width-10, postedFriends.frame.origin.y+10, 30, 30);
    [arrowBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    //[self.viewmenu addSubview:arrowBtn];
    
    
    ViewAllBtn=[[UIButton alloc]initWithFrame:CGRectMake((self.viewmenu.frame.size.width-125), postedFriends.frame.origin.y+10, 120, 36)];
   // ViewAllBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0f];
    [ViewAllBtn setTitle:@"Filter:All" forState:UIControlStateNormal];
    
    [ViewAllBtn addTarget:self action:@selector(ViewAllClick:) forControlEvents:UIControlEventTouchUpInside];
    [ViewAllBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    ViewAllBtn.layer.cornerRadius=4.0f;
    ViewAllBtn.layer.borderColor=[UIColor blackColor].CGColor;
    //Vi
    
    ViewAllBtn.layer.borderWidth=1.0f;
    
    //[self.viewmenu addSubview:ViewAllBtn];
    
    //Line View
    UIView *lineView=[[UIView alloc]init];
    lineView.frame=CGRectMake(0, searchView.frame.origin.y+searchView.frame.size.height+2, self.viewmenu.frame.size.width, 2);
    [lineView setBackgroundColor:[UIColor grayColor]];
     [self.viewmenu addSubview:lineView];

    
    //View Contains Table View
    questionView=[[UIView alloc]init];
    questionView.backgroundColor=[UIColor redColor];
    [questionView setFrame:CGRectMake(0, nav.navigationView.frame.size.height+searchView.frame.size.height+10,self.viewmenu.frame.size.width, (self.viewmenu.frame.size.height-(90+searchView.frame.size.height+12)))];
    [self.viewmenu addSubview:questionView];
    
    
    UIImageView *titleView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    titleView.image=[UIImage imageNamed:@""];
    [questionView addSubview:titleView];
    
    UIImage *image=[UIImage imageNamed:@"arrow"];
    UIButton *upBtn=[[UIButton alloc]init];
    upBtn.frame=CGRectMake(250, ViewAllBtn.frame.origin.y, 50, ViewAllBtn.frame.size.height+10);
        [upBtn setImage:[self rotateImage:image onDegrees:90] forState:UIControlStateNormal];
    //[upBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [upBtn addTarget:self action:@selector(ascendingQuesClick) forControlEvents:UIControlEventTouchUpInside];
  
   // [upBtn setImage:image forState:UIControlStateNormal];
    [questionView addSubview:upBtn];
    
    UIButton *downBtn=[[UIButton alloc]init];
    downBtn.frame=CGRectMake(270, ViewAllBtn.frame.origin.y, 50, ViewAllBtn.frame.size.height+10);
    [downBtn setImage:[self rotateImage:image onDegrees:270] forState:UIControlStateNormal];
 
    [downBtn addTarget:self action:@selector(descendingQuesClick) forControlEvents:UIControlEventTouchUpInside];
    [questionView addSubview:downBtn];
    
   
    
    questionTableView=[[UITableView alloc]init];
    CGSize result=[[UIScreen mainScreen]bounds].size;
    if (result.height==568)
    {
         questionTableView.frame=CGRectMake(0,0, 320, questionView.frame.size.height);
     
    }
    else
    {
         questionTableView.frame=CGRectMake(0,0, 320, questionView.frame.size.height);
    }
    

    //Accept answers
    
    
    questionTableView.delegate=self;
    questionTableView.dataSource=self;
    questionTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [questionView addSubview:questionTableView];
   
    //}
    
    
    
    
   
    
   
    
   
}

- (UIImage *)rotateImage:(UIImage *)image onDegrees:(float)degrees
{
    CGFloat rads = M_PI * degrees / 180;
    float newSide = MAX([image size].width, [image size].height);
    CGSize size =  CGSizeMake(newSide, newSide);
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, newSide/2, newSide/2);
    CGContextRotateCTM(ctx, rads);
    CGContextDrawImage(UIGraphicsGetCurrentContext(),CGRectMake(-[image size].width/2,-[image size].height/2,size.width, size.height),image.CGImage);
    UIImage *i = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return i;
}



-(void)postedAnswersSubview
{

    answersTableView=[[UITableView alloc]init];

    
    
    nav=[[NavigationView alloc]init];
    nav.titleView.text = titleString;
    [self.viewmenu addSubview:nav.navigationView];
    if(![titleString isEqualToString:@"QUESTIONS"])
        nav.titleView.frame=CGRectMake(nav.titleView.frame.origin.x-20,nav.titleView.frame.origin.y,nav.titleView.frame.size.width,nav.titleView.frame.size.height);
    titleBckBtn=[[UIButton alloc]init];
    titleBckBtn.frame=CGRectMake(0,(nav.navigationView.frame.size.height)/2,45,30);
    [titleBckBtn setImage:[UIImage imageNamed:@"back_blue"] forState:UIControlStateNormal];
    backBtnValue=0;
  
    //if (backBtnValue==0)
    //{
    [titleBckBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    //}
    [self.viewmenu addSubview:titleBckBtn];
    
    
    
    answersTableView.delegate=self;
    answersTableView.dataSource=self;
    
    [self.viewmenu addSubview:answersTableView];
    
    self.adBanner=[[GADBannerView alloc]init];
    
    // Need to set this to no since we're creating this custom view.
   /* self.adBanner.translatesAutoresizingMaskIntoConstraints = NO;
    self.adBanner.adUnitID = @"a150bf362eb1333";
    self.adBanner.delegate = self;
    [self.adBanner setRootViewController:self];
    [self.adBanner setBackgroundColor:[UIColor grayColor]];
    [self.adBanner loadRequest:[self createRequest]];
    [self.viewmenu addSubview:self.adBanner];*/
    [self commentView];
    [self postFetchData];
}


-(void)answersSubView
{
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(5, 5, self.viewmenu.frame.size.width-10, 2)];
    [lineView setBackgroundColor:[UIColor lightGrayColor]];
    [self.viewmenu addSubview:lineView];
    
    
    

    
    
    
}

-(void) popImageView:(UITapGestureRecognizer *)recognizer
{
    
    
    imagesQuestionViews= [[NSMutableArray alloc] init];
    //[imagesQuestionViews addObject:@"http://54.69.127.235/question_app/question_images/1467103364_image.png" ];
    ///  [imagesQuestionViews addObject:@"http://54.69.127.235/question_app/////question_images/1467103389_image.png" ];
    
   // NSArray *questionInfo=[questionArray objectAtIndex:recognizer.view.tag];
    NSString *questionId =[[questionInfo valueForKey:@"id"]objectAtIndex:0];
    
    NSArray *listArray=[[WebServiceSingleton sharedMySingleton]getQuestionImagesByquestionId:questionId];
    NSString *status=[[listArray valueForKey:@"status"]objectAtIndex:0];
    if ([status isEqualToString:@"1"])
    {
        NSArray *mainArray=[[listArray valueForKey:@"data"]objectAtIndex:0];
        for (id arrayFr in mainArray)
        {
            NSString *urlString=[arrayFr valueForKey:@"image"];
            urlString = [NSString stringWithFormat:@"http://%@", urlString];
            [ imagesQuestionViews addObject:urlString];
            
        }
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



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // if the gesture recognizers are on different views, don't allow simultaneous recognition
    if (gestureRecognizer.view != otherGestureRecognizer.view)
        return NO;
    
    // if either of the gesture recognizers is the long press, don't allow simultaneous recognition
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] || [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
        return NO;
    
    return YES;
}


- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer
{
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
}

- (void)handleRotate:(UIRotationGestureRecognizer *)recognizer
{
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    recognizer.rotation = 0;
}


-(void) resignImageView
{
    [imageScrollView removeFromSuperview];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return ImagePostQuestion;
}




-(void) popAnswerImageViewProfile:(UITapGestureRecognizer *)recognizer

{
    // UserDetailViewController *userProfile=[[UserDetailViewController alloc]init];
    
    
    //NSString   *userId=userIdGeneral;
    NSString   *userId=[postData valueForKey:@"userId"][recognizer.view.tag];
    
    //NSString *userId=[[filteredResults valueForKey:@"userid"]objectAtIndex:recognizer.view.tag];
    //userProfile.messageValue=2;
    //userProfile.user_id=userId;
    //[self.navigationController pushViewController:userProfile animated:NO];
    AddFriendViewController *addFriend=[[AddFriendViewController alloc]init];
    addFriend.friendUserId=userId;
    [self.navigationController pushViewController:addFriend animated:NO];
}
 -(void) popAnswerImageView:(UITapGestureRecognizer *)recognizer
{
    
    [textView resignFirstResponder];
    [searchBar resignFirstResponder];
    
    answerImageStr=[postData valueForKey:@"attachment"][recognizer.view.tag];
        if ([answerImageStr rangeOfString:@"http://"].location == NSNotFound)
        {
            answerImageStr = [NSString stringWithFormat:@"http://%@", answerImageStr];
        }
        
      //S  NSURL *imageUrl=[NSURL URLWithString:answerImageStr];
    
    imagesQuestionViews= [[NSMutableArray alloc] init];
    //[imagesQuestionViews addObject:@"http://54.69.127.235/question_app/question_images/1467103364_image.png" ];
    ///  [imagesQuestionViews addObject:@"http://54.69.127.235/question_app/////question_images/1467103389_image.png" ];
    
    // NSArray *questionInfo=[questionArray objectAtIndex:recognizer.view.tag];
    [imagesQuestionViews addObject:answerImageStr];
    
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



- (void)pinchImageGesture:(UIPinchGestureRecognizer *)recognizer
{
    UIGestureRecognizerState state = [recognizer state];
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGFloat scale = [recognizer scale];
        [recognizer.view setTransform:CGAffineTransformScale(recognizer.view.transform, scale, scale)];
        [recognizer setScale:1.0];
    }
    
   
    
}

-(void)backImageView
{
    [popImageView removeFromSuperview];
    [backImageBtn removeFromSuperview];
}

-(void) savedPost
{
    
}

-(void) answersValue
{
    NSLog(@"%@",filteredResults);
    NSLog(@"%@",generalQuestionArray);
    //
    if (generalViewValue==0)
    {
        
    }
    else if (generalViewValue==1)
    {
        answersViewArray=generalQuestionArray;
    }
    else if (generalViewValue==2)
    {
        answersViewArray=[NSMutableArray arrayWithObjects:postData,questionInfo,favouriteInfo, nil];
    }
}




-(void) ViewAllClick:(id) sender
{
    
    if (![searchBar isFirstResponder])
    {
        
    
    viewPicker=[[UIView alloc]init];
    [viewPicker setFrame:self.viewmenu.bounds];
    [viewPicker setBackgroundColor:[UIColor clearColor]];
    [self.viewmenu addSubview:viewPicker];
    

    pickerView=[[UIPickerView alloc]init];
    pickerView.frame=CGRectMake(0, (self.viewmenu.frame.size.height-210)/2, 320, 216);
       // pickerView.frame=CGRectMake(0, 0, 320, 216);
  
    pickerView.delegate=self;
    pickerView.dataSource=self;
    [pickerView setBackgroundColor:[UIColor lightGrayColor]];
    //[pickerView selectRow: inComponent:0 animated:YES];
    pickerView.showsSelectionIndicator=YES;
    NSString *str=ViewAllBtn.titleLabel.text;
    
    
    
    NSString *catagoryString;
    if ([str rangeOfString:@"Filter"].location==NSNotFound)
    {
        catagoryString=str;
    }
    else
    {
        
        catagoryString=[str substringWithRange:NSMakeRange(7, str.length-7)];
    }

    
   
    
   
    NSInteger is;
    if ([categoryTblArray containsObject:catagoryString])
    {
         is=[categoryTblArray indexOfObject:catagoryString];
       
    }
    
  
    
  
    [viewPicker addSubview:pickerView];

    
    
    [pickerView selectRow:is inComponent:0 animated:YES];
    }
    
    

    
}


#pragma mark PickerView Methods

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [categoryTblArray count];
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [categoryTblArray objectAtIndex:row];
    
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (row==0)
    {
        
        filteredResults=[NSMutableArray arrayWithArray:questionArray];
     
        NSPredicate *predicate;
        if ([searchTextStr isEqualToString:@""])
        {
            
        }
        else
        {
            predicate=[NSPredicate predicateWithFormat:@"SELF.question contains [c]%@",searchTextStr];
            filteredResults=[NSMutableArray arrayWithArray:[filteredResults filteredArrayUsingPredicate:predicate]];
        }
        [ViewAllBtn setTitle:[NSString stringWithFormat:@"Filter:%@",[categoryTblArray objectAtIndex:row]] forState:UIControlStateNormal];
        [postedFriends setTitle:[NSString stringWithFormat:@"Posted Questions[%lu]",(unsigned long)[filteredResults count]] forState:UIControlStateNormal];
        
       
        
    }
    else
    {
        NSString *str=[NSString stringWithFormat:@"%ld",(row-1)];
        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF.categoryId contains[c] %@",str]; // Creating filter
        filteredResults=[NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:filterPredicate]];
      
        NSPredicate *predicate;
        if ([searchTextStr isEqualToString:@""])
        {
            
        }
        else
        {
            predicate=[NSPredicate predicateWithFormat:@"SELF.question contains [c]%@",searchTextStr];
            filteredResults=[NSMutableArray arrayWithArray:[filteredResults filteredArrayUsingPredicate:predicate]];
        }
       
       
        [ViewAllBtn setTitle:[NSString stringWithFormat:@"%@",[categoryTblArray objectAtIndex:row]] forState:UIControlStateNormal];
        [postedFriends setTitle:[NSString stringWithFormat:@"Posted Questions[%lu]",(unsigned long)[filteredResults count]] forState:UIControlStateNormal];
       
        
        
    }
    [self tableViewScrollToTop];
    [questionTableView reloadData];
    [viewPicker removeFromSuperview];
    
}











#pragma mark SearchBar Methods

-(BOOL) searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //searchBar.keyboardType=UIKeyboardTypeDefault;
   
    //[searchBar resignFirstResponder];
    
    
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar1 textDidChange:(NSString *)searchText
{
    searchTextStr=searchText;
    if (searchValue==0)
    {
        if (searchText.length==0)
        {
            
            NSString *viewTitle=ViewAllBtn.titleLabel.text;
            NSString *stringValue;
            if ([viewTitle rangeOfString:@"Filter:"].location!=NSNotFound)
            {
                filteredResults=questionArray;
                //filteredResults=[[mainArray valueForKey:@"data"]objectAtIndex:0];
                stringValue=[viewTitle substringWithRange:NSMakeRange(7, viewTitle.length-7)];
            }
            else
            {
                
                int intValue=(int)[categoryTblArray indexOfObject:viewTitle];
                NSString *pickerValue=[NSString stringWithFormat:@"%d",(intValue-1)];
                NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF.categoryId contains[c] %@",pickerValue]; // Creating filter condition
                //questionArray=[questionArray filteredArrayUsingPredicate:filterPredicate];
                filteredResults=[NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:filterPredicate]];
            }
            
            //filteredResults=[NSMutableArray arrayWithArray:questionArray];
            [postedFriends setTitle:[NSString stringWithFormat:@"Posted Questions[%lu]",(unsigned long)filteredResults.count] forState:UIControlStateNormal];
        }
        else
        {
            NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF.question contains [c]%@",searchText];
            //filteredResults=[NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:predicate]];
            filteredResults=[NSMutableArray arrayWithArray:[filteredResults filteredArrayUsingPredicate:predicate]];
            [postedFriends setTitle:[NSString stringWithFormat:@"Posted Questions[%lu]",(unsigned long)filteredResults.count] forState:UIControlStateNormal];
            NSLog(@"%@",filteredResults);
        }

         [questionTableView reloadData];
    }
    else
    {
        NSLog(@"%@",postData);
        if (postData)
        {
            if (searchText.length==0)
            {
                postData=[NSMutableArray arrayWithArray:answerData];
            }
            else
            {
            NSPredicate *filterPredicate=[NSPredicate predicateWithFormat:@"SELF.answer contains[c] %@",searchText];
            postData=[NSMutableArray arrayWithArray:[answerData filteredArrayUsingPredicate:filterPredicate]];
            }
            [answersTableView reloadData];
        }
        else
        {
            
        }
       
    }
    
    // Creating filter condition

    searchBar.delegate=self;
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1
{
    searchBarSelected=YES;
    [searchBar resignFirstResponder];
    [questionTableView reloadData];
}

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar1
{
    
    if (searchValue==0)
    {
        searchBar.text=@"";
        filteredResults=[NSMutableArray arrayWithArray:questionArray];
        [questionTableView reloadData];
        [searchBar resignFirstResponder];
    }
    else
    {
        if (postData)
        {
            searchBar.text=@"";
            postData=[NSMutableArray arrayWithArray:answerData];
            [answersTableView reloadData];
        }
        [searchBar resignFirstResponder];
        

        
    }
    searchBarSelected=YES;
   
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBarSelected=NO;
}
-(void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBarSelected=YES;
}














#pragma mark Webservice Methods

-(void) fetchData
{
    
    NSMutableArray *array = [[[WebServiceSingleton sharedMySingleton]fetchData:ids]mutableCopy];
    NSLog(@"%@",array);
    
   
    questionArrayInfo=[[array valueForKey:@"userinfo"]objectAtIndex:0];
    
    
    if ([[[array valueForKey:@"success"]objectAtIndex:0]isEqualToString:@"0"])
    {
        filteredResults=nil;
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"No Question at this time" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
    }
    
    else
    {

        questionArray=[[array valueForKey:@"questions"]objectAtIndex:0];
        filteredResults=[[[array valueForKey:@"questions"]objectAtIndex:0]mutableCopy];
        
        
        NSString *viewTitle=ViewAllBtn.titleLabel.text;
        NSString *stringValue;
        if ([viewTitle rangeOfString:@"Filter:"].location!=NSNotFound)
        {
            filteredResults=[[[array valueForKey:@"questions"]objectAtIndex:0]mutableCopy];
            stringValue=[viewTitle substringWithRange:NSMakeRange(7, viewTitle.length-7)];
        }
        else
        {
            
            int intValue=[categoryTblArray indexOfObject:viewTitle];
            NSString *pickerValue=[NSString stringWithFormat:@"%d",(intValue-1)];
            NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF.categoryId contains[c] %@",pickerValue]; // Creating filter condition
            //questionArray=[questionArray filteredArrayUsingPredicate:filterPredicate];
            filteredResults=[NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:filterPredicate]];
        }
    [questionTableView reloadData];
        [answersTableView reloadData];
        
        
    }
    [self hideActivity];
    NSLog(@"%@",filteredResults);
 }

-(void)reloadTable
{
   
    [questionTableView reloadData];
     [answersTableView reloadData];

}


-(void) tableViewScrollToTop
{
    NSInteger lastSectionIndex = [questionTableView numberOfSections] - 1;
    NSInteger lastItemIndex = [questionTableView numberOfRowsInSection:[[filteredResults valueForKey:@"question"]count]];
    NSIndexPath *pathToLastItem = [NSIndexPath indexPathForItem:lastItemIndex inSection:lastSectionIndex];
    if (filteredResults.count==0)
    {
        
    }
    else
    {
    [questionTableView scrollToRowAtIndexPath:pathToLastItem atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
   
}


-(void) postFetchData
{
    NSLog(@"%@",questionID);
    NSLog(@"%@",ids);
    ids=[userData valueForKey:@"id"];
    answerID=@"";

    NSArray *mainArray=[[WebServiceSingleton sharedMySingleton]postData:questionID userId:ids];
    NSString *success=[[mainArray valueForKey:@"success"]objectAtIndex:0];
   

    answerData=[[mainArray valueForKey:@"data"]objectAtIndex:0];
    NSLog(@"%@",answerData);
    if ([success isEqualToString:@"1"])
    {
//        NSSortDescriptor *descriptor=[NSSortDescriptor sortDescriptorWithKey:@"answer_date" ascending:NO];
//        postData=[[answerData sortedArrayUsingDescriptors:@[descriptor]]mutableCopy];
//        NSLog(@"%@",postData);
        postData=[[[mainArray valueForKey:@"data"]objectAtIndex:0]mutableCopy];
        
    }
    else
    {
        postData=nil;
        //return;
    }
    questionInfo=[[NSMutableArray alloc]initWithObjects:[[mainArray valueForKey:@"question_info"]objectAtIndex:0], nil]
   ;
    NSLog(@"%@",questionInfo);
    
    favouriteInfo=[[mainArray valueForKey:@"favourite"]objectAtIndex:0];
    [answersTableView reloadData];
    
   
    [self hideActivity];
     [activityView removeFromSuperview];
}



-(void) acceptAnswer
{
    NSLog(@"%@",answerID);
    NSArray *mainArray=[[WebServiceSingleton sharedMySingleton]acceptAnswer:[NSString stringWithFormat:@"%@",answerID]];
    status=[NSString stringWithFormat:@"%@",[mainArray objectAtIndex:0]];
  
   
}

-(void) unacceptAnswer
{
    NSArray *mainArray=[[WebServiceSingleton sharedMySingleton]unacceptAnswer:[NSString stringWithFormat:@"%@",answerID]];
    status=[NSString stringWithFormat:@"%@",[mainArray objectAtIndex:0]];
}








#pragma mark TableView Methods





-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==questionTableView)
    {
        return 1;
    }
    else if (tableView==categoryTblView)
    {
        return 1;
    }
    else
    {
        return 2;
    }
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==questionTableView)
    {
        return [filteredResults count];
    }
    else if(tableView==answersTableView)
    {
        if (section==0)
        {
            return 1;
        }
        else
        {
            return [[postData valueForKey:@"answer"]count];
        }
    }
    else if (tableView==categoryTblView)
    {
       return [categoryTblArray count];
    }
    else
    {
     return 1;
    }
    
    
}



-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==questionTableView)
    {
        
        NSString *cellIdentifier=[NSString stringWithFormat:@"CellID1%li",(long)indexPath.row];
        CustomTableViewCell *cell=(CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil)
        {
            //cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 578.0, cell.frame.size.width,2.0)];
            [lineView setBackgroundColor:[UIColor lightGrayColor]];
            [cell.contentView addSubview:lineView];
            
        }
        
        
        //Question Image
        //nameImg=[[UIImageView alloc]initWithFrame:CGRectMake(10,10,50,50)];
        NSString *urlString = [[filteredResults objectAtIndex:indexPath.row] valueForKey:@"thumb"];
        if ([urlString rangeOfString:@"http://"].location == NSNotFound)
        {
            urlString = [NSString stringWithFormat:@"http://%@", urlString];
        }
        NSURL *imageUrl=[NSURL URLWithString:urlString];
        [cell.questionImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"name_icon"]];
        //[cell.contentView addSubview:self.nameImg];
        
        
        //Question Label
       // UILabel *quesLbl=[[UILabel alloc]init];
        //[quesLbl setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
        //quesLbl.frame=CGRectMake(nameImg.frame.origin.x+nameImg.frame.size.width+5,0,cell.frame.size.width-70,40);
        NSString *questionText = [[filteredResults objectAtIndex:indexPath.row]valueForKey:@"question"];
        [cell.questionLabel setText:questionText];
        //[cell.contentView addSubview:quesLbl];
        
       
        

        
        
        
        //User name 
        //UIButton *nameBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        //nameBtn.frame=CGRectMake(quesLbl.frame.origin.x, quesLbl.frame.size.height,70, 30);
        NSString *user_name=[questionArrayInfo valueForKey:@"name"];
        [cell.userNameBtn setTitle:user_name forState:UIControlStateNormal];
        //nameBtn.titleLabel.textColor=[UIColor blackColor];
       // nameBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0f];
        //nameBtn.backgroundColor=[UIColor whiteColor];
        //nameBtn.titleLabel.textAlignment=NSTextAlignmentLeft;
        profileViewVal=1;
        cell.userNameBtn.tag=indexPath.row;
        [cell.userNameBtn addTarget:self action:@selector(profileView:) forControlEvents:UIControlEventTouchUpInside];
       
        NSString *timeStampString=[NSString stringWithFormat:@"%@",[[filteredResults objectAtIndex:indexPath.row]valueForKey:@"question_date"]];
        NSString *dateStr = [[AppDelegate sharedDelegate] localDateFromDate:timeStampString];
        NSString *resultString=[dateStr substringWithRange:NSMakeRange(0, 10)];
        NSString *yearString=[resultString substringWithRange:NSMakeRange(6, 4)];
        NSString *monthString=[resultString substringWithRange:NSMakeRange(3, 2)];
        NSString *date=[resultString substringWithRange:NSMakeRange(0, 2)];
        resultString= [NSString stringWithFormat:@"%@/%@/%@",monthString,date,yearString];
        
        [cell.dateLabel setText:resultString];
        //[cell.contentView addSubview:dateLabel];
        
        
        //Time Label
        NSString *resultTime=[dateStr substringWithRange:NSMakeRange(11, dateStr.length-11)];
        //UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(dateLabel.frame.origin.x+dateLabel.frame.size.width, dateLabel.frame.origin.y, 70, 30)];
       // [timeLabel setTextColor:[UIColor grayColor]];
        //[timeLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
        [cell.timeLabel setText:resultTime];
        //[cell.contentView addSubview:timeLabel];
        
        
        //Total Answers Label
        //UILabel *totalAns=[[UILabel alloc]init];
        //[totalAns setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
        //totalAns.frame=CGRectMake(timeLabel.frame.origin.x+timeLabel.frame.size.width,timeLabel.frame.origin.y, 30, 20);
        [cell.totalAnswersLabel setText:[NSString stringWithFormat:@"%@ Replies",[[filteredResults objectAtIndex:indexPath.row]valueForKey:@"totalAnswers"]]];
        //[cell.contentView addSubview:totalAns];
        return cell;
    }
    
    else if (tableView==categoryTblView)
    {
        static NSString *cellIdentifier=@"CellIdentifier";
        UITableViewCell *cell=(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor=[UIColor grayColor];
            
            UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,29.5, cell.frame.size.width,0.5)];
            [lineView setBackgroundColor:[UIColor lightGrayColor]];
            [cell.contentView addSubview:lineView];
            
            
           
        }
        
        cell.textLabel.text=[categoryTblArray objectAtIndex:indexPath.row];
       
        
        return cell;
        
    }
    else
    {
       // answersTableView.sectionHeaderHeight = 1.0;
        //answersTableView.sectionFooterHeight = 1.0;
        
        answersTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
//        answersTableView.layer.borderColor=[UIColor blackColor].CGColor;
//        answersTableView.layer.borderWidth=0.5;
        
     //answersTableView.
        
        if (indexPath.section==0)
        {
            
            if([self Checkhasimagequestion])
            {
                
                NSString *cellIdentifier=@"QuestionDetailViewCell";
                QuestionDetailViewCell *cell=(QuestionDetailViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                // cell.frame=CGRectMake(5, 100 ,self.viewmenu.frame.size.width-15, 2);
                if (cell==nil)
                {
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"QuestionDetailViewCell" owner:self options:nil];
                    cell=[nib objectAtIndex:0];
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    
                  
                }
                
                
                cell.userImageView.layer.cornerRadius=cell.userImageView.frame.size.width/2;
                cell.userImageView.layer.borderColor=[UIColor lightGrayColor].CGColor;
                cell.userImageView.layer.borderWidth=1.0f;
                cell.userImageView.clipsToBounds=YES;
                NSString *userProfileImage;
                userProfileImage=[[questionInfo valueForKey:@"profile_pic"]objectAtIndex:0];
                if ([userProfileImage isEqualToString:@"(null)"])
                {
                    userProfileImage=@"";
                }
                
                
                NSURL *url=[NSURL URLWithString:userProfileImage];
                
                [cell.userImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"user_icon"]];
                
                //cell.userNameBtn
                NSString *user_name=questionNameStr;
                [cell.userNameBtn setTitle:user_name forState:UIControlStateNormal];
                [cell.userNameBtn setTitleColor:BUTTONCOLOR forState:UIControlStateNormal];
                cell.userNameBtn.titleLabel.font=[UIFont fontWithName:@"Avenir" size:12.0f];
                cell.userNameBtn.backgroundColor=[UIColor whiteColor];
                cell.userNameBtn.tag=[[questionInfo valueForKey:@"id"]objectAtIndex:0];
                [cell.userNameBtn addTarget:self action:@selector(profileViewQuestion:) forControlEvents:UIControlEventTouchUpInside];
                //cell.dateLabel
                NSString *quesDate=[[questionInfo valueForKey:@"question_date"]objectAtIndex:0];
                cell.dateLabel.text=quesDate;
            
               // [cell.tvQuestionText setEditable:NO];
                
                NSString *hashtagquestion =[NSString stringWithFormat:@"%@",postText];
                
                for(id objectvalue in [[questionInfo valueForKey:@"hashtagarr"]objectAtIndex:0])
                {
                    NSString *hashtag=[objectvalue objectForKey:@"hashtag"];
                    if([hashtag isEqualToString:@""] || [hashtag isEqualToString:@"(null)"])
                        continue;
                    hashtagquestion =[NSString stringWithFormat:@"%@ #%@",hashtagquestion,[objectvalue objectForKey:@"hashtag"]];
                    
                }
                
                
                for(id objectvalue in [[questionInfo valueForKey:@"tagfriends"]objectAtIndex:0])
                {
                    
                    hashtagquestion =[NSString stringWithFormat:@"%@ @%@",hashtagquestion,[objectvalue objectForKey:@"username"]];
                    
                }
                
                CCHLinkTextView *questiontext=(CCHLinkTextView *)cell.tvQuestionText;
                
                questiontext.text=hashtagquestion;
                
                CGSize textViewSize = [cell.tvQuestionText sizeThatFits:CGSizeMake(cell.tvQuestionText.frame.size.width, FLT_MAX)];
                
                // [cell.tvQuestionText removeFromSuperview];
                //[cell insertSubview:questiontext atIndex:0];
                cell.clviewquestion.constant=cell.clviewquestion.constant+(textViewSize.height);
                
                cell.lcheightquestiontext.constant=(textViewSize.height);
                
                questiontext.scrollEnabled=true;

                
                NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:hashtagquestion];
                
               
                
                
                for(id objectvalue in [[questionInfo valueForKey:@"hashtagarr"]objectAtIndex:0])
                {
                    
                    
                    NSRange range = [hashtagquestion rangeOfString:[NSString stringWithFormat:@"#%@",[objectvalue objectForKey:@"hashtag"]] options:NSCaseInsensitiveSearch];
                    
                    if (range.location != NSNotFound) {
                        
                        [str addAttribute:CCHLinkAttributeName value:[NSString stringWithFormat:@"#%@",[objectvalue objectForKey:@"hashtag"]] range:range];
                        
                    }

                    
                    
                }
                
                
                for(id objectvalue in [[questionInfo valueForKey:@"tagfriends"]objectAtIndex:0])
                {
                    
                    
                    NSRange range = [hashtagquestion rangeOfString:[NSString stringWithFormat:@"@%@",[objectvalue objectForKey:@"username"]] options:NSCaseInsensitiveSearch];
                    
                    if (range.location != NSNotFound) {
                        
                        [str addAttribute:CCHLinkAttributeName value:[NSString stringWithFormat:@"%@",[objectvalue objectForKey:@"id"]] range:range];
                        
                    }

                    
                }
                
                cell.selectionStyle=UITableViewCellSelectionStyleNone;

                questiontext.attributedText= str;
                questiontext.linkDelegate = self;
                questiontext.selectable=YES;
                questiontext.userInteractionEnabled=YES;
                
                
                questiontext.linkTextAttributes = @{NSForegroundColorAttributeName : [UIColor blueColor]};
                questiontext.linkTextTouchAttributes = @{NSForegroundColorAttributeName : [UIColor orangeColor],
                                                         NSBackgroundColorAttributeName: [UIColor darkGrayColor]};
                
                
                cell.lbactions.userInteractionEnabled = YES;
                
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                                      initWithTarget:self action:@selector(createsubmenuaction:)];
                cell.lbactions.tag=indexPath.row;
                [cell.lbactions addGestureRecognizer:tapGesture];
                
                
                NSString * statussaved=[[questionInfo valueForKey:@"questionSaved"]objectAtIndex:0];
                saveBtn=cell.btSave;
                // cell.btSave
                if ([statussaved isEqualToString:@"0"])
                {
                    [cell.btSave setImage:[UIImage imageNamed:@"save_black"] forState:UIControlStateNormal];
                }
                else
                {
                    [cell.btSave setImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
                    
                }
                [cell.btSave addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
                
                //cell.btShare
                [cell.btShare setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
                [cell.btShare addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
                //cell.questionImageView
                NSString *baseUrl=[NSString stringWithFormat:@"%@question_images/thumbs/",webserviceBaseUrl];
                UITapGestureRecognizer *tapGesturenew=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popImageView:)];
                tapGesturenew.numberOfTapsRequired=1;
                tapGesturenew.view.tag=indexPath.row;
                if (![thumbUrlString isEqualToString:baseUrl])
                {
                    if (!(thumbUrlString.length==0))
                    {
                        
                        
                        if ([thumbUrlString rangeOfString:@"http://"].location == NSNotFound)
                        {
                            thumbUrlString = [NSString stringWithFormat:@"http://%@", thumbUrlString];
                        }
                        NSLog(@"%@",thumbUrlString);
                        NSURL *imageUrl=[NSURL URLWithString:thumbUrlString];
                        [cell.questionImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder"]];
                        // [questionImageView setImage:[UIImage imageNamed:@"name_icon"]];
                        
                        
                        
                        
                        [cell.questionImageView addGestureRecognizer:tapGesturenew];
                        
                        [cell.questionImageView setUserInteractionEnabled:YES];
                        
                    }
                }
                else
                {
                    [cell.questionImageView setImage:[UIImage imageNamed:@"placeholder"]];
                }
                
                
                
                [cell.btEdit setHidden:YES];
                [cell.btDelete setHidden:YES];
                //cell.btlike
                
                queslikeBtn=cell.btlike;
                [queslikeBtn addTarget:self action:@selector(questionLikeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btlike setHidden:YES];
                UITapGestureRecognizer *tapGesturenewlike=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(questionLikeBtnActionnew:)];
               
                tapGesturenewlike.numberOfTapsRequired=1;
                tapGesturenewlike.view.tag=indexPath.row;
                [cell.imggood addGestureRecognizer:tapGesturenewlike];
               
                
                [cell.imggood setUserInteractionEnabled:YES];
                
                
                
                UITapGestureRecognizer *tapGesturenewlike1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(questionLikeBtnActionnew:)];
                tapGesturenewlike1.numberOfTapsRequired=1;
                tapGesturenewlike1.view.tag=indexPath.row;
                
                [cell.imgbordergood addGestureRecognizer:tapGesturenewlike1];
               
                
               
                [cell.imgbordergood setUserInteractionEnabled:YES];
                
                
                [cell.btflag addTarget:self action:@selector(questionFlagBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                
                
                likeCountLabel=cell.lbcountgood;
                NSString *likeStr=[[questionInfo valueForKey:@"likecount"]objectAtIndex:0];
                if (![likeStr isEqualToString:@"0"])
                {
                    likeCountLabel.text=likeStr;
                }
                else
                {
                    likeCountLabel.text=@"";
                }
                
                
                
                /* NSString *likeDislikeStatus=[[questionInfo valueForKey:@"like_dislike_status"]objectAtIndex:0];
                 //DislikeStatus 1 for like 0 for dislike and 2 for none
                 
                 //Dislike
                 if ([likeDislikeStatus isEqualToString:@"0"])
                 {
                 [queslikeBtn setImage:[UIImage imageNamed:@"like_active"] forState:UIControlStateNormal];
                 }
                 //Like
                 else if ([likeDislikeStatus isEqualToString:@"1"])
                 {
                 [queslikeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
                 }
                 
                 //None
                 else if ([likeDislikeStatus isEqualToString:@"2"])
                 {
                 [queslikeBtn setImage:[UIImage imageNamed:@"like_active"] forState:UIControlStateNormal];
                 }
                 */
                return cell;
            }
            else
            {
                
                NSString *cellIdentifier=@"NoImageQuestionDetailViewCell";
                NoImageQuestionDetailViewCell *cell=(NoImageQuestionDetailViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                // cell.frame=CGRectMake(5, 100 ,self.viewmenu.frame.size.width-15, 2);
                if (cell==nil)
                {
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"NoImageQuestionDetailViewCell" owner:self options:nil];
                    cell=[nib objectAtIndex:0];
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    
                }
                
                
                cell.userImageView.layer.cornerRadius=cell.userImageView.frame.size.width/2;
                cell.userImageView.layer.borderColor=[UIColor lightGrayColor].CGColor;
                cell.userImageView.layer.borderWidth=1.0f;
                cell.userImageView.clipsToBounds=YES;
                NSString *userProfileImage;
                userProfileImage=[[questionInfo valueForKey:@"profile_pic"]objectAtIndex:0];
                if ([userProfileImage isEqualToString:@"(null)"])
                {
                    userProfileImage=@"";
                }
                
                
                NSURL *url=[NSURL URLWithString:userProfileImage];
                
                [cell.userImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"user_icon"]];
                
                //cell.userNameBtn
                NSString *user_name=questionNameStr;
                [cell.userNameBtn setTitle:user_name forState:UIControlStateNormal];
                [cell.userNameBtn setTitleColor:BUTTONCOLOR forState:UIControlStateNormal];
                cell.userNameBtn.titleLabel.font=[UIFont fontWithName:@"Avenir" size:12.0f];
                cell.userNameBtn.backgroundColor=[UIColor whiteColor];
                cell.userNameBtn.tag=[[questionInfo valueForKey:@"id"]objectAtIndex:0];
                [cell.userNameBtn addTarget:self action:@selector(profileViewQuestion:) forControlEvents:UIControlEventTouchUpInside];
                //cell.dateLabel
                NSString *quesDate=[[questionInfo valueForKey:@"question_date"]objectAtIndex:0];
                cell.dateLabel.text=quesDate;
                
                // [cell.tvQuestionText setEditable:NO];
                
                NSString *hashtagquestion =[NSString stringWithFormat:@"%@",postText];
                
                for(id objectvalue in [[questionInfo valueForKey:@"hashtagarr"]objectAtIndex:0])
                {
                    NSString *hashtag=[objectvalue objectForKey:@"hashtag"];
                    if([hashtag isEqualToString:@""] || [hashtag isEqualToString:@"(null)"])
                        continue;
                    hashtagquestion =[NSString stringWithFormat:@"%@ #%@",hashtagquestion,[objectvalue objectForKey:@"hashtag"]];
                    
                }
                
                
                for(id objectvalue in [[questionInfo valueForKey:@"tagfriends"]objectAtIndex:0])
                {
                    
                    hashtagquestion =[NSString stringWithFormat:@"%@ @%@",hashtagquestion,[objectvalue objectForKey:@"username"]];
                    
                }
                
                CCHLinkTextView *questiontext=(CCHLinkTextView *)cell.tvQuestionText;
                
                questiontext.text=hashtagquestion;
                
                CGSize textViewSize = [cell.tvQuestionText sizeThatFits:CGSizeMake(cell.tvQuestionText.frame.size.width, FLT_MAX)];
                
                // [cell.tvQuestionText removeFromSuperview];
                //[cell insertSubview:questiontext atIndex:0];
                cell.clviewquestion.constant=cell.clviewquestion.constant+(textViewSize.height);
                
                cell.lcheightquestiontext.constant=(textViewSize.height);
                
                questiontext.scrollEnabled=true;
                
                
                NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:hashtagquestion];
                
                
                
                
                for(id objectvalue in [[questionInfo valueForKey:@"hashtagarr"]objectAtIndex:0])
                {
                    
                    
                    NSRange range = [hashtagquestion rangeOfString:[NSString stringWithFormat:@"#%@",[objectvalue objectForKey:@"hashtag"]] options:NSCaseInsensitiveSearch];
                    
                    if (range.location != NSNotFound) {
                        
                        [str addAttribute:CCHLinkAttributeName value:[NSString stringWithFormat:@"#%@",[objectvalue objectForKey:@"hashtag"]] range:range];
                        
                    }
                    
                    
                    
                }
                
                
                for(id objectvalue in [[questionInfo valueForKey:@"tagfriends"]objectAtIndex:0])
                {
                    
                    
                    NSRange range = [hashtagquestion rangeOfString:[NSString stringWithFormat:@"@%@",[objectvalue objectForKey:@"username"]] options:NSCaseInsensitiveSearch];
                    
                    if (range.location != NSNotFound) {
                        
                        [str addAttribute:CCHLinkAttributeName value:[NSString stringWithFormat:@"%@",[objectvalue objectForKey:@"id"]] range:range];
                        
                    }
                    
                    
                }
                
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                
                questiontext.attributedText= str;
                questiontext.linkDelegate = self;
                questiontext.selectable=YES;
                questiontext.userInteractionEnabled=YES;
                
                
                questiontext.linkTextAttributes = @{NSForegroundColorAttributeName : [UIColor blueColor]};
                questiontext.linkTextTouchAttributes = @{NSForegroundColorAttributeName : [UIColor orangeColor],
                                                         NSBackgroundColorAttributeName: [UIColor darkGrayColor]};
                
                
                cell.lbactions.userInteractionEnabled = YES;
                
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                                      initWithTarget:self action:@selector(createsubmenuaction:)];
                cell.lbactions.tag=indexPath.row;
                [cell.lbactions addGestureRecognizer:tapGesture];
                
                
                
                
                // cell.btSave
                if (saveVal==0)
                {
                    [cell.btSave setImage:[UIImage imageNamed:@"save_black"] forState:UIControlStateNormal];
                }
                else
                {
                    [cell.btSave setImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
                    
                }
                [cell.btSave addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
                
                //cell.btShare
                [cell.btShare setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
                [cell.btShare addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
                //cell.questionImageView
                NSString *baseUrl=[NSString stringWithFormat:@"%@question_images/thumbs/",webserviceBaseUrl];
                UITapGestureRecognizer *tapGesturenew=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popImageView:)];
                tapGesturenew.numberOfTapsRequired=1;
                tapGesturenew.view.tag=indexPath.row;
                if (![thumbUrlString isEqualToString:baseUrl])
                {
                    if (!(thumbUrlString.length==0))
                    {
                        
                        
                        if ([thumbUrlString rangeOfString:@"http://"].location == NSNotFound)
                        {
                            thumbUrlString = [NSString stringWithFormat:@"http://%@", thumbUrlString];
                        }
                        NSLog(@"%@",thumbUrlString);
                        NSURL *imageUrl=[NSURL URLWithString:thumbUrlString];
                        [cell.questionImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder"]];
                        // [questionImageView setImage:[UIImage imageNamed:@"name_icon"]];
                        
                        
                        
                        
                        [cell.questionImageView addGestureRecognizer:tapGesturenew];
                        
                        [cell.questionImageView setUserInteractionEnabled:YES];
                        
                    }
                }
                else
                {
                    [cell.questionImageView setImage:[UIImage imageNamed:@"placeholder"]];
                }
                
                [cell.questionImageView removeFromSuperview];
                
                [cell.btEdit setHidden:YES];
                [cell.btDelete setHidden:YES];
                //cell.btlike
                
                queslikeBtn=cell.btlike;
                [queslikeBtn addTarget:self action:@selector(questionLikeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btlike setHidden:YES];
                UITapGestureRecognizer *tapGesturenewlike=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(questionLikeBtnActionnew:)];
                
                tapGesturenewlike.numberOfTapsRequired=1;
                tapGesturenewlike.view.tag=indexPath.row;
                [cell.imggood addGestureRecognizer:tapGesturenewlike];
                
                
                [cell.imggood setUserInteractionEnabled:YES];
                
                
                
                UITapGestureRecognizer *tapGesturenewlike1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(questionLikeBtnActionnew:)];
                tapGesturenewlike1.numberOfTapsRequired=1;
                tapGesturenewlike1.view.tag=indexPath.row;
                
                [cell.imgbordergood addGestureRecognizer:tapGesturenewlike1];
                
                
                
                [cell.imgbordergood setUserInteractionEnabled:YES];
                
                
                [cell.btflag addTarget:self action:@selector(questionFlagBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                
                
                likeCountLabel=cell.lbcountgood;
                NSString *likeStr=[[questionInfo valueForKey:@"likecount"]objectAtIndex:0];
                if (![likeStr isEqualToString:@"0"])
                {
                    likeCountLabel.text=likeStr;
                }
                else
                {
                    likeCountLabel.text=@"";
                }
                
                
                
                /* NSString *likeDislikeStatus=[[questionInfo valueForKey:@"like_dislike_status"]objectAtIndex:0];
                 //DislikeStatus 1 for like 0 for dislike and 2 for none
                 
                 //Dislike
                 if ([likeDislikeStatus isEqualToString:@"0"])
                 {
                 [queslikeBtn setImage:[UIImage imageNamed:@"like_active"] forState:UIControlStateNormal];
                 }
                 //Like
                 else if ([likeDislikeStatus isEqualToString:@"1"])
                 {
                 [queslikeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
                 }
                 
                 //None
                 else if ([likeDislikeStatus isEqualToString:@"2"])
                 {
                 [queslikeBtn setImage:[UIImage imageNamed:@"like_active"] forState:UIControlStateNormal];
                 }
                 */
                return cell;
            
            }
            
           
            
            
            
            
     
        }
        else
        {
            
            
            if([self CheckhasimageAnswer:indexPath.row])
            {
                //AnswerTableViewCell table
                NSString *cellIdentifier=@"AnswerTableViewCell";
                AnswerTableViewCell *cell=(AnswerTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                // cell.frame=CGRectMake(5, 100 ,self.viewmenu.frame.size.width-15, 2);
                if (cell==nil)
                {
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"AnswerTableViewCell" owner:self options:nil];
                    cell=[nib objectAtIndex:0];
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                   
                }
                // [cell.userImage
                cell.userImage.tag=indexPath.row;
                cell.userImage.userInteractionEnabled=YES;
                //  cell.userImage.layer.cornerRadius=(cell.userImage.frame.size.width)/2;
                //cell.userImage.clipsToBounds=YES;
                //cell.userImage.layer.borderWidth=1.0f;
                //cell.userImage.layer.borderColor=[UIColor grayColor].CGColor;
                
                
                
                NSString *urlString = [[postData objectAtIndex:indexPath.row] valueForKey:@"thumb"];
                NSString *baseUrl=[NSString stringWithFormat:@"%@question_images/thumbs/",webserviceBaseUrl];
                if (![urlString isEqualToString:baseUrl])
                {
                    if (!(urlString.length==0))
                    {
                        
                        if ([urlString rangeOfString:@"http://"].location == NSNotFound)
                        {
                            urlString = [NSString stringWithFormat:@"http://%@", urlString];
                        }
                        
                        
                        
                        
                        NSURL *imageUrl=[NSURL URLWithString:urlString];
                        // [userImg setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"name_icon"]];
                        [cell.userImage setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"name_icon"]];
                        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popAnswerImageView:)];
                        tapGesture.numberOfTapsRequired=1;
                        [cell.userImage setUserInteractionEnabled:YES];
                        cell.userImage.tag=indexPath.row;
                        [cell.userImage addGestureRecognizer:tapGesture];
                        
                    }
                }
                else
                {
                    [cell.userImage setImage:[UIImage imageNamed:@"name_icon"]];
                }
                
                
                NSRange rangeimagepng = [urlString rangeOfString:@".png" options:NSCaseInsensitiveSearch];
                NSRange rangeimagejpg = [urlString rangeOfString:@".jpg" options:NSCaseInsensitiveSearch];
                //if (range.location != NSNotFound) {
                
                
                    
                    //[cell.questionImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"name_icon"]];
                    [cell.lblAnswerNoImages removeFromSuperview];
                    cell.answerLabel.text=[[postData valueForKey:@"answer"]objectAtIndex:indexPath.row];
                    
                    
                    cell.answerLabel.scrollEnabled=false;
                    
                    cell.answerLabel.userInteractionEnabled = YES;
                    
                    if ( cell.answerLabel.text.length>12)
                    {
                        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popView:)];
                        
                        tapGestureRecognizer.numberOfTapsRequired = 1;
                        cell.answerLabel.tag=indexPath.row;
                        [cell.answerLabel addGestureRecognizer:tapGestureRecognizer];
                    }
              
                cell.answerLabel.editable =false;
                
                CGSize textViewSize = [cell.answerLabel sizeThatFits:CGSizeMake(cell.answerLabel.frame.size.width, FLT_MAX)];
                
                // [cell.tvQuestionText removeFromSuperview];
                //[cell insertSubview:questiontext atIndex:0];
                cell.lcviewquestion.constant=cell.lcviewquestion.constant+(textViewSize.height);
                
                cell.lcquestiontextheight.constant=(textViewSize.height);

                cell.lbactions.userInteractionEnabled = YES;
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                                      initWithTarget:self action:@selector(createsubmenuactionanswer:)];
                cell.lbactions.tag=indexPath.row;
                [cell.lbactions addGestureRecognizer:tapGesture];
                
                cell.imgowner.userInteractionEnabled=YES;
                cell.imgowner.layer.cornerRadius=(cell.imgowner.frame.size.width)/2;
                cell.imgowner.clipsToBounds=YES;
                cell.imgowner.layer.borderWidth=1.0f;
                cell.imgowner.layer.borderColor=[UIColor grayColor].CGColor;
                
                UITapGestureRecognizer *tapGesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popAnswerImageViewProfile:)];
                cell.userImage.tag=indexPath.row;
                [cell.imgowner setUserInteractionEnabled:YES];
                [cell.imgowner addGestureRecognizer:tapGesture1];
                
                
                
                
                NSString *urlStringnew = [[postData objectAtIndex:indexPath.row] valueForKey:@"user_image_thumb"];
                NSString *baseUrlnew=[NSString stringWithFormat:@"%@question_images/thumbs/",webserviceBaseUrl];
                if (![urlStringnew isEqualToString:baseUrlnew])
                {
                    if (!urlStringnew.length==0)
                    {
                        
                        if ([urlStringnew rangeOfString:@"http://"].location == NSNotFound)
                        {
                            urlStringnew = [NSString stringWithFormat:@"http://%@", urlStringnew];
                        }
                        
                        
                        
                        
                        NSURL *imageUrlnew=[NSURL URLWithString:urlStringnew];
                        // [userImg setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"name_icon"]];
                        [cell.imgowner setImageWithURL:imageUrlnew placeholderImage:[UIImage imageNamed:@"name_icon"]];
                        
                        
                    }
                }
                else
                {
                    [cell.imgowner setImage:[UIImage imageNamed:@"name_icon"]];
                }
                
                
                
                
                
                //[cell.contentView addSubview:userImg];
                
                
                
                
                
                
                
                
                
                
                //User Name Button
                
                NSString *username=questionNameStr;
                
                
                NSLog(@"%@",postData);
                
                postStatus=[[postData valueForKey:@"status"]objectAtIndex:indexPath.row];
                //acceptBtn=[[UIButton alloc]init];
                // acceptBtn.frame=CGRectMake(errorBtn.frame.origin.x+30, 10, 25, 25);
                //acceptBtn.frame=CGRectMake(postLabel.frame.size.width+80, 10, 25, 25);
                
                if ([postStatus isEqualToString:@"accepted"])
                {
                    cell.lbaccept.text=@"Accepted";
                    [cell.acceptBtn setImage:[UIImage imageNamed:@"accepted_button"] forState:UIControlStateNormal];
                    //[cell.acceptBtn setBackgroundImage:[UIImage imageNamed:@"right1"] forState:UIControlStateNormal];
                }
                else
                {
                    
                    
                    UITapGestureRecognizer *tapGesturenewaccept=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(acceptClicknew:)];
                    tapGesturenewaccept.numberOfTapsRequired=1;
                    tapGesturenewaccept.view.tag=indexPath.row;
                    [cell.imgborderaccept addGestureRecognizer:tapGesturenewaccept];
                    [cell.lbaccept addGestureRecognizer:tapGesturenewaccept];
                    
                    [cell.imgborderaccept setUserInteractionEnabled:YES];
                    [cell.lbaccept setUserInteractionEnabled:YES];
                    
                    
                    [cell.imgborderaccept setTag:indexPath.row];
                    [cell.lbaccept setTag:indexPath.row];
                    
                    
                    cell.lbaccept.text=@"Accept";
                    
                    
                    [cell.acceptBtn setImage:[UIImage imageNamed:@"accept_button"] forState:UIControlStateNormal];
                    NSString* useridofanswer=[[postData valueForKey:@"userId"]objectAtIndex:indexPath.row];
                    if ([userIdlogin isEqualToString:userIdGeneral] && ![userIdlogin isEqualToString:useridofanswer] ) {
                        cell.imgborderaccept.hidden=NO;
                        cell.lbaccept.hidden=NO;
                    }
                    else
                    {
                        cell.imgborderaccept.hidden=YES;
                        cell.lbaccept.hidden=YES;
                    }
                    //[cell.acceptBtn setBackgroundImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
                }
                [cell.acceptBtn setHidden:YES];
                [cell.acceptBtn addTarget:self action:@selector(acceptClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.acceptBtn.tag=indexPath.row;
                
                
                //delete and edit
                
                
                NSString* useridlogin=[userData valueForKey:@"id"];
                NSString* useridofanswer=[[postData valueForKey:@"userId"]objectAtIndex:indexPath.row];
                
                [cell.btEdit addTarget:self action:@selector(editanswerClick:) forControlEvents:UIControlEventTouchUpInside];
                
                
                if(![useridlogin isEqualToString:useridofanswer]    )
                {
                    [cell.btEdit setHidden:YES];
                    ;
                    // [editBtn setHidden:YES];
                    //[deleteBtn setHidden:YES];
                    
                }
                NSString* useridofquestion=[[questionInfo valueForKey:@"userId"]objectAtIndex:0];
                
                [cell.btDelete addTarget:self action:@selector(deleteanswerClick:) forControlEvents:UIControlEventTouchUpInside];
                
                if(![useridlogin isEqualToString:useridofanswer] && ![useridlogin isEqualToString:useridofquestion]   )
                {
                    [cell.btDelete setHidden:YES];
                    ;
                }
                
                
                
                
                
                
                
                
                
                UIButton *errorBtn=[[UIButton alloc]init];
                errorBtn.frame=CGRectMake(acceptBtn.frame.origin.x+40, 10, 25, 25);
                [errorBtn setBackgroundImage:[UIImage imageNamed:@"error"] forState:UIControlStateNormal];
                [errorBtn addTarget:self action:@selector(errBtn) forControlEvents:UIControlEventTouchUpInside];
                
                
                
                
                
                
                
                ratingBtn=[[UIButton alloc]init];
                // ratingBtn.frame=CGRectMake(postLabel.frame.size.width+70, 10, 25, 25);
                ratingBtn.frame=CGRectMake(errorBtn.frame.origin.x+40, 10, 25, 25);
                
                rateVal=[[[postData valueForKey:@"rating"]objectAtIndex:indexPath.row]intValue];
                
                
                
                if (rateVal==0)
                {
                    [ratingBtn setBackgroundImage:[UIImage imageNamed:@"rating"] forState:UIControlStateNormal];
                    [ratingBtn addTarget:self action:@selector(rateBtn:) forControlEvents:UIControlEventTouchUpInside];
                    
                    
                }
                
                else if (rateVal==1)
                {
                    [ratingBtn setBackgroundImage:[UIImage imageNamed:@"rating1"] forState:UIControlStateNormal];
                }
                
                else if (rateVal==2)
                {
                    [ratingBtn setBackgroundImage:[UIImage imageNamed:@"rating2"] forState:UIControlStateNormal];
                }
                
                else if (rateVal==3)
                {
                    [ratingBtn setBackgroundImage:[UIImage imageNamed:@"rating3"] forState:UIControlStateNormal];
                }
                
                else if (rateVal==4)
                {
                    [ratingBtn setBackgroundImage:[UIImage imageNamed:@"rating4"] forState:UIControlStateNormal];
                }
                
                else if(rateVal==5)
                {
                    [ratingBtn setBackgroundImage:[UIImage imageNamed:@"rating5"] forState:UIControlStateNormal];
                }
                
                
                
                
                
                
                
                
                
                
                ratingBtn.tag=indexPath.row;
                //[cell.contentView addSubview:ratingBtn];
                
                //            UIImageView *answerImage=[[UIImageView alloc]initWithFrame:CGRectMake(cell.answerLabel.frame.origin.x, cell.answerLabel.frame.origin.y+cell.answerLabel.frame.size.height, 50, 30)];
                //            [answerImage setImage:[UIImage imageNamed:@"placeholder"]];
                //            [cell.contentView addSubview:answerImage];
                
                
                
                
                
                NSString *user_name=[[postData valueForKey:@"name"]objectAtIndex:indexPath.row];
                
                [cell.userNameBtn setTitle:user_name forState:UIControlStateNormal];
                [cell.userNameBtn addTarget:self action:@selector(profileView:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.userNameBtn.tag=indexPath.row;
                
                
                profileViewVal=2;
                
                
                
                NSString *timeStampString=[NSString stringWithFormat:@"%@",[[postData objectAtIndex:indexPath.row]valueForKey:@"answer_date"]];
                
                [cell.dateLabel setText:timeStampString];
                NSLog(@"%@",questionInfo);
                NSString *userId;
                userId=[[postData valueForKey:@"userId"]objectAtIndex:indexPath.row];
                if (generalViewValue==0)
                {
                    //            [cell.contentView addSubview:errorBtn];
                    //            [cell.contentView addSubview:acceptBtn];
                    
                }
                else
                {
                    userId=[[questionInfo valueForKey:@"userId"]objectAtIndex:0];
                    //userId=[generalQuestionArray valueForKey:@"userid"];
                    ids=[userData valueForKey:@"id"];
                    if ([userId isEqualToString:ids])
                    {
                        //                [cell.contentView addSubview:errorBtn];
                        //                [cell.contentView addSubview:acceptBtn];
                    }
                    
                }
                
                
                
                
                [cell.dislikeBtn removeFromSuperview];
                [cell.likeBtn setTag:indexPath.row];
                [cell.dislikeBtn setTag:indexPath.row];
                [cell.likeBtn addTarget:self action:@selector(likeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                
                
                UITapGestureRecognizer *tapGesturenewlike=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(likeBtnActionnew:)];
                tapGesturenewlike.numberOfTapsRequired=1;
                tapGesturenewlike.view.tag=indexPath.row;
               
               
                [cell.imgbordergood addGestureRecognizer:tapGesturenewlike];
                
                
               
                [cell.imgbordergood setUserInteractionEnabled:YES];
                
                ////
                UITapGestureRecognizer *tapGesturenewlike1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(likeBtnActionnew:)];
                tapGesturenewlike1.numberOfTapsRequired=1;
                tapGesturenewlike1.view.tag=indexPath.row;
                
                [cell.imggood addGestureRecognizer:tapGesturenewlike1];
                
                
                [cell.imggood setUserInteractionEnabled:YES];
              
                
                ///
                
                [cell.imggood setTag:indexPath.row];
                [cell.imgbordergood setTag:indexPath.row];
                [cell.lbcountlike setTag:indexPath.row];
                
                [cell.dislikeBtn addTarget:self action:@selector(dislikeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.flagBtn addTarget:self action:@selector(flagBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.flagBtn setTag:indexPath.row];
                
                
                CGRect likeBtnFrame=cell.likeBtn.frame;
                
                CGRect dislikeBtnFrame=cell.dislikeBtn.frame;
                
                NSString *likesCount=[[postData valueForKey:@"likecount"]objectAtIndex:indexPath.row];
                
                
                UILabel *likeCountLabel=[[UILabel alloc]init];
                if (![likesCount isEqualToString:@"0"])
                {
                    likeCountLabel.text=likesCount;
                    cell.lbcountlike.text=likesCount;
                }
                else
                {
                    likeCountLabel.text=@"";
                    cell.lbcountlike.text=@"";
                }
                
                [likeCountLabel setFont:[UIFont systemFontOfSize:10.0f]];
                [likeCountLabel setFont:[UIFont boldSystemFontOfSize:10.0f]];
                [likeCountLabel setTextAlignment:NSTextAlignmentCenter];
                [likeCountLabel setTextColor:BUTTONCOLOR];
                likeCountLabel.tag=101;
                [likeCountLabel setHidden:YES];
                CGSize likelabelSize=[likesCount boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NO attributes:@{NSFontAttributeName:likeCountLabel.font} context:nil].size;
                likeCountLabel.frame=CGRectMake(likeBtnFrame.origin.x-(likelabelSize.width-2), likeBtnFrame.origin.y,likelabelSize.width, 10);
                [cell.contentView addSubview:likeCountLabel];
                
                NSString *dislikesCount=[[postData valueForKey:@"dislikes"]objectAtIndex:indexPath.row];
                
                
                UILabel *dislikeCountLabel=[[UILabel alloc]init];
                
                // dislikeCountLabel.tag=101;
                if (![dislikesCount isEqualToString:@"0"])
                {
                    dislikeCountLabel.text=dislikesCount;
                }
                
                
                
                
                [dislikeCountLabel setFont:[UIFont systemFontOfSize:10.0f]];
                [dislikeCountLabel setFont:[UIFont boldSystemFontOfSize:10.0f]];
                [dislikeCountLabel setTextAlignment:NSTextAlignmentCenter];
                [dislikeCountLabel setTextColor:[UIColor lightGrayColor]];
                
                CGSize labelSize=[dislikesCount boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NO attributes:@{NSFontAttributeName:dislikeCountLabel.font} context:nil].size;
                dislikeCountLabel.frame=CGRectMake(dislikeBtnFrame.origin.x-(labelSize.width-2),dislikeBtnFrame.origin.y,labelSize.width, 10);
                [cell.contentView addSubview:dislikeCountLabel];
                
                NSString *likeDislikeStatus=[[postData valueForKey:@"like_dislike_status"]objectAtIndex:indexPath.row];
                //Dislike
                if ([likeDislikeStatus isEqualToString:@"0"])
                {
                    [cell.likeBtn setImage:[UIImage imageNamed:@"like_active"] forState:UIControlStateNormal];
                    [cell.dislikeBtn setImage:[UIImage imageNamed:@"dislike_active"] forState:UIControlStateNormal];
                }
                //Like
                else if ([likeDislikeStatus isEqualToString:@"1"])
                {
                    [cell.likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
                    [cell.dislikeBtn setImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
                }
                
                //None
                else if ([likeDislikeStatus isEqualToString:@"2"])
                {
                    [cell.likeBtn setImage:[UIImage imageNamed:@"like_active"] forState:UIControlStateNormal];
                    [cell.dislikeBtn setImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
                }
                
                return cell;

            }
            else
            {
                //AnswerTableViewCell table
                NSString *cellIdentifier=@"NoImageAnswerTableViewCell";
                NoImageAnswerTableViewCell *cell=(NoImageAnswerTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                // cell.frame=CGRectMake(5, 100 ,self.viewmenu.frame.size.width-15, 2);
                if (cell==nil)
                {
                    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"NoImageAnswerTableViewCell" owner:self options:nil];
                    cell=[nib objectAtIndex:0];
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    
                }
                // [cell.userImage
                cell.userImage.tag=indexPath.row;
                cell.userImage.userInteractionEnabled=YES;
                //  cell.userImage.layer.cornerRadius=(cell.userImage.frame.size.width)/2;
                //cell.userImage.clipsToBounds=YES;
                //cell.userImage.layer.borderWidth=1.0f;
                //cell.userImage.layer.borderColor=[UIColor grayColor].CGColor;
                
                
                
                NSString *urlString = [[postData objectAtIndex:indexPath.row] valueForKey:@"thumb"];
                NSString *baseUrl=[NSString stringWithFormat:@"%@question_images/thumbs/",webserviceBaseUrl];
                if (![urlString isEqualToString:baseUrl])
                {
                    if (!(urlString.length==0))
                    {
                        
                        if ([urlString rangeOfString:@"http://"].location == NSNotFound)
                        {
                            urlString = [NSString stringWithFormat:@"http://%@", urlString];
                        }
                        
                        
                        
                        
                        NSURL *imageUrl=[NSURL URLWithString:urlString];
                        // [userImg setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"name_icon"]];
                        [cell.userImage setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"name_icon"]];
                        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popAnswerImageView:)];
                        tapGesture.numberOfTapsRequired=1;
                        [cell.userImage setUserInteractionEnabled:YES];
                        cell.userImage.tag=indexPath.row;
                        [cell.userImage addGestureRecognizer:tapGesture];
                        
                    }
                }
                else
                {
                    [cell.userImage setImage:[UIImage imageNamed:@"name_icon"]];
                }
                [cell.userImage setHidden:YES];
                
                cell.answerLabel.text=[[postData valueForKey:@"answer"]objectAtIndex:indexPath.row];
                
                cell.answerLabel.editable =false;
                cell.answerLabel.scrollEnabled=false;
                cell.lbactions.userInteractionEnabled = YES;
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                                      initWithTarget:self action:@selector(createsubmenuactionanswer:)];
                cell.lbactions.tag=indexPath.row;
                [cell.lbactions addGestureRecognizer:tapGesture];
                
                cell.imgowner.userInteractionEnabled=YES;
                cell.imgowner.layer.cornerRadius=(cell.imgowner.frame.size.width)/2;
                cell.imgowner.clipsToBounds=YES;
                cell.imgowner.layer.borderWidth=1.0f;
                cell.imgowner.layer.borderColor=[UIColor grayColor].CGColor;
                
                UITapGestureRecognizer *tapGesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popAnswerImageViewProfile:)];
                cell.userImage.tag=indexPath.row;
                [cell.imgowner setUserInteractionEnabled:YES];
                [cell.imgowner addGestureRecognizer:tapGesture1];
                
                
                
                
                NSString *urlStringnew = [[postData objectAtIndex:indexPath.row] valueForKey:@"user_image_thumb"];
                NSString *baseUrlnew=[NSString stringWithFormat:@"%@question_images/thumbs/",webserviceBaseUrl];
                if (![urlStringnew isEqualToString:baseUrlnew])
                {
                    if (!urlStringnew.length==0)
                    {
                        
                        if ([urlStringnew rangeOfString:@"http://"].location == NSNotFound)
                        {
                            urlStringnew = [NSString stringWithFormat:@"http://%@", urlStringnew];
                        }
                        
                        
                        
                        
                        NSURL *imageUrlnew=[NSURL URLWithString:urlStringnew];
                        // [userImg setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"name_icon"]];
                        [cell.imgowner setImageWithURL:imageUrlnew placeholderImage:[UIImage imageNamed:@"name_icon"]];
                        
                        
                    }
                }
                else
                {
                    [cell.imgowner setImage:[UIImage imageNamed:@"name_icon"]];
                }
                
                
                CGSize textViewSize = [cell.answerLabel sizeThatFits:CGSizeMake(cell.answerLabel.frame.size.width, FLT_MAX)];
                
                // [cell.tvQuestionText removeFromSuperview];
                //[cell insertSubview:questiontext atIndex:0];
                cell.lcviewquestion.constant=cell.lcviewquestion.constant+(textViewSize.height);
                
                cell.lcquestiontextheight.constant=(textViewSize.height);

                
                
                //[cell.contentView addSubview:userImg];
                
                
                
                
                
                
                
                
                
                
                //User Name Button
                
                NSString *username=questionNameStr;
                
                
                NSLog(@"%@",postData);
                
                postStatus=[[postData valueForKey:@"status"]objectAtIndex:indexPath.row];
                //acceptBtn=[[UIButton alloc]init];
                // acceptBtn.frame=CGRectMake(errorBtn.frame.origin.x+30, 10, 25, 25);
                //acceptBtn.frame=CGRectMake(postLabel.frame.size.width+80, 10, 25, 25);
                
                if ([postStatus isEqualToString:@"accepted"])
                {
                    cell.lbaccept.text=@"Accepted";
                    [cell.acceptBtn setImage:[UIImage imageNamed:@"accepted_button"] forState:UIControlStateNormal];
                    //[cell.acceptBtn setBackgroundImage:[UIImage imageNamed:@"right1"] forState:UIControlStateNormal];
                }
                else
                {
                    
                    
                    UITapGestureRecognizer *tapGesturenewaccept=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(acceptClicknew:)];
                    tapGesturenewaccept.numberOfTapsRequired=1;
                    tapGesturenewaccept.view.tag=indexPath.row;
                    [cell.imgborderaccept addGestureRecognizer:tapGesturenewaccept];
                    [cell.lbaccept addGestureRecognizer:tapGesturenewaccept];
                    
                    [cell.imgborderaccept setUserInteractionEnabled:YES];
                    [cell.lbaccept setUserInteractionEnabled:YES];
                    
                    
                    [cell.imgborderaccept setTag:indexPath.row];
                    [cell.lbaccept setTag:indexPath.row];
                    
                    
                    cell.lbaccept.text=@"Accept";
                    
                    
                    [cell.acceptBtn setImage:[UIImage imageNamed:@"accept_button"] forState:UIControlStateNormal];
                    NSString* useridofanswer=[[postData valueForKey:@"userId"]objectAtIndex:indexPath.row];
                    if ([userIdlogin isEqualToString:userIdGeneral] && ![userIdlogin isEqualToString:useridofanswer] ) {
                        cell.imgborderaccept.hidden=NO;
                        cell.lbaccept.hidden=NO;
                    }
                    else
                    {
                        cell.imgborderaccept.hidden=YES;
                        cell.lbaccept.hidden=YES;
                    }
                    //[cell.acceptBtn setBackgroundImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
                }
                [cell.acceptBtn setHidden:YES];
                [cell.acceptBtn addTarget:self action:@selector(acceptClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.acceptBtn.tag=indexPath.row;
                
                
                //delete and edit
                
                
                NSString* useridlogin=[userData valueForKey:@"id"];
                NSString* useridofanswer=[[postData valueForKey:@"userId"]objectAtIndex:indexPath.row];
                
                [cell.btEdit addTarget:self action:@selector(editanswerClick:) forControlEvents:UIControlEventTouchUpInside];
                
                
                if(![useridlogin isEqualToString:useridofanswer]    )
                {
                    [cell.btEdit setHidden:YES];
                    ;
                    // [editBtn setHidden:YES];
                    //[deleteBtn setHidden:YES];
                    
                }
                NSString* useridofquestion=[[questionInfo valueForKey:@"userId"]objectAtIndex:0];
                
                [cell.btDelete addTarget:self action:@selector(deleteanswerClick:) forControlEvents:UIControlEventTouchUpInside];
                
                if(![useridlogin isEqualToString:useridofanswer] && ![useridlogin isEqualToString:useridofquestion]   )
                {
                    [cell.btDelete setHidden:YES];
                    ;
                }
                
                
                
                
                
                
                
                
                
                UIButton *errorBtn=[[UIButton alloc]init];
                errorBtn.frame=CGRectMake(acceptBtn.frame.origin.x+40, 10, 25, 25);
                [errorBtn setBackgroundImage:[UIImage imageNamed:@"error"] forState:UIControlStateNormal];
                [errorBtn addTarget:self action:@selector(errBtn) forControlEvents:UIControlEventTouchUpInside];
                
                
                
                
                
                
                
                ratingBtn=[[UIButton alloc]init];
                // ratingBtn.frame=CGRectMake(postLabel.frame.size.width+70, 10, 25, 25);
                ratingBtn.frame=CGRectMake(errorBtn.frame.origin.x+40, 10, 25, 25);
                
                rateVal=[[[postData valueForKey:@"rating"]objectAtIndex:indexPath.row]intValue];
                
                
                
                if (rateVal==0)
                {
                    [ratingBtn setBackgroundImage:[UIImage imageNamed:@"rating"] forState:UIControlStateNormal];
                    [ratingBtn addTarget:self action:@selector(rateBtn:) forControlEvents:UIControlEventTouchUpInside];
                    
                    
                }
                
                else if (rateVal==1)
                {
                    [ratingBtn setBackgroundImage:[UIImage imageNamed:@"rating1"] forState:UIControlStateNormal];
                }
                
                else if (rateVal==2)
                {
                    [ratingBtn setBackgroundImage:[UIImage imageNamed:@"rating2"] forState:UIControlStateNormal];
                }
                
                else if (rateVal==3)
                {
                    [ratingBtn setBackgroundImage:[UIImage imageNamed:@"rating3"] forState:UIControlStateNormal];
                }
                
                else if (rateVal==4)
                {
                    [ratingBtn setBackgroundImage:[UIImage imageNamed:@"rating4"] forState:UIControlStateNormal];
                }
                
                else if(rateVal==5)
                {
                    [ratingBtn setBackgroundImage:[UIImage imageNamed:@"rating5"] forState:UIControlStateNormal];
                }
                
                
                
                
                
                
                
                
                
                
                ratingBtn.tag=indexPath.row;
                //[cell.contentView addSubview:ratingBtn];
                
                //            UIImageView *answerImage=[[UIImageView alloc]initWithFrame:CGRectMake(cell.answerLabel.frame.origin.x, cell.answerLabel.frame.origin.y+cell.answerLabel.frame.size.height, 50, 30)];
                //            [answerImage setImage:[UIImage imageNamed:@"placeholder"]];
                //            [cell.contentView addSubview:answerImage];
                
                
                
                
                
                NSString *user_name=[[postData valueForKey:@"name"]objectAtIndex:indexPath.row];
                
                [cell.userNameBtn setTitle:user_name forState:UIControlStateNormal];
                [cell.userNameBtn addTarget:self action:@selector(profileView:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.userNameBtn.tag=indexPath.row;
                
                
                profileViewVal=2;
                
                
                
                NSString *timeStampString=[NSString stringWithFormat:@"%@",[[postData objectAtIndex:indexPath.row]valueForKey:@"answer_date"]];
                
                [cell.dateLabel setText:timeStampString];
                NSLog(@"%@",questionInfo);
                NSString *userId;
                userId=[[postData valueForKey:@"userId"]objectAtIndex:indexPath.row];
                if (generalViewValue==0)
                {
                    //            [cell.contentView addSubview:errorBtn];
                    //            [cell.contentView addSubview:acceptBtn];
                    
                }
                else
                {
                    userId=[[questionInfo valueForKey:@"userId"]objectAtIndex:0];
                    //userId=[generalQuestionArray valueForKey:@"userid"];
                    ids=[userData valueForKey:@"id"];
                    if ([userId isEqualToString:ids])
                    {
                        //                [cell.contentView addSubview:errorBtn];
                        //                [cell.contentView addSubview:acceptBtn];
                    }
                    
                }
                
                
                
                
                [cell.dislikeBtn removeFromSuperview];
                [cell.likeBtn setTag:indexPath.row];
                [cell.dislikeBtn setTag:indexPath.row];
                [cell.likeBtn addTarget:self action:@selector(likeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                
                
                UITapGestureRecognizer *tapGesturenewlike=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(likeBtnActionnew:)];
                tapGesturenewlike.numberOfTapsRequired=1;
                tapGesturenewlike.view.tag=indexPath.row;
                [cell.imggood addGestureRecognizer:tapGesturenewlike];
                [cell.imgbordergood addGestureRecognizer:tapGesturenewlike];
                [cell.lbcountlike addGestureRecognizer:tapGesturenewlike];
                
                [cell.imggood setUserInteractionEnabled:YES];
                [cell.lbcountlike setUserInteractionEnabled:YES];
                [cell.imgbordergood setUserInteractionEnabled:YES];
                
                [cell.imggood setTag:indexPath.row];
                [cell.imgbordergood setTag:indexPath.row];
                [cell.lbcountlike setTag:indexPath.row];
                
                
                [cell.dislikeBtn addTarget:self action:@selector(dislikeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.flagBtn addTarget:self action:@selector(flagBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.flagBtn setTag:indexPath.row];
                
                
                CGRect likeBtnFrame=cell.likeBtn.frame;
                
                CGRect dislikeBtnFrame=cell.dislikeBtn.frame;
                
                NSString *likesCount=[[postData valueForKey:@"likecount"]objectAtIndex:indexPath.row];
                
                
                UILabel *likeCountLabel=[[UILabel alloc]init];
                if (![likesCount isEqualToString:@"0"])
                {
                    likeCountLabel.text=likesCount;
                    cell.lbcountlike.text=likesCount;
                }
                else
                {
                    likeCountLabel.text=@"";
                    cell.lbcountlike.text=@"";
                }
                
                [likeCountLabel setFont:[UIFont systemFontOfSize:10.0f]];
                [likeCountLabel setFont:[UIFont boldSystemFontOfSize:10.0f]];
                [likeCountLabel setTextAlignment:NSTextAlignmentCenter];
                [likeCountLabel setTextColor:BUTTONCOLOR];
                likeCountLabel.tag=101;
                [likeCountLabel setHidden:YES];
                CGSize likelabelSize=[likesCount boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NO attributes:@{NSFontAttributeName:likeCountLabel.font} context:nil].size;
                likeCountLabel.frame=CGRectMake(likeBtnFrame.origin.x-(likelabelSize.width-2), likeBtnFrame.origin.y,likelabelSize.width, 10);
                [cell.contentView addSubview:likeCountLabel];
                
                NSString *dislikesCount=[[postData valueForKey:@"dislikes"]objectAtIndex:indexPath.row];
                
                
                UILabel *dislikeCountLabel=[[UILabel alloc]init];
                
                // dislikeCountLabel.tag=101;
                if (![dislikesCount isEqualToString:@"0"])
                {
                    dislikeCountLabel.text=dislikesCount;
                }
                
                
                
                
                [dislikeCountLabel setFont:[UIFont systemFontOfSize:10.0f]];
                [dislikeCountLabel setFont:[UIFont boldSystemFontOfSize:10.0f]];
                [dislikeCountLabel setTextAlignment:NSTextAlignmentCenter];
                [dislikeCountLabel setTextColor:[UIColor lightGrayColor]];
                
                CGSize labelSize=[dislikesCount boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NO attributes:@{NSFontAttributeName:dislikeCountLabel.font} context:nil].size;
                dislikeCountLabel.frame=CGRectMake(dislikeBtnFrame.origin.x-(labelSize.width-2),dislikeBtnFrame.origin.y,labelSize.width, 10);
                [cell.contentView addSubview:dislikeCountLabel];
                
                NSString *likeDislikeStatus=[[postData valueForKey:@"like_dislike_status"]objectAtIndex:indexPath.row];
                //Dislike
                if ([likeDislikeStatus isEqualToString:@"0"])
                {
                    [cell.likeBtn setImage:[UIImage imageNamed:@"like_active"] forState:UIControlStateNormal];
                    [cell.dislikeBtn setImage:[UIImage imageNamed:@"dislike_active"] forState:UIControlStateNormal];
                }
                //Like
                else if ([likeDislikeStatus isEqualToString:@"1"])
                {
                    [cell.likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
                    [cell.dislikeBtn setImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
                }
                
                //None
                else if ([likeDislikeStatus isEqualToString:@"2"])
                {
                    [cell.likeBtn setImage:[UIImage imageNamed:@"like_active"] forState:UIControlStateNormal];
                    [cell.dislikeBtn setImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
                }
                
                return cell;

            }
            
            
            
       }
        
    }

}
-(CGSize)constraintSize:(NSString*)textString
{
    CGSize constraintSize = {190.0f, MAXFLOAT};
    CGSize neededSize = [textString sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14.0f] constrainedToSize:constraintSize  lineBreakMode:NSLineBreakByWordWrapping];
    return neededSize;
}


-(void)profileView:(id) sender
{
    NSInteger i=[sender tag];
    NSString   *userId=[postData valueForKey:@"userId"][i];
   // NSString *inStr = [NSString stringWithFormat:@"%d", i];
  // [[AppDelegate sharedDelegate].TabBarView gotoFriendProfileScreenWithFriendID:inStr];
    AddFriendViewController *addFriend=[[AddFriendViewController alloc]init];
    addFriend.friendUserId=userId;
    [self.navigationController pushViewController:addFriend animated:NO];
   /* NSString *friendId=[[postData valueForKey:@"userId"]objectAtIndex:i];
    NSString *loginId=[[[AppDelegate sharedDelegate]userDetail]valueForKey:@"id"];
    
    if ([friendId isEqualToString:loginId])
    {
        UserDetailViewController *userDetail=[[UserDetailViewController alloc]init];
        userDetail.messageValue=50;
        [self.navigationController pushViewController:userDetail animated:NO];
    }
    else
    {
        //Care
    
        HomeViewController *homeView=[[HomeViewController alloc]init];
        homeView.friendID=userIdGeneral;
        [self.navigationController pushViewController:homeView animated:NO];
    
        
//        AddFriendViewController *addFriend=[[AddFriendViewController alloc]init];
//        addFriend.friendUserId=friendId;
//        [self.navigationController pushViewController:addFriend animated:NO];
        
        [[AppDelegate sharedDelegate].TabBarView gotoFriendProfileScreenWithFriendID:friendId]; 
    */
        
    }



-(void)profileViewQuestion:(id)sender
{
    
     // UserDetailViewController *userProfile=[[UserDetailViewController alloc]init];
    NSInteger i=[sender tag];
    
     //NSString   *userId=userIdGeneral;
        //userId=[[filteredResults valueForKey:@"userid"]objectAtIndex:i];
   
    //NSString *userId=[[filteredResults valueForKey:@"userid"]objectAtIndex:recognizer.view.tag];
    //userProfile.messageValue=2;
    //userProfile.user_id=userId;
    //[self.navigationController pushViewController:userProfile animated:NO];
    AddFriendViewController *addFriend=[[AddFriendViewController alloc]init];
    addFriend.friendUserId=userIdGeneral;
    [self.navigationController pushViewController:addFriend animated:NO];

    
    
       
    
    

    
    
    
}


-(CGSize) resizePostView:(NSString*)questionText textFont:(UIFont*)font
{
    return [questionText sizeWithFont:font constrainedToSize:CGSizeMake(300, 1000000) lineBreakMode:NSLineBreakByWordWrapping];
    
     //CGSize stringSize=[questionTextView siz]
    //return theStringSize;
}



-(UIImage *)imageManager:(SDWebImageManager *)imageManager transformDownloadedImage:(UIImage *)image withURL:(NSURL *)imageURL
{
    [nameImg setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"name_icon"] options:SDWebImageCacheMemoryOnly];
    return image;
    
   
}





-(bool)CheckhasimageAnswer:(NSInteger)rowindex {
    
    
    //Answer Image
    NSString *urlString =[[postData objectAtIndex:rowindex] valueForKey:@"thumb"];;
    if ([urlString rangeOfString:@"http://"].location == NSNotFound)
    {
        urlString = [NSString stringWithFormat:@"http://%@", urlString];
    }
    else
    {
        urlString=@"";
        
    }
    
    NSRange rangeimagepng = [urlString rangeOfString:@".png" options:NSCaseInsensitiveSearch];
    NSRange rangeimagejpg = [urlString rangeOfString:@".jpg" options:NSCaseInsensitiveSearch];
    
    if(rangeimagepng.location != NSNotFound || rangeimagejpg.location != NSNotFound)
    {
        return true;
    }
    else
        return false;
}


-(bool)Checkhasimagequestion {
   
    
    //QuestionImage
    NSString *urlString = [[questionInfo valueForKey:@"thumb"]objectAtIndex:0];
    if ([urlString rangeOfString:@"http://"].location == NSNotFound)
    {
        urlString = [NSString stringWithFormat:@"http://%@", urlString];
    }
    else
    {
        urlString=@"";
        
    }
    
    NSRange rangeimagepng = [urlString rangeOfString:@".png" options:NSCaseInsensitiveSearch];
    NSRange rangeimagejpg = [urlString rangeOfString:@".jpg" options:NSCaseInsensitiveSearch];
    
    if(rangeimagepng.location != NSNotFound || rangeimagejpg.location != NSNotFound)
    {
        return true;
    }
    else
        return false;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [textView resignFirstResponder];
    
   
   
   
    
//    if (tableView!=answersTableView)
//    {
//    //[self performSelectorInBackground:@selector(fetchData) withObject:nil];
//    }
  
    if (!isKeyboardUp)
    {
        
    
    if (tableView==questionTableView)
    {
        
        NSArray *filteredData=[filteredResults objectAtIndex:indexPath.row];
       // filteredResults=[filteredResults objectAtIndex:indexPath.row];
        
        questionID=[filteredData valueForKey:@"questionId"];
        postText= [filteredData valueForKey:@"question"];
        favouriteID=[filteredData valueForKey:@"favourite"];
        saveVal=[[filteredData valueForKey:@"questionSaved"]intValue];
        questionImageStr=[filteredData valueForKey:@"attachment"];
        thumbUrlString=[filteredData valueForKey:@"thumb"];
        questionNameStr=[questionArrayInfo valueForKey:@"name"];
        questionDateStr=[filteredData valueForKey:@"question_date"];
        titleString=@"POSTED QUESTIONS";
        [self postedAnswersSubview];
    }
    }
    
    
    //Filtered table View
    if (tableView==categoryTblView)
    {
        
        searchTextField.text=[categoryTblArray objectAtIndex:indexPath.row];
        if (indexPath.row==0)
        {
            
            filteredResults=[NSMutableArray arrayWithArray:questionArray];
            
            NSPredicate *predicate;
            if ([searchTextStr isEqualToString:@""])
            {
                
            }
            else
            {
                predicate=[NSPredicate predicateWithFormat:@"SELF.question contains [c]%@",searchTextStr];
                filteredResults=[NSMutableArray arrayWithArray:[filteredResults filteredArrayUsingPredicate:predicate]];
            }
            [ViewAllBtn setTitle:[NSString stringWithFormat:@"Filter:%@",[categoryTblArray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
            [postedFriends setTitle:[NSString stringWithFormat:@"Posted Questions[%lu]",(unsigned long)[filteredResults count]] forState:UIControlStateNormal];
            
            
            
        }
        else
        {
            NSString *str=[NSString stringWithFormat:@"%ld",(indexPath.row-1)];
            NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF.categoryId contains[c] %@",str]; // Creating filter
            filteredResults=[NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:filterPredicate]];
            
            NSPredicate *predicate;
            if ([searchTextStr isEqualToString:@""])
            {
                
            }
            else
            {
                predicate=[NSPredicate predicateWithFormat:@"SELF.question contains [c]%@",searchTextStr];
                filteredResults=[NSMutableArray arrayWithArray:[filteredResults filteredArrayUsingPredicate:predicate]];
            }
            
            
            [ViewAllBtn setTitle:[NSString stringWithFormat:@"%@",[categoryTblArray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
            [postedFriends setTitle:[NSString stringWithFormat:@"Posted Questions[%lu]",(unsigned long)[filteredResults count]] forState:UIControlStateNormal];
            
            
            
        }
        [self tableViewScrollToTop];
        [questionTableView reloadData];
        [categoryTblView removeFromSuperview];
        [viewPicker removeFromSuperview];

    }
    else
    {
        [searchBar resignFirstResponder];
        [viewPicker resignFirstResponder];
        [categoryTblView removeFromSuperview];
    }
    
    [categoryTblView removeFromSuperview];
    [searchTextField resignFirstResponder];
}






-(void) acceptquestionViewdisappearAction
{
   [self.navigationController popViewControllerAnimated:YES];
    searchValue=0;
    [self resignFirstResponder];
    [textView resignFirstResponder];
    
    //[self fetchData];
    
 

   
  
}





-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==answersTableView)
    {
        if (indexPath.section==0)
        {
            
            NSString *hashtagquestion =[[questionInfo valueForKey:@"question"]objectAtIndex:0];
            for(id objectvalue in [[questionArray valueForKey:@"hashtagarr"]objectAtIndex:indexPath.row])
            {
                NSString *hashtag=[objectvalue objectForKey:@"hashtag"];
                if([hashtag isEqualToString:@""] || [hashtag isEqualToString:@"(null)"])
                    continue;
                
                hashtagquestion =[NSString stringWithFormat:@"%@ #%@",hashtagquestion,[objectvalue objectForKey:@"hashtag"]];
                
                
            }
            
            
            for(id objectvalue in [[questionArray valueForKey:@"tagfriends"]objectAtIndex:indexPath.row])
            {
                
                hashtagquestion =[NSString stringWithFormat:@"%@ @%@",hashtagquestion,[objectvalue objectForKey:@"username"]];
                
            }
            UITextView *questiontext=[[UITextView alloc] initWithFrame:CGRectMake(0, 0, 300, 20 )];
            questiontext.text=hashtagquestion;
            CGSize textViewSize = [questiontext sizeThatFits:CGSizeMake(questiontext.frame.size.width, FLT_MAX)];

            if([self Checkhasimagequestion])
            {
                return 330.0f +textViewSize.height;
            }
            
            else
                return 80.0f +textViewSize.height;
        }
        else
        {
            
            UITextView *answertext=[[UITextView alloc] initWithFrame:CGRectMake(0, 0, 300, 20 )];
            answertext.text=[[postData valueForKey:@"answer"]objectAtIndex:indexPath.row];
            CGSize textViewSize = [answertext sizeThatFits:CGSizeMake(answertext.frame.size.width, FLT_MAX)];

            
            if(indexPath.row==[[postData valueForKey:@"answer"]count]-1)
            {
              if([self CheckhasimageAnswer:indexPath.row])
                  return 330.0f +textViewSize.height+120;
                
               else
                    return 80.0f +textViewSize.height+120;
            }
            else
            {
                if([self CheckhasimageAnswer:indexPath.row])
                     return 330.0f +textViewSize.height;
                else
                    return 80.0f +textViewSize.height;
            }
        }
      
    }
    else if (tableView==categoryTblView)
    {
        return 30.0f;
    }
    else
    {
    return 80.0f;
    }
    
}
//image size

-(UIImage*)fixrotation:(UIImage *)image{
    
    
    if (image.imageOrientation == UIImageOrientationUp) return image;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;}


-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage *) resizeimage :(UIImage *)originalImage
{
    
    CGSize newSize;
    UIGraphicsBeginImageContext(newSize);
    newSize.width=originalImage.size.width;
    newSize.height=originalImage.size.height;
    
    if (originalImage.size.width > 1920)
    {
        newSize.width = 1920;
        newSize.height = (1920 * originalImage.size.height) / originalImage.size.width;
        
    }
    
    if (originalImage.size.height > 1080)
    {
        
        newSize.width = (1080 * originalImage.size.width) / originalImage.size.height;
        newSize.height = 1080;
        
        
    }
    
    
    
    return [self imageWithImage :originalImage scaledToSize:newSize] ;
    
    
}





-(void)createsubmenuaction:(UITapGestureRecognizer *)sender
{
    
    UILabel *lablelsubmenu=(UILabel*)sender.view;
    
    if ([lablelsubmenu.superview viewWithTag:2] !=nil) {
        [[lablelsubmenu.superview viewWithTag:2] removeFromSuperview];
        return;
    }
    
    menuactionSubview=[[UIScrollView alloc]initWithFrame:CGRectMake(lablelsubmenu.frame.origin.x-60, lablelsubmenu.frame.origin.y+20, 80,80)];
    
    menuactionSubview.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(createsubmenuaction:)];
    [menuactionSubview addGestureRecognizer:tapGesture];
    
    
    
    [menuactionSubview setBackgroundColor:[UIColor whiteColor]];
    [menuactionSubview setBackgroundColor:[UIColor whiteColor]];
    menuactionSubview.layer.borderColor=[UIColor grayColor].CGColor;
    menuactionSubview.layer.borderWidth=2.0f;
    menuactionSubview.layer.cornerRadius=4.0f;
    
    UILabel *flagImageView=[[UILabel alloc]initWithFrame:CGRectMake(5,10, 100, 20)];
    flagImageView.text=@"Flag";
    UITapGestureRecognizer *tapGesture2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reportadmin:)];
    flagImageView.tag=lablelsubmenu.tag;
    [flagImageView setUserInteractionEnabled:YES];
    [flagImageView addGestureRecognizer:tapGesture2];
    
    UILabel *editImageView=[[UILabel alloc]initWithFrame:CGRectMake(5,30, 100, 20)];
    editImageView.text=@"Edit";
    UITapGestureRecognizer *tapGesture3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editquestionBtnAction:)];
    editImageView.tag=lablelsubmenu.tag;
    [editImageView setUserInteractionEnabled:YES];
    [editImageView addGestureRecognizer:tapGesture3];
    
    
    UILabel *deleteImageView=[[UILabel alloc]initWithFrame:CGRectMake(5,50, 120, 20)];
    deleteImageView.text=@"Delete";
    UITapGestureRecognizer *tapGesture4=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deletequestionBtnAction:)];
    deleteImageView.tag=lablelsubmenu.tag;
    [deleteImageView setUserInteractionEnabled:YES];
    [deleteImageView addGestureRecognizer:tapGesture4];
    
    
    NSString* useridlogin=[userData valueForKey:@"id"];
    NSString* useridofquestion=[[questionInfo valueForKey:@"userId"]objectAtIndex:0];
    
    if(![useridlogin isEqualToString:useridofquestion] )
    {
        
        [editImageView setHidden:YES];
        [deleteImageView setHidden:YES];
        
    }

    
    menuactionSubview.tag=2;
    
    [menuactionSubview addSubview:flagImageView];
     [menuactionSubview addSubview:deleteImageView];
     [menuactionSubview addSubview:editImageView];
    
    
    [lablelsubmenu.superview addSubview:menuactionSubview];
    
}

-(void)createsubmenuactionanswer:(UITapGestureRecognizer *)sender
{
    
    UILabel *lablelsubmenu=(UILabel*)sender.view;
    
    if ([lablelsubmenu.superview viewWithTag:1000] !=nil) {
        [[lablelsubmenu.superview viewWithTag:1000] removeFromSuperview];
        return;
    }
    
    menuactionSubviewAnswer=[[UIScrollView alloc]initWithFrame:CGRectMake(lablelsubmenu.frame.origin.x-60, lablelsubmenu.frame.origin.y+30, 80,80)];
    
    menuactionSubviewAnswer.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(createsubmenuactionanswer:)];
    [menuactionSubviewAnswer addGestureRecognizer:tapGesture];
    
    
    
    [menuactionSubviewAnswer setBackgroundColor:[UIColor whiteColor]];
    [menuactionSubviewAnswer setBackgroundColor:[UIColor whiteColor]];
    menuactionSubviewAnswer.layer.borderColor=[UIColor grayColor].CGColor;
    menuactionSubviewAnswer.layer.borderWidth=2.0f;
    menuactionSubviewAnswer.layer.cornerRadius=4.0f;
    
    UILabel *flagImageView=[[UILabel alloc]initWithFrame:CGRectMake(5,10, 100, 20)];
    flagImageView.text=@"Flag";
    UITapGestureRecognizer *tapGesture2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(flagBtnActionnew:)];
    flagImageView.tag=lablelsubmenu.tag;
    [flagImageView setUserInteractionEnabled:YES];
    [flagImageView addGestureRecognizer:tapGesture2];
    
    UILabel *editImageView=[[UILabel alloc]initWithFrame:CGRectMake(5,30, 100, 20)];
    editImageView.text=@"Edit";
    UITapGestureRecognizer *tapGesture3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(editanswerClicknew:)];
    editImageView.tag=lablelsubmenu.tag;
    [editImageView setUserInteractionEnabled:YES];
    [editImageView addGestureRecognizer:tapGesture3];
    
    
    UILabel *deleteImageView=[[UILabel alloc]initWithFrame:CGRectMake(5,50, 120, 20)];
    deleteImageView.text=@"Delete";
    UITapGestureRecognizer *tapGesture4=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteanswerClicknew:)];
    deleteImageView.tag=lablelsubmenu.tag;
    [deleteImageView setUserInteractionEnabled:YES];
    [deleteImageView addGestureRecognizer:tapGesture4];
    
    
    NSString* useridlogin=[userData valueForKey:@"id"];
    NSString* useridofanswer=[[postData valueForKey:@"userId"]objectAtIndex:lablelsubmenu.tag];

    
    if(![useridlogin isEqualToString:useridofanswer]    )
    {
        [editImageView setHidden:YES];
       
    }
    NSString* useridofquestion=[[questionInfo valueForKey:@"userId"]objectAtIndex:0];

    if(![useridlogin isEqualToString:useridofanswer] && ![useridlogin isEqualToString:useridofquestion]   )
    {
         [deleteImageView  setHidden:YES];
        
    }
    
    menuactionSubviewAnswer.tag=1000;
    
    [menuactionSubviewAnswer addSubview:flagImageView];
    [menuactionSubviewAnswer addSubview:deleteImageView];
    [menuactionSubviewAnswer addSubview:editImageView];
    
    
    [lablelsubmenu.superview addSubview:menuactionSubviewAnswer];
    
}

-(void) textSize:(NSString*)textString
{
    
}





#pragma mark list View Methods


-(void)ascendingQuesClick
{
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"question_date" ascending:YES];
    filteredResults = [[questionArray sortedArrayUsingDescriptors:@[descriptor]] mutableCopy];
    [questionTableView reloadData];
}

-(void)descendingQuesClick
{
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"question_date" ascending:NO];
    filteredResults = [[questionArray sortedArrayUsingDescriptors:@[descriptor]] mutableCopy];
    [questionTableView reloadData];
}

-(void) popView:(UITapGestureRecognizer*) recognizer
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    CGRect rect=screenRect;
    rect.origin.y=44;
    screenRect=rect;
    
    transparentView=[[UIView alloc]initWithFrame:self.viewmenu.bounds];
    transparentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    transparentView.userInteractionEnabled=YES;
    [self.viewmenu addSubview:transparentView];
    
    // add this new view to your main view
    
    popUptxt=[[UITextView alloc]init];
    popUptxt.frame=CGRectMake((self.viewmenu.frame.size.width-280)/2, (self.viewmenu.frame.size.height-150)/2, 280, 150);
    
    [popUptxt setBackgroundColor:[UIColor whiteColor]];
    [popUptxt setTextColor:[UIColor blackColor]];
    [popUptxt setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
    [popUptxt setTextAlignment:NSTextAlignmentCenter];
    popUptxt.layer.borderWidth=1.0f;
    popUptxt.layer.cornerRadius=10.0;
    popUptxt.layer.borderColor=[UIColor blackColor].CGColor;
    popUptxt.text=[postData valueForKey:@"answer"][recognizer.view.tag];
    popUptxt.userInteractionEnabled=YES;
    popUptxt.editable=NO;
    popUptxt.scrollEnabled=YES;
    
    
    [self.viewmenu addSubview:popUptxt];
    
    
    [[popUptxt layer] addAnimation:[AppDelegate popupAnimation] forKey:@"popupAnimation"];
    
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]init];
 
    tapGesture.numberOfTapsRequired=1;
    [tapGesture addTarget:self action:@selector(removeView)];
    [self.viewmenu addGestureRecognizer:tapGesture];
    
}


-(void) backBtn
{
    if(generalViewValue==9)
    {
        TopicViewController *topicView=[[TopicViewController alloc]init];
        [self.navigationController pushViewController:topicView animated:NO];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
   // [self.navigationController popToRootViewControllerAnimated:YES];
    
}


-(void) shareClick
{
    [textView resignFirstResponder];
    [searchBar resignFirstResponder];
    
    shareActionSheet=[[UIActionSheet alloc]initWithTitle:@"ActionSheet" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Facebook" otherButtonTitles:@"Twitter", nil];
    //[shareActionSheet showInView:self.viewmenu];
    [shareActionSheet showInView:[UIApplication sharedApplication].keyWindow];
    
   
    

}


-(void) saveClick
{
    [textView resignFirstResponder];
    [searchBar resignFirstResponder];
    if (saveVal==0)
    {
        saveAlert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Do you want to save this question?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [saveAlert show];
    }
    else
    {
        deleteSaveAlert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Do you want to delete this question from saved questions?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [deleteSaveAlert show];
    }
  
}

-(void) questionViewdisappearAction
{
   
    if (backBtnValue==0)
    {
        [self.navigationController popViewControllerAnimated:YES];
        //[self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
    
    answerViewAppear=NO;
    [question removeFromSuperview];
    [self.viewmenu addSubview:questionView];
    [ViewAllBtn setEnabled:YES];
    [self fetchData];
    backBtnValue=0;
        searchValue=0;
    }
    [ImagePostQuestion removeFromSuperview];
    [textView resignFirstResponder];
    
    
}



-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
   // NSString *image=[filteredResults valueForKey:@"attachment"]objectAtIndex:
    if ( actionSheet==shareActionSheet)
    {
    if (buttonIndex==0)
    {
        SLComposeViewController *composeController = [SLComposeViewController
                                                      composeViewControllerForServiceType:SLServiceTypeFacebook];
        
    
        [composeController setInitialText:postTextView.text];
        NSInteger i=[postTextView tag];
        NSLog(@"%ld",(long)i);
       // NSString *imageStr=[[filteredResults objectAtIndex:i]valueForKey:@"attachment"];
        
        if ([questionImageStr isEqualToString:@""])
        {
           
        }
        else
        {

            NSString *str=@"http://";
            NSString *imgStr=[str stringByAppendingString:questionImageStr];
            NSURL *imageUrl=[NSURL URLWithString:imgStr];
       
            NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
            UIImage *postImage = [UIImage imageWithData:imageData];
            UIImageView *postImageView=[[UIImageView alloc]init];
            [postImageView setImage:postImage];
            [composeController addImage:postImageView.image];
        }
      
    
        [self presentViewController:composeController animated:YES completion:nil];
    }
    else if(buttonIndex==1)
    {
        
        SLComposeViewController *composeController = [SLComposeViewController
                                                      composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        
        [composeController setInitialText:postTextView.text];
        NSInteger i=[postTextView tag];
        
        //NSString *imageStr=[[filteredResults objectAtIndex:i]valueForKey:@"attachment"];
        if ([questionImageStr isEqualToString:@""])
        {
            
        }
        else
        {
            
           
            NSString *str=@"http://";
            NSString *imgStr=[str stringByAppendingString:questionImageStr];
            NSURL *imageUrl=[NSURL URLWithString:imgStr];
            
            NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
            UIImage *postImage = [UIImage imageWithData:imageData];
            UIImageView *postImageView=[[UIImageView alloc]init];
            [postImageView setImage:postImage];
            [composeController addImage:postImageView.image];
            
        }

       
        [self presentViewController:composeController
                           animated:YES completion:nil];
        
        
    }
    }
    else if(actionSheet==cameraActionSheet)
    {
        if (buttonIndex==0)
        {
            if ([UIImagePickerController isSourceTypeAvailable:
                 UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *imagePicker =
                [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.sourceType =
                UIImagePickerControllerSourceTypeCamera;
                imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
                imagePicker.allowsEditing = YES;
                [self presentViewController:imagePicker
                                   animated:YES completion:nil];
                
                [[AppDelegate sharedDelegate]setAnswersPostImage:nil];
                // _newMedia = YES;
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Camera is not available" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Ok", nil];
                [alert show];
            }
            
        }
        else if (buttonIndex==1)
        {
            if ([UIImagePickerController isSourceTypeAvailable:
                 UIImagePickerControllerSourceTypeSavedPhotosAlbum])
            {
                UIImagePickerController *imagePicker =
                [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.sourceType =
                UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
                imagePicker.allowsEditing = NO;
                [self presentViewController:imagePicker
                                   animated:YES completion:nil];
                 [[AppDelegate sharedDelegate]setAnswersPostImage:nil];
                
            }
        }
        else if (buttonIndex==2)
        {
            ACEViewController *sketchView=[[ACEViewController alloc]initWithNibName:@"ACEViewController" bundle:nil];
            sketchView.postImageValue=2;
            [self.navigationController pushViewController:sketchView animated:YES];
        }
    }



}
#pragma mark Posted View Methods

-(void)questiondisLikeBtnAction:(id)sender
{
    
    NSString *likeDislikeStatus=[[questionInfo valueForKey:@"like_dislike_status"]objectAtIndex:0];
    //Dislike
    if ([likeDislikeStatus isEqualToString:@"0"])
    {
        //        [queslikeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        //        [quesDislikeBtn setImage:[UIImage imageNamed:@"dislike_active"] forState:UIControlStateNormal];
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"You already disliked this question" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }
    //Like
    else if ([likeDislikeStatus isEqualToString:@"1"])
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"You already liked this question" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
        //        [queslikeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        //        [quesDislikeBtn setImage:[UIImage imageNamed:@"dislike_active"] forState:UIControlStateNormal];
    }
    
    //None
    else if ([likeDislikeStatus isEqualToString:@"2"])
    {
        //        [queslikeBtn setImage:[UIImage imageNamed:@"like_active"] forState:UIControlStateNormal];
        //        [quesDislikeBtn setImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Do you want to dislike this question?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        alertView.tag=400;
        [alertView show];
    }

//    NSLog(@"%@",generalQuestionArray);
//   // NSInteger i=[sender tag];
//    
//    
//    NSString *likes=[generalQuestionArray valueForKey:@"dislikes"];
//    if ([likes isEqualToString:@"0"])
//    {
//        
//        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Do you want to dislike this question?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
//        alertView.tag=100;
//        [alertView show];
//    }
//    else
//    {
//        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"You already disliked this question" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
//        [alertView show];
//    }
}

-(void)editquestionBtnAction:(UITapGestureRecognizer *)recognizer
{
    TaBBarViewController *TabVC=[[TaBBarViewController alloc]init];
    TabVC.notificationViewValue=2;
    TabVC.questionId=[[questionInfo valueForKey:@"id"]objectAtIndex:0];
    
    [AppDelegate sharedDelegate].window.rootViewController=TabVC;

    
}
-(void)deletequestionBtnAction:(UITapGestureRecognizer *)recognizer
{
    [recognizer.view.superview removeFromSuperview];
    deletequestionAlertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Do you want to delete this question?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [deletequestionAlertView show];
    
}

-(void) questionLikeBtnActionnew:(UIGestureRecognizer*)recognizer
{
    [self questionLikeBtnAction:nil];
}

-(void)questionLikeBtnAction:(id)sender
{
    NSString *likeDislikeStatus=[[questionInfo valueForKey:@"like_dislike_status"]objectAtIndex:0];
    //Dislike
    if ([likeDislikeStatus isEqualToString:@"0"])
    {
//        [queslikeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
//        [quesDislikeBtn setImage:[UIImage imageNamed:@"dislike_active"] forState:UIControlStateNormal];
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"You already disliked this question" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }
    //Like
    else if ([likeDislikeStatus isEqualToString:@"1"])
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"You already liked this question" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
//        [queslikeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
//        [quesDislikeBtn setImage:[UIImage imageNamed:@"dislike_active"] forState:UIControlStateNormal];
    }
    
    //None
    else if ([likeDislikeStatus isEqualToString:@"2"])
    {
//        [queslikeBtn setImage:[UIImage imageNamed:@"like_active"] forState:UIControlStateNormal];
//        [quesDislikeBtn setImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
        
      //  UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Do you want to like this question?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        //alertView.tag=300;
        //[alertView show];
        [ProgressHUD show:@"Please Wait..." Interaction:NO];
        NSString *quesIddd=[[questionInfo valueForKey:@"id"]objectAtIndex:0];
        id array=[[WebServiceSingleton sharedMySingleton]likeAndDislikeQuestions:quesIddd andDislikeValue:@"1"];
        //[queslikeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        NSDictionary *oldDict = (NSDictionary *)[questionInfo objectAtIndex:0];
        [newDict addEntriesFromDictionary:oldDict];
        [newDict setObject:@"1" forKey:@"like_dislike_status"];
        [questionInfo replaceObjectAtIndex:0 withObject:newDict];
        
        
        
        NSString *strcount=@"";
        int count=0;
        if([likeCountLabel.text isEqualToString:@""])
        {
            strcount=@"1";
        }
        else
        {
            count=[likeCountLabel.text intValue];
            count++;
            strcount=[@(count) stringValue];
        }
        
        NSMutableDictionary *newDictcount = [[NSMutableDictionary alloc] init];
        NSDictionary *oldDictcount = (NSDictionary *)[questionInfo objectAtIndex:0];
        [newDictcount addEntriesFromDictionary:oldDictcount];
        [newDictcount setObject:strcount forKey:@"likecount"];
        [questionInfo replaceObjectAtIndex:0 withObject:newDictcount];
        
        
        
        [answersTableView reloadData];
        //[self postFetchData];
       // [[[UIAlertView alloc]initWithTitle:@"Alert!" message:[array valueForKey:@"message"]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]show];
        [ProgressHUD dismiss];
        
    }

    
   // NSInteger i=[sender tag];
    
    
//    NSString *likes=[generalQuestionArray valueForKey:@"likes"];
//    if ([likes isEqualToString:@"0"])
//    {
//        
//        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Do you want to like this question?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
//        alertView.tag=100;
//        [alertView show];
//    }
//    else
//    {
//        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"You already liked this question" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
//        [alertView show];
//    }
//  
}

-(void)questionFlagBtnAction:(id)sender
{
    [ProgressHUD show:@"Please Wait..." Interaction:NO];
    id array=[[WebServiceSingleton sharedMySingleton]flagAnswersQuestions:questionID entity:@"1"];
    
    
    
    [[[UIAlertView alloc]initWithTitle:@"Alert!" message:[array valueForKey:@"message"]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]show];
    [ProgressHUD dismiss];
    

}

-(void) reportadmin:(UITapGestureRecognizer *)recognizer

{
    [recognizer.view.superview removeFromSuperview];
    // UserDetailViewController *userProfile=[[UserDetailViewController alloc]init];
   
    
    reportadminAlert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Do you want to report this question to admin??" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [reportadminAlert show];
    
    
    
    
}
-(void) flagBtnActionnew:(UITapGestureRecognizer *)recognizer
{
    [recognizer.view.superview removeFromSuperview];
    
    [self flagBtnAction:recognizer.view];
    
    
    
}
-(void) flagBtnAction:(id)sender
{
   
    
        NSInteger i=[sender tag];
   
           NSString *ansId=[[postData valueForKey:@"id"]objectAtIndex:i];
        [ProgressHUD show:@"Please Wait..." Interaction:NO];
        id array=[[WebServiceSingleton sharedMySingleton]flagAnswersQuestions:ansId entity:@"0"];
    
    
    
       [[[UIAlertView alloc]initWithTitle:@"Alert!" message:[array valueForKey:@"message"]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]show];
        [ProgressHUD dismiss];
    
    
    
    
}
-(void) likeBtnActionnew:(UIGestureRecognizer*)recognizer
{
    [self likeBtnAction:recognizer.view];
}
-(void) likeBtnAction:(id)sender
{
    
    UITableViewCell *cellparent=(AnswerTableViewCell*)[sender superview];
    if(cellparent==nil)
    {
        cellparent=(NoImageAnswerTableViewCell*)[sender superview];
    }
    likecount=(UILabel*)[cellparent viewWithTag:101];
       //cellparent
    NSInteger i=[sender tag];
    NSString *likeDislikeStatus=[[postData valueForKey:@"like_dislike_status"]objectAtIndex:i];
    //Dislike
    if ([likeDislikeStatus isEqualToString:@"0"])
    {
        //        [queslikeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        //        [quesDislikeBtn setImage:[UIImage imageNamed:@"dislike_active"] forState:UIControlStateNormal];
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"You already disliked this answer" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }
    //Like
    else if ([likeDislikeStatus isEqualToString:@"1"])
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"You already liked this answer" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
        //        [queslikeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        //        [quesDislikeBtn setImage:[UIImage imageNamed:@"dislike_active"] forState:UIControlStateNormal];
    }
    
    //None
    else if ([likeDislikeStatus isEqualToString:@"2"])
    {
        //        [queslikeBtn setImage:[UIImage imageNamed:@"like_active"] forState:UIControlStateNormal];
        //        [quesDislikeBtn setImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
        
       // likeAnswerAlertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Do you want to like this answer?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        //likeAnswerAlertView.tag=i;
        //[likeAnswerAlertView show];
        NSString *ansId=[[postData valueForKey:@"id"]objectAtIndex:i];
        [ProgressHUD show:@"Please Wait..." Interaction:NO];
        id array=[[WebServiceSingleton sharedMySingleton]likeAndDislikeAnswers:ansId likeValue:@"1"];
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        NSDictionary *oldDict = (NSDictionary *)[postData objectAtIndex:i];
        [newDict addEntriesFromDictionary:oldDict];
        [newDict setObject:@"1" forKey:@"like_dislike_status"];
        [postData replaceObjectAtIndex:i withObject:newDict];
        
        
        // [self postFetchData];
        
        
        NSString *strcount=@"";
        int count=0;
        if([likecount.text isEqualToString:@""])
        {
            strcount=@"1";
        }
        else
        {
            count=[likecount.text intValue];
            count++;
            strcount=[@(count) stringValue];
            
        }
        
        NSMutableDictionary *newDictcount = [[NSMutableDictionary alloc] init];
        NSDictionary *oldDictcount = (NSDictionary *)[postData objectAtIndex:i];
        [newDictcount addEntriesFromDictionary:oldDictcount];
        [newDictcount setObject:strcount forKey:@"likecount"];
        [postData replaceObjectAtIndex:i withObject:newDictcount];
        
        
        [answersTableView reloadData];
        
        
        [[[UIAlertView alloc]initWithTitle:@"Alert!" message:[array valueForKey:@"message"]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]show];
        [ProgressHUD dismiss];
    }

    
//
//    NSInteger i=[sender tag];
//    answerID=[[postData valueForKey:@"id"]objectAtIndex:i];
//   
//    NSString *likes=[[postData valueForKey:@"likes"]objectAtIndex:i];
//    if ([likes isEqualToString:@"0"])
//    {
//        
//       UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Do you want to like this answer?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
//        alertView.tag=100;
//        [alertView show];
//    }
//    else
//    {
//        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"You already liked this answer" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        [alertView show];
//    }
    
    
  
}


-(void) dislikeBtnAction:(id)sender
{
    NSInteger i=[sender tag];
    NSString *likeDislikeStatus=[[postData valueForKey:@"like_dislike_status"]objectAtIndex:i];
    //Dislike
    if ([likeDislikeStatus isEqualToString:@"0"])
    {
       
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"You already disliked this answer" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }
    //Like
    else if ([likeDislikeStatus isEqualToString:@"1"])
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"You already liked this answer" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
      
    }
    
    //None
    else if ([likeDislikeStatus isEqualToString:@"2"])
    {
        
        
        dislikeAnswerAlertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Do you want to dislike this answer?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        dislikeAnswerAlertView.tag=i;
        [dislikeAnswerAlertView show];
    }

//    answerID=[[postData valueForKey:@"id"]objectAtIndex:i];
////    NSString *ansId=[NSString stringWithFormat:@"%@",answerID];
////    [ProgressHUD show:@"Please Wait..." Interaction:NO];
////    [[WebServiceSingleton sharedMySingleton]likeAndDislikeAnswers:ansId likeValue:@"1"];
//    NSString *dislikes=[[postData valueForKey:@"dislikes"]objectAtIndex:i];
//    NSString *likes=[[postData valueForKey:@"likes"]objectAtIndex:i];
//    if ([likes isEqualToString:@"0"])
//    {
//        
//    }
//    else
//    {
//        
//    }
//    if ([dislikes isEqualToString:@"0"])
//    {
//        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Do you want to dislike this answer?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
//        alertView.tag=200;
//        [alertView show];
//    }
//    else
//    {
//        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"You already disliked this answer" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
//       [alertView show];
//    }

   
}


-(void)filterBtn:(id)sender
{
    categoryTblView=[[UITableView alloc]init];
    categoryTblView.frame=CGRectMake(searchView.frame.origin.x, searchView.frame.origin.y+searchView.frame.size.height,searchView.frame.size.width, 120);
    categoryTblView.layer.borderWidth=0.5f;
    categoryTblView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    categoryTblView.layer.cornerRadius=5.0f;
    categoryTblView.dataSource=self;
    categoryTblView.delegate=self;
    categoryTblView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.viewmenu addSubview:categoryTblView];
}

-(void) rateBtn: (id) sender
{
   
    
    [textView resignFirstResponder];
     NSInteger i=[sender tag];
    float rateValue=[[[postData valueForKey:@"rating"]objectAtIndex:i]floatValue];
    ratingView=[[UIView alloc]init];
    ratingView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    ratingView.frame=self.viewmenu.bounds;
    //[popUptxt setBackgroundColor:[UIColor whiteColor]];
   // ratingView.frame=CGRectMake((self.viewmenu.frame.size.width-200)/2,(self.viewmenu.frame.size.height-150)/2, 200, 150);
    //ratingView.frame=CGRectMake(0, 44, 320, self.viewmenu.frame.size.height-90);
    //ratingView.frame=self.viewmenu.bounds;
    //[ratingView setBackgroundColor:[UIColor lightGrayColor]];
  
   [self.viewmenu addSubview:ratingView];
   
    
    
    
    starRatingView=[[ASStarRatingView alloc]init];
   // starRatingView.frame=CGRectMake(, 0, 150, 100);
    starRatingView.frame=CGRectMake((self.viewmenu.frame.size.width-150)/2, (self.viewmenu.frame.size.height-150)/2, 150, 150);
   // starRatingView layer] addAnimation:[AppDelegate popupAnimation] forKey:@"popupAnimation"];
    [starRatingView setRating:rateValue];
    
 
    [starRatingView setBackgroundColor:[UIColor lightGrayColor]];
    [ratingView addSubview:starRatingView];
   // [[ratingView layer] addAnimation:[AppDelegate popupAnimation] forKey:@"popupAnimation"];
    
    UIButton *okButton=[[UIButton alloc]init];
    
    okButton.frame=CGRectMake(100,starRatingView.frame.size.height-40, 30, 30);
   
    [okButton setTitle:@"Ok" forState:UIControlStateNormal];
    okButton.tag=i;
    [okButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [okButton setBackgroundColor:[UIColor clearColor]];
    [okButton addTarget:self action:@selector(OkClick:) forControlEvents:UIControlEventTouchUpInside];
    [starRatingView addSubview:okButton];
    
    UIButton *cancelBtn=[[UIButton alloc]init];
    
   //cancelBtn.frame=CGRectMake(80,starRatingView.frame.size.height+10, 70, 30);
    cancelBtn.frame=CGRectMake(10,starRatingView.frame.size.height-40, 70, 30);
    
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:[UIColor clearColor]];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [starRatingView addSubview:cancelBtn];
    

    
    
    
  
   
 }

-(void)OkClick:(id) sender
{
 
    
    //postValue=2;
    int i=[sender tag];
    rateIndexValue=i;
    
    
    
    [[AppDelegate sharedDelegate] showActivityInView:ratingView withBlock:^{
        NSString *ansID=[[postData valueForKey:@"id"]objectAtIndex:rateIndexValue];
        float starRating=starRatingView.rating;
    float rateValue=[[[postData valueForKey:@"rating"]objectAtIndex:i]floatValue];
        
    if (rateValue==starRating)
    {
         [ratingView removeFromSuperview];
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Rating not Updated" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
    }
    else
    {
        NSArray *mainArray=[[WebServiceSingleton sharedMySingleton]answerRate:ansID userId:ids rating:starRating];
        NSLog(@"%f", [[NSDate date] timeIntervalSince1970]);
        NSString *ratingStatus=[[mainArray valueForKey:@"status"]objectAtIndex:0];
        NSLog(@"%@",ratingStatus);
        if ([ratingStatus isEqualToString:@"0"])
        {
            
        }
        
        else
        {
            UIAlertView *rateAlert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Rating Updated" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [rateAlert show];
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            NSDictionary *oldDict = (NSDictionary *)[postData objectAtIndex:rateIndexValue];
            [newDict addEntriesFromDictionary:oldDict];
            [newDict setObject:[NSString stringWithFormat:@"%f",starRating] forKey:@"rating"];
            [postData replaceObjectAtIndex:rateIndexValue withObject:newDict];
            [answersTableView reloadData];
            
            
            
            // [self postFetchData];
            
        }
        [self removeView];
    }
      //  [self hideActivity];
        [[AppDelegate sharedDelegate]hideActivity];
        
    }];
    
    
  
    
   
    

//    NSInteger i=[sender tag];
//    NSString *ansID=[[postData valueForKey:@"id"]objectAtIndex:i];
//    float starRating=starRatingView.rating;
// 
//    NSArray *mainArray=[[WebServiceSingleton sharedMySingleton]answerRate:ansID userId:ids rating:starRating];
//    NSLog(@"%@",mainArray);
//
//  
//    [self removeView];
//    
//    [self postFetchData];
    
}



-(void)cancelClick
{
    [ratingView removeFromSuperview];
   
    
}



-(void) errBtn
{
    
    NSLog(@"error");
    
}
-(void) acceptClicknew:(UIGestureRecognizer*)recognizer{
    
        [self acceptClick:recognizer.view];
    
}
-(void) acceptClick:(id) sender
{
    NSInteger i=[sender tag];
   // answerID=[answerID objectAtIndex:i];
     answerID=[[postData valueForKey:@"id"]objectAtIndex:i];
    status=[[postData valueForKey:@"status"]objectAtIndex:i];
    //[self acceptAnswer];
    // NSInteger i=[sender tag];
    if ([status isEqualToString:@"accepted"])
    {
        
        UnAcceptAlert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Do you want to delete from accept questions?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        UnAcceptAlert.tag=i;
        [UnAcceptAlert show];
    }
    else
    {
        acceptAlert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Do you want to accept this answer?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        acceptAlert.tag=i;
        [acceptAlert show];
    }
  
}

-(void) editanswerClicknew: (UITapGestureRecognizer *)sender
{
    [sender.view.superview removeFromSuperview];
    [self editanswerClick:sender.view];
}

-(void) editanswerClick:(id) sender
{
    NSInteger i=[sender tag];
    // answerID=[answerID objectAtIndex:i];
    answerID=[[postData valueForKey:@"id"]objectAtIndex:i];
    NSString* answer=[[postData valueForKey:@"answer"]objectAtIndex:i];

    
    textView.text=answer;
    
}
-(void) deleteanswerClicknew:(UITapGestureRecognizer *)sender
{
    [sender.view.superview removeFromSuperview];
    [self deleteanswerClick:sender.view];
}
-(void) deleteanswerClick:(id) sender
{
    NSInteger i=[sender tag];
    // answerID=[answerID objectAtIndex:i];
    answerID=[[postData valueForKey:@"id"]objectAtIndex:i];
   
    deleteanswerAlertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Do you want to delete this answer?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [deleteanswerAlertView show];
    
}


-(void) removeView
{
    [transparentView removeFromSuperview];
    [popUptxt removeFromSuperview];
    [ratingView removeFromSuperview];
}



-(void) favoriteBtn
{
    [textView resignFirstResponder];
    [searchBar resignFirstResponder];
    if (favouriteVal==0)
    {
        favoriteAlert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Do you want to add this question in Favourite?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        
        [favoriteAlert show];
    }
    //else if(favouriteVal==1)
    else
    {
        UnfavAlert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Do you want to delete this question from Favourite?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        UnfavAlert.delegate=self;
        [UnfavAlert show];
    }
    
}

#pragma mark Alert View Method

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==favoriteAlert)
    {
    if (buttonIndex==1)
    {
//       [self showActivity:self.viewmenu];
//       postValue=3;
//        [self activityDidAppear];
       
        
      
       
        [[AppDelegate sharedDelegate] showActivityInView:self.viewmenu withBlock:^{
            
            NSLog(@"%d",favouriteVal);
                       favouriteVal=1;
                       NSString *favoriteid=[NSString stringWithFormat:@"%d",favouriteVal];
                       NSArray *questionArray1=[[NSArray alloc]initWithObjects:questionID,ids,favoriteid,nil];
           
           
                       [[WebServiceSingleton sharedMySingleton]addFavorite:questionArray1 favouriteValue:favouriteVal];
                       [favouriteBtn setBackgroundImage:[UIImage imageNamed:@"star01"] forState:UIControlStateNormal];
                       //[self hideActivity];
                        //[[AppDelegate sharedDelegate]hideActivity];
           
                       UIAlertView *successFavouriteAlertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Successfully added in favourites" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                       [successFavouriteAlertView show];
            
            
            [[AppDelegate sharedDelegate]hideActivity];
            
        }];
        

        

       
        
    }
        
    }
    
 
    else if(alertView==UnfavAlert)
    {
        if (buttonIndex==1)
        {
//            [self showActivity:self.viewmenu];
//            postValue=4;
//            [self activityDidAppear];
            
            [[AppDelegate sharedDelegate]showActivityInView:self.viewmenu withBlock:^{
        
                
            favouriteVal=0;
            NSString *favoriteid=[NSString stringWithFormat:@"%d",favouriteVal];
            NSArray *questionArray1=[[NSArray alloc]initWithObjects:questionID,ids,favoriteid,nil];
            // favouriteVal=0;
            [[WebServiceSingleton sharedMySingleton]addFavorite:questionArray1 favouriteValue:favouriteVal];
            [favouriteBtn setBackgroundImage:[UIImage imageNamed:@"star_black01"] forState:UIControlStateNormal];
            [self hideActivity];
            
            UIAlertView *successFavouriteAlertView=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Successfully deleted from favourites" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [successFavouriteAlertView show];
                
                [[AppDelegate sharedDelegate]hideActivity];
            }];
            

           
        }
    }
    
    else if (alertView==acceptAlert)
    {
        if (buttonIndex==1)
        {
//            [self showActivity:self.viewmenu];
//            postValue=5;
//            [self activityDidAppear];
            //status=@"rejected";
            
           
             [[AppDelegate sharedDelegate]showActivityInView:self.viewmenu withBlock:^{
            NSArray *mainArray=[[WebServiceSingleton sharedMySingleton]acceptAnswer:[NSString stringWithFormat:@"%@",answerID]];
            status=[NSString stringWithFormat:@"%@",[mainArray objectAtIndex:0]];
           
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            NSDictionary *oldDict = (NSDictionary *)[postData objectAtIndex:acceptAlert.tag];
            [newDict addEntriesFromDictionary:oldDict];
            [newDict setObject:@"accepted" forKey:@"status"];
            [postData replaceObjectAtIndex:acceptAlert.tag withObject:newDict];
            [answersTableView reloadData];
            [self performSelectorOnMainThread:@selector(postFetchData) withObject:nil waitUntilDone:YES];
            
            
            UIAlertView *successPost=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Successfully accepted this answer" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [successPost show];
             [[AppDelegate sharedDelegate]hideActivity];
                 
             }];
            // answerID=@"";
        }
    }
    
    else if (alertView==UnAcceptAlert)
    {
        if (buttonIndex==1)
        {
//           
//            [self showActivity:self.viewmenu];
//             postValue=6;
//            [self activityDidAppear];
//            
//               NSLog(@"%@",postStatus);
            
             [[AppDelegate sharedDelegate]showActivityInView:self.viewmenu withBlock:^{
                 
                 
            NSArray *mainArray=[[WebServiceSingleton sharedMySingleton]unacceptAnswer:[NSString stringWithFormat:@"%@",answerID]];
            status=[NSString stringWithFormat:@"%@",[mainArray objectAtIndex:0]];
            
            [acceptBtn setBackgroundImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
          
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            NSDictionary *oldDict = (NSDictionary *)[postData objectAtIndex:UnAcceptAlert.tag];
            [newDict addEntriesFromDictionary:oldDict];
            [newDict setObject:@"rejected" forKey:@"status"];
            [postData replaceObjectAtIndex:UnAcceptAlert.tag withObject:newDict];
            [answersTableView reloadData];
            
            UIAlertView *successPost=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Successfully deleted from accepted answers" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [successPost show];
                 [[AppDelegate sharedDelegate]hideActivity];

                         }];
         
          
           
        }
    }
    
    
    
    
    else if (alertView==saveAlert)
    {
        if (buttonIndex==1)
        {
            
            [[AppDelegate sharedDelegate]showActivityInView:self.viewmenu withBlock:^{
                saveVal=1;
                NSString *quesId=[NSString stringWithFormat:@"%@",questionID];
                [[WebServiceSingleton sharedMySingleton]saveQuestion:quesId userId:ids status:saveVal];
                //[saveBtn setImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
                NSMutableDictionary *newDictcount = [[NSMutableDictionary alloc] init];
                NSDictionary *oldDictcount = (NSDictionary *)[questionInfo objectAtIndex:0];
                [newDictcount addEntriesFromDictionary:oldDictcount];
                [newDictcount setObject:@"1" forKey:@"questionSaved"];
                [questionInfo replaceObjectAtIndex:0 withObject:newDictcount];
                
                
                
                [answersTableView reloadData];
                
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Successfully saved this question" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alertView show];
                [[AppDelegate sharedDelegate]hideActivity];
                

                
            }];
          
        }
    }
    else if (alertView==deleteSaveAlert)
    {
        if (buttonIndex==1)
        {
            
            [[AppDelegate sharedDelegate]showActivityInView:self.viewmenu withBlock:^{
                saveVal=0;
                NSString *quesId=[NSString stringWithFormat:@"%@",questionID];
                
                [[WebServiceSingleton sharedMySingleton]saveQuestion:quesId userId:ids status:saveVal];
                [saveBtn setImage:[UIImage imageNamed:@"save_black"] forState:UIControlStateNormal];
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Successfully deleted from saved questions" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alertView show];
                 [[AppDelegate sharedDelegate]hideActivity];
                
                
                
                
            }];
       
           
        }
    }
    //Answers Like Alert View
    else if (alertView==likeAnswerAlertView)
    {
        if (buttonIndex==1)
        {
        
        //NSString *ansId=[NSString stringWithFormat:@"%@",answerID];
        NSString *ansId=[[postData valueForKey:@"id"]objectAtIndex:likeAnswerAlertView.tag];
        [ProgressHUD show:@"Please Wait..." Interaction:NO];
        id array=[[WebServiceSingleton sharedMySingleton]likeAndDislikeAnswers:ansId likeValue:@"1"];
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        NSDictionary *oldDict = (NSDictionary *)[postData objectAtIndex:likeAnswerAlertView.tag];
        [newDict addEntriesFromDictionary:oldDict];
        [newDict setObject:@"1" forKey:@"like_dislike_status"];
        [postData replaceObjectAtIndex:likeAnswerAlertView.tag withObject:newDict];
          
        
       // [self postFetchData];
           
            
            NSString *strcount=@"";
            int count=0;
            if([likecount.text isEqualToString:@""])
            {
                strcount=@"1";
            }
            else
            {
                count=[likecount.text intValue];
                count++;
                strcount=[@(count) stringValue];
                
            }
            
            NSMutableDictionary *newDictcount = [[NSMutableDictionary alloc] init];
            NSDictionary *oldDictcount = (NSDictionary *)[postData objectAtIndex:likeAnswerAlertView.tag];
            [newDictcount addEntriesFromDictionary:oldDictcount];
            [newDictcount setObject:strcount forKey:@"likes"];
            [postData replaceObjectAtIndex:likeAnswerAlertView.tag withObject:newDictcount];
            
            
            [answersTableView reloadData];
            
            
        [[[UIAlertView alloc]initWithTitle:@"Alert!" message:[array valueForKey:@"message"]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]show];
        [ProgressHUD dismiss];
        }
    }
    //Answers Dislike Alert View
    else if (alertView==dislikeAnswerAlertView)
    {
        if (buttonIndex==1)
        {
            
            NSString *ansId=[[postData valueForKey:@"id"]objectAtIndex:dislikeAnswerAlertView.tag];
            
            [ProgressHUD show:@"Please Wait..." Interaction:NO];
            id array=[[WebServiceSingleton sharedMySingleton]likeAndDislikeAnswers:ansId likeValue:@"0"];
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            NSDictionary *oldDict = (NSDictionary *)[postData objectAtIndex:dislikeAnswerAlertView.tag];
            [newDict addEntriesFromDictionary:oldDict];
            [newDict setObject:@"0" forKey:@"like_dislike_status"];
            [postData replaceObjectAtIndex:dislikeAnswerAlertView.tag withObject:newDict];
            [answersTableView reloadData];
            [[[UIAlertView alloc]initWithTitle:@"Alert!" message:[array valueForKey:@"message"]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]show];
            [ProgressHUD dismiss];
        }
      
    }
    
    else if (alertView==deletequestionAlertView)
    {
        if (buttonIndex==1)
        {
            NSArray *questionArray=nil;
            questionArray=[[NSArray alloc]initWithObjects:@"",@"",@"0",@"",@""/*[NSString stringWithFormat:@"%d",timestamp]*/,@"",questionID,@"delete",@"",nil];
            [WebServiceSingleton sharedMySingleton].postQuestionDelegate=self;
            NSArray *mainArray=[[WebServiceSingleton sharedMySingleton]sendQuestionService:questionArray imageBase64String:@"" tabfriendids:@"" guidimage:@""];
            
            //friendIdsString
            if ([[mainArray valueForKey:@"status"] isEqualToString:@"1"])
            {
                
                TaBBarViewController *TabBarView=[[TaBBarViewController alloc]init];
                [AppDelegate sharedDelegate].navController=[[CustomnavigationController alloc]initWithRootViewController:TabBarView];
                [AppDelegate sharedDelegate].navController.navigationBarHidden = YES;
                
                // TabBarView.questionId=@"1";
                TabBarView.notificationViewValue=0;
                // TabBarView.
                
                
                //UpdatesViewController *loginView=[[UpdatesViewController alloc]init];
                
                //self.navController=[[UINavigationController alloc]initWithRootViewController:loginView];
                // self.window.rootViewController=self.navController;
                
                
                //
                // UpdatesViewController *updatesView=[[UpdatesViewController alloc]init];
                //updatesView.friendID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDetail"][@"id"];
                //[self.window.rootViewController.navigationController pushViewController:updatesView animated:NO];
                
                
                [AppDelegate sharedDelegate].window.rootViewController=TabBarView;
                //[self successposted];
            }
            
            
        }
        
    }

    
    
    else if (alertView==deleteanswerAlertView)
    {
        if (buttonIndex==1)
        {
            
            NSMutableArray *questionArray1=[[NSMutableArray alloc]initWithObjects:@"",@"",@"",@""/*[NSString stringWithFormat:@"%d",timestamp]*/,@"pending",@"yes",answerID,@"delete",nil];
            
            [[WebServiceSingleton sharedMySingleton]addAnswer:questionArray1 imageBase64String:@""];
            [answerImageView setImage:[UIImage imageNamed:@""]];
            
            //[self postFetchData];
            [self performSelectorOnMainThread:@selector(postFetchData) withObject:nil waitUntilDone:YES];
          
        }
        
    }

    
    else if (alertView==reportadminAlert)
    {
        if (buttonIndex==1)
        {
            
            [[AppDelegate sharedDelegate]showActivityInView:self.viewmenu withBlock:^{
               
                NSString *questionid=[[questionInfo valueForKey:@"id"]objectAtIndex:0];

                [ProgressHUD show:@"Please Wait..." Interaction:NO];
                id array=[[WebServiceSingleton sharedMySingleton]flagAnswersQuestions:questionid entity:@"1"];
                
                
                
                [[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"report successfully"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]show];
                [ProgressHUD dismiss];
                [[AppDelegate sharedDelegate]hideActivity];
            }];

            
        }
        
    }

    
    
    //questions like Alert View
    else if (alertView.tag==300)
    {
        if (buttonIndex==1)
        {
            //NSString *ansId=[NSString stringWithFormat:@"%@",answerID];
            [ProgressHUD show:@"Please Wait..." Interaction:NO];
            NSString *quesIddd=[[questionInfo valueForKey:@"id"]objectAtIndex:0];
            id array=[[WebServiceSingleton sharedMySingleton]likeAndDislikeQuestions:quesIddd andDislikeValue:@"1"];
            //[queslikeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            NSDictionary *oldDict = (NSDictionary *)[questionInfo objectAtIndex:0];
            [newDict addEntriesFromDictionary:oldDict];
            [newDict setObject:@"1" forKey:@"like_dislike_status"];
            [questionInfo replaceObjectAtIndex:0 withObject:newDict];
            
            
            
            NSString *strcount=@"";
            int count=0;
            if([likeCountLabel.text isEqualToString:@""])
            {
                strcount=@"1";
            }
            else
            {
                count=[likeCountLabel.text intValue];
                count++;
                strcount=[@(count) stringValue];
                
            }
            
            NSMutableDictionary *newDictcount = [[NSMutableDictionary alloc] init];
            NSDictionary *oldDictcount = (NSDictionary *)[questionInfo objectAtIndex:0];
            [newDictcount addEntriesFromDictionary:oldDictcount];
            [newDictcount setObject:strcount forKey:@"likes"];
            [questionInfo replaceObjectAtIndex:0 withObject:newDictcount];
            
            

            [answersTableView reloadData];
            //[self postFetchData];
            [[[UIAlertView alloc]initWithTitle:@"Alert!" message:[array valueForKey:@"message"]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]show];
            [ProgressHUD dismiss];
        }
    }
    //Questions Dislike Alert View
    else if (alertView.tag==400)
    {
        if(buttonIndex==1)
        {
        [ProgressHUD show:@"Please Wait..." Interaction:NO];
        NSString *quesIddd=[[questionInfo valueForKey:@"id"]objectAtIndex:0];
        id array=[[WebServiceSingleton sharedMySingleton]likeAndDislikeQuestions:quesIddd andDislikeValue:@"0"];
        //NSDictionary *dic=[[NSDictionary alloc]init];
        //[questionInfo setValue:@"" forKey:@"like_dislike_status"];
            
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        NSDictionary *oldDict = (NSDictionary *)[questionInfo objectAtIndex:0];
        [newDict addEntriesFromDictionary:oldDict];
        [newDict setObject:@"0" forKey:@"like_dislike_status"];
        [questionInfo replaceObjectAtIndex:0 withObject:newDict];
        //[ replaceObjectAtIndex:0 withObject:newDict];
        [answersTableView reloadData];

        [answersTableView reloadData];
        //[quesDislikeBtn setImage:[UIImage imageNamed:@"dislike_active"] forState:UIControlStateNormal];
            //[questionInfo setObje]
            
        [[[UIAlertView alloc]initWithTitle:@"Alert!" message:[array valueForKey:@"message"]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]show];
        [ProgressHUD dismiss];
        }
    }
    
    
   // [[AppDelegate sharedDelegate]hideActivity];
 
   
    
    
}







-(void) cameraClick
{
    [textView resignFirstResponder];
    
    cameraActionSheet=[[UIActionSheet alloc]initWithTitle:@"ActionSheet" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Open Camera" otherButtonTitles:@"Saved Photos",@"Draw Sketch", nil];
   
        [cameraActionSheet showInView:[UIApplication sharedApplication].keyWindow];
    
    
//    if ([UIImagePickerController isSourceTypeAvailable:
//         UIImagePickerControllerSourceTypeCamera])
//    {
//        UIImagePickerController *imagePicker =
//        [[UIImagePickerController alloc] init];
//        imagePicker.delegate = self;
//        imagePicker.sourceType =
//        UIImagePickerControllerSourceTypeCamera;
//        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
//        imagePicker.allowsEditing = NO;
//        [self presentViewController:imagePicker
//                           animated:YES completion:nil];
//        // _newMedia = YES;
//        
//    }
//    else
//    {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Camera is not available" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Ok", nil];
//        [alert show];
//    }

    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    answerImageView.image=[UIImage imageNamed:@""];
    convertedImage=[info valueForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    /*CGRect rect = CGRectMake(0.0, 0.0, 320, self.viewmenu.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    [self.viewmenu.layer renderInContext:UIGraphicsGetCurrentContext()];//here you can use your image view instead of self,view...
    [convertedImage drawInRect:rect];
    convertedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    
    
    
    
    NSData *data=UIImageJPEGRepresentation(convertedImage,0.1f);
    convertedImage=[UIImage imageWithData:data];*/
    
//    answerImageView=[[UIImageView alloc]init];
//    // answerImageView.frame=CGRectMake(0,textView.frame.origin.y-30, 30, 30);
//    answerImageView.frame=CGRectMake(10, textView.frame.origin.y-30, 30, 30);
//    answerImageView.layer.borderWidth=0.0f;
//    answerImageView.image=convertedImage;
//    [containerView addSubview:answerImageView];
//    
//    
//    [answerImageView setImage:convertedImage];
//    answerImageView.layer.borderWidth=0.5f;
//    
//    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popImage)];
//    [answerImageView addGestureRecognizer:tapGesture];
//    tapGesture.numberOfTapsRequired=1;
//    answerImageView.userInteractionEnabled=YES;
//    [answerImageView setBackgroundColor:[UIColor lightGrayColor]];
    
   

 
    
   
//
   
    
    
    
  
    
    
    
    
}

-(void) popImage
{
//    [textView resignFirstResponder];
//    [searchBar resignFirstResponder];
//    popImageView=[[UIView alloc]init];
//    popImageView.frame=CGRectMake(0, 44, self.viewmenu.frame.size.width, self.viewmenu.frame.size.height-44);
//    [self.viewmenu addSubview:popImageView];
//   ImagePostQuestion=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, popImageView.frame.size.width, popImageView.frame.size.height)];
//    [popImageView addSubview:ImagePostQuestion];
//    
    
    
    
    
    [textView resignFirstResponder];
    [searchBar resignFirstResponder];
    
    
    imageScrollView=[[UIScrollView alloc]init];
    imageScrollView.delegate=self;
    imageScrollView.frame=CGRectMake(0, 44, 320, self.viewmenu.frame.size.height-44);
    imageScrollView.maximumZoomScale=5.0;
    imageScrollView.minimumZoomScale=1.0;
    imageScrollView.delegate=self;
    
    [self.viewmenu addSubview:imageScrollView];
    popImageView=[[UIView alloc]init];
    popImageView.frame=CGRectMake(0, 44, self.viewmenu.frame.size.width, self.viewmenu.frame.size.height-44);
    [popImageView setBackgroundColor:[UIColor grayColor]];
    //[self.viewmenu addSubview:popImageView];
    
    
    
    ImagePostQuestion=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, popImageView.frame.size.width, popImageView.frame.size.height)];
    [ImagePostQuestion setBackgroundColor:[UIColor grayColor]];
    [imageScrollView addSubview:ImagePostQuestion];
    
    
    
    if ([questionImageStr rangeOfString:@"http://"].location == NSNotFound)
    {
        questionImageStr = [NSString stringWithFormat:@"http://%@", questionImageStr];
    }
    
    NSURL *imageUrl=[NSURL URLWithString:questionImageStr];
    NSURL *thumbUrl=[NSURL URLWithString:thumbUrlString];
    UIImage *thumbImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:thumbUrl]];
    if (imageUrl)
    {
        [ImagePostQuestion setImageWithURL:imageUrl placeholderImage:thumbImage];
    }
    else
    {
        
    }


    ImagePostQuestion.image=convertedImage;
    
    
    
    UITapGestureRecognizer *imageGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignImageView)];
    imageGesture.numberOfTapsRequired=1;
    [imageScrollView addGestureRecognizer:imageGesture];
    
    
    UIPinchGestureRecognizer *pinchGesture=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)];
    [pinchGesture setDelegate:self];
    [imageScrollView addGestureRecognizer:pinchGesture];
    
    
    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
    [rotationRecognizer setDelegate:self];
    [imageScrollView addGestureRecognizer:rotationRecognizer];
    

    
    
//    backImageBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 10, 45, 30)];
//    [backImageBtn setImage:[UIImage imageNamed:@"back_blue"] forState:UIControlStateNormal];
//    [backImageBtn addTarget:self action:@selector(backImageView) forControlEvents:UIControlEventTouchUpInside];
//    [self.viewmenu addSubview:backImageBtn];

}



- (void)didReceiveMemoryWarning
{
    [[[SDWebImageManager sharedManager] imageCache] clearDisk];
    [[[SDWebImageManager sharedManager] imageCache] clearMemory];
    [[[SDWebImageManager sharedManager]imageCache] cleanDisk];
   
  
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Activity View


-(void) showActivity:(UIView*)view
{

    activity = [ActivityView activityView];
    [activity setTitle:@"Loading..."];
    // [activity setDelegate:self];
    [activity setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.9]];
    [activity showBorder];
    
    [activity showActivityInView:view];
    activity.center=view.center;
}

-(void)hideActivity
{
    [activity hideActivity];
}



-(void)viewDidAppear:(BOOL)animated
{


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
