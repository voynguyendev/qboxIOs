//
//  SavedPostViewController.m
//  QBox
//
//  Created by iApp on 14/07/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

#import "SavedPostViewController.h"
#import "NavigationView.h"
#import "WebServiceSingleton.h"
#import "UIImageView+WebCache.h"
#include "PostQuestionDetailViewController.h"
#import "ActivityView.h"
#import "AppDelegate.h"
#import "ProgressHUD.h"
#import "CustomTableViewCell.h"
#import "AddFriendViewController.h"


@interface SavedPostViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UIPickerViewDataSource,UIPickerViewDelegate,ActivityViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    NSMutableArray *questionArray;
    NSString *totalAnswers;
    UITableView *questionsTableView;
    NSMutableArray *filteredResults;
    UIView *viewPicker;
    UIButton *ViewAllBtn;
    NSMutableArray  *categoryTblArray;
    ActivityView *activity;
    UIView *questionView;
    UISearchBar *searchBar;
    BOOL isKeyboardUp;
    UIButton *postedFriends;
    NSString *searchTextStr;
    NSMutableArray *categoryArray;
       NSArray *categoryofuserArray;
     bool iscreatecategory;
     UIScrollView *categorySubview;
    UITableView *categoryTableView;
    NSMutableArray *selectedBtnArray;
    UIView *searchView;
    UITextField *searchTextField;
     NSString *selectedCategoryStr;
}

@end

@implementation SavedPostViewController
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
    selectedBtnArray=[[NSMutableArray alloc]init];
    searchTextStr=[[NSString alloc]init];
    [self createUI];
    
    categoryTblArray=[NSMutableArray arrayWithObjects:@"All",@"Science",@"Math",@"Arts" ,nil];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyboard)];
    tapGesture.numberOfTapsRequired=1;
    tapGesture.delegate=self;
    //[self.view addGestureRecognizer:tapGesture];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)resignKeyboard
{
    [searchBar resignFirstResponder];
    [viewPicker removeFromSuperview];
    if (![searchBar isFirstResponder])
    {
        
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:questionsTableView]) {
        
        // Don't let selections of auto-complete entries fire the
        // gesture recognizer
        return NO;
    }
    
    return YES;
}
-(void) viewWillAppear:(BOOL)animated
{
    //[self showActivity];
    [ProgressHUD show:@"Loading..." Interaction:NO];
    [self getSavedQuestion];
   
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


//Activity View Delegate Method
-(void) activityDidAppear
{
    [self getSavedQuestion];
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
    NSInteger rowCount=categoryArray.count/2;
    NSInteger columnCount;
    columnCount=2;
    if (categoryArray.count%2!=0)
    {
        rowCount=rowCount+1;
    }
    
    int a=0;
    for (int i=0; i<rowCount; i++)
    {
        
        
        for (int j=0; j<columnCount; j++)
        {
            if(a==categoryArray.count)
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
            [categoryBtn setTitle:[categoryArray objectAtIndex:a] forState:UIControlStateNormal];
            [categoryBtn addTarget:self action:@selector(multipleCategorySelection:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView *boxImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,(categoryBtn.frame.size.height-15)/2,17, 15)];
            [boxImageView setImage:[UIImage imageNamed:@"unselected_box"]];
            [categoryBtn addSubview:boxImageView];
            UILabel *categoryLabel=[[UILabel alloc]initWithFrame:CGRectMake(boxImageView.frame.origin.x+boxImageView.frame.size.width+5, 0, categoryBtn.frame.size.width-22, categoryBtn.frame.size.height)];
            [categoryLabel setText:[categoryArray objectAtIndex:a]];
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


//UIView Method
-(void) createUI
{
    
    
    
    
    //Navigation View
    NavigationView *nav = [[NavigationView alloc] init];
    nav.titleView.text = @"Saved Questions";
    [self.view addSubview:nav.navigationView];
    
//    titleBckBtn=[[UIButton alloc]init];
//    titleBckBtn.frame=CGRectMake(0,(nav.navigationView.frame.size.height-30)/2,45,30);
//    [titleBckBtn setImage:[UIImage imageNamed:@"back_blue"] forState:UIControlStateNormal];
//    backBtnValue=0;
    nav.iconImageView.image=[UIImage imageNamed:@"nav_saved_question_icon"];
//    //if (backBtnValue==0)
//    //{
//    [titleBckBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
//    //}
//    [self.view addSubview:titleBckBtn];
    
    
    
    
    //Custom Search Field
    searchView=[[UIView alloc]initWithFrame:CGRectMake(5,nav.navigationView.frame.origin.y+nav.navigationView.frame.size.height+5, self.view.frame.size.width-10, 30)];
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
    searchTextField.textColor=[UIColor grayColor];
    [searchView addSubview:searchTextField];
    
    UIButton *filterButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [filterButton setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
    [filterButton addTarget:self action:@selector(filterBtn:) forControlEvents:UIControlEventTouchUpInside];
    [filterButton setFrame:CGRectMake(searchView.frame.size.width-40,(searchView.frame.size.height-25)/2, 25, 25)];
    [searchView addSubview:filterButton];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [searchView addSubview:btn];
    

    
//    NavigationView *nav=[[NavigationView alloc]init];
//    nav.titleView.text=@"SAVED POSTS";
//    [self.view addSubview:nav.navigationView];
    
   searchBar=[[UISearchBar alloc]init];
    searchBar.frame=CGRectMake(0, 44, 320, 44);
    searchBar.tintColor=[UIColor lightGrayColor];
    //searchBar.showsCancelButton=YES;
   // UISearchDisplayController *searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
   // searchDisplayController.delegate = self;
    searchBar.delegate=self;
    //searchDisplayController.searchResultsDataSource = self;
    //[self.view addSubview:searchBar];
    
  
    
  postedFriends=[[UIButton alloc]init];
    postedFriends.frame=CGRectMake(0, searchBar.frame.origin.y+44, 200, 50);
    [postedFriends setTitle:[NSString stringWithFormat:@"Saved Questions%@",totalQuesString] forState:UIControlStateNormal];
    //postedFriends.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0f];
    [postedFriends setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[postedFriends addTarget:self action:@selector(postedQuestion) forControlEvents:UIControlEventTouchUpInside];
   // [self.view addSubview:postedFriends];
    
    
  
    
    ViewAllBtn=[[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-125), postedFriends.frame.origin.y+10, 120, 36)];
   // ViewAllBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0f];
    [ViewAllBtn setTitle:@"Filter:All" forState:UIControlStateNormal];
    ViewAllBtn.layer.borderWidth=1.0f;
    ViewAllBtn.layer.borderColor=[UIColor blackColor].CGColor;
    ViewAllBtn.layer.cornerRadius=4.0f;
    
  
       [ViewAllBtn addTarget:self action:@selector(ViewAllClick:) forControlEvents:UIControlEventTouchUpInside];
  
   
    
   
    [ViewAllBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[self.view addSubview:ViewAllBtn];
    
    
    UIView *lineView=[[UIView alloc]init];
    lineView.frame=CGRectMake(0, searchView.frame.origin.y+searchView.frame.size.height+2, self.view.frame.size.width, 2);
    [lineView setBackgroundColor:[UIColor lightGrayColor]];
   // [self.view addSubview:lineView];
    
    //questionsTableView=[[UITableView alloc]init];
    
    
    
    UIButton *backBtn=[[UIButton alloc]init];
    backBtn.frame=CGRectMake(0, 13, 45, 30);
    [backBtn setImage:[UIImage imageNamed:@"back_blue"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    
    questionView=[[UIView alloc]init];
    questionView.backgroundColor=[UIColor lightGrayColor];
    [questionView setFrame:CGRectMake(0, searchView.frame.origin.y+searchView.frame.size.height+5,self.view.frame.size.width,(self.view.frame.size.height-(90+searchView.frame.size.height+10)))];
    [self.view addSubview:questionView];
    
   questionsTableView=[[UITableView alloc]init];
//  [questionsTableView setFrame:CGRectMake(0, nav.navigationView.frame.size.height+searchBar.frame.size.height+50, 320, (self.view.frame.size.height-(90+searchBar.frame.size.height+postedFriends.frame.size.height)))];
    
    [questionsTableView setFrame:CGRectMake(0, 0, 320, questionView.frame.size.height)];
    questionsTableView.dataSource=self;
    questionsTableView.delegate=self;
    questionsTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [questionView addSubview:questionsTableView];
    
    categoryTableView=[[UITableView alloc]init];
    categoryTableView.frame=CGRectMake(searchView.frame.origin.x, searchView.frame.origin.y+searchView.frame.size.height,searchView.frame.size.width, 120);
    categoryTableView.bounces=NO;
    categoryTableView.layer.borderWidth=0.5f;
    categoryTableView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    categoryTableView.layer.cornerRadius=5.0f;
    categoryTableView.dataSource=self;
    categoryTableView.delegate=self;
    categoryTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
}
-(void)ViewAllClick:(id) sender
{
   // [searchBar resignFirstResponder];
    
    if (![searchBar isFirstResponder])
    {
        
    
    viewPicker=[[UIView alloc]init];
    [viewPicker setFrame:self.view.bounds];
    //[viewPicker setFrame:CGRectMake(0, questionView.frame.origin.y-110, 320, 162)];
    [viewPicker setBackgroundColor:[UIColor clearColor]];
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

-(void) getSavedQuestion
{
    NSArray *userdata=[[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"], nil]objectAtIndex:0];
    NSString *userId=[userdata valueForKey:@"id"];
    NSArray *mainArray=[[WebServiceSingleton sharedMySingleton]getAllSavedQuestion:_friendId];
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
   
        questionArray=[[mainArray valueForKey:@"data"]objectAtIndex:0];
        filteredResults=[[mainArray valueForKey:@"data"]objectAtIndex:0];
        
        NSString *viewTitle=ViewAllBtn.titleLabel.text;
        NSString *stringValue;
        if ([viewTitle rangeOfString:@"Filter:"].location!=NSNotFound)
        {
            filteredResults=[[mainArray valueForKey:@"data"]objectAtIndex:0];
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

   // NSSortDescriptor *descriptor=[NSSortDescriptor sortDescriptorWithKey:@"question_date" ascending:NO];
   // filteredResults=[[questionArray sortedArrayUsingDescriptors:@[descriptor]]mutableCopy];
    NSString *message=[[mainArray valueForKey:@"message"]objectAtIndex:0];;
    totalAnswers=[message substringWithRange:NSMakeRange(0, 2)];
     
    [questionsTableView reloadData];
    }
    [ProgressHUD dismiss];
    
}

-(void)backClick
{
    UserProfileViewController *controller = [[UserProfileViewController alloc]init];
    [self.navigationController pushViewController:controller animated:NO];
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
-(void)resetcategoryButtonClick:(id)sender
{
    
    [categorySubview setHidden:YES];
    selectedBtnArray=[[NSMutableArray alloc]init];
    [self categorySubview];
    
    
}
-(void)filterBtnCategory:(id)sender
{
    NSMutableArray *filteredArrayCategory=[[NSMutableArray alloc]init];
    NSMutableString *str=[[NSMutableString alloc]init];
   filteredResults =[NSMutableArray arrayWithArray:questionArray];
    searchTextField.text=@"";
    bool hasall=NO;
    for (int i=0; i<selectedBtnArray.count; i++)
    {
        int value = [[selectedBtnArray objectAtIndex:i] intValue];
        if(value==0)
            hasall=YES;
        if(value<=3)
            selectedCategoryStr=[NSString stringWithFormat:@"%d",value];
        else
            selectedCategoryStr=[self GetCategoryIdByIndex:value];
        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF.categoryId contains[c] %@",selectedCategoryStr];
        [filteredArrayCategory addObject:filterPredicate];
        
        int value1 = [[selectedBtnArray objectAtIndex:i] intValue];
        [str appendString:[categoryArray objectAtIndex:value1]];
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
    if(filteredArrayCategory.count>0 && hasall==NO)
    {
        NSPredicate *predicatecategory = [NSCompoundPredicate orPredicateWithSubpredicates:filteredArrayCategory];
        
        filteredResults=[NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:predicatecategory]];
        // Creating filter condition
    }
    else
    {
       filteredResults  =[NSMutableArray arrayWithArray:questionArray];
    }
    
    
    [categorySubview setHidden:YES];
    [questionsTableView reloadData];
    
    
}


-(void)filterBtn:(id)sender
{
    categoryArray=[NSMutableArray arrayWithObjects:@"All",@"Science",@"Math",@"Arts" ,nil];
    
   // selectedBtnArray=[[NSMutableArray alloc]init];
    
    
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

#pragma mark TextField Delegate Methods
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
  
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    searchBar.text=@"";
    filteredResults=[NSMutableArray arrayWithArray:questionArray];
    [questionsTableView reloadData];
    [textField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
    
    

    
    searchTextStr=string;
    
    if (string.length==0)
    {
      filteredResults  =[NSMutableArray arrayWithArray:questionArray];
    }
    else
    {
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF.question contains [c]%@",string];
        NSPredicate  *predicate1=[NSPredicate predicateWithFormat:@"SELF.hashtag contains [c]%@",searchTextStr];
        
        
        NSPredicate *predicate2 = [NSCompoundPredicate orPredicateWithSubpredicates:@[predicate1, predicate]];
        
        filteredResults=[NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:predicate2]];
        
        
    }
    [questionsTableView reloadData];

    return YES;
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
        [postedFriends setTitle:[NSString stringWithFormat:@"Saved Questions[%lu]",(unsigned long)[filteredResults count]] forState:UIControlStateNormal];
        
    }
    else
    {
        NSString *str=[NSString stringWithFormat:@"%ld",(row-1)];
        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF.categoryId contains[c] %@",str]; // Creating filter condition
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
        
        [postedFriends setTitle:[NSString stringWithFormat:@"Saved Questions[%lu]",(unsigned long)[filteredResults count]] forState:UIControlStateNormal];
       
        
        
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
     return [filteredResults count];
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
    
    
    NSString *cellIdentifier=[NSString stringWithFormat:@"CellIdentifier %li",(long)indexPath.row];
    CustomTableViewCell *cell=(CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        //cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        
        
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
      //Question Image
       NSString *urlString = [[filteredResults objectAtIndex:indexPath.row] valueForKey:@"thumb"];
        if ([urlString rangeOfString:@"http://"].location == NSNotFound)
        {
            urlString = [NSString stringWithFormat:@"http://%@", urlString];
        }
        NSURL *imageUrl=[NSURL URLWithString:urlString];
        [cell.questionImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"name_icon"]];
       
        
        //Question Label
    
        NSRange rangeimagepng = [urlString rangeOfString:@".png" options:NSCaseInsensitiveSearch];
        NSRange rangeimagejpg = [urlString rangeOfString:@".jpg" options:NSCaseInsensitiveSearch];
        //if (range.location != NSNotFound) {
        
        if(rangeimagepng.location != NSNotFound || rangeimagejpg.location != NSNotFound)
        {

            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popquestiondetail:)];
            cell.questionLabel.tag=indexPath.row;
            [cell.questionLabel setUserInteractionEnabled:YES];
            [cell.questionLabel addGestureRecognizer:singleTap];
            
            [cell.questionImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"name_icon"]];
            [cell.questionLabelNoImage removeFromSuperview];
        }
        else
        {
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popquestiondetail:)];
            cell.questionLabelNoImage.tag=indexPath.row;
            [cell.questionLabelNoImage setUserInteractionEnabled:YES];
            [cell.questionLabelNoImage addGestureRecognizer:singleTap];
            
            [cell.questionImageView removeFromSuperview];
            
            [cell.questionLabel removeFromSuperview];
            
            [cell.questionLabelNoImage setText:[[filteredResults objectAtIndex:indexPath.row]valueForKey:@"question"]];
            
        }

   
        [cell.questionLabel setText:[[filteredResults objectAtIndex:indexPath.row]valueForKey:@"question"]];
        

   
   
    [cell.totalAnswersLabel setText:[NSString stringWithFormat:@"%@",[[filteredResults objectAtIndex:indexPath.row]valueForKey:@"totalAnswers"]]];
  
    [cell.ReliesLabel setText:@"Replies"];

    NSString *user_name=[[filteredResults valueForKey:@"name"]objectAtIndex:indexPath.row];
    
    [cell.userNameBtn setTitle:user_name forState:UIControlStateNormal];
    
    [cell.userNameBtn addTarget:self action:@selector(profileView:) forControlEvents:UIControlEventTouchUpInside];
    cell.userNameBtn.tag=indexPath.row;
    
    
        NSString *urlString1 = [[filteredResults objectAtIndex:indexPath.row]valueForKey:@"profile_pic"];
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
    
    
    
    
    NSString *timeStampString=[NSString stringWithFormat:@"%@",[[filteredResults objectAtIndex:indexPath.row]valueForKey:@"question_date"]];
    
    
    
    
   //NSString *dateStr=[[AppDelegate sharedDelegate]localDateFromDate:timeStampString];

     //    NSString *resultString=[dateStr substringWithRange:NSMakeRange(0, 10)];
    [cell.dateLabel setText:timeStampString];
   
        
        
        //Time Label
       // NSString *resultTime=[dateStr substringWithRange:NSMakeRange(11, dateStr.length-11)];
      
    //    [cell.timeLabel setText:resultTime];
     
        
        
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 78.0, cell.frame.size.width,2.0)];
    [lineView setBackgroundColor:[UIColor lightGrayColor]];
    [cell.contentView addSubview:lineView];

    
    
   
    
    
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
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            
            UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 29.5, cell.frame.size.width,0.5)];
            [lineView setBackgroundColor:[UIColor lightGrayColor]];
            [cell.contentView addSubview:lineView];
           
            
           
        }
        
        cell.textLabel.text=[categoryTblArray objectAtIndex:indexPath.row];
       
        
        return cell;
    }
}
-(void) popquestiondetail:(UITapGestureRecognizer *)recognizer{
    NSLog(@"%@",questionArray);
    PostQuestionDetailViewController *profileView=[[PostQuestionDetailViewController alloc]init];
    profileView.generalViewValue=3;
    NSMutableArray *questionArr=[filteredResults objectAtIndex:recognizer.view.tag];
    profileView.ViewAllTitle=ViewAllBtn.titleLabel.text;
    profileView.generalQuestionArray=[NSMutableArray arrayWithObjects:questionArr,totalAnswers, nil];
    NSString *userID=[[filteredResults valueForKey:@"userId"]objectAtIndex:recognizer.view.tag];
    profileView.userIdGeneral=userID;
    [self.navigationController pushViewController:profileView animated:NO];
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isKeyboardUp)
    {
        if (tableView==questionsTableView)
        {
            NSLog(@"%@",questionArray);
            PostQuestionDetailViewController *profileView=[[PostQuestionDetailViewController alloc]init];
            profileView.generalViewValue=3;
            NSMutableArray *questionArr=[filteredResults objectAtIndex:indexPath.row];
            profileView.ViewAllTitle=ViewAllBtn.titleLabel.text;
            profileView.generalQuestionArray=[NSMutableArray arrayWithObjects:questionArr,totalAnswers, nil];
            NSString *userID=[[filteredResults valueForKey:@"userId"]objectAtIndex:indexPath.row];
            profileView.userIdGeneral=userID;
            [self.navigationController pushViewController:profileView animated:NO];
        }
       
    }
    else
    {
        [searchBar resignFirstResponder];
        [viewPicker removeFromSuperview];
    }
    
    
    if (tableView==categoryTableView)
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
            [postedFriends setTitle:[NSString stringWithFormat:@"Saved Questions[%lu]",(unsigned long)[filteredResults count]] forState:UIControlStateNormal];
            
        }
        else
        {
            NSString *str=[NSString stringWithFormat:@"%ld",(indexPath.row-1)];
            NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF.categoryId contains[c] %@",str]; // Creating filter condition
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
            
            [postedFriends setTitle:[NSString stringWithFormat:@"Saved Questions[%lu]",(unsigned long)[filteredResults count]] forState:UIControlStateNormal];
            
            
            
        }
        
        
        
        [self tableViewScrollToTop];
        [questionsTableView reloadData];
        [viewPicker removeFromSuperview];
    }
    [categoryTableView removeFromSuperview];
    [searchTextField resignFirstResponder];
   
   
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==questionsTableView)
    {
         return 80.0f;
    }
    else
    {
        return 30.0f;
    }
   
}


-(void) tableViewScrollToTop
{
    NSInteger lastSectionIndex = [questionsTableView numberOfSections] - 1;
    NSInteger lastItemIndex = [questionsTableView numberOfRowsInSection:[[filteredResults valueForKey:@"question"]count]];
    NSIndexPath *pathToLastItem = [NSIndexPath indexPathForItem:lastItemIndex inSection:lastSectionIndex];
    if (filteredResults.count==0)
    {
        
    }
    else
    {
    [questionsTableView scrollToRowAtIndexPath:pathToLastItem atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

-(void)profileView:(id)sender
{
    NSInteger i=[sender tag];
    NSString *userId=[[filteredResults valueForKey:@"userId"]objectAtIndex:i];
    
//    AddFriendViewController *addFriend=[[AddFriendViewController alloc]init];
//    addFriend.friendUserId=userId;
//    [self.navigationController pushViewController:addFriend animated:NO];
    
    [[AppDelegate sharedDelegate].TabBarView gotoFriendProfileScreenWithFriendID:userId];
    
//    NSInteger i=[sender tag];
//    UserDetailViewController *userProfile=[[UserDetailViewController alloc]init];
//    NSString *userId=[[filteredResults valueForKey:@"userId"]objectAtIndex:i];
//    userProfile.messageValue=2;
//    userProfile.user_id=userId;
//    [self.navigationController pushViewController:userProfile animated:NO];
    
    
    
}



#pragma mark Search Bar Methods
//-(BOOL) searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    searchBar.keyboardType=UIKeyboardTypeDefault;
//    return YES;
//}
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
           [postedFriends setTitle:[NSString stringWithFormat:@"Saved Questions[%lu]",(unsigned long)filteredResults.count] forState:UIControlStateNormal];
    }
    else
    {
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF.question contains [c]%@",searchText];
    //filteredResults=[NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:predicate]];
        filteredResults=[NSMutableArray arrayWithArray:[filteredResults filteredArrayUsingPredicate:predicate]];
           [postedFriends setTitle:[NSString stringWithFormat:@"Saved Questions[%lu]",(unsigned long)filteredResults.count] forState:UIControlStateNormal];
    NSLog(@"%@",filteredResults);
    }
    [questionsTableView reloadData];
    searchBar.delegate=self;
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text=@"";
    filteredResults=[NSMutableArray arrayWithArray:questionArray];
    [questionsTableView reloadData];
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
