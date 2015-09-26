//
//  AcceptAnswerViewController.m
//  QBox
//
//  Created by iApp on 7/2/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

#import "AcceptAnswerViewController.h"
#import "NavigationView.h"
#import "WebServiceSingleton.h"
#import "AppDelegate.h"
#include "PostQuestionDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "ActivityView.h"
#import "ProgressHUD.h"
#import "CustomTableViewCell.h"
#import "AddFriendViewController.h"

@interface AcceptAnswerViewController ()<UITableViewDataSource,UITableViewDelegate,ActivityViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *answerData;
    UIView *transparentView;
    UITextView *popUptxt;
    NSArray *detailArray;
    ActivityView *activity;
    UITableView *answerTableView;
    UIView *searchView;
    UITextField *searchTextField;
    UITableView *categoryTableView;
    NSArray *categoryTblArray;
    
    NSString *searchTextStr;
    NSMutableArray *filteredArray;
    UIScrollView *categorySubview;
    NSMutableArray *categoryArray;
    NSArray *categoryofuserArray;
    bool iscreatecategory;
    NSMutableArray *selectedBtnArray;
    NSString *selectedCategoryStr;

    
}

@end

@implementation AcceptAnswerViewController



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
    iscreatecategory=NO;
    
    categoryTblArray=[NSMutableArray arrayWithObjects:@"All",@"Science",@"Math",@"Arts" ,nil];
    [self createUI];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [categoryTableView removeFromSuperview];
    [ProgressHUD show:@"Loading..." Interaction:NO];
    [self fetchData];
}
-(void) activityDidAppear
{
    
}

-(void) createUI
{
    //Navigation View
    NavigationView *nav=[[NavigationView alloc]init];
    nav.titleView.text=@"Accepted Answers";
    [self.view addSubview:nav.navigationView];
    
    UIButton *titleBckBtn=[[UIButton alloc]init];
    titleBckBtn.frame=CGRectMake(0, 10, 45, 30);
    [titleBckBtn setImage:[UIImage imageNamed:@"back_blue"] forState:UIControlStateNormal];
    [titleBckBtn addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:titleBckBtn];
    nav.iconImageView.image=[UIImage imageNamed:@"nav_accepted_question_icon"];
    

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
    searchTextField.textColor=[UIColor grayColor];
    searchTextField.returnKeyType=UIReturnKeySearch;
    searchTextField.font=[UIFont italicSystemFontOfSize:15.0f];
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
    

    //Table View
    answerTableView=[[UITableView alloc]init];
    answerTableView.frame=CGRectMake(0,nav.navigationView.frame.size.height+searchView.frame.size.height+12, self.view.frame.size.width, self.view.frame.size.height-(90+searchView.frame.size.height+10));
    answerTableView.dataSource=self;
    answerTableView.delegate=self;
    answerTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:answerTableView];
    
    categoryTableView=[[UITableView alloc]init];
    categoryTableView.frame=CGRectMake(searchView.frame.origin.x, searchView.frame.origin.y+searchView.frame.size.height,searchView.frame.size.width, 120);
    categoryTableView.bounces=NO;
    categoryTableView.layer.borderWidth=0.5f;
    categoryTableView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    categoryTableView.layer.cornerRadius=5.0f;
    categoryTableView.dataSource=self;
    categoryTableView.delegate=self;
    categoryTableView.bounces=NO;
    categoryTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    
    
    
    
   
    
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








#pragma mark Action Methods

-(void)filterBtnCategory:(id)sender
{
    // filteredArray=[NSMutableArray arrayWithArray:[answerData
    
    NSMutableArray *filteredArrayCategory=[[NSMutableArray alloc]init];
    NSMutableString *str=[[NSMutableString alloc]init];
    filteredArray=[NSMutableArray arrayWithArray:answerData];
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
        
        filteredArray=[NSMutableArray arrayWithArray:[answerData filteredArrayUsingPredicate:predicatecategory]];
        // Creating filter condition
    }
    else
    {
        filteredArray=[NSMutableArray arrayWithArray:answerData];
    }
    
    [categorySubview setHidden:YES];
    [answerTableView reloadData];
    
    
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
-(void)backView
{
    UserProfileViewController *controller = [[UserProfileViewController alloc]init];
    [self.navigationController pushViewController:controller animated:NO];
    
    //[self.navigationController popViewControllerAnimated:NO];
    //[self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)userProfileBtn:(id)sender
{
    NSIndexPath *indexPath=[answerTableView indexPathForSelectedRow];
    NSInteger i=[indexPath row];
    NSString *friendId=[[answerData objectAtIndex:i]valueForKey:@"userId"];
    
//    AddFriendViewController *addFriend=[[AddFriendViewController alloc]init];
//    addFriend.friendUserId=friendId;
//    [self.navigationController pushViewController:addFriend animated:NO];
    
    [[AppDelegate sharedDelegate].TabBarView gotoFriendProfileScreenWithFriendID:friendId];
    
}
#pragma mark Webservice Methods

-(void) fetchData
{
    detailArray=[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"], nil];
    NSString *userId=[[detailArray valueForKey:@"id"]objectAtIndex:0];
  
   
    NSArray *mainArray=[[WebServiceSingleton sharedMySingleton]countAcceptedAnswer:_friendId];
    
    
    NSArray *messageArray=[[mainArray valueForKey:@"message"]objectAtIndex:0];
    if([messageArray isEqualToArray:[NSArray arrayWithObjects:nil]])
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"No Answers at this time" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
        answerData=nil;
    }
    else
    {
  
    NSMutableArray *acceptAnswers=[[mainArray valueForKey:@"message"]objectAtIndex:0];
   // NSSortDescriptor *descriptor=[NSSortDescriptor sortDescriptorWithKey:@"answer_date" ascending:NO];
   // answerData=[acceptAnswers sortedArrayUsingDescriptors:@[descriptor]];
   // answerData=[[mainArray valueForKey:@"message"]objectAtIndex:0];
        answerData=acceptAnswers;
    NSLog(@"%@",answerData);
  //  NSSortDescriptor *descriptor=[NSSortDescriptor sortDescriptorWithKey:@"" ascending:<#(BOOL)#>]
        
    [answerTableView reloadData];
    }
    filteredArray=answerData;
    
    [ProgressHUD dismiss];
   
 
}


- (void)didReceiveMemoryWarning
{
    
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
       /* NSString *viewTitle=searchTextField.text;
        NSString *stringValue;
        if ([viewTitle rangeOfString:@"Filter:"].location!=NSNotFound)
        {
            filteredArray=answerData;
            //filteredResults=[[mainArray valueForKey:@"data"]objectAtIndex:0];
            stringValue=[viewTitle substringWithRange:NSMakeRange(7, viewTitle.length-7)];
        }
        else
        {
            
            int intValue=(int)[categoryTblArray indexOfObject:viewTitle];
            NSString *pickerValue=[NSString stringWithFormat:@"%d",(intValue-1)];
            NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF.categoryId contains[c] %@",pickerValue]; // Creating filter condition
            //questionArray=[questionArray filteredArrayUsingPredicate:filterPredicate];
            filteredArray=[NSMutableArray arrayWithArray:[answerData filteredArrayUsingPredicate:filterPredicate]];
        */
        filteredArray=answerData;
        //}
        
        //filteredResults=[NSMutableArray arrayWithArray:questionArray];
//        [postedFriends setTitle:[NSString stringWithFormat:@"General Questions[%lu]",(unsigned long)filteredResults.count] forState:UIControlStateNormal];
    }
    else
    {
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF.answer contains [c]%@",string];
        //filteredResults=[NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:predicate]];
        filteredArray=[NSMutableArray arrayWithArray:[answerData filteredArrayUsingPredicate:predicate]];
//        [postedFriends setTitle:[NSString stringWithFormat:@"General Questions[%lu]",(unsigned long)filteredResults.count] forState:UIControlStateNormal];
//        NSLog(@"%@",filteredResults);
    }
    [answerTableView reloadData];
    
    return YES;
}

#pragma mark Table view Methods

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==answerTableView)
        
    {
        NSInteger i1=[filteredArray count];
         return i1;
    }
    else
    {
        return [categoryTblArray count];
    }
   
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==answerTableView)
    {
        
    
    static  NSString *cellIdentifier=@"CellIdentifier";
    CustomTableViewCell *cell=(CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
        
    }
    

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    
    NSString *urlString = [[filteredArray objectAtIndex:indexPath.row] valueForKey:@"thumb"];
    if ([urlString rangeOfString:@"http://"].location == NSNotFound) {
        urlString = [NSString stringWithFormat:@"http://%@", urlString];
    }
    
    NSURL *imageUrl=[NSURL URLWithString:urlString];
    
    
    [cell.questionImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"name_icon"]];
    [cell.questionLabel setText:[[filteredArray objectAtIndex:indexPath.row]valueForKey:@"answer"]];
        
    NSArray *userData=[[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil]objectAtIndex:0];
        NSString *userName=[userData valueForKey:@"name"];
        
    [cell.userNameBtn setTitle:userName forState:UIControlStateNormal];
    cell.userNameBtn.tag=indexPath.row;
    [cell.userNameBtn addTarget:self action:@selector(userProfileBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSString *timeStampString=[NSString stringWithFormat:@"%@",[[filteredArray objectAtIndex:indexPath.row]valueForKey:@"accept_date"]];
    NSString *dateStr=[[AppDelegate sharedDelegate]localDateFromDate:timeStampString];
    NSString *resultString=[dateStr substringWithRange:NSMakeRange(0, 10)];
    [cell.dateLabel setText:resultString];
        
    //Time Label
    NSString *resultTime=[dateStr substringWithRange:NSMakeRange(11, dateStr.length-11)];
    [cell.timeLabel setText:resultTime];
        
    UIView *lineView=[[UIView alloc]init];
    lineView.frame=CGRectMake(0, 78.0,cell.frame.size.width, 2.0);
    lineView.backgroundColor=[UIColor lightGrayColor];
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
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor=[UIColor grayColor];
            
            UIView *lineView=[[UIView alloc]init];
            lineView.frame=CGRectMake(0, 29.5,cell.frame.size.width,0.5);
            lineView.backgroundColor=[UIColor lightGrayColor];
            [cell.contentView addSubview:lineView];
            
            
           
        }
        cell.textLabel.text=[categoryTblArray objectAtIndex:indexPath.row];
        return cell;
    }
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==answerTableView)
    {
    
    NSLog(@"%@",answerData);
    NSString *userId=[[detailArray valueForKey:@"id"]objectAtIndex:0];
    NSString *totalQues=[[detailArray valueForKey:@"no_of_ques"]objectAtIndex:0];
    NSString *questionId=[[answerData valueForKey:@"questionId"]objectAtIndex:indexPath.row];
//
   PostQuestionDetailViewController *profileView=[[PostQuestionDetailViewController alloc]init];
   // profileView.ques=totalQues;
    profileView.ids=userId;
    //profileView.value=true;
    profileView.generalViewValue=1;
    profileView.acceptQuestId=questionId;
    
    
    [self.navigationController pushViewController:profileView animated:NO];
    }
    else
    {
        searchTextField.text=[categoryTblArray objectAtIndex:indexPath.row];
        filteredArray=[NSMutableArray arrayWithArray:answerData];
        if (indexPath.row==0)
        {
            
        filteredArray=[NSMutableArray arrayWithArray:answerData];
            
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
//            [postedFriends setTitle:[NSString stringWithFormat:@"General Questions[%lu]",(unsigned long)[filteredResults count]] forState:UIControlStateNormal];
            
        }
        else
        {
            NSString *str=[NSString stringWithFormat:@"%ld",(indexPath.row-1)];
            NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF.categoryId contains[c] %@",str]; // Creating filter condition
            //questionArray=[questionArray filteredArrayUsingPredicate:filterPredicate];
            filteredArray=[NSMutableArray arrayWithArray:[filteredArray filteredArrayUsingPredicate:filterPredicate]];
            
            NSPredicate *predicate;
            if ([searchTextStr isEqualToString:@""])
            {
                
            }
            else
            {
                predicate=[NSPredicate predicateWithFormat:@"SELF.question contains [c]%@",searchTextStr];
                filteredArray=[NSMutableArray arrayWithArray:[filteredArray filteredArrayUsingPredicate:predicate]];
                //[self tableViewScrollToTop];
            }
            
            
            
            
//            [ViewAllBtn setTitle:[NSString stringWithFormat:@"%@",[categoryTblArray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
//            
//            [postedFriends setTitle:[NSString stringWithFormat:@"General Questions[%lu]",(unsigned long)[filteredResults count]] forState:UIControlStateNormal];
            // [ViewAllBtn setTitle:[NSString stringWithFormat:@"%@",[categoryTblArray objectAtIndex:row]] forState:UIControlStateNormal];
            
            
        }
        //[self tableViewScrollToTop];
        [answerTableView reloadData];
        [categoryTableView removeFromSuperview];
    }
    
    [categoryTableView removeFromSuperview];
    [searchTextField resignFirstResponder];
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==answerTableView)
    {
        return 80.0f;
    }
    else
    {
        return 30.0f;
    }
}
   

    





-(void) popView:(UITapGestureRecognizer*) recognizer
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    CGRect rect=screenRect;
    rect.origin.y=44;
    screenRect=rect;
    
   
    transparentView=[[UIView alloc]initWithFrame:self.view.bounds];
 
    
    
  
    transparentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    transparentView.userInteractionEnabled=YES;
    [self.view addSubview:transparentView];
   
  
    popUptxt=[[UITextView alloc]init];
    popUptxt.frame=CGRectMake((self.view.frame.size.width-280)/2, (self.view.frame.size.height-200)/2, 280, 200);

    [popUptxt setBackgroundColor:[UIColor whiteColor]];
    [popUptxt setTextColor:[UIColor blackColor]];
    [popUptxt setFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
    [popUptxt setTextAlignment:NSTextAlignmentCenter];
    popUptxt.layer.borderWidth=1.0f;
    popUptxt.layer.cornerRadius=10.0;
    popUptxt.layer.borderColor=[UIColor orangeColor].CGColor;
    
    
    
 
    popUptxt.text=[answerData valueForKey:@"answer"][recognizer.view.tag];
    popUptxt.userInteractionEnabled=YES;
    popUptxt.editable=NO;
    popUptxt.scrollEnabled=YES;
        
    
    [self.view addSubview:popUptxt];
    
    
    [[popUptxt layer] addAnimation:[AppDelegate popupAnimation] forKey:@"popupAnimation"];

    

    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]init];
   
    tapGesture.numberOfTapsRequired=2;
    [tapGesture addTarget:self action:@selector(removeView)];
    [self.view addGestureRecognizer:tapGesture];
    
   }

-(void) removeView
{
    [transparentView removeFromSuperview];
    [popUptxt removeFromSuperview];
    
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



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
