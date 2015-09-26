//
//  SearchFriendsViewController.m
//  QBox
//
//  Created by iApp on 6/23/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

#import "SearchFriendsViewController.h"
#import "NavigationView.h"
#import "InviteViewController.h"
#import "UIImageView+WebCache.h"
#import "UserDetailViewController.h"
#import "WebServiceSingleton.h"
#import "ActivityView.h"
#import "IndexBar.h"
#import "AddFriendViewController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"


@interface SearchFriendsViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,ActivityViewDelegate,UITextFieldDelegate>
{
    NSArray *personalDetailarray;
    NSMutableArray *friendsData;
    UIButton *backBtn;
    UIView *viewFriends;
    UIAlertView *rejectAlert;
    UITableView *friendsList;
    UIAlertView *acceptAlert;
    ActivityView *activity;
    UIAlertView *acceptRequestAlert;
    UIAlertView *rejectRequestAlert;
    UIAlertView *inviteFriendAlert;
    NSArray *mainArray;
    NSMutableArray *searchData;
    NSString *alertText;
    int requestValue;
    int friendsValue;
    
    UIButton *correctBtn;
    UIView *popImageView;
    UIButton *backImageBtn;
    NavigationView *nav;
    int navValue;
    int searchValue;
    
    NSMutableArray *searchFriendsArray;
    UITextField *searchTextField;
    
    NSMutableArray *alphabetArray;
    
    
}

@end

@implementation SearchFriendsViewController
@synthesize UserDetailArray;
@synthesize searchData;
@synthesize  friendsValue;
@synthesize searchvalue;

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
    searchValue=0;
    
    alertText=[[NSString alloc]init];
    
    searchFriendsArray=[[NSMutableArray alloc]init];
   
    self.navigationController.navigationBarHidden=YES;
   nav=[[NavigationView alloc]init];
    ///alertText=searchvalue;
    if (navValue==0)
    {
         nav.titleView.text=@"INVITE FRIENDS";
    }
    else
    {
        nav.titleView.text=@"FRIEND REQUESTS";
    }
  
  
   // alertText=searchvalue;
   friendsValue=1;
    [self.view addSubview:nav.navigationView];
    
    
    [self createUI];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [searchTextField resignFirstResponder];
    
    if (searchValue==1)
    {
        [self searchUser];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillShowNotification object:nil];
    
    if([searchvalue isEqualToString:@""]!=true)
    {
    
      [self inviteFriendsBtn:nil];
    }
 
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(void)keyboardWillShow:(NSNotification*)notif
{
    NSDictionary *info = [notif userInfo];
    CGSize size = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGRect tableFrame=friendsList.frame;
    tableFrame.size.height=friendsList.frame.size.height-size.height;
    friendsList.frame=tableFrame;
    
    
}
-(void)keyboardWillHide:(NSNotification*)notif
{
    NSDictionary *info = [notif userInfo];
    CGSize size = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGRect tableFrame=friendsList.frame;
    tableFrame.size.height=friendsList.frame.size.height+size.height;
    friendsList.frame=tableFrame;
}

- (void)didReceiveMemoryWarning
{
    [[[SDWebImageManager sharedManager] imageCache] clearDisk];
    [[[SDWebImageManager sharedManager] imageCache] clearMemory];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) createUI
{
    //UIButton *SearchFriends=[[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-150)/2, 50, 150, 50)];
   /* UIButton *SearchFriends=[[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-150)/2,100, 150, 30.0)];
    //loginButton.frame = CGRectMake((self.view.frame.size.width-150)/2,100, 150, 30.0);
    //registerButton.frame = CGRectMake((self.view.frame.size.width-150)/2,200, 150, 30.0);
    [SearchFriends setTitle:@"Search Friends" forState:UIControlStateNormal];
    [SearchFriends setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    SearchFriends.titleLabel.textAlignment=NSTextAlignmentCenter;
    SearchFriends.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:14.0f];
    [SearchFriends setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];

    [SearchFriends addTarget:self action:@selector(searchFriends) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:SearchFriends];
    
    
    //UIButton *viewfriendsBtn=[[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-150)/2, 120, 150,50)];
      UIButton *viewfriendsBtn=[[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-150)/2,200, 150, 30.0)];
    
    [viewfriendsBtn setTitle:@"Friend Requests" forState:UIControlStateNormal];
    [viewfriendsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    viewfriendsBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    viewfriendsBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:14.0f];
    [viewfriendsBtn setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];

    [viewfriendsBtn addTarget:self action:@selector(viewFriends) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:viewfriendsBtn];*/
    [self viewFriends];
}



#pragma mark Action Methods

-(void) searchFriends
{
    
//  inviteFriendAlert=[[UIAlertView alloc]initWithTitle:@"Search Friends" message:@"Please type your friend email address to send an invite" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Search", nil];
//    inviteFriendAlert.alertViewStyle=UIAlertViewStylePlainTextInput;
//
//    [inviteFriendAlert show];
    
    requestValue=0;
    friendsValue=1;
    
    [self viewFriends];
}


-(void) viewFriends
{
    
    viewFriends=[[UIView alloc]init];
    
    viewFriends.frame=CGRectMake(0, 0, 320, self.view.frame.size.height-90);
    
  
    
    CGFloat tableViewPos;
    CGFloat tableViewHeight;
    CGRect tableViewFrame;
    friendsList=[[UITableView alloc]init];
 
    
    
    
    if (friendsValue==0)
    {
         [self friendWebservice];
          navValue=1;
        nav=[[NavigationView alloc]init];
        nav.titleView.text=@"FRIEND REQUESTS";
        
        [self.view addSubview:nav.navigationView];
        tableViewPos=nav.navigationView.frame.size.height;
        tableViewHeight=self.view.frame.size.height-(90+searchTextField.frame.size.height);
        tableViewFrame=CGRectMake(0, tableViewPos, self.view.frame.size.width, tableViewHeight);
        friendsList.frame=tableViewFrame;
        
        [self.view addSubview:viewFriends];
        [viewFriends addSubview:friendsList];
       
      
    }
    else
    {
        [self searchUser];
        nav.titleView.text=@"SEARCH FRIENDS";
        
        searchTextField=[[UITextField alloc]initWithFrame:CGRectMake(10, nav.navigationView.frame.size.height+5,self.view.frame.size.width-20,40)];
        [searchTextField setPlaceholder:@"Search Filter"];
        searchTextField.delegate=self;
        searchTextField.layer.borderColor=[UIColor lightGrayColor].CGColor;
        searchTextField.layer.borderWidth=0.5f;
        searchTextField.layer.cornerRadius=4.0f;
        searchTextField.font=TEXTFIELDFONT;
        searchTextField.returnKeyType=UIReturnKeySearch;
        searchTextField.font=[UIFont italicSystemFontOfSize:15.0f];
        searchTextField.textColor=[UIColor grayColor];
        searchTextField.text=searchvalue;
        
        UIImageView *searchImageView=[[UIImageView alloc]init];
        searchImageView.frame=CGRectMake(0,(searchTextField.frame.size.height-25)/2, 25, 25);
        [searchImageView setImage:[UIImage imageNamed:@"search_icon"]];
        searchTextField.leftView=searchImageView;
        searchTextField.leftViewMode=UITextFieldViewModeAlways;
        
        
        UIButton *inviteFriendsBtn=[[UIButton alloc]initWithFrame:CGRectMake(searchTextField.frame.origin.x+searchTextField.frame.size.width+5, searchTextField.frame.origin.y, self.view.frame.size.width-(searchTextField.frame.size.width+30),40)];
        inviteFriendsBtn.layer.cornerRadius=4.0f;
        [inviteFriendsBtn setTitle:@"Invite Friends" forState:UIControlStateNormal];
        [inviteFriendsBtn setBackgroundColor:BUTTONCOLOR];
        [inviteFriendsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        inviteFriendsBtn.titleLabel.font=[UIFont fontWithName:@"Avenir" size:12.0f];
        inviteFriendsBtn.titleLabel.font=[UIFont boldSystemFontOfSize:12.0f];
        [inviteFriendsBtn addTarget:self action:@selector(inviteFriendsBtn:) forControlEvents:UIControlEventTouchUpInside];
        

        [viewFriends addSubview:searchTextField];
       // [viewFriends addSubview:inviteFriendsBtn];
        
         tableViewPos=nav.navigationView.frame.size.height+searchTextField.frame.size.height+10;
         tableViewHeight=self.view.frame.size.height-(90+searchTextField.frame.size.height+10);
         tableViewFrame=CGRectMake(0, tableViewPos, self.view.frame.size.width, tableViewHeight);
         friendsList.frame=tableViewFrame;
         [self.view addSubview:viewFriends];
         [viewFriends addSubview:friendsList];
         [self loadIndexBar];
        
        
    }
    
   
    
   
   // friendsList.frame=CGRectMake(0,tableViewPos,self.view.frame.size.width,tableViewHeight);
    friendsList.dataSource=self;
    friendsList.delegate=self;
   
    
    
    
    backBtn=[[UIButton alloc]init];
    backBtn.frame=CGRectMake(0, 10, 45,30);
    [backBtn setImage:[UIImage imageNamed:@"back_blue"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
   
    
    
 

  
  
   
    
    
   
    
    
    
}


-(void)loadIndexBar
{
    alphabetArray=[[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#",nil];
    
    
    IndexBar *indexBar=[[IndexBar alloc]initWithFrame:CGRectMake(self.view.frame.size.width-20,friendsList.frame.origin.y+5,20,self.view.frame.size.height-(90+searchTextField.frame.size.height+20))  target:self selector:@selector(indexBarClick:) alphabetArray:alphabetArray];
    [viewFriends addSubview:indexBar];
    [indexBar setBackgroundColor:[[UIColor lightGrayColor]colorWithAlphaComponent:0.5]];
}

-(void)indexBarClick:(id)sender
{
    NSString  *indexBarTitle=[sender currentTitle];
    if([alphabetArray containsObject:indexBarTitle])
     {

         NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",indexBarTitle];
         friendsData=[searchFriendsArray filteredArrayUsingPredicate:predicate].mutableCopy;
         if (friendsData.count==0)
         {
             friendsData=searchFriendsArray;
         }
         [friendsList reloadData];
     }
}



-(void) friendWebservice
{
    
    NSLog(@"%@",friendsData);
    
    
    personalDetailarray=[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil];
    NSString *userID=[[personalDetailarray valueForKey:@"id"]objectAtIndex:0];
    NSArray *DataArray=[[WebServiceSingleton sharedMySingleton]getAllFriendRequest:userID];
    if (DataArray==nil)
    {
        UIAlertView *alertFriend=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"No Friend Request at this time" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertFriend show];
    }
    friendsData=[[NSMutableArray alloc]init];
   
    
    NSLog(@"%@",friendsData);
    
    // NSArray *friend=[DataArray objectAtIndex:i];
    //    for (int i=0; i<[DataArray count]; i++)
    //    {
    //        NSArray *arrFriend=[DataArray objectAtIndex:i];
    //        if (![[arrFriend valueForKey:@"sender_id"]isEqualToString:userID])
    //        {
    //            [friendsData addObject:arrFriend];
    //        }
    //    }
    
    
    for (NSArray *arrFriend in DataArray)
    {
        if (![[arrFriend valueForKey:@"sender_id"]isEqualToString:userID])
        {
            [friendsData addObject:arrFriend];
        }
    }
    NSLog(@"%@",friendsData);
    
    NSMutableArray *searchArray=[[NSMutableArray alloc]init];
    [searchArray addObject:friendsData];
    
}





-(void)backBtn:(id) sender
{
   
    nav.titleView.text=@"INVITE FRIENDS";
    [viewFriends removeFromSuperview];
    [backBtn removeFromSuperview];
    friendsValue=0;
    [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)inviteFriendsBtn:(id)sender
{
    [searchTextField resignFirstResponder];
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchTextField.text];
    friendsData=[searchFriendsArray filteredArrayUsingPredicate:predicate].mutableCopy;
    [friendsList reloadData];
    
    
    
}

#pragma mark Table View Methods
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return[[friendsData valueForKey:@"name"]count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"Cell";
    UITableViewCell *cell=(UITableViewCell*) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if ([cell.contentView subviews])
    {
        for (UIView *subview in [cell.contentView subviews]) {
            [subview removeFromSuperview];
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    UIImageView *nameImg=[[UIImageView alloc]init];
    nameImg.frame=CGRectMake(10, 5, 30, 30);
    NSString *urlString=[[friendsData valueForKey:@"profile_pic"]objectAtIndex:indexPath.row];
    
     if (!urlString.length==0)
     {
        if (![urlString isEqualToString:@"108.175.148.221/question_app_test/uploads/thumbs/"])
        {
            if ([urlString rangeOfString:@"http:"].location==NSNotFound)
            {
                urlString=[NSString stringWithFormat:@"http:\%@",urlString];
            }
            NSURL *imageUrl=[NSURL URLWithString:urlString];
            
            [nameImg setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"name_icon"]];
//            UITapGestureRecognizer *tapGestureImage=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popImageView:)];
//            tapGestureImage.numberOfTapsRequired=1;
//            [nameImg setUserInteractionEnabled:YES];
//            nameImg.tag=indexPath.row;
//            [nameImg addGestureRecognizer:tapGestureImage];
            
            
        }
        
        else
        {
        [nameImg setImage:[UIImage imageNamed:@"name_icon"]];

        }
    }
    else
    {
             [nameImg setImage:[UIImage imageNamed:@"name_icon"]];
    }

   
    [cell.contentView addSubview:nameImg];
    
    UILabel *nameLbl=[[UILabel alloc]init];
    nameLbl.text=[[friendsData valueForKey:@"name"]objectAtIndex:indexPath.row];
    nameLbl.frame=CGRectMake(nameImg.frame.size.width+30, 0, 100, 30);
    nameLbl.font=[UIFont fontWithName:@"Helvetica" size:14.0f];
    [cell.contentView addSubview:nameLbl];

    
    UILabel *statusLbl=[[UILabel alloc]init];
    statusLbl.text  = [[friendsData valueForKey:@"StatusText"]objectAtIndex:indexPath.row];
    statusLbl.frame=CGRectMake(nameImg.frame.size.width+30, 15, 150, 30);
    statusLbl.font=[UIFont fontWithName:@"Helvetica" size:12.0f];
    [cell.contentView addSubview:statusLbl];

    
    UILabel *emailLbl=[[UILabel alloc]init];
    emailLbl.text=[[friendsData valueForKey:@"email"]objectAtIndex:indexPath.row];
    emailLbl.frame=CGRectMake(nameLbl.frame.origin.x, 30, 150, 30);
    emailLbl.font=[UIFont fontWithName:@"Helvetica" size:12.0f];
    [cell.contentView addSubview:emailLbl];
    
    correctBtn=[[UIButton alloc]init];
    correctBtn.frame=CGRectMake(emailLbl.frame.origin.x+emailLbl.frame.size.width+30, 10, 25, 25);
    
    
    correctBtn.tag=indexPath.row;
    [cell.contentView addSubview:correctBtn];
    
   // UIButton *errorBtn=[[UIButton alloc]init];
    //errorBtn.frame=CGRectMake(correctBtn.frame.origin.x+30, 10, 25, 25);
    //[errorBtn setBackgroundImage:[UIImage imageNamed:@"error"] forState:UIControlStateNormal];
    //[errorBtn addTarget:self action:@selector(rejectRequest:) forControlEvents:UIControlEventTouchUpInside];
    //errorBtn.tag=indexPath.row;
    //[cell.contentView addSubview:errorBtn];
    
    if (friendsValue==1)
    {
        NSString *pastRequest=[[friendsData valueForKey:@"pastRequest"]objectAtIndex:indexPath.row];
        int pastValue=[pastRequest integerValue];
        NSString *friendStatus=[[friendsData valueForKey:@"friendStatus"]objectAtIndex:indexPath.row];
        int friendValue=[friendStatus integerValue];
        if (pastValue==0)
        {
            [correctBtn setBackgroundImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
            [correctBtn addTarget:self action:@selector(acceptRequest:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            if (friendValue==0)
            {
              [correctBtn setBackgroundImage:[UIImage imageNamed:@"right1"] forState:UIControlStateNormal];
            }
            else
            {
                
            }
            
        }
    }
    else
    {
        [correctBtn setBackgroundImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
        [correctBtn addTarget:self action:@selector(acceptRequest:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
   
    
    
    return cell;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Care
    /*
    HomeViewController *homeView=[[HomeViewController alloc]init];
    //Search Friends
    NSString *userId;
    if (friendsValue==0)
    {
     userId=[[friendsData valueForKey:@"sender_id"]objectAtIndex:indexPath.row];
    }
    else
    {
     userId=[[friendsData valueForKey:@"id"]objectAtIndex:indexPath.row];
    }
    
    
    homeView.friendID=userId;
    [self.navigationController pushViewController:homeView animated:NO];
    
    */
    
//    AddFriendViewController *addFriend=[[AddFriendViewController alloc]init];
//    addFriend.friendUserId=[[friendsData valueForKey:@"id"]objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:addFriend animated:NO];
    
    [[AppDelegate sharedDelegate].TabBarView gotoFriendProfileScreenWithFriendID:[[friendsData valueForKey:@"id"]objectAtIndex:indexPath.row]];
    
//    
   /* UserDetailViewController *userDetail=[[UserDetailViewController alloc]init];
    NSLog(@"%@",friendsData);
    NSString *userID;
    if (friendsValue==0)
    {
           userID=[[friendsData valueForKey:@"sender_id"]objectAtIndex:indexPath.row];
           userDetail.messageValue=2;
        
    }
    else
    {
         userID=[[friendsData valueForKey:@"id"]objectAtIndex:indexPath.row];
         userDetail.messageValue=2;
    }

    
 

    
    NSArray *detailArray=[[WebServiceSingleton sharedMySingleton]getUserInfo:userID];
 
    UserDetailArray=[[detailArray valueForKey:@"userdata"]objectAtIndex:0];
    NSLog(@"%@",UserDetailArray);
 
    userDetail.personalDetailarray=UserDetailArray;
   
    userDetail.user_id=userID;
    [self.navigationController pushViewController:userDetail animated:NO];*/
    
    
    
//    NSLog(@"%@",searchData);
//    NSString *userID=[[searchData valueForKey:@"id"]objectAtIndex:indexPath.row];
//    
//    
//    NSArray *UserDetailArray=[[WebServiceSingleton sharedMySingleton]getUserInfo:userID];
//    
//    //UserDetailArray=[dic objectForKey:@"userdata"];
//    NSLog(@"%@",UserDetailArray);
//    
//    UserDetailViewController *userDetail=[[UserDetailViewController alloc]init];
//    userDetail.personalDetailarray=UserDetailArray;
//    
//    [self.navigationController pushViewController:userDetail animated:NO];
    
    
   
    
}




-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}



-(void) popImageView:(UIGestureRecognizer*)recognizer
{
    //[textView resignFirstResponder];
    popImageView=[[UIView alloc]init];
    popImageView.frame=CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44);
    [popImageView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:popImageView];
    UIImageView *ImagePostQuestion=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, popImageView.frame.size.width, popImageView.frame.size.height)];
    [popImageView addSubview:ImagePostQuestion];
    // NSInteger i=
    
    NSString *userImageStr=[[friendsData valueForKey:@"profile_pic"]objectAtIndex:recognizer.view.tag];
    
    if ([userImageStr rangeOfString:@"http://"].location == NSNotFound)
    {
        userImageStr = [NSString stringWithFormat:@"http://%@", userImageStr];
    }
    NSString *thumbUrlString=[[friendsData valueForKey:@"thumb"]objectAtIndex:recognizer
                              .view.tag];
    
    NSURL *imageUrl=[NSURL URLWithString:userImageStr];
    NSURL *thumbUrl=[NSURL URLWithString:thumbUrlString];
    UIImage *thumbImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:thumbUrl]];
    if (imageUrl)
    {
        [ImagePostQuestion setImageWithURL:imageUrl placeholderImage:thumbImage];
    }
    else
    {
        
    }
    
    
    
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureDetected:)];
    
    [popImageView addGestureRecognizer:pinchGestureRecognizer];
    
    
    backImageBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 10, 45, 30)];
    [backImageBtn setImage:[UIImage imageNamed:@"back_blue"] forState:UIControlStateNormal];
    [backImageBtn addTarget:self action:@selector(backImageView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backImageBtn];
    
    
}

-(void) backImageView
{
    [popImageView removeFromSuperview];
    [backImageBtn removeFromSuperview];
    
}

-(void)pinchGestureDetected:(UIPinchGestureRecognizer*)recognizer
{
    UIGestureRecognizerState state=[recognizer state];
    if (state==UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGFloat scale = [recognizer scale];
        [recognizer.view setTransform:CGAffineTransformScale(recognizer.view.transform, scale, scale)];
        [recognizer setScale:1.0];
        
    }
    
}





-(void) searchUser
{
    mainArray=[[WebServiceSingleton sharedMySingleton]searchUser:alertText];
    NSArray *successArray=[mainArray valueForKey:@"success"];
    friendsData=[[NSMutableArray alloc]init];
    
    int success=[[successArray objectAtIndex:0]integerValue];
    if (success==0)
    {
        UIAlertView *searchAlert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"No user found with this name" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [searchAlert show];
    }
    else
    {
    
    
    
       NSMutableArray *searchArray=[[NSMutableArray alloc]init];
    
   // searchArray=[mainArray objectAtIndex:0];
        searchArray=[[mainArray valueForKey:@"message"]objectAtIndex:0];
    NSLog(@"%@",searchArray);
      personalDetailarray=[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil];
        NSString *user_id=[[personalDetailarray valueForKey:@"id"]objectAtIndex:0];
       
       
//        if ([searchArray count]==1)
//        {
//            
//         NSArray *arr=[searchArray objectAtIndex:0];
//        if ([[arr valueForKey:@"id"]isEqualToString:user_id])
//        {
//                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"You are searching with user name" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//                    [alertView show];
//        }
//        }
        
     
    for (int i=0; i<[searchArray count]; i++)
    {
        NSMutableArray *arrayFr=[searchArray objectAtIndex:i];
       
        
            if ([[arrayFr valueForKey:@"id"]isEqualToString:user_id])
            {
                
//                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"No user found with this name" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//                [alertView show];
            }
            else
            {
            //[searchData addObject:arrayFr];
            [friendsData addObject:arrayFr];
            }
            
       
        
    }
    }
    
    
    if ([friendsData isEqualToArray:[[NSArray alloc]initWithObjects:nil]])
    {

    }
    [friendsList reloadData];
    searchFriendsArray=friendsData;
    searchValue=1;
}

#pragma mark TextField Delegate Methods

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
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
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF.name beginsWith[c] %@",string];
    friendsData=[searchFriendsArray filteredArrayUsingPredicate:predicate].mutableCopy;
    if (friendsData.count==0)
    {
        friendsData=searchFriendsArray;
    }
    [friendsList reloadData];
   
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark webservice Methods

-(void)acceptRequest:(id) sender
{
    [ProgressHUD show:@"Please Wait..." Interaction:NO];
    if (friendsValue==0)
    {
        acceptRequestAlert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Do you want to accept friend request?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [acceptRequestAlert show];
        
        NSInteger i=[sender tag];
        
        acceptRequestAlert.tag=i;
    }
    else
    {
//        acceptRequestAlert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Do you want to send friend request?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
//        [acceptRequestAlert show];
        NSInteger i=[sender tag];
       // acceptRequestAlert.tag=i;
        

        
        personalDetailarray=[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil];
        NSString *senderId=[[personalDetailarray valueForKey:@"id"]objectAtIndex:0];
        NSString *receiverId=[[friendsData valueForKey:@"id"]objectAtIndex:i];
        
        
        
        NSArray *requestArray=[[[WebServiceSingleton sharedMySingleton]sendFriendRequest:senderId receiverId:receiverId]objectAtIndex:0];
        NSString *successArray=[requestArray valueForKey:@"success"];
        if (successArray)
        {
            
            
            int success=[successArray intValue];
            if (success==0)
            {
                //                UIAlertView *msg=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:[successArray objectAtIndex:1] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
                UIAlertView *msg=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"You have already send friend request to this user" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [msg show];
                
                
                
                //correctBtn.tag=requestAlertView.tag;
                //[correctBtn setBackgroundImage:[UIImage imageNamed:@"right1"] forState:UIControlStateNormal];
                
            }
            else
            {
                NSString *message=[requestArray valueForKey:@"message"];
                UIAlertView *msg1=[[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [msg1 show];
                
                
                
                
               // int i=acceptRequestAlert.tag;
                
                NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                NSDictionary *oldDict = (NSDictionary *)[friendsData objectAtIndex:i];
                [newDict addEntriesFromDictionary:oldDict];
                [newDict setObject:@"1" forKey:@"pastRequest"];
                [friendsData replaceObjectAtIndex:i withObject:newDict];
                [friendsList reloadData];
                
                
                
                
                
                
                
                
                
                
            }
        }
        

    }
    
    [ProgressHUD dismiss];
   
  //  }
    
   
    
   
    
}

-(void) rejectRequest:(id) sender
{
    
    if (friendsValue==0)
    {
        rejectRequestAlert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Do you want to reject friend request?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [rejectRequestAlert show];
        
        NSInteger i=[sender tag];
        rejectRequestAlert.tag=i;
    }
    else
    {
        rejectRequestAlert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Do you want to delete user from list?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [rejectRequestAlert show];
        
        NSInteger i=[sender tag];
        rejectRequestAlert.tag=i;
    }
    
   
    
//    [friendsData removeObject:[friendsData objectAtIndex:i]];
//    [friendsList reloadData];
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==rejectAlert)
    {
        if (buttonIndex==0)
        {
            
            [friendsData removeObject:[friendsData objectAtIndex:rejectAlert.tag]];
            [friendsList reloadData];
        }
    }
    else if (alertView==acceptAlert)
    {
        if (buttonIndex==0)
        {
            [friendsData removeObject:[friendsData objectAtIndex:acceptAlert.tag]];
            [friendsList reloadData];
        }
    }
    
    else if (alertView==acceptRequestAlert)
    {
        if (buttonIndex==1)
        {
            if (friendsValue==0)
            {
                [self showActivity];
                requestValue=1;
            }
            else
            {
                [self showActivity];
                requestValue=3;
            }
            
            
        

        }
    }
    else if(alertView==rejectRequestAlert)
    {
        if (buttonIndex==1)
        {
            if (friendsValue==0)
            {
                [self showActivity];
                requestValue=2;
            }
            else
            {
                [self showActivity];
                requestValue=4;
            }
            
         

        }
        

    }
    
    else if (alertView==inviteFriendAlert)
    {
       
        if (buttonIndex==1)
        {
           
            
        alertText=[[alertView textFieldAtIndex:0]text];
            if ([alertText isEqualToString:@""])
            {
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Enter some text" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alertView show];
            }
            else
            {
                requestValue=0;
                friendsValue=1;
             //[self showActivity];
                [self viewFriends];
                
 

               
            }
        }
        

    }
}


-(void) activityDidAppear
{
    
    if (requestValue==0)
    {
        
    
    [self searchUser];
   int success=[[mainArray objectAtIndex:1]integerValue];
    // int success=[[mainArray valueForKey:@"success"]intValue];
    
    if (success==0)
    {
        
    }
    else
    {
        NSLog(@"%@",searchData);
        InviteViewController *inviteView=[[InviteViewController alloc]init];
        inviteView.searchData=searchData;
        [self.navigationController pushViewController:inviteView animated:NO];
        
    }
    }
    else if (requestValue==1)
    {
        personalDetailarray=[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil];
        NSString *receiverId=[[personalDetailarray valueForKey:@"id"]objectAtIndex:0];
        NSString *senderId=[[friendsData valueForKey:@"sender_id"]objectAtIndex:acceptRequestAlert.tag];
        
        
        NSArray *arr=[[WebServiceSingleton sharedMySingleton]acceptRequest:receiverId senderId:senderId pushnotifycationid:@"0"];
        NSString *str=[NSString stringWithFormat:@"%@",[[arr valueForKey:@"message"]objectAtIndex:0]];
        
        acceptAlert=[[UIAlertView alloc]initWithTitle:@"Alert" message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [acceptAlert show];
        acceptAlert.tag=acceptRequestAlert.tag;
        
        
        
    }
    
    else if (requestValue==2)
    {
        personalDetailarray=[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil];
        NSString *receiverId=[[personalDetailarray valueForKey:@"id"]objectAtIndex:0];
        NSString *senderId=[[friendsData valueForKey:@"sender_id"]objectAtIndex:rejectRequestAlert.tag];
        
        
        
        NSArray *arr=[[WebServiceSingleton sharedMySingleton]rejectRequest:receiverId senderId:senderId pushnotifycationid:@"0"];
        NSString *str=[NSString stringWithFormat:@"%@",[[arr valueForKey:@"message"]objectAtIndex:0]];
        
        rejectAlert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [rejectAlert show];
        rejectAlert.tag=rejectRequestAlert.tag;
        
        
//        personalDetailarray=[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil];
//        NSString *receiverId=[[personalDetailarray valueForKey:@"id"]objectAtIndex:0];
//        NSString *senderId=[[friendsData valueForKey:@"sender_id"]objectAtIndex:rejectRequestAlert.tag];
//        
//        
//        
//        NSArray *arr=[[WebServiceSingleton sharedMySingleton]rejectRequest:receiverId senderId:senderId];
//        NSString *str=[NSString stringWithFormat:@"%@",[[arr valueForKey:@"message"]objectAtIndex:0]];
//        
//        rejectAlert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//        [rejectAlert show];
//        rejectAlert.tag=rejectRequestAlert.tag;
    }
    
    else if (requestValue==3)
    {
       personalDetailarray=[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil];
        NSString *senderId=[[personalDetailarray valueForKey:@"id"]objectAtIndex:0];
        NSString *receiverId=[[friendsData valueForKey:@"id"]objectAtIndex:acceptRequestAlert.tag];
        
        
        
        NSArray *requestArray=[[[WebServiceSingleton sharedMySingleton]sendFriendRequest:senderId receiverId:receiverId]objectAtIndex:0];
        NSString *successArray=[requestArray valueForKey:@"success"];
        if (successArray)
        {
            
            
            int success=[successArray intValue];
            if (success==0)
            {
                //                UIAlertView *msg=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:[successArray objectAtIndex:1] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
                UIAlertView *msg=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"You have already send friend request to this user" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [msg show];
                
                
                
                //correctBtn.tag=requestAlertView.tag;
                //[correctBtn setBackgroundImage:[UIImage imageNamed:@"right1"] forState:UIControlStateNormal];
                
            }
            else
            {
                NSString *message=[requestArray valueForKey:@"message"];
                UIAlertView *msg1=[[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [msg1 show];
                
              
          
                
                int i=acceptRequestAlert.tag;
                
                NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                NSDictionary *oldDict = (NSDictionary *)[friendsData objectAtIndex:i];
                [newDict addEntriesFromDictionary:oldDict];
                [newDict setObject:@"1" forKey:@"pastRequest"];
                [friendsData replaceObjectAtIndex:i withObject:newDict];
                [friendsList reloadData];
                
                
                
               
               

                
                
                
                
            }
        }

    }
    
    else if (requestValue==4)
    {
       
            [friendsData removeObject:[friendsData objectAtIndex:rejectRequestAlert.tag]];
            [friendsList reloadData];
    }
    [self hideActivity];

}





#pragma mark Activity View


-(void) showActivity
{
    activity = [ActivityView activityView];
    [activity setTitle:@"Loading..."];
   [activity setDelegate:self];
    [activity setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.9]];
    [activity showBorder];
    [activity showActivityInView:self.view];
    activity.center = self.view.center;
}

-(void)hideActivity
{
    [activity hideActivity];
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
