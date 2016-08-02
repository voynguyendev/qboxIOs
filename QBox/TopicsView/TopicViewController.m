 //
//  TopicViewController.m
//  QBox
//
//  Created by iApp1 on 28/01/15.
//  Copyright (c) 2015 iapp. All rights reserved.
//

#import "TopicViewController.h"
#import "NavigationView.h"
#import "CustomTableViewCell.h"
#import "AppDelegate.h"
#import "ProgressHUD.h"
#import "WebServiceSingleton.h"
#import "ProjectHelper.h"
#import "UIImageView+WebCache.h"
#import "UpdatesViewController.h"
#import "AddFriendViewController.h"
#import "QuestionCustomTableViewCell.h"
#import "NoImageQuestionCustomTableViewCell.h"
#import "CCHLinkTextView.h"
#import "CCHLinkTextViewDelegate.h"
#import "CCHLinkGestureRecognizer.h"
#import "MWPhotoBrowser.h"
#import <Photos/Photos.h>
#import "SDImageCache.h"
#import "MWCommon.h"




@interface TopicViewController ()<CCHLinkTextViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,MNMPullToRefreshManagerClient,MWPhotoBrowserDelegate,UINavigationControllerDelegate,UITextViewDelegate>
{
    UIView *searchView;
    UITextField *searchTextField;
    UITableView *questionTableView;
    UITableView *categoryTableView;
    UIButton *globalBtn;
    UIButton *buddiesBtn;
    UIButton *topicsBtn;
    NSMutableArray *questionArray;
    NSArray *categoryofuserArray;
    
    UIAlertView *reportadminAlert;
    NSString *questionid;
    UIScrollView *menuactionSubview;
    NSMutableArray *categoryArray;
    NSArray *questionInfoArray;
    NSString *searchTextStr;
    NSString *selectedCategoryStr;
    UIScrollView *categorySubview;
    NSMutableArray *selectedBtnArray;
    NSString *btaction;
    bool iscreatecategory;
    bool issearchcategory;
    NSMutableArray *filteredArrayCategory;
    bool hasall;
    bool isshowsubmenu;
    CGFloat lastContentOffset;
    bool isscroll;
    UIScrollView *imageScrollView;
    UIView *popImageView;
    UIImageView *ImagePostQuestion;
    NSString *categoriesId;
    int coutquestion;
    NSString *rowget;
    NSMutableArray *imagesQuestionViews;
    UIPageViewController *PageViewController;
    NSMutableArray *_photos;
    NSMutableArray *arrayheights;
    
}

@end

@implementation TopicViewController;
@synthesize pullToRefreshManager = pullToRefreshManager_;

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController) {
        // Do your stuff here
    }
}

- (void)viewDidLoad
{
    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"test"];
    
    
    [[NSUserDefaults standardUserDefaults]synchronize];
 
    
     NSString* user=[[NSUserDefaults standardUserDefaults]objectForKey:@"test"];
   // NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    ///[[UIDevice currentDevice] setValue:value forKey:@"orientation"];
  
  /// [UIViewController a];
    isshowsubmenu=false;
    coutquestion=15;
    rowget=[NSString stringWithFormat:@"%d",coutquestion];
    categoriesId=@"";
    isscroll=YES;
    issearchcategory=NO;
    selectedBtnArray=[[NSMutableArray alloc]init];
    iscreatecategory=NO;
    if([self.Indexredirect isEqualToString:@"1"])
    {
        
        
        
    }
    btaction=@"buddies";
    
    [super viewDidLoad];
    
    searchTextStr=[[NSString alloc]init];
    [self createUI];
    
    pullToRefreshManager_ = [[MNMPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f
                                                                                   tableView:questionTableView
                                                                                  withClient:self];
    arrayheights=[[NSMutableArray alloc]init];
    imagesQuestionViews=[[NSMutableArray alloc]init];
    
   
    // Do any additional setup after loading the view.
    
    if(self.hashtag!=nil && ![self.hashtag isEqualToString:@""] )
    {
         btaction=@"global";
        [globalBtn setImage:[UIImage imageNamed:@"globe_active"] forState:UIControlStateNormal];
        [globalBtn setTitleColor:BUTTONCOLOR forState:UIControlStateNormal];

        [topicsBtn setImage:[UIImage imageNamed:@"hot_topic"] forState:UIControlStateNormal];
        [topicsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [buddiesBtn setImage:[UIImage imageNamed:@"buddies"] forState:UIControlStateNormal];
        [buddiesBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self RefreshData:@"" hashtag:self.hashtag];
        
    }
    else
    {
        btaction=@"buddies";
        [buddiesBtn setImage:[UIImage imageNamed:@"buddies_active"] forState:UIControlStateNormal];
        [buddiesBtn setTitleColor:BUTTONCOLOR forState:UIControlStateNormal];

        [topicsBtn setImage:[UIImage imageNamed:@"hot_topic"] forState:UIControlStateNormal];
        [topicsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [globalBtn setImage:[UIImage imageNamed:@"globe"] forState:UIControlStateNormal];
        [globalBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self RefreshData:@"" hashtag:@""];

    }
     self.hashtag=@"";
    
}
-(void) popquestiondetail:(UITapGestureRecognizer *)recognizer{
    //NSArray *questionInfo=[questionArray objectAtIndex:recognizer.view.tag];

   // NSString   *questionidId=[questionInfo valueForKey:@"id"];
    PostQuestionDetailViewController *postView=[[PostQuestionDetailViewController alloc]init];
    postView.generalQuestionArray=[questionArray objectAtIndex:recognizer.view.tag];
    postView.generalViewValue=9;
    [self.navigationController pushViewController:postView animated:NO];

}
-(void) popAnswerImageViewProfile:(UITapGestureRecognizer *)recognizer

{
    // UserDetailViewController *userProfile=[[UserDetailViewController alloc]init];
     NSArray *questionInfo=[questionArray objectAtIndex:recognizer.view.tag];
     NSString   *userId=[questionInfo valueForKey:@"userid"];
    //NSString   *userId=userIdGeneral;
    
    
    //NSString *userId=[[filteredResults valueForKey:@"userid"]objectAtIndex:recognizer.view.tag];
    //userProfile.messageValue=2;
    //userProfile.user_id=userId;
    //[self.navigationController pushViewController:userProfile animated:NO];
    AddFriendViewController *addFriend=[[AddFriendViewController alloc]init];
    addFriend.friendUserId=userId;
    [self.navigationController pushViewController:addFriend animated:NO];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView==reportadminAlert)
    {
        if (buttonIndex==1)
        {
            //            [self showActivity:self.view];
            //            postValue=4;
            //            [self activityDidAppear];
            
            [[AppDelegate sharedDelegate]showActivityInView:self.view withBlock:^{
                
                
                [ProgressHUD show:@"Please Wait..." Interaction:NO];
                id array=[[WebServiceSingleton sharedMySingleton]flagAnswersQuestions:questionid entity:@"1"];
                
                
                
                [[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"report successfully"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]show];
                [ProgressHUD dismiss];
                [[AppDelegate sharedDelegate]hideActivity];
            }];
            
            
            
        }
    }

}

-(void) reportadmin:(UITapGestureRecognizer *)recognizer

{
    [recognizer.view.superview removeFromSuperview];
    // UserDetailViewController *userProfile=[[UserDetailViewController alloc]init];
    NSArray *questionInfo=[questionArray objectAtIndex:recognizer.view.tag];
    questionid=[questionInfo valueForKey:@"id"];
    
    reportadminAlert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Do you want to report this question to admin??" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [reportadminAlert show];

    
    
   
}

-(void) searchtagfriend:(NSString*)strsearch
{
    
    NSString *textsearch=[strsearch stringByReplacingOccurrencesOfString:@"#"
                                                        withString:@""];
    issearchcategory=NO;
    searchTextField.text=@"";
    categoriesId=@"";
    searchTextField.text=@"";

    self.hashtag=textsearch;
    questionArray=[self RefreshData:@"" hashtag:textsearch];
    
    [questionTableView reloadData];
    //    AddFriendViewController *addFriend=[[AddFriendViewController alloc]init];
    //    addFriend.friendUserId=userId;
    //    [self.navigationController pushViewController:addFriend animated:NO];
    
    
    
}
-(void) ViewProfiletabfriend:(UITapGestureRecognizer*)sender
{
    UILabel* lable=(UILabel*)(sender.view);
    NSString* userid=[NSString stringWithFormat:@"%d", lable.tag];
    AddFriendViewController *addFriend=[[AddFriendViewController alloc]init];
    addFriend.friendUserId=userid;
    [self.navigationController pushViewController:addFriend animated:NO];
}
-(void)profileViewQuestion:(id) sender
{
    NSInteger i=[sender tag];
    NSArray *questionInfo=[questionArray objectAtIndex:i];
    NSString   *userId=[questionInfo valueForKey:@"userid"];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
  if(scrollView.contentOffset.y+scrollView.frame.size.height>scrollView.contentSize.height+50)
  {
      coutquestion+=15;
      rowget=[NSString stringWithFormat:@"%d",coutquestion];

     questionArray=[self RefreshData:categoriesId hashtag:self.hashtag] ;
      NSLog([NSString stringWithFormat:@"%d",questionArray.count]);
//    [categorySubview setHidden:YES];
    [questionTableView reloadData];
  }

    
    if (lastContentOffset > scrollView.contentOffset.y)
    {
        [[AppDelegate sharedDelegate].TabBarView  showtabar];
    }
        // scrollDirection = ScrollDirectionRight;
    else if (lastContentOffset < scrollView.contentOffset.y)
    {
         if(lastContentOffset>10.0f)
        [[AppDelegate sharedDelegate].TabBarView  hidetabar];

    }
        // scrollDirection = ScrollDirectionLeft;
    //isscroll=YES;
    lastContentOffset = scrollView.contentOffset.y;
    [pullToRefreshManager_ tableViewScrolled];


}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y >=360.0f)
     {
         int a=1;
     }
     else
     {
         
            // [[AppDelegate sharedDelegate].TabBarView  showtabar];
            [pullToRefreshManager_ tableViewReleased];
     }
}

- (void)pullToRefreshTriggered:(MNMPullToRefreshManager *)manager
{
    
    if([btaction isEqualToString:@"topic"] )
        {
            [self hotTopicsWebservice];

        }
    else if([btaction isEqualToString:@"buddies"] )
    {
        [self friendsQuesWebservice];
    }
    else
    {
         [self globalQuesWebservice];
    }
    isscroll=NO;
    [pullToRefreshManager_ tableViewReloadFinishedAnimated:YES];
    //[[AppDelegate sharedDelegate].TabBarView  showtabar];
    
}

/*-(void)getEarlierMessages
 {
 NSLog(@"get Earlir Messages And Appand to Array");
 [self performSelector:@selector(loadfinished) withObject:nil afterDelay:1];
 }
 
 -(void)loadfinished
 {
 [pullToRefreshManager_ tableViewReloadFinishedAnimated:YES];
 //[self.sphChatTable reloadData];
 
 }
 
 */
-(void)viewWillAppear:(BOOL)animated
{
    [categoryTableView removeFromSuperview];
}
#pragma mark UiView
-(void)createUI
{
    self.navigationController.navigationBarHidden=YES;
    
    categoryArray=[NSMutableArray arrayWithObjects:@"All",@"Science",@"Math",@"Arts" ,nil];
    
    
    
    NSString *userid=[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    
    NSArray *listArray=[[WebServiceSingleton sharedMySingleton]getAllCategoriesByuserId:userid];
    
    NSString *status=[[listArray valueForKey:@"status"]objectAtIndex:0];
    if([status isEqualToString:@"1"])
    {
        categoryofuserArray=[[listArray valueForKey:@"data"]objectAtIndex:0];
        
        if(categoryofuserArray.count>0)
        {
            for (id arrayFr in categoryofuserArray)
            {
                
                [categoryArray addObject:[arrayFr valueForKey:@"category_name"]];
                
            }
        }
    }
    
    
    //Navigation View
        NavigationView  *nav = [[NavigationView alloc] init];
       // nav.titleView.text = @"General";
        [self.view addSubview:nav.navigationView];
    //
    //    UIButton *titleBckBtn=[[UIButton alloc]init];
    //    titleBckBtn.frame=CGRectMake(0,(nav.navigationView.frame.size.height-30)/2,45,30);
    //    [titleBckBtn setImage:[UIImage imageNamed:@"back_blue"] forState:UIControlStateNormal];
    //    [titleBckBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:titleBckBtn];
    
    
    
    
    //Custom Search Field
    searchView=[[UIView alloc]initWithFrame:CGRectMake(15,13, self.view.frame.size.width-20, 30)];
    //searchView.layer.borderColor=[UIColor whiteColor].CGColor;
   // searchView.layer.borderWidth=0.5f;
    //searchView.layer.cornerRadius=4.0f;
    [self.view addSubview:searchView];
    
    UIImageView *searchImageView=[[UIImageView alloc]init];
    searchImageView.frame=CGRectMake(0,(searchView.frame.size.height-25)/2, 25, 25);
    [searchImageView setImage:[UIImage imageNamed:@"search_icon"]];
    [searchView addSubview:searchImageView];
    
    searchTextField=[[UITextField alloc]initWithFrame:CGRectMake(searchImageView.frame.origin.x+searchImageView.frame.size.width, 0, searchView.frame.size.width-40,30)];
    searchTextField.delegate=self;
    searchTextField.font=TEXTFIELDFONT;
    searchTextField.returnKeyType=UIReturnKeySearch;
    searchTextField.font=[UIFont italicSystemFontOfSize:15.0f];
    searchTextField.textColor=[UIColor whiteColor];
    //[searchTextField setPlaceholder:@"Search Filter"];
    
    UIColor *color = [UIColor whiteColor];
    searchTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Search Filter"
                                    attributes:@{
                                                 NSForegroundColorAttributeName: color
                                                
                                                 }
     ];
    
    [searchView addSubview:searchTextField];
    
    UIButton *filterButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [filterButton setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
    [filterButton addTarget:self action:@selector(filterBtn:) forControlEvents:UIControlEventTouchUpInside];
    [filterButton setFrame:CGRectMake(searchView.frame.size.width-40,(searchView.frame.size.height-25)/2, 25, 25)];
    [searchView addSubview:filterButton];
    
    
    //    //Line View
    //    UIView *lineView=[[UIView alloc]init];
    //    lineView.frame=CGRectMake(0, searchView.frame.origin.y+searchView.frame.size.height+2, self.view.frame.size.width, 2);
    //    [lineView setBackgroundColor:[UIColor lightGrayColor]];
    //    [self.view addSubview:lineView];
    
    
    
    
    UILabel *sortByLabel=[[UILabel alloc]initWithFrame:CGRectMake(searchView.frame.origin.x,searchView.frame.origin.y+searchView.frame.size.height+15,50,20)];
    [sortByLabel setText:@"Sort By:"];
    [sortByLabel setTextColor:[UIColor lightGrayColor]];
    [sortByLabel setFont:[[AppDelegate sharedDelegate]fontWithName:12.0f]];
    //    [self.view addSubview:sortByLabel];
    
    
    //OPtions View
    UIView *optionsView=[[UIView alloc]initWithFrame:CGRectMake(sortByLabel.frame.origin.x+sortByLabel.frame.size.width-50, searchView.frame.origin.y+searchView.frame.size.height+10,self.view.frame.size.width-(sortByLabel.frame.size.width+20)+50, 30)];
    optionsView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    optionsView.layer.borderWidth=0.5f;
    optionsView.layer.cornerRadius=4.0f;
    [self.view addSubview:optionsView];
    
    
    
    
    
    //Buddies Btn
    buddiesBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    buddiesBtn.frame=CGRectMake(30,(optionsView.frame.size.height-20)/2,80,20);
    [buddiesBtn setTitle:@"Buddies" forState:UIControlStateNormal];
    [buddiesBtn setImage:[UIImage imageNamed:@"buddies"] forState:UIControlStateNormal];
    buddiesBtn.titleLabel.font=[[AppDelegate sharedDelegate]fontWithName:12.0f];
    [buddiesBtn setImage:[UIImage imageNamed:@"buddies_active"] forState:UIControlStateHighlighted];
    [buddiesBtn setTitleColor:BUTTONCOLOR forState:UIControlStateHighlighted];
    [buddiesBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [buddiesBtn addTarget:self action:@selector(buddiesBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [optionsView addSubview:buddiesBtn];
    
    //Hot topics
    topicsBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    topicsBtn.frame=CGRectMake(buddiesBtn.frame.origin.x+buddiesBtn.frame.size.width+5,(optionsView.frame.size.height-20)/2, 80,20);
    [topicsBtn setTitle:@"Hot Topics" forState:UIControlStateNormal];
    //[topicsBtn setImage:[UIImage imageNamed:@"hot_topic"] forState:UIControlStateNormal];
    //[topicsBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 5.0, 0, 5.0)];
    //[topicsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    topicsBtn.titleLabel.font=[[AppDelegate sharedDelegate]fontWithName:12.0f];
    [topicsBtn setImage:[UIImage imageNamed:@"hot_topic_active"] forState:UIControlStateNormal];
    [topicsBtn setTitleColor:BUTTONCOLOR forState:UIControlStateNormal];
    [topicsBtn addTarget:self action:@selector(topicsBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [optionsView addSubview:topicsBtn];
    
    //GlobalView
    globalBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    globalBtn.frame=CGRectMake(topicsBtn.frame.origin.x+topicsBtn.frame.size.width+5,(optionsView.frame.size.height-20)/2, 80,20);
    [globalBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [globalBtn setTitle:@"Global" forState:UIControlStateNormal];
    [globalBtn setImage:[UIImage imageNamed:@"globe"] forState:UIControlStateNormal];
    globalBtn.titleLabel.font=[[AppDelegate sharedDelegate]fontWithName:12.0f];
    [globalBtn setImage:[UIImage imageNamed:@"globe_active"] forState:UIControlStateHighlighted];
    [globalBtn setTitleColor:BUTTONCOLOR forState:UIControlStateHighlighted];
    [globalBtn addTarget:self action:@selector(globalBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [optionsView addSubview:globalBtn];
    
    
    
    
    
    
    
    
    
    
    //View Contains Table View
    questionTableView=[[UITableView alloc]init];
    questionTableView.frame=CGRectMake(10,optionsView.frame.origin.y+optionsView.frame.size.height+5,self.view.frame.size.width-20, (self.view.frame.size.height-(searchView.frame.size.height+optionsView.frame.size.height)));
    questionTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    questionTableView.bounces=YES;
    questionTableView.delegate=self;
    questionTableView.dataSource=self;
    
    [self.view addSubview:questionTableView];
    
    
    
    
    
    
    //CategoryTableView
    categoryTableView=[[UITableView alloc]init];
    categoryTableView.frame=CGRectMake(searchView.frame.origin.x, searchView.frame.origin.y+searchView.frame.size.height, searchView.frame.size.width, 120);
    categoryTableView.dataSource=self;
    categoryTableView.delegate=self;
    categoryTableView.layer.borderWidth=0.5f;
    categoryTableView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    categoryTableView.layer.cornerRadius=5.0f;
    
   }
-(void)categorySubview
{
    categorySubview=[[UIScrollView alloc]initWithFrame:CGRectMake(searchTextField.frame.origin.x, searchTextField.frame.origin.y+30, searchTextField.frame.size.width, self.view.frame.size.height-(searchTextField.frame.origin.y+130))];
    [categorySubview setBackgroundColor:[UIColor whiteColor]];
    categorySubview.layer.borderColor=[UIColor grayColor].CGColor;
    categorySubview.layer.borderWidth=2.0f;
    categorySubview.layer.cornerRadius=4.0f;
    [self.view addSubview:categorySubview];
    
    CGRect btnFrame=CGRectMake(10, 0, 120,30);
    // NSArray *titleArray=[[NSArray alloc]initWithObjects:@"All",@"Science",@"Maths",@"Arts", nil];
    NSInteger rowCount=categoryofuserArray.count/2;
    NSInteger columnCount;
    columnCount=2;
    if (categoryofuserArray.count%2!=0)
    {
        rowCount=rowCount+1;
    }
    
    int a=0;
    for (int i=0; i<rowCount; i++)
    {
        
        
        for (int j=0; j<columnCount; j++)
        {
            if(a==categoryofuserArray.count)
                break;
            UIButton *categoryBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            categoryBtn.frame=btnFrame;
            categoryBtn.tag=a;
            
            [categoryBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            // [categoryBtn setImage:[UIImage imageNamed:@"unselected_box"] forState:UIControlStateNormal];
            categoryBtn.titleLabel.font=LABELFONT;
            categoryBtn.titleLabel.textAlignment=NSTextAlignmentLeft;
            //
            
            categoryBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
            
            categoryBtn.titleEdgeInsets=UIEdgeInsetsMake(0,30, 0, -10);
            [categoryBtn setTitle:[[categoryofuserArray objectAtIndex:a] valueForKey:@"category_name" ] forState:UIControlStateNormal];
            [categoryBtn addTarget:self action:@selector(multipleCategorySelection:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView *boxImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,(categoryBtn.frame.size.height-15)/2,17, 15)];
            [boxImageView setImage:[UIImage imageNamed:@"unselected_box"]];
            [categoryBtn addSubview:boxImageView];
            UILabel *categoryLabel=[[UILabel alloc]initWithFrame:CGRectMake(boxImageView.frame.origin.x+boxImageView.frame.size.width+5, 0, categoryBtn.frame.size.width-22, categoryBtn.frame.size.height)];
            [categoryLabel setText:[[categoryofuserArray objectAtIndex:a] valueForKey:@"category_name" ]];
            [categoryLabel setTextColor:[UIColor lightGrayColor]];
            // [categoryBtn addSubview:categoryLabel];
            [categorySubview addSubview:categoryBtn];
            a++;
            
            
            btnFrame.origin.x=btnFrame.origin.x+btnFrame.size.width+10;
        }
        
        btnFrame.origin.y=btnFrame.origin.y+btnFrame.size.height+10;
        btnFrame.origin.x=10;
    }
    
    
    
    
    
    
    
    UIButton *deleteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame=CGRectMake((categorySubview.frame.size.width-50)/2-80, categorySubview.frame.size.height-50, 100, 30);
    // [deleteBtn setTitle:@"Delete" forState:UIControlStateNormal];
    //[deleteBtn setba];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"btReset"] forState:UIControlStateNormal];
    deleteBtn.titleLabel.font=LABELFONT;
    [deleteBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    deleteBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    deleteBtn.layer.borderWidth=1.0f;
    deleteBtn.layer.cornerRadius=4.0f;
    [deleteBtn addTarget:self action:@selector(resetcategoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [categorySubview addSubview:deleteBtn];
    
    
    UIButton *createBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    createBtn.frame=CGRectMake((categorySubview.frame.size.width-50)/2+30, categorySubview.frame.size.height-50, 100, 30);
    // [createBtn setTitle:@"Create" forState:UIControlStateNormal];
    
    [createBtn setBackgroundImage:[UIImage imageNamed:@"btFilter"] forState:UIControlStateNormal];
    
    createBtn.titleLabel.font=LABELFONT;
    [createBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    createBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    createBtn.layer.borderWidth=1.0f;
    createBtn.layer.cornerRadius=4.0f;
    [createBtn addTarget:self action:@selector(filterBtnCategory:) forControlEvents:UIControlEventTouchUpInside];
    [categorySubview addSubview:createBtn];
    
    
    
    
    
}



#pragma mark Action Methods

-(void) resignImageView
{
    [imageScrollView removeFromSuperview];
}

-(void) popQuestionImageView:(UITapGestureRecognizer *)recognizer
{
    imagesQuestionViews= [[NSMutableArray alloc] init];
    //[imagesQuestionViews addObject:@"http://54.69.127.235/question_app/question_images/1467103364_image.png" ];
   ///  [imagesQuestionViews addObject:@"http://54.69.127.235/question_app/////question_images/1467103389_image.png" ];
   
    NSArray *questionInfo=[questionArray objectAtIndex:recognizer.view.tag];
    NSString *questionId = [questionInfo valueForKey:@"questionId"];
    
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



- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return ImagePostQuestion;
}



-(void)multipleCategorySelection:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    for (UIView *v in btn.subviews)
    {
        if ([v isKindOfClass:[UIImageView class]])
        {
            UIImage *image=[UIImage imageNamed:@"selected_box"];
            UIImageView *imgView=(UIImageView*)v;
            if ([imgView.image isEqual:image])
            {
                imgView.image=[UIImage imageNamed:@"unselected_box"];
                NSString *str=[NSString stringWithFormat:@"%ld",(long)btn.tag];
                //int value = [btn.tatag intValue];
                //NSInteger inter=btn.tag;
                [selectedBtnArray removeObject:str];
            }
            else
            {
                imgView.image=[UIImage imageNamed:@"selected_box"];
                NSString *str=[NSString stringWithFormat:@"%ld",(long)btn.tag];
                [selectedBtnArray addObject:str];
            }
            
        }
    }
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)resetcategoryButtonClick:(id)sender
{
    
    [categorySubview setHidden:YES];
    selectedBtnArray=[[NSMutableArray alloc]init];
    [self categorySubview];
    
    
}

-(NSMutableArray*)RefreshData:(NSString*) categoriesId hashtag:(NSString*) hashtag
{
    arrayheights=[[NSMutableArray alloc]init];

    NSMutableString *mutableStringfriends = [categoriesId mutableCopy];
    isshowsubmenu=false;
    if (![mutableStringfriends isEqualToString:@""])
    {
        [mutableStringfriends deleteCharactersInRange:NSMakeRange(mutableStringfriends.length-1, 1)];
    }
    categoriesId=[NSString stringWithString:mutableStringfriends];

    
    
    
    if(btaction==@"buddies")
    {
       // NSArray *userData=[[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil]objectAtIndex:0];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        // getting an NSString
       // NSString *myString = [prefs stringForKey:@"userid"];
        
        NSString *userId=[prefs stringForKey:@"userid"];
        
        id dic= [[WebServiceSingleton sharedMySingleton]privateFriendPost:userId categoriesId:categoriesId hashtag:hashtag rowget:rowget];
        
       
        questionArray=[dic objectForKey:@"questions"];
        

    }
    else if(btaction==@"topic")
    {
        id dic=[[WebServiceSingleton sharedMySingleton]getHotTopicsQuestions:categoriesId hashtag:hashtag rowget:rowget];
      questionArray=[dic objectForKey:@"data"];

    }
    else
    {
        // NSArray *userData=[[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil]objectAtIndex:0];
        //NSString *userId=[userData valueForKey:@"id"];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        // getting an NSString
        // NSString *myString = [prefs stringForKey:@"userid"];
        
        NSString *userId=[prefs stringForKey:@"userid"];

        
        id dic= [[WebServiceSingleton sharedMySingleton]getAllQuestions:userId categoriesId:categoriesId hashtag:hashtag rowget:rowget];
        questionArray=[dic objectForKey:@"questions"];
    }
    return questionArray;
}
-(void)filterBtnCategory:(id)sender
{
    issearchcategory=YES;
    filteredArrayCategory=[[NSMutableArray alloc]init];
    NSMutableString *str=[[NSMutableString alloc]init];
    questionArray=[NSMutableArray arrayWithArray:questionInfoArray];
    searchTextField.text=@"";
    self.hashtag=@"";
    categoriesId=@"";
    hasall=NO;
    for (int i=0; i<selectedBtnArray.count; i++)
    {
        int value = [[selectedBtnArray objectAtIndex:i] intValue];
        categoriesId=[categoriesId stringByAppendingString:[[categoryofuserArray objectAtIndex:value] valueForKey:@"id" ]];
        categoriesId=[categoriesId stringByAppendingString:@","];
        
        [str appendString:[[categoryofuserArray objectAtIndex:value] valueForKey:@"category_name" ]];
        [str appendString:@","];
        
        
    }
    if (![str isEqualToString:@""])
    {
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];
        searchTextField.text=str;
    }
    else
    {
        searchTextField.text=@"";
    }
    questionArray=[self RefreshData:categoriesId hashtag:@""] ;
    
    [categorySubview setHidden:YES];
    [questionTableView reloadData];
    
    
}
-(void)filterBtn:(id)sender
{
    
    categoryArray=[NSMutableArray arrayWithObjects:@"All",@"Science",@"Math",@"Arts" ,nil];
    
    //selectedBtnArray=[[NSMutableArray alloc]init];
    
    
    NSString *userid= [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    
    NSArray *listArray=[[WebServiceSingleton sharedMySingleton]getAllCategoriesByuserId:userid];
    
    NSString *status=[[listArray valueForKey:@"status"]objectAtIndex:0];
    if([status isEqualToString:@"1"])
    {
        categoryofuserArray=[[listArray valueForKey:@"data"]objectAtIndex:0];
        
        if(categoryofuserArray.count>0)
        {
            for (id arrayFr in categoryofuserArray)
            {
                
                [categoryArray addObject:[arrayFr valueForKey:@"category_name"]];
                
            }
        }
    }
    
    
    
    if(iscreatecategory==NO)
    {
        [self categorySubview];
        iscreatecategory=YES;
    }
    else
    {
        [categorySubview setHidden:NO];
    }
    
}
-(void)globalBtnAction:(id)sender
{
    coutquestion=15;
    rowget=[NSString stringWithFormat:@"%d",coutquestion];
    self.hashtag=@"";
    categoriesId=@"";
    searchTextField.text=@"";
    
    
   if([btaction isEqualToString:@"global"])
   {
       [self globalQuesWebservice];
       return;
   }
    btaction=@"global";
    [self globalQuesWebservice];
    UIButton *btn=(UIButton*)sender;
    UIImage *globalImage=[UIImage imageNamed:@"globe"];
    if ([[btn imageForState:UIControlStateNormal]isEqual:globalImage])
    {
        [btn setImage:[UIImage imageNamed:@"globe_active"] forState:UIControlStateNormal];
        [btn setTitleColor:BUTTONCOLOR forState:UIControlStateNormal];
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"globe"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    [topicsBtn setImage:[UIImage imageNamed:@"hot_topic"] forState:UIControlStateNormal];
    [topicsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [buddiesBtn setImage:[UIImage imageNamed:@"buddies"] forState:UIControlStateNormal];
    [buddiesBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    
    
}
-(void)topicsBtnAction:(id)sender
{
    coutquestion=15;
    rowget=[NSString stringWithFormat:@"%d",coutquestion];
    self.hashtag=@"";
    categoriesId=@"";
    searchTextField.text=@"";
    
    if([btaction isEqualToString:@"topic"])
    {
        [self hotTopicsWebservice];

        return;
    }
    btaction=@"topic";
    [self hotTopicsWebservice];

    UIButton *btn=(UIButton*)sender;
    UIImage *topicImage=[UIImage imageNamed:@"hot_topic"];
    if ([[btn imageForState:UIControlStateNormal]isEqual:topicImage])
    {
        [btn setImage:[UIImage imageNamed:@"hot_topic_active"] forState:UIControlStateNormal];
        [btn setTitleColor:BUTTONCOLOR forState:UIControlStateNormal];
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"hot_topic"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    [globalBtn setImage:[UIImage imageNamed:@"globe"] forState:UIControlStateNormal];
    [globalBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [buddiesBtn setImage:[UIImage imageNamed:@"buddies"] forState:UIControlStateNormal];
    [buddiesBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    
    
    //WEbserVice
    // http://54.69.127.235/question_app/hot_topics.php
}

-(void)buddiesBtnAction:(id)sender
{
    coutquestion=15;
    rowget=[NSString stringWithFormat:@"%d",coutquestion];
    self.hashtag=@"";
    categoriesId=@"";
    searchTextField.text=@"";
    if([btaction isEqualToString:@"buddies"])
    {
        [self friendsQuesWebservice];
        
        return;
    }
    btaction=@"buddies";
    [self friendsQuesWebservice];
    //btaction=@"buddies";
    UIButton *btn=(UIButton*)sender;
    UIImage *buddiesImage=[UIImage imageNamed:@"buddies"];
    if ([[btn imageForState:UIControlStateNormal]isEqual:buddiesImage])
    {
        [btn setImage:[UIImage imageNamed:@"buddies_active"] forState:UIControlStateNormal];
        [btn setTitleColor:BUTTONCOLOR forState:UIControlStateNormal];
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"buddies"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    [globalBtn setImage:[UIImage imageNamed:@"globe"] forState:UIControlStateNormal];
    [globalBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [topicsBtn setImage:[UIImage imageNamed:@"hot_topic"] forState:UIControlStateNormal];
    [topicsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    //[self friendsQuesWebservice];
}
-(void)submenuactiontab:(UITapGestureRecognizer *)sender
{
    [sender.view removeFromSuperview];
}
-(void)createsubmenuaction:(UITapGestureRecognizer *)sender
{
   
    UILabel *lablelsubmenu=(UILabel*)sender.view;
    
    if ([lablelsubmenu.superview viewWithTag:2] !=nil) {
        [[lablelsubmenu.superview viewWithTag:2] removeFromSuperview];
        return;
    }
    
    menuactionSubview=[[UIScrollView alloc]initWithFrame:CGRectMake(lablelsubmenu.frame.origin.x-10, lablelsubmenu.frame.origin.y+50, 40,40)];
    
    menuactionSubview.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(createsubmenuaction:)];
    [menuactionSubview addGestureRecognizer:tapGesture];
    
    
    
    [menuactionSubview setBackgroundColor:[UIColor whiteColor]];
    [menuactionSubview setBackgroundColor:[UIColor whiteColor]];
    menuactionSubview.layer.borderColor=[UIColor grayColor].CGColor;
    menuactionSubview.layer.borderWidth=2.0f;
    menuactionSubview.layer.cornerRadius=4.0f;
    
    UILabel *flagImageView=[[UILabel alloc]initWithFrame:CGRectMake(5,10, 50, 30)];
    flagImageView.text=@"Flag";
    UITapGestureRecognizer *tapGesture2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reportadmin:)];
    flagImageView.tag=lablelsubmenu.tag;
    [flagImageView setUserInteractionEnabled:YES];
    [flagImageView addGestureRecognizer:tapGesture2];
    menuactionSubview.tag=2;
    
    [menuactionSubview addSubview:flagImageView];
    
    
    [lablelsubmenu.superview addSubview:menuactionSubview];
     
     }


-(void)profileView:(id)sender
{
    
}

#pragma  mark WEbservice Method
-(void)hotTopicsWebservice
{
    [ProgressHUD show:@"Please Wait..." Interaction:NO];
    if ([ProjectHelper internetAvailable])
    {
        NSMutableString *mutableStringfriends = [categoriesId mutableCopy];
        
        
        if (![mutableStringfriends isEqualToString:@""])
        {
            [mutableStringfriends deleteCharactersInRange:NSMakeRange(mutableStringfriends.length-1, 1)];
        }
        categoriesId=[NSString stringWithString:mutableStringfriends];

        id dic=[[WebServiceSingleton sharedMySingleton]getHotTopicsQuestions:categoriesId hashtag:@"" rowget:rowget];
        if ([[dic objectForKey:@"success"]boolValue])
        {
            questionArray=[dic objectForKey:@"data"];
            questionInfoArray=questionArray;
           if(issearchcategory==YES)
            {
             
            
            }
            else
            {
              if (![searchTextField.text isEqualToString:@""])
              {
                NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF.question contains[c] %@",selectedCategoryStr]; // Creating filter condition
                questionArray=[NSMutableArray arrayWithArray:[questionInfoArray filteredArrayUsingPredicate:  filterPredicate]];
              }
            
            }
            
            
        }
        else
        {
            if ([[dic objectForKey:@"status"] isEqualToString:@"-2"])
            {
                [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Your token expired,please login again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]show];
                LoginViewController_iPhone *loginView = [[LoginViewController_iPhone alloc] init];
                [AppDelegate sharedDelegate].navController = [[[AppDelegate sharedDelegate] navController]
                                                              initWithRootViewController:loginView];
                
                [AppDelegate sharedDelegate].window.rootViewController=[AppDelegate sharedDelegate].navController;
                [ProgressHUD dismiss];
                return;
                
            }
            else
            {
                questionArray=nil;
                [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"No question at this time" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]show];
            }
            
            
            
            
        }
        [questionTableView reloadData];
    }
    else
    {
        SHOW_NO_INTERNET_ALERT(self);
    }
    
    [ProgressHUD dismiss];
}

-(void)globalQuesWebservice
{
    
    
     NSString *userId= [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];

    
    [ProgressHUD show:@"Please Wait..." Interaction:NO];
    if ([ProjectHelper internetAvailable])
    {
        NSMutableString *mutableStringfriends = [categoriesId mutableCopy];
        
        
        if (![mutableStringfriends isEqualToString:@""])
        {
            [mutableStringfriends deleteCharactersInRange:NSMakeRange(mutableStringfriends.length-1, 1)];
        }
        categoriesId=[NSString stringWithString:mutableStringfriends];

        id dic= [[WebServiceSingleton sharedMySingleton]getAllQuestions:userId categoriesId:categoriesId hashtag:@"" rowget:rowget];
        if ([[dic objectForKey:@"success"]boolValue])
        {
            questionArray=[dic objectForKey:@"questions"];
            questionInfoArray=questionArray;
            
            if(issearchcategory==YES)
            {
                
                
            }
            else
            {
                if (![searchTextField.text isEqualToString:@""])
                {
                    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF.question contains[c] %@",selectedCategoryStr]; // Creating filter condition
                    questionArray=[NSMutableArray arrayWithArray:[questionInfoArray filteredArrayUsingPredicate:  filterPredicate]];
                }
                
            }

            
            
        }
        else
        {
            questionArray=nil;
            [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"No question at this time" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]show];
            
        }
        [questionTableView reloadData];
    }
    else
    {
        SHOW_NO_INTERNET_ALERT(self);
    }
    
    [ProgressHUD dismiss];
}

-(void)friendsQuesWebservice
{
    
    NSString *userId= [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];

    [ProgressHUD show:@"Please Wait..." Interaction:NO];
    if ([ProjectHelper internetAvailable])
    {
        NSMutableString *mutableStringfriends = [categoriesId mutableCopy];
        
        
        if (![mutableStringfriends isEqualToString:@""])
        {
            [mutableStringfriends deleteCharactersInRange:NSMakeRange(mutableStringfriends.length-1, 1)];
        }
        categoriesId=[NSString stringWithString:mutableStringfriends];

        id dic= [[WebServiceSingleton sharedMySingleton]privateFriendPost:userId categoriesId:categoriesId hashtag:@"" rowget:rowget];
        
        if ([[dic objectForKey:@"success"]boolValue])
        {
            questionArray=[dic objectForKey:@"questions"];
            questionInfoArray=questionArray;
            
            
            if(issearchcategory==YES)
            {
                
            }
            else
            {
                if (![searchTextField.text isEqualToString:@""])
                {
                    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF.question contains[c] %@",selectedCategoryStr]; // Creating filter condition
                    questionArray=[NSMutableArray arrayWithArray:[questionInfoArray filteredArrayUsingPredicate:  filterPredicate]];
                }
                
            }
            
            
            
        }
        else
        {
            questionArray=nil;
            [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"No question at this time" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]show];
            
            
        }
      [questionTableView reloadData];
    }
    else
    {
        SHOW_NO_INTERNET_ALERT(self);
    }
    [ProgressHUD dismiss];
}
#pragma mark Delegate Metdsdshods
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{

    return YES;

}

- (void)textViewDidBeginEditing:(UITextView *)textView{

}
- (void)textViewDidEndEditing:(UITextView *)textView{

}

-(void)textViewDidChange:(UITextView *)textView
{
   [questionTableView beginUpdates];
   // CGFloat paddingForTextView = 40; //Padding varies depending on your cell design
    textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, textView.contentSize.height + 140);
    
     [questionTableView endUpdates];
    
}

#pragma  mark TextFieldDelegate Methods
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    issearchcategory=NO;
    if ([string isEqualToString:@""])
    {
        NSMutableString *str = [textField.text mutableCopy];
        if (str.length > 0)
        {
            [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];
        }
        
        string = str;
        
    }
    else
    {
        string=[searchTextField.text stringByAppendingString:string];
    }
    searchTextStr=string;
    if (string.length==0)
    {
        questionArray=[NSMutableArray arrayWithArray:questionInfoArray];
    }
    else
    {
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF.question contains [c]%@",string];
       // NSPredicate  *predicate1=[NSPredicate predicateWithFormat:@"SELF.hashtag contains [c]%@",searchTextStr];
        
        
        //NSPredicate *predicate2 = [NSCompoundPredicate orPredicateWithSubpredicates:@[predicate1, predicate]];
        
        questionArray=[NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:predicate]];
        
        
    }
    [questionTableView reloadData];
    
    return YES;
}
#pragma mark Table View Methods
- (void)alignTop:(UILabel*) label {
    CGSize fontSize = [label.text sizeWithFont:label.font];
    double finalHeight = fontSize.height * label.numberOfLines;
    double finalWidth = label.frame.size.width;    //expected width of label
    CGSize theStringSize = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:label.lineBreakMode];
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    for(int i=0; i<newLinesToPad; i++)
        label.text = [label.text stringByAppendingString:@"\n "];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==questionTableView)
    {
        return [questionArray count];
    }
    else
    {
        return [categoryArray count];
    }
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{


}


-(bool)Getishasimage :(NSInteger)rowindex{
    NSArray *questionInfo=[questionArray objectAtIndex:rowindex];
    
    //QuestionImage
    NSString *urlString = [questionInfo valueForKey:@"thumb"];
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
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==questionTableView)
    {
     
      
        bool ischecknoimage=[self Getishasimage: indexPath.row];
        if(ischecknoimage)
        {
            static NSString *cellIdentifier = @"Cell";
            QuestionCustomTableViewCell *cell = (QuestionCustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (cell == nil)
            {
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"QuestionCustomTableViewCell" owner:self options:nil];
                cell=[nib objectAtIndex:0];
                
                
            }
            //cell.questionLabel.delegate=self;
            NSArray *questionInfo=[questionArray objectAtIndex:indexPath.row];
            
            //QuestionImage
            NSString *urlString = [questionInfo valueForKey:@"thumb"];
            if ([urlString rangeOfString:@"http://"].location == NSNotFound)
            {
                urlString = [NSString stringWithFormat:@"http://%@", urlString];
            }
            else
            {
                urlString=@"";
                
            }
            NSURL *imageUrl=[NSURL URLWithString:urlString];
            
            NSString *countImages = [questionInfo valueForKey:@"questionImages"];
            if([countImages isEqualToString:@"0"])
            {
                [cell.lbCountPictures setHidden:true];
            }
            else
            {
                countImages = [NSString stringWithFormat:@"%@ Pictures", countImages];
                cell.lbCountPictures.text=countImages;
            }
            
            
            NSString *hashtagquestion =[NSString stringWithFormat:@"%@",[questionInfo valueForKey:@"question"]];
            
            
            
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
            CCHLinkTextView * questiontext=nil;
            cell.questionLabel.text=hashtagquestion;
            
            CGSize textViewSize = [cell.questionLabel sizeThatFits:CGSizeMake(cell.questionLabel.frame.size.width, FLT_MAX)];
         
            questiontext=(CCHLinkTextView*)cell.questionLabel;
           // questiontext.userInteractionEnabled=YES;
           // [cell.questionLabel removeFromSuperview];
           // [questiontext setBackgroundColor:[UIColor blackColor]];
            //cell.questionLabelNoImage.frame=CGRectMake(cell.frame.origin.x +20, 30, cell.frame.size.width - 20, 200);
            //[cell addSubview:questiontext];
        //[cell insertSubview:questiontext atIndex:0];
            cell.lcquestionlabelheight.constant=textViewSize.height;
            cell.lcviewquestion.constant=cell.lcviewquestion.constant+(textViewSize.height);
           // cell.se
            //add line
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
          /*  UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,320+ cell.questionLabel.contentSize.height, questionTableView.frame.size.width, 1.0f)];
            [lineView setBackgroundColor:[UIColor lightGrayColor]];
            [cell.contentView addSubview:lineView];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;*/
            
            [cell.questionLabelNoImage removeFromSuperview];
            
            // [cell.questionLabelNoImage removeFromSuperview];
           
          //  questiontext.layer.zPosition=300;
           // cell.viewquestion.layer.zPosition=500;
            int yquestionlable=cell.questionLabel.frame.origin.y+cell.questionLabel.frame.size.height;
            
            NSRange rangeimagepng = [urlString rangeOfString:@".png" options:NSCaseInsensitiveSearch];
            NSRange rangeimagejpg = [urlString rangeOfString:@".jpg" options:NSCaseInsensitiveSearch];
            //if (range.location != NSNotFound) {
            
            
            [cell.questionImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"name_icon"]];
            
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popquestiondetail:)];
            
            UITapGestureRecognizer *tapGesture3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popQuestionImageView:)];
            cell.questionImageView.tag=indexPath.row;
            
            [cell.questionImageView setBackgroundColor:[UIColor blackColor]];
            [cell.questionImageView setUserInteractionEnabled:YES];
            [cell.questionImageView addGestureRecognizer:tapGesture3];
           questiontext.selectable=YES;
           // questiontext.editable=true;
            //questiontext.delegate=self;
            questiontext.scrollEnabled=true;
            questiontext.text=hashtagquestion;
            
            //cell.questionLabelNoImage.delegate=self;
           // cell.questionLabelNoImage.text=hashtagquestion;
            
            
            
      
            NSMutableAttributedString * str =  [questiontext.attributedText mutableCopy];
            
            for(id objectvalue in [[questionArray valueForKey:@"hashtagarr"]objectAtIndex:indexPath.row])
            {
                
                
                NSRange range = [hashtagquestion rangeOfString:[NSString stringWithFormat:@"#%@",[objectvalue objectForKey:@"hashtag"]] options:NSCaseInsensitiveSearch];
                
                if (range.location != NSNotFound) {
                    
                    [str addAttribute:CCHLinkAttributeName value:[NSString stringWithFormat:@"#%@",[objectvalue objectForKey:@"hashtag"]] range:range];
                    
                }
                
                
            }
            
            
            for(id objectvalue in [[questionArray valueForKey:@"tagfriends"]objectAtIndex:indexPath.row])
            {
                
                
                NSRange range = [hashtagquestion rangeOfString:[NSString stringWithFormat:@"@%@",[objectvalue objectForKey:@"username"]] options:NSCaseInsensitiveSearch];
                
                if (range.location != NSNotFound) {
                    
                    [str addAttribute:CCHLinkAttributeName value:[NSString stringWithFormat:@"%@",[objectvalue objectForKey:@"id"]] range:range];
                    
                }
                
            }
            questiontext.userInteractionEnabled=YES;
            questiontext.attributedText= str;
            questiontext.linkDelegate = self;
            
            questiontext.linkTextAttributes = @{NSForegroundColorAttributeName : [UIColor blueColor]};
            questiontext.linkTextTouchAttributes = @{NSForegroundColorAttributeName : [UIColor orangeColor],
                                                     NSBackgroundColorAttributeName: [UIColor darkGrayColor]};
            
            
            
            
            
            cell.lbmenuaction.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                                  initWithTarget:self action:@selector(createsubmenuaction:)];
            cell.lbmenuaction.tag=indexPath.row;
            [cell.lbmenuaction addGestureRecognizer:tapGesture];
            
            
            
            
            //categories
            
            //id test =[questionInfo valueForKey:@"categoiesId"];
            // [[questionInfo valueForKey:@"categoiesId"]objectAtIndex:0]
            // NSString* s=[[[questionInfo valueForKey:@"categoiesId"] objectAtIndex:0] objectForKey: @"category_name"];
            
            
            /*  NSString *hashtagquestionview=[questionInfo valueForKey:@"hashtag"];
             if(![hashtagquestionview isEqualToString:@""])
             {
             UILabel *lablehastag=[[UILabel alloc]initWithFrame:CGRectMake(xlabelhastag, yquestionlable, 70,15)];
             xlabelhastag+=lablehastag.frame.size.width+10;
             lablehastag.text=[NSString stringWithFormat:@"%@%@",@"#",hashtagquestionview];
             lablehastag.textColor = [UIColor blueColor];
             
             [lablehastag setFont:[UIFont systemFontOfSize:12]];
             lablehastag.userInteractionEnabled = YES;
             UITapGestureRecognizer *tapGesture =
             [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchtagfriend:)];
             [lablehastag addGestureRecognizer:tapGesture];
             
             [cell.contentView addSubview:lablehastag];
             }
             */
            
            //CGRect frame = cell.questionLabel.frame;
           // frame.size.height = cell.questionLabel.contentSize.height+100;
           // cell.questionLabel.frame = frame;
            //[cell.questionImageView setHidden:YES];
            //cell.questionLabel.frame=CGRectMake(8,130, 400,400);
            
            //cell.lcquestionlabel.constant=frame.size.height+37;
           // cell.questionLabel.numberOfLines=0;
            
            //[cell.userImageView
            
            cell.lbcountview.text=[questionInfo valueForKey:@"viewcount"];
            
            
            NSString *urlString1 = [questionInfo valueForKey:@"userthumb"];
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
            UITapGestureRecognizer *tapGesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popAnswerImageViewProfile:)];
            cell.userImageView.tag=indexPath.row;
            [cell.userImageView setUserInteractionEnabled:YES];
            [cell.userImageView addGestureRecognizer:tapGesture1];
            
            [cell.imflag setHidden:true];
            
            
            UITapGestureRecognizer *tapGesture2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewquestiondetail:)];
            cell.imgComent.tag=indexPath.row;
            [cell.imgComent setUserInteractionEnabled:YES];
            [cell.imgComent addGestureRecognizer:tapGesture2];
            
            cell.imgComentborder.tag=indexPath.row;
            [cell.imgComentborder setUserInteractionEnabled:YES];
            [cell.imgComentborder addGestureRecognizer:tapGesture2];
            
            
            UITapGestureRecognizer *tapGesturenewlike=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(questionLikeBtnActionnew:)];
            tapGesturenewlike.numberOfTapsRequired=1;
            cell.imggood.tag=indexPath.row;
            [cell.imggood addGestureRecognizer:tapGesturenewlike];
            
            
            [cell.imggood setUserInteractionEnabled:YES];
            
            
            
            UITapGestureRecognizer *tapGesturenewlike1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(questionLikeBtnActionnew:)];
            tapGesturenewlike1.numberOfTapsRequired=1;
            cell.imgbordergood.tag=indexPath.row;
            
            [cell.imgbordergood addGestureRecognizer:tapGesturenewlike1];
            
            
            
            [cell.imgbordergood setUserInteractionEnabled:YES];

            
            
            [cell.ReliesLabel setText:@""];
            //Total Answers
            //[cell.totalAnswersLabel setText:[questionInfo valueForKey:@"answercount"]];
            [cell.totalAnswersLabel setText:[NSString stringWithFormat:@"%@",[questionInfo valueForKey:@"answercount"]]];
            
            if([cell.totalAnswersLabel.text isEqualToString:@"0"])
            {
                [cell.totalAnswersLabel setHidden:true];
            }
            
            
            [cell.totalLikeLabel setText:[NSString stringWithFormat:@"%@",[questionInfo valueForKey:@"likecount"]]];
            
            if([cell.totalLikeLabel.text isEqualToString:@"0"])
            {
                [cell.totalLikeLabel setHidden:true];
            }
            
            
            //[cell.totalAnswersLabel
            //User Name
            NSString *user_name=[questionInfo valueForKey:@"name"];
            [cell.userNameBtn setTitle:user_name forState:UIControlStateNormal];
            [cell.userNameBtn addTarget:self action:@selector(profileView:) forControlEvents:UIControlEventTouchUpInside];
            cell.userNameBtn.tag=indexPath.row;
            
            [cell.userNameBtn addTarget:self action:@selector(profileViewQuestion:) forControlEvents:UIControlEventTouchUpInside];
            
            //Question Date
            NSString *timeStampString=[NSString stringWithFormat:@"%@",[questionInfo valueForKey:@"question_date"]];
            /*NSString *dateStr=[[AppDelegate sharedDelegate]localDateFromDate:timeStampString];
             NSString *resultString=[dateStr substringWithRange:NSMakeRange(0, 10)];
             NSString *yearString=[resultString substringWithRange:NSMakeRange(6, 4)];
             NSString *monthString=[resultString substringWithRange:NSMakeRange(3, 2)];
             NSString *date=[resultString substringWithRange:NSMakeRange(0, 2)];
             resultString= [NSString stringWithFormat:@"%@/%@/%@",monthString,date,yearString];
             [cell.dateLabel setText:resultString];
             
             //Time Label
             NSString *resultTime=[dateStr substringWithRange:NSMakeRange(11, dateStr.length-11)];*/
            [cell.dateLabel setText:timeStampString];
            // [cell.timeLabel setText:resultTime];
            
            
            
            /* UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 78.0, cell.frame.size.width,0.5)];
             [lineView setBackgroundColor:[UIColor lightGrayColor]];
             [cell.contentView addSubview:lineView];*/
            
            return cell;
        }
        else
        {
            static NSString *cellIdentifier = @"Cell";
             NoImageQuestionCustomTableViewCell *cell = (NoImageQuestionCustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (cell == nil)
            {
                NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"NoImageQuestionCustomTableViewCell" owner:self options:nil];
                cell=[nib objectAtIndex:0];
                
             
            }
        

            //cell.questionLabel.delegate=self;
            NSArray *questionInfo=[questionArray objectAtIndex:indexPath.row];
            cell.lbcountview.text=[questionInfo valueForKey:@"viewcount"];
            //QuestionImage
            NSString *urlString = [questionInfo valueForKey:@"thumb"];
            if ([urlString rangeOfString:@"http://"].location == NSNotFound)
            {
                urlString = [NSString stringWithFormat:@"http://%@", urlString];
            }
            else
            {
                urlString=@"";
                
            }
            NSURL *imageUrl=[NSURL URLWithString:urlString];
            
            NSString *countImages = [questionInfo valueForKey:@"questionImages"];
            if([countImages isEqualToString:@"0"])
            {
                [cell.lbCountPictures setHidden:true];
            }
            else
            {
                countImages = [NSString stringWithFormat:@"%@ Pictures", countImages];
                cell.lbCountPictures.text=countImages;
            }
            
            
            NSString *hashtagquestion =[NSString stringWithFormat:@"%@",[questionInfo valueForKey:@"question"]];
            
            
            
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
            CCHLinkTextView * questiontext=nil;
            cell.questionLabel.text=hashtagquestion;
            questiontext=(CCHLinkTextView*)cell.questionLabel;
            CGSize textViewSize = [cell.questionLabel sizeThatFits:CGSizeMake(cell.questionLabel.frame.size.width, FLT_MAX)];
            
            
           // questiontext=[[CCHLinkTextView alloc] initWithFrame:CGRectMake(cell.questionLabel.frame.origin.x, cell.questionLabel.frame.origin.y, cell.questionLabel.frame.size.width , textViewSize.height )];
            
            // [questiontext setBackgroundColor:[UIColor blackColor]];
            //cell.questionLabelNoImage.frame=CGRectMake(cell.frame.origin.x +20, 30, cell.frame.size.width - 20, 200);
           
            //[cell insertSubview:questiontext atIndex:0];
            cell.lcquestionlabelheight.constant=textViewSize.height;
            cell.lcviewquestion.constant=cell.lcviewquestion.constant+(textViewSize.height);
            
            //add line
            
            /*  UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,320+ cell.questionLabel.contentSize.height, questionTableView.frame.size.width, 1.0f)];
             [lineView setBackgroundColor:[UIColor lightGrayColor]];
             [cell.contentView addSubview:lineView];
             cell.selectionStyle=UITableViewCellSelectionStyleNone;*/
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            // [cell.questionLabelNoImage removeFromSuperview];
            //[cell.questionLabel removeFromSuperview];
            //  questiontext.layer.zPosition=300;
            // cell.viewquestion.layer.zPosition=500;
            int yquestionlable=cell.questionLabel.frame.origin.y+cell.questionLabel.frame.size.height;
            
            NSRange rangeimagepng = [urlString rangeOfString:@".png" options:NSCaseInsensitiveSearch];
            NSRange rangeimagejpg = [urlString rangeOfString:@".jpg" options:NSCaseInsensitiveSearch];
            //if (range.location != NSNotFound) {
            
            
            [cell.questionImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"name_icon"]];
            [cell.questionImageView setHidden:YES];
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popquestiondetail:)];
            
            UITapGestureRecognizer *tapGesture3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popQuestionImageView:)];
            cell.questionImageView.tag=indexPath.row;
            
            [cell.questionImageView setBackgroundColor:[UIColor blackColor]];
            [cell.questionImageView setUserInteractionEnabled:YES];
            [cell.questionImageView addGestureRecognizer:tapGesture3];
            cell.questionLabel.selectable=YES;
            
            
            questiontext.scrollEnabled=true;
            questiontext.text=hashtagquestion;
            
            //cell.questionLabelNoImage.delegate=self;
            // cell.questionLabelNoImage.text=hashtagquestion;
            
            
            
            
            NSMutableAttributedString * str =  [questiontext.attributedText mutableCopy];
            
            for(id objectvalue in [[questionArray valueForKey:@"hashtagarr"]objectAtIndex:indexPath.row])
            {
                
                
                NSRange range = [hashtagquestion rangeOfString:[NSString stringWithFormat:@"#%@",[objectvalue objectForKey:@"hashtag"]] options:NSCaseInsensitiveSearch];
                
                if (range.location != NSNotFound) {
                    
                    [str addAttribute:CCHLinkAttributeName value:[NSString stringWithFormat:@"#%@",[objectvalue objectForKey:@"hashtag"]] range:range];
                    
                }
                
                
            }
            
            
            for(id objectvalue in [[questionArray valueForKey:@"tagfriends"]objectAtIndex:indexPath.row])
            {
                
                
                NSRange range = [hashtagquestion rangeOfString:[NSString stringWithFormat:@"@%@",[objectvalue objectForKey:@"username"]] options:NSCaseInsensitiveSearch];
                
                if (range.location != NSNotFound) {
                    
                    [str addAttribute:CCHLinkAttributeName value:[NSString stringWithFormat:@"%@",[objectvalue objectForKey:@"id"]] range:range];
                    
                }
                
            }
            questiontext.attributedText= str;
            questiontext.linkDelegate = self;
            
            questiontext.linkTextAttributes = @{NSForegroundColorAttributeName : [UIColor blueColor]};
            questiontext.linkTextTouchAttributes = @{NSForegroundColorAttributeName : [UIColor orangeColor],
                                                     NSBackgroundColorAttributeName: [UIColor darkGrayColor]};
            
            
            
            
            
            cell.lbmenuaction.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                                  initWithTarget:self action:@selector(createsubmenuaction:)];
            cell.lbmenuaction.tag=indexPath.row;
            [cell.lbmenuaction addGestureRecognizer:tapGesture];
            
            
            
            
            //categories
            
            //id test =[questionInfo valueForKey:@"categoiesId"];
            // [[questionInfo valueForKey:@"categoiesId"]objectAtIndex:0]
            // NSString* s=[[[questionInfo valueForKey:@"categoiesId"] objectAtIndex:0] objectForKey: @"category_name"];
            
            
            /*  NSString *hashtagquestionview=[questionInfo valueForKey:@"hashtag"];
             if(![hashtagquestionview isEqualToString:@""])
             {
             UILabel *lablehastag=[[UILabel alloc]initWithFrame:CGRectMake(xlabelhastag, yquestionlable, 70,15)];
             xlabelhastag+=lablehastag.frame.size.width+10;
             lablehastag.text=[NSString stringWithFormat:@"%@%@",@"#",hashtagquestionview];
             lablehastag.textColor = [UIColor blueColor];
             
             [lablehastag setFont:[UIFont systemFontOfSize:12]];
             lablehastag.userInteractionEnabled = YES;
             UITapGestureRecognizer *tapGesture =
             [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchtagfriend:)];
             [lablehastag addGestureRecognizer:tapGesture];
             
             [cell.contentView addSubview:lablehastag];
             }
             */
            
            //CGRect frame = cell.questionLabel.frame;
            // frame.size.height = cell.questionLabel.contentSize.height+100;
            // cell.questionLabel.frame = frame;
            //[cell.questionImageView setHidden:YES];
            //cell.questionLabel.frame=CGRectMake(8,130, 400,400);
            
            //cell.lcquestionlabel.constant=frame.size.height+37;
            // cell.questionLabel.numberOfLines=0;
            
            //[cell.userImageView
            
            NSString *urlString1 = [questionInfo valueForKey:@"userthumb"];
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
            UITapGestureRecognizer *tapGesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popAnswerImageViewProfile:)];
            cell.userImageView.tag=indexPath.row;
            [cell.userImageView setUserInteractionEnabled:YES];
            [cell.userImageView addGestureRecognizer:tapGesture1];
            
            [cell.imflag setHidden:true];
            
            
            UITapGestureRecognizer *tapGesture2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewquestiondetail:)];
            cell.imgComent.tag=indexPath.row;
            [cell.imgComent setUserInteractionEnabled:YES];
            [cell.imgComent addGestureRecognizer:tapGesture2];
            
            cell.imgComentborder.tag=indexPath.row;
            [cell.imgComentborder setUserInteractionEnabled:YES];
            [cell.imgComentborder addGestureRecognizer:tapGesture2];
            
            
            UITapGestureRecognizer *tapGesturenewlike=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(questionLikeBtnActionnew:)];
            tapGesturenewlike.numberOfTapsRequired=1;
            cell.imggood.tag=indexPath.row;
            [cell.imggood addGestureRecognizer:tapGesturenewlike];
            
            
            [cell.imggood setUserInteractionEnabled:YES];
            
            
            
            UITapGestureRecognizer *tapGesturenewlike1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(questionLikeBtnActionnew:)];
            tapGesturenewlike1.numberOfTapsRequired=1;
            cell.imgbordergood.tag=indexPath.row;
            
            [cell.imgbordergood addGestureRecognizer:tapGesturenewlike1];
            
            
            
            [cell.imgbordergood setUserInteractionEnabled:YES];
            
            
            
            [cell.ReliesLabel setText:@""];
            //Total Answers
            //[cell.totalAnswersLabel setText:[questionInfo valueForKey:@"answercount"]];
            [cell.totalAnswersLabel setText:[NSString stringWithFormat:@"%@",[questionInfo valueForKey:@"answercount"]]];
            
            if([cell.totalAnswersLabel.text isEqualToString:@"0"])
            {
                [cell.totalAnswersLabel setHidden:true];
            }
            
            
            [cell.totalLikeLabel setText:[NSString stringWithFormat:@"%@",[questionInfo valueForKey:@"likecount"]]];
            
            if([cell.totalLikeLabel.text isEqualToString:@"0"])
            {
                [cell.totalLikeLabel setHidden:true];
            }
            
            
            //[cell.totalAnswersLabel
            //User Name
            NSString *user_name=[questionInfo valueForKey:@"name"];
            [cell.userNameBtn setTitle:user_name forState:UIControlStateNormal];
            [cell.userNameBtn addTarget:self action:@selector(profileView:) forControlEvents:UIControlEventTouchUpInside];
            cell.userNameBtn.tag=indexPath.row;
            
            [cell.userNameBtn addTarget:self action:@selector(profileViewQuestion:) forControlEvents:UIControlEventTouchUpInside];
            
            //Question Date
            NSString *timeStampString=[NSString stringWithFormat:@"%@",[questionInfo valueForKey:@"question_date"]];
            /*NSString *dateStr=[[AppDelegate sharedDelegate]localDateFromDate:timeStampString];
             NSString *resultString=[dateStr substringWithRange:NSMakeRange(0, 10)];
             NSString *yearString=[resultString substringWithRange:NSMakeRange(6, 4)];
             NSString *monthString=[resultString substringWithRange:NSMakeRange(3, 2)];
             NSString *date=[resultString substringWithRange:NSMakeRange(0, 2)];
             resultString= [NSString stringWithFormat:@"%@/%@/%@",monthString,date,yearString];
             [cell.dateLabel setText:resultString];
             
             //Time Label
             NSString *resultTime=[dateStr substringWithRange:NSMakeRange(11, dateStr.length-11)];*/
            [cell.dateLabel setText:timeStampString];
            // [cell.timeLabel setText:resultTime];
            
            
            
            /* UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 78.0, cell.frame.size.width,0.5)];
             [lineView setBackgroundColor:[UIColor lightGrayColor]];
             [cell.contentView addSubview:lineView];*/
            
            return cell;
        }
        
        
    }
    else
    {
        static NSString *cellIdentifier=@"Cell1";
        UITableViewCell *cell=(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,29.5, questionTableView.frame.size.width, 0.5f)];
            [lineView setBackgroundColor:[UIColor lightGrayColor]];
            [cell.contentView addSubview:lineView];
            cell.textLabel.textColor=[UIColor lightGrayColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text=[categoryArray objectAtIndex:indexPath.row];
        return cell;
        
    }
    
}

-(void) questionLikeBtnActionnew:(UIGestureRecognizer*)recognizer
{
    [self questionLikeBtnAction:recognizer.view];
}

-(void)questionLikeBtnAction:(UIView*)sender
{
    
    NSArray *questionInfo=[questionArray objectAtIndex:sender.tag];
    NSString * likecount=[questionInfo valueForKey:@"likecount"];    //QuestionImage
   // NSString *urlString = [questionInfo valueForKey:@"thumb"];
    
    NSString *likeDislikeStatus=[questionInfo valueForKey:@"like_dislike_status"];
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
        NSString *quesIddd=[questionInfo valueForKey:@"questionId"];
        id array=[[WebServiceSingleton sharedMySingleton]likeAndDislikeQuestions:quesIddd andDislikeValue:@"1"];
        
        [self RefreshData:categoriesId hashtag: self.hashtag ];
        
        
        
        [questionTableView reloadData];
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


-(NSString*) GetCategoryIdByIndex:(NSInteger) index
{
    NSString *categoryname=[categoryArray objectAtIndex:index];
    
    for(id objectvalue in categoryofuserArray)
    {
        if([[objectvalue objectForKey:@"category_name"] isEqualToString:categoryname])
        {
            return [objectvalue objectForKey:@"id"];
        }
    }
    return  @"";
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==categoryTableView)
    {
        searchTextField.text=[categoryArray objectAtIndex:indexPath.row];
        if (indexPath.row==0)
        {
            questionArray=[NSMutableArray arrayWithArray:questionInfoArray];
            
            
            NSPredicate *predicate;
            if ([searchTextStr isEqualToString:@""])
            {
                
            }
            else
            {
                predicate=[NSPredicate predicateWithFormat:@"SELF.question contains [c]%@ or  ",searchTextStr];
                
                
                NSPredicate  *predicate1=[NSPredicate predicateWithFormat:@"SELF.hashtag contains [c]%@",searchTextStr];
                
                
                NSPredicate *predicate2 = [NSCompoundPredicate orPredicateWithSubpredicates:@[predicate1, predicate]];
                
                questionArray=[NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:predicate2]];
                
            }
            
            
        }
        else
        {
            
            if(indexPath.row<=3)
            {
                selectedCategoryStr=[NSString stringWithFormat:@"%ld",(indexPath.row)];
            }
            else
            {
                selectedCategoryStr=[self GetCategoryIdByIndex:(indexPath.row)];
                
            }
            
            
            
            NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF.categoryId contains[c] %@",selectedCategoryStr]; // Creating filter condition
            questionArray=[NSMutableArray arrayWithArray:[questionInfoArray filteredArrayUsingPredicate:filterPredicate]];
            
            NSPredicate *predicate;
            if ([searchTextStr isEqualToString:@""])
            {
                
            }
            else
            {
                predicate=[NSPredicate predicateWithFormat:@"SELF.question contains [c]%@",searchTextStr];
                NSPredicate  *predicate1=[NSPredicate predicateWithFormat:@"SELF.hashtag contains [c]%@",searchTextStr];
                
                
                NSPredicate *predicate2 = [NSCompoundPredicate orPredicateWithSubpredicates:@[predicate1, predicate]];
                
                questionArray=[NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:predicate2]];
                
            }
            
            
            
        }
        
        [questionTableView reloadData];
        [categoryTableView removeFromSuperview];
        
        
        
        
    }
    else
    {
        PostQuestionDetailViewController *postView=[[PostQuestionDetailViewController alloc]init];
        postView.generalQuestionArray=[questionArray objectAtIndex:indexPath.row];
        postView.generalViewValue=9;
        [self.navigationController pushViewController:postView animated:NO];
    }
}
-(void)viewquestiondetail:(UITapGestureRecognizer *)sender
{
    PostQuestionDetailViewController *postView=[[PostQuestionDetailViewController alloc]init];
    postView.generalQuestionArray=[questionArray objectAtIndex:sender.view.tag];
    postView.generalViewValue=9;
    if ([sender.view.superview viewWithTag:2] !=nil) {
        [[sender.view.superview viewWithTag:2] removeFromSuperview];
        
    }
    [self.navigationController pushViewController:postView animated:NO];
    
}
- (void)linkTextView:(CCHLinkTextView *)linkTextView didTapLinkWithValue:(id)value
{
    NSString *strurl= value;
    
    NSRange range = [strurl rangeOfString:@"#" options:NSCaseInsensitiveSearch];
    
    if (range.location != NSNotFound) {
        [self searchtagfriend:strurl];
        
    }
    else
    {
        AddFriendViewController *addFriend=[[AddFriendViewController alloc]init];
        addFriend.friendUserId=strurl;
        [self.navigationController pushViewController:addFriend animated:NO];

    }
    
    
    

}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)url inRange:(NSRange)characterRange
{

    NSString *strurl= [url absoluteString];;
    
    NSRange range = [strurl rangeOfString:@"#" options:NSCaseInsensitiveSearch];
    
    if (range.location != NSNotFound) {
        [self searchtagfriend:strurl];
        
    }
    else
    {
        AddFriendViewController *addFriend=[[AddFriendViewController alloc]init];
        addFriend.friendUserId=strurl;
        [self.navigationController pushViewController:addFriend animated:NO];
        
    }
    
    
    
    
    //[[[UIAlertView alloc]initWithTitle:@"Alert" message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]show];
    return YES;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{   if (tableView==questionTableView)
    {
        
        NSArray *questionInfo=[questionArray objectAtIndex:indexPath.row];
        
        NSString *hashtagquestion =[NSString stringWithFormat:@"%@",[questionInfo valueForKey:@"question"]];
        
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
        CCHLinkTextView *questiontext=[[CCHLinkTextView alloc] initWithFrame:CGRectMake(0, 0, 300, 20 )];
        questiontext.text=hashtagquestion;
        CGSize textViewSize = [questiontext sizeThatFits:CGSizeMake(questiontext.frame.size.width, FLT_MAX)];
        if([self Getishasimage:indexPath.row])
        {
            return 330.0f +textViewSize.height;
        }
        else
        {
            return 80.0f +textViewSize.height;
        }
    }
    else
    {
        return 30.0f;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
