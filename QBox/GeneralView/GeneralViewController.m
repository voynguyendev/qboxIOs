//
//  GeneralViewController.m
//  QBox
//
//  Created by iapp1 on 7/11/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

#import "GeneralViewController.h"
#import "NavigationView.h"
#import "WebServiceSingleton.h"
#import "UIImageView+WebCache.h"
#include "PostQuestionDetailViewController.h"
#import "ActivityView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import"AppDelegate.h"
#import "UserDetailViewController.h"
#import "UIButton+VSButton.h"
#import "HomeViewController.h"
#import "ProgressHUD.h"
#import "CustomTableViewCell.h"


#import "GADBannerView.h"
#import "GADRequest.h"
#import "SampleConstants.h"
#import <iAd/iAd.h>




@interface GeneralViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,ActivityViewDelegate,UIGestureRecognizerDelegate,GADBannerViewDelegate,UITextFieldDelegate>
{
    UITableView *questionTableView;
    NSMutableArray *questionArray;
    NSString *message;
    UIButton* ViewAllBtn;
   
    NSMutableArray  *categoryTblArray;
    UIView *viewPicker;
    
    NSMutableArray *filteredResults;
    ActivityView *activity;
    UIView *questionView;
    UISearchBar *searchBar;
    BOOL isKeyboardUp;
    UIButton *postedFriends;
    NSString *searchTextStr;
    NSString *questionCount;
    
    UIView *searchView;
    UITextField *searchTextField;
    UITableView *categoryTableView;
    
    
   
}





@end

@implementation GeneralViewController
@synthesize totalQuesString;
@synthesize adBanner;



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
    
    
//    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyboard)];
//    tapGesture.numberOfTapsRequired=2;
//    [self.view addGestureRecognizer:tapGesture];
    
    
//    
//    UITapGestureRecognizer *tapGesturePicker=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pickerRemoveView:)];
//    [self.view addGestureRecognizer:tapGesturePicker];
//    tapGesturePicker.numberOfTapsRequired=1;
//    tapGesturePicker.delegate=self;
   
    
    
//    self.adBanner = [[GADBannerView alloc]
//                     initWithAdSize:kGADAdSizeSmartBannerPortrait];
    self.adBanner=[[GADBannerView alloc]init];
    
    // Need to set this to no since we're creating this custom view.
    self.adBanner.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Note: Edit SampleConstants.h to provide a definition for kSampleAdUnitID
    // before compiling.
    self.adBanner.adUnitID = @"a150bf362eb1333";
    self.adBanner.delegate = self;
    [self.adBanner setRootViewController:self];
    self.adBanner.frame=CGRectMake(0, 0, 320,80);
   
    //[self.view addSubview:self.adBanner];
    //[self.adBanner loadRequest:[self createRequest]];
    
//    [self.view addConstraint:
//     [NSLayoutConstraint constraintWithItem:self.adBanner
//                                  attribute:NSLayoutAttributeBottom
//                                  relatedBy:NSLayoutRelationEqual
//                                     toItem:self.view
//                                  attribute:NSLayoutAttributeBottom
//                                 multiplier:1.0
//                                   constant:0]];
//    [self.view addConstraint:
//     [NSLayoutConstraint constraintWithItem:self.adBanner
//                                  attribute:NSLayoutAttributeCenterX
//                                  relatedBy:NSLayoutRelationEqual
//                                     toItem:self.view
//                                  attribute:NSLayoutAttributeCenterX
//                                 multiplier:1.0
//                                   constant:0]];

   // [self.adBanner loadRequest:[self createRequest]];
    
    
    
    
   
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

-(void) resignKeyboard
{
    [searchBar resignFirstResponder];
    [viewPicker removeFromSuperview];
}

-(void) viewWillAppear:(BOOL)animated
{
    
//    if ([_callFromView isEqualToString:@"PostQuestion"])
//    {
//        
//        [self.navigationController popToRootViewControllerAnimated:NO];
//    }
    
    
    //Show Indicator
    [ProgressHUD show:@"Loading" Interaction:NO];
    
    [self performSelectorInBackground:@selector(questioneWebservice) withObject:nil];
         // [self showActivity];
   
    
  
    
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
  
    
}
-(void)backClick
{
     UserProfileViewController *controller = [[UserProfileViewController alloc]init];
     [self.navigationController pushViewController:controller animated:NO];

    //[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)keyboardDidShow: (NSNotification *) notif
{
    isKeyboardUp = YES;
    CGRect questionFrame=questionTableView.frame;
    
    questionFrame.size.height=questionView.frame.size.height-162;
    questionTableView.frame=questionFrame;
}


- (void)keyboardDidHide: (NSNotification *) notif
{
    isKeyboardUp = NO;
    CGRect questionFrame=questionTableView.frame;
    
    questionFrame.size.height=questionView.frame.size.height;
    questionTableView.frame=questionFrame;
}
-(void) activityDidAppear
{
     [self performSelectorInBackground:@selector(questioneWebservice) withObject:nil];
}

-(void) createUI
{
    //Navigation View
    NavigationView  *nav = [[NavigationView alloc] init];
    nav.titleView.text = @"General";
    [self.view addSubview:nav.navigationView];
    
    UIButton *titleBckBtn=[[UIButton alloc]init];
    titleBckBtn.frame=CGRectMake(0,(nav.navigationView.frame.size.height-30)/2,45,30);
    [titleBckBtn setImage:[UIImage imageNamed:@"back_blue"] forState:UIControlStateNormal];
    //backBtnValue=0;
   // nav.iconImageView.image=[UIImage imageNamed:@"posted_question"];
    //if (backBtnValue==0)
    //{
    [titleBckBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    //}
    [self.view addSubview:titleBckBtn];
    
    
    
    
    //Custom Search Field
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
    searchTextField.textColor=[UIColor grayColor];
    [searchTextField setPlaceholder:@"Search Filter"];
    [searchView addSubview:searchTextField];
    
    UIButton *filterButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [filterButton setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
    [filterButton addTarget:self action:@selector(filterBtn:) forControlEvents:UIControlEventTouchUpInside];
    [filterButton setFrame:CGRectMake(searchView.frame.size.width-40,(searchView.frame.size.height-25)/2, 25, 25)];
    [searchView addSubview:filterButton];
    
    
    //Line View
    UIView *lineView=[[UIView alloc]init];
    lineView.frame=CGRectMake(0, searchView.frame.origin.y+searchView.frame.size.height+2, self.view.frame.size.width, 2);
    [lineView setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:lineView];
    
    //View Contains Table View
    questionView=[[UIView alloc]init];
    questionView.backgroundColor=[UIColor redColor];
    [questionView setFrame:CGRectMake(0, nav.navigationView.frame.size.height+searchView.frame.size.height+12,self.view.frame.size.width, (self.view.frame.size.height-(90+searchView.frame.size.height+10)))];
    [self.view addSubview:questionView];
    
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
//    questionTableView.frame=CGRectMake(0, nav.navigationView.frame.size.height+searchView.frame.size.height+12,self.view.frame.size.width, (self.view.frame.size.height-(90+searchView.frame.size.height+12)));
    questionTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    questionTableView.delegate=self;
    questionTableView.dataSource=self;
    [questionView addSubview:questionTableView];
    
    
//    UIImageView *titleView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
//    titleView.image=[UIImage imageNamed:@""];
//    [questionView addSubview:titleView];
//    
//    UIImage *image=[UIImage imageNamed:@"arrow"];
//    UIButton *upBtn=[[UIButton alloc]init];
//    upBtn.frame=CGRectMake(250, ViewAllBtn.frame.origin.y, 50, ViewAllBtn.frame.size.height+10);
//    //[upBtn setImage:[self rotateImage:image onDegrees:90] forState:UIControlStateNormal];
//    //[upBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
//    [upBtn addTarget:self action:@selector(ascendingQuesClick) forControlEvents:UIControlEventTouchUpInside];
//    
//    // [upBtn setImage:image forState:UIControlStateNormal];
//    [questionView addSubview:upBtn];
//    
//    UIButton *downBtn=[[UIButton alloc]init];
//    downBtn.frame=CGRectMake(270, ViewAllBtn.frame.origin.y, 50, ViewAllBtn.frame.size.height+10);
//   // [downBtn setImage:[self rotateImage:image onDegrees:270] forState:UIControlStateNormal];
//    
//    [downBtn addTarget:self action:@selector(descendingQuesClick) forControlEvents:UIControlEventTouchUpInside];
//    [questionView addSubview:downBtn];
    
    
    
  
    
    
//    questionView=[[UIView alloc]init];
//    questionView.backgroundColor=[UIColor lightGrayColor];
//    [questionView setFrame:CGRectMake(0, nav.navigationView.frame.size.height+searchView.frame.size.height+10,self.view.frame.size.width,(self.view.frame.size.height-(90+searchView.frame.size.height)))];
//    [self.view addSubview:questionView];
//    
//    questionTableView=[[UITableView alloc]init];
//    //  [questionsTableView setFrame:CGRectMake(0, nav.navigationView.frame.size.height+searchBar.frame.size.height+50, 320, (self.view.frame.size.height-(90+searchBar.frame.size.height+postedFriends.frame.size.height)))];
//    
//    [questionTableView setFrame:CGRectMake(0, 0, 320, questionView.frame.size.height)];
//    questionTableView.dataSource=self;
//    questionTableView.delegate=self;
//    [questionView addSubview:questionTableView];

    

    
    
//   searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 44, 320, 44)];
//   // UISearchDisplayController *searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
//    //searchDisplayController.delegate = self;
//        searchBar.tintColor=[UIColor lightGrayColor];
//    searchBar.delegate=self;
//   // searchDisplayController.searchResultsDataSource = self;
//    //searchBar.showsCancelButton=YES;
//    //[self.view addSubview:searchBar];
//    
//    postedFriends=[[UIButton alloc]init];
//    postedFriends.frame=CGRectMake(0, searchBar.frame.origin.y+20, 200, 100);
//   // postedFriends.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0f];
//    totalQuesString=[[NSString alloc]init];
//    [postedFriends setTitle:[NSString stringWithFormat:@"General Questions[%@]",totalQuesString] forState:UIControlStateNormal];
//    [postedFriends setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    //[postedFriends addTarget:self action:@selector(postedQuestion) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:postedFriends];
//    
//    
//    ViewAllBtn=[[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-125), postedFriends.frame.origin.y+30, 120, 36)];
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
//    
//    
//    
//    questionView=[[UIView alloc]init];
//    questionView.backgroundColor=[UIColor lightGrayColor];
//    [questionView setFrame:CGRectMake(0, nav.navigationView.frame.size.height+searchView.frame.size.height+10, 320, (self.view.frame.size.height-(90+searchView.frame.size.height)))];
//    [self.view addSubview:questionView];
//    
//    questionTableView=[[UITableView alloc]init];
////   [questionTableView setFrame:CGRectMake(0, nav.navigationView.frame.size.height+searchBar.frame.size.height+50, 320, (self.view.frame.size.height-(90+searchBar.frame.size.height+50)))];
//    [questionTableView setFrame:CGRectMake(0, 0, 320,questionView.frame.size.height)];
//    
//    questionTableView.dataSource=self;
//    questionTableView.delegate=self;
//    //[questionTableView setUserInteractionEnabled:NO];
//    [questionView addSubview:questionTableView];
       //[questionView bringSubviewToFront:questionTableView];
//    UIButton *backBtn=[[UIButton alloc]init];
//    backBtn.frame=CGRectMake(0, 10, 45, 30);
//    [backBtn setImage:[UIImage imageNamed:@"back_blue"] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
//    [nav.navigationView addSubview:backBtn];
    
    
    
    
    
    
}

-(void)filterBtn:(id)sender
{
    categoryTableView=[[UITableView alloc]init];
    categoryTableView.frame=CGRectMake(searchView.frame.origin.x, searchView.frame.origin.y+searchView.frame.size.height,searchView.frame.size.width, 120);
    categoryTableView.layer.borderWidth=0.5f;
    categoryTableView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    categoryTableView.layer.cornerRadius=5.0f;
    categoryTableView.dataSource=self;
    categoryTableView.delegate=self;
    categoryTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:categoryTableView];
}

-(void)ViewAllClick:(id) sender
{
    
    if (![searchBar isFirstResponder])
    {
        
    
   
   
    viewPicker=[[UIView alloc]init];
    [viewPicker setFrame:self.view.bounds];
   // [viewPicker setBackgroundColor:[UIColor lightGrayColor]];
    [viewPicker setBackgroundColor:[UIColor clearColor]];
    [viewPicker setUserInteractionEnabled:YES];
    [self.view addSubview:viewPicker];
    
   
    
    
    
    [self.view bringSubviewToFront:viewPicker];
    UIPickerView* pickerView=[[UIPickerView alloc]init];
    pickerView.frame=CGRectMake(0, (self.view.frame.size.height-216)/2, 320, 216);
    //CGRectMake(0, questionView.frame.origin.y-110, 320, 162)
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
    
   // [[viewPicker layer] addAnimation:[AppDelegate popupAnimation] forKey:@"popupAnimation"];
    
      [pickerView selectRow:is inComponent:0 animated:YES];
    }
    

}

-(void) pickerRemoveView:(UITapGestureRecognizer*)recognizer
{
    [viewPicker removeFromSuperview];
    [searchBar resignFirstResponder];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:questionTableView]) {
        
        // Don't let selections of auto-complete entries fire the
        // gesture recognizer
        return NO;
    }
    
    return YES;
}


-(void) questioneWebservice
{
    
   
    NSArray *userData=[[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil]objectAtIndex:0];
    NSString *userId=[userData valueForKey:@"id"];
    
    NSArray *mainArray=[[WebServiceSingleton sharedMySingleton]getAllQuestions:userId categoriesId:@"" hashtag:@"" rowget:@"2000"];
    NSString *success=[[mainArray valueForKey:@"success"]objectAtIndex:0];
    if ([success isEqualToString:@"0"])
    {
       
        questionArray=nil;
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"No Question at this time" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
    }
    else
    {
        
        
        NSString *totalQuesStr=[[mainArray valueForKey:@"message"]objectAtIndex:0];
       questionCount=[totalQuesStr substringWithRange:NSMakeRange(0, 3)];
        
    questionArray=[[mainArray valueForKey:@"questions"]objectAtIndex:0];
    filteredResults=[[[mainArray valueForKey:@"questions"]objectAtIndex:0]mutableCopy];
    NSLog(@"%@",questionArray);
        
       // NSString *str=[NSString stringWithFormat:@"%d",(row-1)];
        
        NSString *viewTitle=ViewAllBtn.titleLabel.text;
        NSString *stringValue;
        if ([viewTitle rangeOfString:@"Filter:"].location!=NSNotFound)
        {
            filteredResults=[[mainArray valueForKey:@"questions"]objectAtIndex:0];
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
        
        NSPredicate *predicate;
        if ([searchTextStr isEqualToString:@""])
        {
            
        }
        else
        {
            predicate=[NSPredicate predicateWithFormat:@"SELF.question contains [c]%@",searchTextStr];
            filteredResults=[NSMutableArray arrayWithArray:[filteredResults filteredArrayUsingPredicate:predicate]];
    
        }
        
        

        
        
        
    
    //NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"question_date" ascending:NO];
    //filteredResults = [[questionArray sortedArrayUsingDescriptors:@[descriptor]] mutableCopy];
   
    NSString *messageVal=[[mainArray valueForKey:@"message"]objectAtIndex:0];
    NSRange range=NSMakeRange(0, 3);
    message=[messageVal substringWithRange:range];
           [questionTableView reloadData];
    }
    [postedFriends setTitle:[NSString stringWithFormat:@"General Questions[%lu]",(unsigned long)[filteredResults count]] forState:UIControlStateNormal];
    
    //[self hideActivity];
    [ProgressHUD dismiss];
    
   
  
  
    
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
        [postedFriends setTitle:[NSString stringWithFormat:@"General Questions[%lu]",(unsigned long)[filteredResults count]] forState:UIControlStateNormal];
        
    }
    else
    {
        NSString *str=[NSString stringWithFormat:@"%ld",(row-1)];
        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF.categoryId contains[c] %@",str]; // Creating filter condition
        //questionArray=[questionArray filteredArrayUsingPredicate:filterPredicate];
        filteredResults=[NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:filterPredicate]];
       
        NSPredicate *predicate;
        if ([searchTextStr isEqualToString:@""])
        {
            
        }
        else
        {
            predicate=[NSPredicate predicateWithFormat:@"SELF.question contains [c]%@",searchTextStr];
            filteredResults=[NSMutableArray arrayWithArray:[filteredResults filteredArrayUsingPredicate:predicate]];
            [self tableViewScrollToTop];
        }
     
        
        
     
        [ViewAllBtn setTitle:[NSString stringWithFormat:@"%@",[categoryTblArray objectAtIndex:row]] forState:UIControlStateNormal];
        
        [postedFriends setTitle:[NSString stringWithFormat:@"General Questions[%lu]",(unsigned long)[filteredResults count]] forState:UIControlStateNormal];
        // [ViewAllBtn setTitle:[NSString stringWithFormat:@"%@",[categoryTblArray objectAtIndex:row]] forState:UIControlStateNormal];
        
        
    }
    [self tableViewScrollToTop];
    [questionTableView reloadData];
    [viewPicker removeFromSuperview];
}




#pragma mark Table View Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==questionTableView)
    {
        int count=[[filteredResults valueForKey:@"question"]count];
        return (count+count/10);
    }
    else
    {
        return [categoryTblArray count];
    }
    
    //return count+1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==questionTableView)
    {
        
    
    static NSString *cellIdentifier=@"CellIdentifier";
    CustomTableViewCell *cell=(CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil)
    {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        
        //Line View
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 78.0, cell.frame.size.width,2.0)];
        [lineView setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:lineView];
        
    }
    
    for (id obj in cell.contentView.subviews)
    {
        if ([obj isKindOfClass:[GADBannerView class]]) {
            [obj removeFromSuperview];
        }
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
            
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            NSInteger index = indexPath.row - indexPath.row/10;
            
            [cell.questionLabel setText:[[filteredResults objectAtIndex:index]valueForKey:@"question"]];
            [cell.totalAnswersLabel setText:[NSString stringWithFormat:@"%@",[[filteredResults objectAtIndex:index]valueForKey:@"totalAnswers"]]];
            
            
            
            NSString *urlString = [[filteredResults objectAtIndex:index] valueForKey:@"thumb"];
            if ([urlString rangeOfString:@"http://"].location == NSNotFound)
            {
                urlString = [NSString stringWithFormat:@"http://%@", urlString];
                
                NSURL *imageUrl=[NSURL URLWithString:urlString];
                [cell.questionImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"name_icon"]];
            }
            NSString *user_name=[[filteredResults valueForKey:@"name"]objectAtIndex:index];
            [cell.userNameBtn setTitle:user_name forState:UIControlStateNormal];
            cell.userNameBtn.tag=index;
            [cell.userNameBtn addTarget:self action:@selector(profileView:) forControlEvents:UIControlEventTouchUpInside];

            NSString *timeStampString=[NSString stringWithFormat:@"%@",[[filteredResults objectAtIndex:index]valueForKey:@"question_date"]];
            NSString *dateStr = [[AppDelegate sharedDelegate] localDateFromDate:timeStampString];
            NSString *resultString=[dateStr substringWithRange:NSMakeRange(0, 10)];
            NSString *resultTime=[dateStr substringWithRange:NSMakeRange(11, dateStr.length-11)];
            [cell.dateLabel setText:resultString];
            
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
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        NSInteger index = indexPath.row - indexPath.row/10;
        
        [cell.questionLabel setText:[[filteredResults objectAtIndex:index]valueForKey:@"question"]];
        [cell.totalAnswersLabel setText:[NSString stringWithFormat:@"%@",[[filteredResults objectAtIndex:index]valueForKey:@"totalAnswers"]]];
        
        
        
        NSString *urlString = [[filteredResults objectAtIndex:index] valueForKey:@"thumb"];
        if ([urlString rangeOfString:@"http://"].location == NSNotFound)
        {
            urlString = [NSString stringWithFormat:@"http://%@", urlString];
            
            NSURL *imageUrl=[NSURL URLWithString:urlString];
            [cell.questionImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"name_icon"]];
        }
        
        
        
        
       
        NSString *user_name=[[filteredResults valueForKey:@"name"]objectAtIndex:index];
        [cell.userNameBtn setTitle:user_name forState:UIControlStateNormal];
        
        cell.userNameBtn.tag=index;
        [cell.userNameBtn addTarget:self action:@selector(profileView:) forControlEvents:UIControlEventTouchUpInside];
      
        
        
        
        
        NSString *timeStampString=[NSString stringWithFormat:@"%@",[[filteredResults objectAtIndex:index]valueForKey:@"question_date"]];
        
        NSString *dateStr = [[AppDelegate sharedDelegate] localDateFromDate:timeStampString];
        NSString *resultString=[dateStr substringWithRange:NSMakeRange(0, 10)];
        NSString *resultTime=[dateStr substringWithRange:NSMakeRange(11, dateStr.length-11)];
        [cell.dateLabel setText:resultString];
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

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==questionTableView)
    {
       return 80.0f;
    }
    else
    {
        return 30.0f;
    }
    
   
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==questionTableView)
    {
        
    
    
    if (indexPath.row < 11)
    {
        
        if (indexPath.row == 10)
        {
            
        }
        else
        {
            NSInteger index = indexPath.row - indexPath.row/10;
            
            if (!isKeyboardUp) {
                NSArray *generalquestionArray=[filteredResults objectAtIndex:index];
                
                PostQuestionDetailViewController *profileView=[[PostQuestionDetailViewController alloc]init];
                profileView.generalQuestionArray=[NSMutableArray arrayWithObjects:generalquestionArray,message, nil];
                NSString *userId=[[filteredResults valueForKey:@"userid"]objectAtIndex:index];
                profileView.userIdGeneral=userId;
                profileView.generalViewValue=2;
                profileView.ViewAllTitle=ViewAllBtn.titleLabel.text;
                [self.navigationController pushViewController:profileView animated:NO];
            }
            else
            {
                [viewPicker removeFromSuperview];
                [searchBar resignFirstResponder];
            }
  
        }
    }
    else if ((indexPath.row + 1) % 11 == 0)
    {
        
    }
    else
    {
        NSInteger index = indexPath.row - indexPath.row/10;
        
        if (!isKeyboardUp) {
            NSArray *generalquestionArray=[filteredResults objectAtIndex:index];
            
            PostQuestionDetailViewController *profileView=[[PostQuestionDetailViewController alloc]init];
            profileView.generalQuestionArray=[NSMutableArray arrayWithObjects:generalquestionArray,message, nil];
            NSString *userId=[[filteredResults valueForKey:@"userid"]objectAtIndex:index];
            profileView.userIdGeneral=userId;
            profileView.generalViewValue=2;
            profileView.ViewAllTitle=ViewAllBtn.titleLabel.text;
            [self.navigationController pushViewController:profileView animated:NO];
        }
        else
        {
            [viewPicker removeFromSuperview];
            [searchBar resignFirstResponder];
        }
 
    }
    }
    else
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
            [postedFriends setTitle:[NSString stringWithFormat:@"General Questions[%lu]",(unsigned long)[filteredResults count]] forState:UIControlStateNormal];
            
        }
        else
        {
            NSString *str=[NSString stringWithFormat:@"%ld",(indexPath.row-1)];
            NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF.categoryId contains[c] %@",str]; // Creating filter condition
            //questionArray=[questionArray filteredArrayUsingPredicate:filterPredicate];
            filteredResults=[NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:filterPredicate]];
            
            NSPredicate *predicate;
            if ([searchTextStr isEqualToString:@""])
            {
                
            }
            else
            {
                predicate=[NSPredicate predicateWithFormat:@"SELF.question contains [c]%@",searchTextStr];
                filteredResults=[NSMutableArray arrayWithArray:[filteredResults filteredArrayUsingPredicate:predicate]];
                [self tableViewScrollToTop];
            }
            
            
            
            
            [ViewAllBtn setTitle:[NSString stringWithFormat:@"%@",[categoryTblArray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
            
            [postedFriends setTitle:[NSString stringWithFormat:@"General Questions[%lu]",(unsigned long)[filteredResults count]] forState:UIControlStateNormal];
            // [ViewAllBtn setTitle:[NSString stringWithFormat:@"%@",[categoryTblArray objectAtIndex:row]] forState:UIControlStateNormal];
            
            
        }
        [self tableViewScrollToTop];
        [questionTableView reloadData];
        [categoryTableView removeFromSuperview];
    }
    
    [categoryTableView removeFromSuperview];
    [searchTextField resignFirstResponder];
    
    /*if (indexPath.row!=0  && indexPath.row!=1 && indexPath.row%10 == 1)
    {
        
    }
    else
    {
        NSInteger index = indexPath.row - indexPath.row/10;
        
        if (!isKeyboardUp) {
            NSArray *generalquestionArray=[filteredResults objectAtIndex:index];
            
            PostQuestionDetailViewController *profileView=[[PostQuestionDetailViewController alloc]init];
            profileView.generalQuestionArray=[NSMutableArray arrayWithObjects:generalquestionArray,message, nil];
            NSString *userId=[[filteredResults valueForKey:@"userid"]objectAtIndex:index];
            profileView.userIdGeneral=userId;
            profileView.generalViewValue=2;
            profileView.ViewAllTitle=ViewAllBtn.titleLabel.text;
            [self.navigationController pushViewController:profileView animated:NO];
        }
        else
        {
            [viewPicker removeFromSuperview];
            [searchBar resignFirstResponder];
        }

    }*/
    
}





-(void)profileView:(id)sender
{
    NSInteger i=[sender tag];
  
    UserDetailViewController *userProfile=[[UserDetailViewController alloc]init];
    
    
  
    NSString *userId=[[filteredResults valueForKey:@"userid"]objectAtIndex:i];
    userProfile.messageValue=2;
    userProfile.user_id=userId;
    [self.navigationController pushViewController:userProfile animated:NO];
    
    
    
}

#pragma mark TextField Delegate Methods
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
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
        [postedFriends setTitle:[NSString stringWithFormat:@"General Questions[%lu]",(unsigned long)filteredResults.count] forState:UIControlStateNormal];
    }
    else
    {
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF.question contains [c]%@",string];
        //filteredResults=[NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:predicate]];
        filteredResults=[NSMutableArray arrayWithArray:[filteredResults filteredArrayUsingPredicate:predicate]];
        [postedFriends setTitle:[NSString stringWithFormat:@"General Questions[%lu]",(unsigned long)filteredResults.count] forState:UIControlStateNormal];
        NSLog(@"%@",filteredResults);
    }
    [questionTableView reloadData];

    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark Searchbar delegate Methods
-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    searchTextStr=searchText;
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
        [postedFriends setTitle:[NSString stringWithFormat:@"General Questions[%lu]",(unsigned long)filteredResults.count] forState:UIControlStateNormal];
    }
    else
    {
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF.question contains [c]%@",searchText];
        //filteredResults=[NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:predicate]];
        filteredResults=[NSMutableArray arrayWithArray:[filteredResults filteredArrayUsingPredicate:predicate]];
        [postedFriends setTitle:[NSString stringWithFormat:@"General Questions[%lu]",(unsigned long)filteredResults.count] forState:UIControlStateNormal];
        NSLog(@"%@",filteredResults);
    }
     [questionTableView reloadData];

   
    searchBar.delegate=self;
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

//-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
//{
//    searchBar.text = @"";
//    filteredResults = [NSMutableArray arrayWithArray:questionArray];
//    [questionTableView reloadData];
//    [searchBar resignFirstResponder];
//}





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
