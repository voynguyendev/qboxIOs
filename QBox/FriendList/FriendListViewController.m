//
//  FriendListViewController.m
//  QBox
//
//  Created by iapp on 29/05/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

#import "FriendListViewController.h"
#import "NavigationView.h"
#import "WebServiceSingleton.h"
#import "UIImageView+WebCache.h"
#import "UserDetailViewController.h"
#import "ActivityView.h"n
#import "AddFriendViewController.h"
#import "HomeViewController.h"
#import "IndexBar.h"
#import "SearchFriendsViewController.h"
#import "AppDelegate.h"

@interface FriendListViewController ()<UITableViewDataSource,UITableViewDelegate,ActivityViewDelegate,UITextFieldDelegate>
{
    UITableView *friendsTableView;
    NSMutableArray *friendsData;
    ActivityView *activity;
    UIView *popImageView;
    UIButton  *backImageBtn;
    UITextField *searchTextField;
    NSMutableArray *alphabetArray;
    NSMutableArray *searchFriendsArray;
}

@end

@implementation FriendListViewController

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
    self.navigationController.navigationBarHidden=YES;
    [self createUI];
  
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
}
-(void) viewWillAppear:(BOOL)animated
{
    [self showActivity];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [searchTextField resignFirstResponder];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    

}
-(void)keyboardDidShow:(NSNotification*)notif
{
    //CGSize size=[[notif.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey]CGSizeValue];
    NSDictionary *info = [notif userInfo];
    CGSize size = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect tableFrame=friendsTableView.frame;
    tableFrame.size.height=friendsTableView.frame.size.height-size.height;
    friendsTableView.frame=tableFrame;
}
-(void)keyboardDidHide:(NSNotification*)notif
{
    NSDictionary *info = [notif userInfo];
    CGSize size = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGRect tableFrame=friendsTableView.frame;
    tableFrame.size.height=friendsTableView.frame.size.height+size.height;
    friendsTableView.frame=tableFrame;
}

-(void) activityDidAppear
{
      [self performSelectorInBackground:@selector(friendList) withObject:nil];
}
-(void) createUI
{
    NavigationView *nav = [[NavigationView alloc] init];
    nav.titleView.text = @"FRIEND LIST";
    [self.view addSubview:nav.navigationView];
    
    searchTextField=[[UITextField alloc]initWithFrame:CGRectMake(10, nav.navigationView.frame.size.height+5,200,40)];
    [searchTextField setPlaceholder:@"Search Filter"];
    searchTextField.delegate=self;
    searchTextField.layer.borderColor=[UIColor lightGrayColor].CGColor;
    searchTextField.layer.borderWidth=0.5f;
    searchTextField.layer.cornerRadius=4.0f;
    searchTextField.font=TEXTFIELDFONT;
    searchTextField.returnKeyType=UIReturnKeySearch;
    searchTextField.font=[UIFont italicSystemFontOfSize:15.0f];
    searchTextField.textColor=[UIColor grayColor];
    
    
    UIImageView *searchImageView=[[UIImageView alloc]init];
    searchImageView.frame=CGRectMake(0,(searchTextField.frame.size.height-25)/2, 25, 25);
    [searchImageView setImage:[UIImage imageNamed:@"search_icon"]];
    searchTextField.leftView=searchImageView;
    searchTextField.leftViewMode=UITextFieldViewModeAlways;
    
    
    UIButton *inviteFriendsBtn=[[UIButton alloc]initWithFrame:CGRectMake(searchTextField.frame.origin.x+searchTextField.frame.size.width+5, searchTextField.frame.origin.y, self.view.frame.size.width-(searchTextField.frame.size.width+30),40)];
    inviteFriendsBtn.layer.cornerRadius=4.0f;
    [inviteFriendsBtn setTitle:@"Search" forState:UIControlStateNormal];
    [inviteFriendsBtn setBackgroundColor:BUTTONCOLOR];
    [inviteFriendsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    inviteFriendsBtn.titleLabel.font=[UIFont fontWithName:@"Avenir" size:12.0f];
    inviteFriendsBtn.titleLabel.font=[UIFont boldSystemFontOfSize:12.0f];
    [inviteFriendsBtn addTarget:self action:@selector(inviteFriendsBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:searchTextField];
    [self.view addSubview:inviteFriendsBtn];
    
    CGFloat tableViewPos=nav.navigationView.frame.size.height+searchTextField.frame.size.height+10;
    CGFloat tableViewHeight=self.view.frame.size.height-(90+searchTextField.frame.size.height+10);
    CGRect tableViewFrame=CGRectMake(0, tableViewPos, self.view.frame.size.width, tableViewHeight);
    
    
    

    friendsTableView=[[UITableView alloc]init];
    friendsTableView.frame=tableViewFrame;
    //friendsTableView.frame=CGRectMake(0, 44, 320, self.view.frame.size.height-90);
    friendsTableView.dataSource=self;
    friendsTableView.delegate=self;
    [self.view addSubview:friendsTableView];
    
    [self loadIndexBar];
}



-(void)loadIndexBar
{
    alphabetArray=[[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#",nil];
    
    
    IndexBar *indexBar=[[IndexBar alloc]initWithFrame:CGRectMake(self.view.frame.size.width-20,friendsTableView.frame.origin.y+5,20,self.view.frame.size.height-(90+searchTextField.frame.size.height+20))  target:self selector:@selector(indexBarClick:) alphabetArray:alphabetArray];
    [self.view addSubview:indexBar];
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
        [friendsTableView reloadData];
        
        
        
    }
}

-(void)inviteFriendsBtn:(id)sender
{
    SearchFriendsViewController *searchFriend=[[SearchFriendsViewController alloc]init];
    searchFriend.searchvalue=searchTextField.text;
    [self.navigationController pushViewController:searchFriend animated:NO];
    
}



-(void) friendList
{
   
   NSArray *personalDetailarray=[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil];
    NSString *userId=[[personalDetailarray valueForKey:@"id"]objectAtIndex:0];
    NSArray *listArray=[[WebServiceSingleton sharedMySingleton]getAllFriendList:userId];
    NSString *status=[[listArray valueForKey:@"status"]objectAtIndex:0];
    if ([status isEqualToString:@"0"])
    {
        UIAlertView *friendsAlert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"No friends at this time" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [friendsAlert show];
        friendsData=nil;
    }
    else
    {
    NSArray *mainArray=[[listArray valueForKey:@"data"]objectAtIndex:0];
    
  
    friendsData=[[NSMutableArray alloc]init];
    
    for (id arrayFr in mainArray)
    {
        if ([[arrayFr valueForKey:@"id"]isEqualToString:userId])
        {
            
            
        }
        else
        {
            [friendsData addObject:arrayFr];
        }
    }
        
        searchFriendsArray=friendsData;
        
        
    
    NSLog(@"%@",friendsData);
    

    [friendsTableView reloadData];
    }
    
    [self hideActivity];
     
    
}

- (void)didReceiveMemoryWarning
{
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Table View Methods

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[friendsData valueForKey:@"name"]count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"Cell";
    UITableViewCell *cell=(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if ([cell.contentView subviews])
    {
        for (UIView *subview in [cell.contentView subviews]) {
            [subview removeFromSuperview];
        }
    }

    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
  
    //userImageStr=[[friendsData valueForKey:@"profile_pic"]objectAtIndex:indexPath.row];
    
    UIImageView *nameImg=[[UIImageView alloc]init];
    nameImg.frame=CGRectMake(10, 5, 30, 30);
    NSString *urlString=[[friendsData valueForKey:@"thumb"]objectAtIndex:indexPath.row];
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
//              [nameImg setUserInteractionEnabled:YES];
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
    
    

   // [nameImg setImage:[UIImage imageNamed:@"name_icon"]];
    [cell.contentView addSubview:nameImg];
    
    UILabel *nameLbl=[[UILabel alloc]init];
    nameLbl.text=[[friendsData valueForKey:@"name"]objectAtIndex:indexPath.row];
    nameLbl.frame=CGRectMake(nameImg.frame.size.width+30, 0, 100, 30);
    nameLbl.font=[UIFont fontWithName:@"Helvetica" size:14.0f];
    [cell.contentView addSubview:nameLbl];
    
    //show status text for user
    ////UILabel *statusLbl=[[UILabel alloc]init];
    //statusLbl.text = [[friendsData valueForKey:@"StatusText"]objectAtIndex:indexPath.row];
    //statusLbl.frame=CGRectMake(nameImg.frame.size.width+30, 15, 150, 30);
    //statusLbl.font=[UIFont fontWithName:@"Helvetica" size:12.0f];
    //[cell.contentView addSubview:statusLbl];
    
    UILabel *emailLbl=[[UILabel alloc]init];
    emailLbl.text=[[friendsData valueForKey:@"email"]objectAtIndex:indexPath.row];
    emailLbl.frame=CGRectMake(nameLbl.frame.origin.x, 20, 150, 30);
    emailLbl.font=[UIFont fontWithName:@"Helvetica" size:12.0f];
    [cell.contentView addSubview:emailLbl];

    return cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Care
    /*
    NSString *userId=[[friendsData valueForKey:@"id"]objectAtIndex:indexPath.row];
    HomeViewController *addFriend=[[HomeViewController alloc]init];
    addFriend.friendID=userId;
    [self.navigationController pushViewController:addFriend animated:NO];
    */
    
//    AddFriendViewController *addFriend=[[AddFriendViewController alloc]init];
//    addFriend.friendUserId=[[friendsData valueForKey:@"id"]objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:addFriend animated:NO];
    
    [[AppDelegate sharedDelegate].TabBarView gotoFriendProfileScreenWithFriendID:[[friendsData valueForKey:@"id"]objectAtIndex:indexPath.row]];
    
   
//    [self userDetailData:indexPath.row];
//    NSString *userId=[[friendsData valueForKey:@"id"]objectAtIndex:indexPath.row];
//   NSArray *mainArray=[[WebServiceSingleton sharedMySingleton]getUserInfo:userId];
//    NSArray *UserDetailArray=[[mainArray valueForKey:@"userdata"]objectAtIndex:0];
//    UserDetailViewController *userDetail=[[UserDetailViewController alloc]init];
//    userDetail.personalDetailarray=UserDetailArray;
//    userDetail.messageValue=1;
//    [self.navigationController pushViewController:userDetail animated:NO];
}

#pragma mark TextField Delegate Methods
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
    
    
    if ([string isEqualToString:@""])
    {
        friendsData=searchFriendsArray;
    }
    else
    {
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",string];
        friendsData=[searchFriendsArray filteredArrayUsingPredicate:predicate].mutableCopy;
        
    }
    
   
   
    [friendsTableView reloadData];
    
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [searchTextField resignFirstResponder];
    return YES;
}

-(void) userDetailData:(int) rowValue
{
    NSString *userId=[[friendsData valueForKey:@"id"]objectAtIndex:rowValue];
    NSArray *mainArray=[[WebServiceSingleton sharedMySingleton]getUserInfo:userId];
    NSArray *UserDetailArray=[[mainArray valueForKey:@"userdata"]objectAtIndex:0];
    UserDetailViewController *userDetail=[[UserDetailViewController alloc]init];
    userDetail.personalDetailarray=UserDetailArray;
    userDetail.messageValue=1;
    [self.navigationController pushViewController:userDetail animated:NO];
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
