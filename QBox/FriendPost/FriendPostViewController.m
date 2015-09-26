//
//  FriendPostViewController.m
//  QBox
//
//  Created by iApp on 18/07/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

#import "FriendPostViewController.h"
#import "NavigationView.h"
#import "WebServiceSingleton.h"
#import "PostQuestionDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "ActivityView.h"
#import "AppDelegate.h"

#import "GADBannerView.h"
#import "GADRequest.h"
#import "SampleConstants.h"
#import <iAd/iAd.h>
#import "ProgressHUD.h"
#import "CustomTableViewCell.h"


@interface FriendPostViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UIPickerViewDelegate,UIPickerViewDataSource,ActivityViewDelegate,UIGestureRecognizerDelegate,GADBannerViewDelegate,UITextFieldDelegate>
{
    UITableView *questionsTableView;
    NSArray *questionArray;
    NSString *messageString;
    NSArray *filteredArray;
    UIButton *ViewAllBtn;
    UIView *viewPicker;
    NSMutableArray *categoryTblArray;
    ActivityView *activity;
    UIView *questionView;
    UISearchBar *searchBar;
    BOOL isKeyboardUp;
    UIButton *postedFriends;
    NSString *searchTextStr;
    UIView *searchView;
    UITextField *searchTextField;
    
    UITableView *categoryTblView;
    
   }

@end

@implementation FriendPostViewController
@synthesize totalQuesString;

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
    searchTextStr=[[NSString alloc]init];
    categoryTblArray=[NSMutableArray arrayWithObjects:@"All",@"Science",@"Math",@"Arts" ,nil];
    [self createUI];
   
 
    
    UITapGestureRecognizer *recognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyboard)];
    //recognizer.numberOfTapsRequired=1;
    recognizer.delegate=self;
    [self.view addGestureRecognizer:recognizer];
    
    
    self.adBanner=[[GADBannerView alloc]init];
    
    // Need to set this to no since we're creating this custom view.
    self.adBanner.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Note: Edit SampleConstants.h to provide a definition for kSampleAdUnitID
    // before compiling.
    self.adBanner.adUnitID = @"a150bf362eb1333";
    self.adBanner.delegate = self;
    [self.adBanner setRootViewController:self];
    self.adBanner.frame=CGRectMake(0, 0, 320, 80);
       [super viewDidLoad];
    // Do any additional setup after loading the view.
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
-(void)resignKeyboard
{
    [searchBar resignFirstResponder];
    [viewPicker removeFromSuperview];
    [categoryTblView removeFromSuperview];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:questionsTableView] || [touch.view isDescendantOfView:categoryTblView])
    {
        
        // Don't let selections of auto-complete entries fire the
        // gesture recognizer
        return NO;
    }
    
    return YES;
}
-(void) viewWillAppear:(BOOL)animated
{
    
   //[self showActivity];
    //Show Activity Indicator
    [ProgressHUD show:@"Loading..." Interaction:NO];
    [self getFriendsPost];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


- (void)keyboardDidShow: (NSNotification *) notif
{
    isKeyboardUp=YES;
    CGRect questionFrame=questionsTableView.frame;
    
    questionFrame.size.height=questionView.frame.size.height-162;
    questionsTableView.frame=questionFrame;
}


- (void)keyboardDidHide: (NSNotification *) notif
{
    isKeyboardUp=NO;
    CGRect questionFrame=questionsTableView.frame;
    
    questionFrame.size.height=questionView.frame.size.height;
    questionsTableView.frame=questionFrame;
}

//-(void) activityDidAppear
//{
//   [self getFriendsPost];
//}

-(void) getFriendsPost
{
    NSArray *personalDetailArray=[NSArray arrayWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"], nil];
    NSString *userId=[[personalDetailArray valueForKey:@"id"]objectAtIndex:0];
    NSArray *mainArray=[[WebServiceSingleton sharedMySingleton]privateFriendPost:userId];
    NSLog(@"%@",mainArray);
    NSString *success=[[mainArray valueForKey:@"success"]objectAtIndex:0];
    if ([success isEqualToString:@"0"])
    {
        questionArray=nil;
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"No Question at this time" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
    }
    else
    {
        questionArray=[[mainArray valueForKey:@"questions"]objectAtIndex:0];
        filteredArray=[[[mainArray valueForKey:@"questions"]objectAtIndex:0]mutableCopy];
        
        NSString *viewTitle=ViewAllBtn.titleLabel.text;
        NSString *stringValue;
        if ([viewTitle rangeOfString:@"Filter:"].location!=NSNotFound)
        {
            filteredArray=[[mainArray valueForKey:@"questions"]objectAtIndex:0];
            stringValue=[viewTitle substringWithRange:NSMakeRange(7, viewTitle.length-7)];
        }
        else
        {
            
            int intValue=[categoryTblArray indexOfObject:viewTitle];
            NSString *pickerValue=[NSString stringWithFormat:@"%d",(intValue-1)];
            NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF.categoryId contains[c] %@",pickerValue]; // Creating filter condition
            //questionArray=[questionArray filteredArrayUsingPredicate:filterPredicate];
            
            
            
            
            
            filteredArray=[NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:filterPredicate]];
        }
        

        NSString *message=[[mainArray valueForKey:@"message"]objectAtIndex:0];
        messageString=[message substringWithRange:NSMakeRange(0, 2)];
       
        [questionsTableView reloadData];
    }
    
   
    [ProgressHUD dismiss];
   
    
}


-(void) tableViewScrollToTop
{
    NSInteger lastSectionIndex = [questionsTableView numberOfSections] - 1;
    NSInteger lastItemIndex = [questionsTableView numberOfRowsInSection:[[filteredArray valueForKey:@"question"]count]];
    NSIndexPath *pathToLastItem = [NSIndexPath indexPathForItem:lastItemIndex inSection:lastSectionIndex];
    if (filteredArray.count==0)
    {
        
    }
    else
    {
    [questionsTableView scrollToRowAtIndexPath:pathToLastItem atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}


-(void) createUI
{
    //Navigation View
    NavigationView *nav=[[NavigationView alloc]init];
    nav.titleView.text=@"FRIEND'S POSTS";
    [self.view addSubview:nav.navigationView];
    
    
    
    //Custom Search TextField
    searchView=[[UIView alloc]initWithFrame:CGRectMake(5,nav.navigationView.frame.size.height+5, self.view.frame.size.width-10, 30)];
    searchView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    searchView.layer.borderWidth=0.5f;
    searchView.layer.cornerRadius=4.0f;
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
    
    
    //questionsTableView=[[UITableView alloc]init];
    
    
    
    UIButton *backBtn=[[UIButton alloc]init];
    backBtn.frame=CGRectMake(0, 10, 45, 30);
    [backBtn setImage:[UIImage imageNamed:@"back_blue"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    
    questionView=[[UIView alloc]init];
    questionView.backgroundColor=[UIColor lightGrayColor];
    [questionView setFrame:CGRectMake(0, nav.navigationView.frame.size.height+searchView.frame.size.height+10,self.view.frame.size.width,(self.view.frame.size.height-(90+searchView.frame.size.height)))];
    [self.view addSubview:questionView];
    
    questionsTableView=[[UITableView alloc]init];
    //  [questionsTableView setFrame:CGRectMake(0, nav.navigationView.frame.size.height+searchBar.frame.size.height+50, 320, (self.view.frame.size.height-(90+searchBar.frame.size.height+postedFriends.frame.size.height)))];
    
    [questionsTableView setFrame:CGRectMake(0, 0, 320, questionView.frame.size.height)];
    questionsTableView.dataSource=self;
    questionsTableView.delegate=self;
    questionsTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [questionView addSubview:questionsTableView];

    
//    NavigationView *nav=[[NavigationView alloc]init];
//    nav.titleView.text=@"FRIEND'S POSTS";
//    [self.view addSubview:nav.navigationView];
//    
//    searchBar=[[UISearchBar alloc]init];
//    searchBar.frame=CGRectMake(0, 44, 320, 44);
//   
//    
//    //UISearchDisplayController *searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
//   // searchBar.showsCancelButton=YES;
//   // searchDisplayController.delegate = self;
//    searchBar.delegate=self;
//        searchBar.tintColor=[UIColor lightGrayColor];
//    //searchDisplayController.searchResultsDataSource = self;
//    [self.view addSubview:searchBar];
//    
//    UIButton *backBtn=[[UIButton alloc]init];
//    backBtn.frame=CGRectMake(0, 10, 45, 30);
//    [backBtn setImage:[UIImage imageNamed:@"back_blue"] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backBtn];
//    
//    
//    
//    
//    
//   postedFriends=[[UIButton alloc]init];
//    postedFriends.frame=CGRectMake(0, searchBar.frame.origin.y+44, 200, 50);
//   // postedFriends.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:14.0f];
//    [postedFriends setTitle:[NSString stringWithFormat:@"Friend's Questions[%@]",totalQuesString] forState:UIControlStateNormal];
//   // [postedFriends setTitle:@"Posted Friends" forState:UIControlStateNormal];
//    [postedFriends setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    //[postedFriends addTarget:self action:@selector(postedQuestion) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:postedFriends];
//    
//    
//    ViewAllBtn=[[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-125), postedFriends.frame.origin.y+10, 120, 36)];
//    
//    //ViewAllBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0f];
//    [ViewAllBtn setTitle:@"Filter:All" forState:UIControlStateNormal];
//    ViewAllBtn.layer.borderWidth=1.0f;
//    ViewAllBtn.layer.borderColor=[UIColor blackColor].CGColor;
//    ViewAllBtn.layer.cornerRadius=4.0f;
//    
//    [ViewAllBtn addTarget:self action:@selector(ViewAllClick:) forControlEvents:UIControlEventTouchUpInside];
//    [ViewAllBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.view addSubview:ViewAllBtn];
//
//    
//    questionView=[[UIView alloc]init];
//    questionView.backgroundColor=[UIColor lightGrayColor];
//    [questionView setFrame:CGRectMake(0, nav.navigationView.frame.size.height+searchBar.frame.size.height+50, 320, (self.view.frame.size.height-(90+searchBar.frame.size.height+postedFriends.frame.size.height)))];
//    [self.view addSubview:questionView];
//    
//    questionsTableView=[[UITableView alloc]init];
//   
//    questionsTableView.frame=CGRectMake(0, 0, 320, questionView.frame.size.height);
//   
//    questionsTableView.dataSource=self;
//    questionsTableView.delegate=self;
//    [questionView addSubview:questionsTableView];
    
    categoryTblView=[[UITableView alloc]init];
    categoryTblView.frame=CGRectMake(searchView.frame.origin.x, searchView.frame.origin.y+searchView.frame.size.height,searchView.frame.size.width, 120);
    categoryTblView.layer.borderWidth=0.5f;
    categoryTblView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    categoryTblView.layer.cornerRadius=5.0f;
    categoryTblView.dataSource=self;
    categoryTblView.delegate=self;
    categoryTblView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
}

-(void)ViewAllClick:(id) sender
{
    
    if (![searchBar isFirstResponder])
    {
    viewPicker=[[UIView alloc]init];
    [viewPicker setFrame:self.view.bounds];
    [viewPicker setUserInteractionEnabled:YES];
    [self.view addSubview:viewPicker];
    
    [self.view bringSubviewToFront:viewPicker];
    UIPickerView* pickerView=[[UIPickerView alloc]init];
   pickerView.frame=CGRectMake(0, (self.view.frame.size.height-216)/2, 320, 216);
    pickerView.delegate=self;
    pickerView.dataSource=self;
    pickerView.userInteractionEnabled=YES;
    [pickerView setBackgroundColor:[UIColor lightGrayColor]];
    
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

-(void)backClick
{
    //[self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)filterBtn:(id)sender
{
    
    if (![self.view.subviews containsObject:categoryTblView])
    {
         [self.view addSubview:categoryTblView];
    }
   
   
}



#pragma mark Picker View Methods
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

//-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    
//    if (row==0)
//    {
//        //questionArray=[NSMutableArray arrayWithArray:questionArray];
//        filteredArray=[NSMutableArray arrayWithArray:questionArray];
//        
//        [ViewAllBtn setTitle:[NSString stringWithFormat:@"Filter:%@",[categoryTblArray objectAtIndex:row]] forState:UIControlStateNormal];
//          [postedFriends setTitle:[NSString stringWithFormat:@"Friend's Questions[%d]",[filteredArray count]] forState:UIControlStateNormal];
//        
//    }
//    else
//    {
//        NSString *str=[NSString stringWithFormat:@"%ld",(row-1)];
//        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF.categoryId contains[c] %@",str]; // Creating filter condition
//        //questionArray=[questionArray filteredArrayUsingPredicate:filterPredicate];
//        
//        filteredArray = [NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:filterPredicate]];
//        [ViewAllBtn setTitle:[NSString stringWithFormat:@"%@",[categoryTblArray objectAtIndex:row]] forState:UIControlStateNormal];
//        [postedFriends setTitle:[NSString stringWithFormat:@"Friend's Questions[%d]",[filteredArray count]] forState:UIControlStateNormal];
//        // [ViewAllBtn setTitle:[NSString stringWithFormat:@"%@",[categoryTblArray objectAtIndex:row]] forState:UIControlStateNormal];
//        
//        
//    }
//    
//    
//    
//    
//    [questionsTableView reloadData];
//    [viewPicker removeFromSuperview];
//}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (row==0)
    {
        
        filteredArray=[NSMutableArray arrayWithArray:questionArray];
       
        NSPredicate *predicate;
        if ([searchTextStr isEqualToString:@""])
        {
            
        }
        else
        {
            predicate=[NSPredicate predicateWithFormat:@"SELF.question contains [c]%@",searchTextStr];
            filteredArray=[NSMutableArray arrayWithArray:[filteredArray filteredArrayUsingPredicate:predicate]];
        }
      
        
        
        
        
        [ViewAllBtn setTitle:[NSString stringWithFormat:@"Filter:%@",[categoryTblArray objectAtIndex:row]] forState:UIControlStateNormal];
        [postedFriends setTitle:[NSString stringWithFormat:@"Friend's Questions[%lu]",(unsigned long)[filteredArray count]] forState:UIControlStateNormal];
        
    }
    else
    {
        NSString *str=[NSString stringWithFormat:@"%ld",(row-1)];
        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF.categoryId contains[c] %@",str]; // Creating filter condition
        filteredArray=[NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:filterPredicate]];
      
        NSPredicate *predicate;
        if ([searchTextStr isEqualToString:@""])
        {
            
        }
        else
        {
            predicate=[NSPredicate predicateWithFormat:@"SELF.question contains [c]%@",searchTextStr];
            filteredArray=[NSMutableArray arrayWithArray:[filteredArray filteredArrayUsingPredicate:predicate]];
        }
     
        [ViewAllBtn setTitle:[NSString stringWithFormat:@"%@",[categoryTblArray objectAtIndex:row]] forState:UIControlStateNormal];
        [postedFriends setTitle:[NSString stringWithFormat:@"Friend's Questions[%lu]",(unsigned long)[filteredArray count]] forState:UIControlStateNormal];
    }
    [self tableViewScrollToTop];
    [questionsTableView reloadData];
    [viewPicker removeFromSuperview];
}





#pragma mark Table View Methods

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==questionsTableView)
    {
        int count=[filteredArray count];
        return (count+count/10);
    }
    else
    {
        return [categoryTblArray count];
    }
    
   
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==questionsTableView)
    {
    
    static NSString *cellIdentifier=@"CellIdentifier";
    CustomTableViewCell *cell=(CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        //cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 78.0, cell.frame.size.width,2.0)];
        [lineView setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:lineView];
    }
    
    
    
    if (indexPath.row < 11)
    {
        
        if (indexPath.row == 10)
        {
    
    
            [cell.questionImageView setHidden:YES];
            [cell.userNameBtn setHidden:YES];
            [cell.questionLabel setHidden:YES];
            [cell.dateLabel setHidden:YES];
            [cell.timeLabel setHidden:YES];
            [cell.dateImageView setHidden:YES];
            [cell.timeImageView setHidden:YES];
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.adBanner loadRequest:[self createRequest]];
        });
        [cell.contentView addSubview:self.adBanner];
        
        
        
        
    }
    else
    {
        
        [cell.questionImageView setHidden:NO];
        [cell.userNameBtn setHidden:NO];
        [cell.questionLabel setHidden:NO];
        [cell.dateLabel setHidden:NO];
        [cell.timeLabel setHidden:NO];
        [cell.dateImageView setHidden:NO];
        [cell.timeImageView setHidden:NO];
        
         NSInteger index = indexPath.row - indexPath.row/10;

    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
   
        
        
    //Question Image
    NSString *urlString = [[filteredArray objectAtIndex:index] valueForKey:@"thumb"];
    if ([urlString rangeOfString:@"http://"].location == NSNotFound)
    {
        urlString = [NSString stringWithFormat:@"http://%@", urlString];
    }
    NSURL *imageUrl=[NSURL URLWithString:urlString];
    [cell.questionImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"name_icon"]];
 
        
    //Question Label
    [cell.questionLabel setText:[[filteredArray objectAtIndex:index]valueForKey:@"question"]];
  
    
    //Total Answers
    [cell.totalAnswersLabel setText:[NSString stringWithFormat:@"[%@]",[[filteredArray objectAtIndex:index]valueForKey:@"totalAnswers"]]];
   
    //Name Btn
        NSString *user_name=[[filteredArray valueForKey:@"name"]objectAtIndex:index];
    cell.userNameBtn.tag=index;
    [cell.userNameBtn setTitle:user_name forState:UIControlStateNormal];
    [cell.userNameBtn addTarget:self action:@selector(profileView:) forControlEvents:UIControlEventTouchUpInside];
   
     
    //Date Label
    NSString *timeStampString=[NSString stringWithFormat:@"%@",[[filteredArray objectAtIndex:index]valueForKey:@"question_date"]];
    NSString *dateStr=[[AppDelegate sharedDelegate]localDateFromDate:timeStampString];
    NSString *resultString=[dateStr substringWithRange:NSMakeRange(0, 10)];
    [cell.dateLabel setText:resultString];
   
    //Time Label
    NSString *resultTime=[dateStr substringWithRange:NSMakeRange(11, dateStr.length-11)];
    [cell.timeLabel setText:resultTime];
        
    }
    }
    
        
    else if ((indexPath.row + 1) % 11 == 0)
    {
        
        [cell.questionImageView setHidden:YES];
        [cell.userNameBtn setHidden:YES];
        [cell.questionLabel setHidden:YES];
        [cell.dateLabel setHidden:YES];
        [cell.timeLabel setHidden:YES];
        [cell.dateImageView setHidden:YES];
        [cell.timeImageView setHidden:YES];
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.adBanner loadRequest:[self createRequest]];
        });
        [cell.contentView addSubview:self.adBanner];
    }
    else
    {
        
        [cell.questionImageView setHidden:NO];
        [cell.userNameBtn setHidden:NO];
        [cell.questionLabel setHidden:NO];
        [cell.dateLabel setHidden:NO];
        [cell.timeLabel setHidden:NO];
        [cell.dateImageView setHidden:NO];
        [cell.timeImageView setHidden:NO];
        
        NSInteger index = indexPath.row - indexPath.row/10;
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        //Question Image
        NSString *urlString = [[filteredArray objectAtIndex:index] valueForKey:@"thumb"];
        if ([urlString rangeOfString:@"http://"].location == NSNotFound)
        {
            urlString = [NSString stringWithFormat:@"http://%@", urlString];
        }
        NSURL *imageUrl=[NSURL URLWithString:urlString];
        [cell.questionImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"name_icon"]];
        
        
        //Question Label
        [cell.questionLabel setText:[[filteredArray objectAtIndex:index]valueForKey:@"question"]];
        
        
        //Total Answers
        [cell.totalAnswersLabel setText:[NSString stringWithFormat:@"[%@]",[[filteredArray objectAtIndex:index]valueForKey:@"totalAnswers"]]];
        
        //Name Btn
        NSString *user_name=[[filteredArray valueForKey:@"name"]objectAtIndex:index];
        cell.userNameBtn.tag=index;
        [cell.userNameBtn setTitle:user_name forState:UIControlStateNormal];
        [cell.userNameBtn addTarget:self action:@selector(profileView:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //Date Label
        NSString *timeStampString=[NSString stringWithFormat:@"%@",[[filteredArray objectAtIndex:index]valueForKey:@"question_date"]];
        NSTimeInterval _interval=[timeStampString doubleValue];
        NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:_interval];
        NSString *dateStr=[[AppDelegate sharedDelegate]localDateFromDate:timeStampString];
        NSString *resultString=[dateStr substringWithRange:NSMakeRange(0, 10)];
        [cell.dateLabel setText:resultString];
        
        //Time Label
        NSString *resultTime=[dateStr substringWithRange:NSMakeRange(11, dateStr.length-11)];
        [cell.timeLabel setText:resultTime];

    }

    
    
    return cell;
    }
    else
    {
        static NSString *cellIdentifier=@"CellIdentifier";
        UITableViewCell *cell=(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.textLabel.textColor=[UIColor grayColor];
            cell.textLabel.font=TEXTFIELDFONT;
            cell.textLabel.font=[UIFont italicSystemFontOfSize:15.0f];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 29.5, cell.frame.size.width,0.5)];
            [lineView setBackgroundColor:[UIColor lightGrayColor]];
            [cell.contentView addSubview:lineView];
            
            
            
           
        }
        
        cell.textLabel.text=[categoryTblArray objectAtIndex:indexPath.row];
        
        
        return cell;
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==questionsTableView)
    {
    
    
    if (indexPath.row < 11)
    {
        
        if (indexPath.row == 10)
        {
            
        }
        else
        {
            NSInteger index = indexPath.row - indexPath.row/10;
            if (!isKeyboardUp)
            {
                
                
                [searchBar resignFirstResponder];
                PostQuestionDetailViewController *profileView=[[PostQuestionDetailViewController alloc]init];
                NSLog(@"%lu",(unsigned long)filteredArray.count);
                NSLog(@"%ld",(long)indexPath.row);
                NSArray *quesArr=[filteredArray objectAtIndex:index];
                profileView.generalQuestionArray=[NSMutableArray arrayWithObjects:quesArr,messageString, nil];
                profileView.generalViewValue=4;
                profileView.ViewAllTitle=ViewAllBtn.titleLabel.text;
                
                NSString *userId=[[filteredArray valueForKey:@"userId"]objectAtIndex:index];
                profileView.userIdGeneral=userId;
                [self.navigationController pushViewController:profileView animated:NO];
            }
            else
            {
                [searchBar resignFirstResponder];
                [viewPicker removeFromSuperview];
            }

        }
    }
    else if ((indexPath.row + 1) % 11 == 0)
    {
        
    }
    else
    {
        NSInteger index = indexPath.row - indexPath.row/10;
        if (!isKeyboardUp)
        {
            
            
            [searchBar resignFirstResponder];
            PostQuestionDetailViewController *profileView=[[PostQuestionDetailViewController alloc]init];
            NSLog(@"%lu",(unsigned long)filteredArray.count);
            NSLog(@"%ld",(long)indexPath.row);
            NSArray *quesArr=[filteredArray objectAtIndex:index];
            profileView.generalQuestionArray=[NSMutableArray arrayWithObjects:quesArr,messageString, nil];
            profileView.generalViewValue=4;
            profileView.ViewAllTitle=ViewAllBtn.titleLabel.text;
            
            NSString *userId=[[filteredArray valueForKey:@"userId"]objectAtIndex:index];
            profileView.userIdGeneral=userId;
            [self.navigationController pushViewController:profileView animated:NO];
        }
        else
        {
            [searchBar resignFirstResponder];
            [viewPicker removeFromSuperview];
        }
 
    }
    }
    else
    {
        
        searchTextField.text=[categoryTblArray objectAtIndex:indexPath.row];
        
        if (indexPath.row==0)
        {
            
            filteredArray=[NSMutableArray arrayWithArray:questionArray];
            
            NSPredicate *predicate;
            if ([searchTextStr isEqualToString:@""])
            {
                
            }
            else
            {
                predicate=[NSPredicate predicateWithFormat:@"SELF.question contains [c]%@",searchTextStr];
                filteredArray=[NSMutableArray arrayWithArray:[filteredArray filteredArrayUsingPredicate:predicate]];
            }
            
            
            
            
            
//            [ViewAllBtn setTitle:[NSString stringWithFormat:@"Filter:%@",[categoryTblArray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
//            [postedFriends setTitle:[NSString stringWithFormat:@"Friend's Questions[%lu]",(unsigned long)[filteredArray count]] forState:UIControlStateNormal];
            
            
            
        }
        else
        {
            NSString *str=[NSString stringWithFormat:@"%ld",(indexPath.row-1)];
            NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF.categoryId contains[c] %@",str]; // Creating filter condition
            filteredArray=[NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:filterPredicate]];
            
            NSPredicate *predicate;
            if ([searchTextStr isEqualToString:@""])
            {
                
            }
            else
            {
                predicate=[NSPredicate predicateWithFormat:@"SELF.question contains [c]%@",searchTextStr];
                filteredArray=[NSMutableArray arrayWithArray:[filteredArray filteredArrayUsingPredicate:predicate]];
            }
            
//            [ViewAllBtn setTitle:[NSString stringWithFormat:@"%@",[categoryTblArray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
//            [postedFriends setTitle:[NSString stringWithFormat:@"Friend's Questions[%lu]",(unsigned long)[filteredArray count]] forState:UIControlStateNormal];
        }
        [self tableViewScrollToTop];
        [questionsTableView reloadData];
        [categoryTblView removeFromSuperview];
    }
    [categoryTblView removeFromSuperview];
    [searchTextField resignFirstResponder];
    
    
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row!=0  && indexPath.row!=1 && indexPath.row%10 == 1)
//        return 50.0;
    if (tableView==questionsTableView)
    {
        return 80.0f;
    }
    else
    {
        return 30.0f;
    }
    
}

-(void)profileView:(id)sender
{
    NSInteger i=[sender tag];
    UserDetailViewController *userProfile=[[UserDetailViewController alloc]init];
    NSString *userId=[[filteredArray valueForKey:@"userId"]objectAtIndex:i];
    userProfile.messageValue=2;
    userProfile.user_id=userId;
    [self.navigationController pushViewController:userProfile animated:NO];
    
    
    
}

#pragma mark TextField Delegate Methods
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    searchTextStr=string;
    if (string.length==0)
    {
        
        NSString *viewTitle=ViewAllBtn.titleLabel.text;
        NSString *stringValue;
        if ([viewTitle rangeOfString:@"Filter:"].location!=NSNotFound)
        {
            filteredArray=questionArray;
            stringValue=[viewTitle substringWithRange:NSMakeRange(7, viewTitle.length-7)];
        }
        else
        {
            
            int intValue=(int)[categoryTblArray indexOfObject:viewTitle];
            NSString *pickerValue=[NSString stringWithFormat:@"%d",(intValue-1)];
            NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF.categoryId contains[c] %@",pickerValue]; // Creating filter condition
            //questionArray=[questionArray filteredArrayUsingPredicate:filterPredicate];
            filteredArray=[NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:filterPredicate]];
        }
        
        //filteredResults=[NSMutableArray arrayWithArray:questionArray];
        [postedFriends setTitle:[NSString stringWithFormat:@"Friend's Questions[%lu]",(unsigned long)filteredArray.count] forState:UIControlStateNormal];
    }
    else
    {
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF.question contains [c]%@",string];
        //filteredResults=[NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:predicate]];
        filteredArray=[NSMutableArray arrayWithArray:[filteredArray filteredArrayUsingPredicate:predicate]];
        [postedFriends setTitle:[NSString stringWithFormat:@"Friend's Questions[%lu]",(unsigned long)filteredArray.count] forState:UIControlStateNormal];
        NSLog(@"%@",filteredArray);
    }
    [questionsTableView reloadData];
    return YES;
}

#pragma mark Search Bar Delegate Methods
-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    searchTextStr=searchText;
    if (searchText.length==0)
    {
        
        NSString *viewTitle=ViewAllBtn.titleLabel.text;
        NSString *stringValue;
        if ([viewTitle rangeOfString:@"Filter:"].location!=NSNotFound)
        {
            filteredArray=questionArray;
            stringValue=[viewTitle substringWithRange:NSMakeRange(7, viewTitle.length-7)];
        }
        else
        {
            
            int intValue=(int)[categoryTblArray indexOfObject:viewTitle];
            NSString *pickerValue=[NSString stringWithFormat:@"%d",(intValue-1)];
            NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF.categoryId contains[c] %@",pickerValue]; // Creating filter condition
            //questionArray=[questionArray filteredArrayUsingPredicate:filterPredicate];
            filteredArray=[NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:filterPredicate]];
        }
        
        //filteredResults=[NSMutableArray arrayWithArray:questionArray];
        [postedFriends setTitle:[NSString stringWithFormat:@"Friend's Questions[%lu]",(unsigned long)filteredArray.count] forState:UIControlStateNormal];
    }
    else
    {
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF.question contains [c]%@",searchText];
        //filteredResults=[NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:predicate]];
        filteredArray=[NSMutableArray arrayWithArray:[filteredArray filteredArrayUsingPredicate:predicate]];
        [postedFriends setTitle:[NSString stringWithFormat:@"Friend's Questions[%lu]",(unsigned long)filteredArray.count] forState:UIControlStateNormal];
        NSLog(@"%@",filteredArray);
    }
    [questionsTableView reloadData];
    }

//-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    if (searchText.length==0)
//    {
//        filteredArray=[NSMutableArray arrayWithArray:questionArray];
//         [postedFriends setTitle:[NSString stringWithFormat:@"Friend's Questions[%d]",filteredArray.count] forState:UIControlStateNormal];
//    }
//    else
//    {
//    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF.question contains[c] %@",searchText];
//    filteredArray=[NSArray arrayWithArray:[questionArray filteredArrayUsingPredicate:predicate]];
//         [postedFriends setTitle:[NSString stringWithFormat:@"Friend's Questions[%d]",filteredArray.count] forState:UIControlStateNormal];
//    NSLog(@"%@",filteredArray);
//    }
//    [questionsTableView reloadData];
//}
//

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
}

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text=@"";
    filteredArray=[NSMutableArray arrayWithArray:questionArray];
    [questionsTableView reloadData];
    [searchBar resignFirstResponder];
}

-(BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

-(BOOL) searchBarShouldEndEditing:(UISearchBar *)searchBar
{
   
    return YES;
    
}

-(void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
}

-(void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder]; 
}

#pragma mark Activity View

-(void) showActivity
{
    activity = [ActivityView activityView];
    [activity setTitle:@"Loading..."];
    activity.delegate=self;
    [activity setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.9]];
    [activity showBorder];
    [activity showActivityInView:self.view];
    
    activity.center=self.view.center;
    
}

-(void)hideActivity
{
    [activity hideActivity];
}

#pragma  mark Ad View Methods

- (void)adViewDidReceiveAd:(GADBannerView *)adView
{
    NSLog(@"Received ad successfully");
}

- (void)adView:(GADBannerView *)view
didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"Failed to receive ad with error: %@", [error localizedFailureReason]);
}




- (void)didReceiveMemoryWarning
{
    
    [[[SDWebImageManager sharedManager] imageCache] clearDisk];
    [[[SDWebImageManager sharedManager] imageCache] clearMemory];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
