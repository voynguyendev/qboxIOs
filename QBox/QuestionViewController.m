//
//  QuestionViewController.m
//  QBox
//
//  Created by iApp1 on 08/01/15.
//  Copyright (c) 2015 iapp. All rights reserved.
//

#import "QuestionViewController.h"
#import "NavigationView.h"
#import "CustomTableViewCell.h"
#import "WebServiceSingleton.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "ProgressHUD.h"
#import "AddFriendViewController.h"

@interface QuestionViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView *searchView;
    UITextField *searchTextField;
    UITableView *questionsTableView;
    UIView *questionView;
    NSMutableArray *filteredResults;
    NSMutableArray *questionArray;
    NSArray *categoryTblArray;
    UITableView *categoryTableView;
    NSString *searchTextStr;
    NSMutableArray *userDetailData;
    bool iscreatecategory;
      NSMutableArray *selectedBtnArray;
        UIScrollView *categorySubview;
        NSMutableArray *categoryArray;
    NSArray *categoryofuserArray;
     NSString *selectedCategoryStr;
    
}

@end

@implementation QuestionViewController

- (void)viewDidLoad
{
    selectedBtnArray=[[NSMutableArray alloc]init];
    iscreatecategory=NO;
    [super viewDidLoad];
    categoryTblArray=[NSMutableArray arrayWithObjects:@"All",@"Science",@"Math",@"Arts" ,nil];
    searchTextStr=[[NSString alloc]init];
   
    [self createUI];
    
    // Do any additional setup after loading the view.
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




-(void)viewWillAppear:(BOOL)animated
{
    [ProgressHUD show:@"Loading..." Interaction:NO];
    [self fetchData];
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void) createUI
{
    
    //Navigation View
    NavigationView *nav = [[NavigationView alloc] init];
    nav.titleView.text = @"Posted Questions";
    [self.view addSubview:nav.navigationView];
    
    UIButton *titleBckBtn=[[UIButton alloc]init];
    titleBckBtn.frame=CGRectMake(0,(nav.navigationView.frame.size.height-30)/2,45,30);
    [titleBckBtn setImage:[UIImage imageNamed:@"back_blue"] forState:UIControlStateNormal];
    //backBtnValue=0;
    nav.iconImageView.image=[UIImage imageNamed:@"nav_posted_question"];
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
    
    
     questionsTableView=[[UITableView alloc]init];
    
    
    
//    UIButton *backBtn=[[UIButton alloc]init];
//    backBtn.frame=CGRectMake(0, 10, 45, 30);
//    [backBtn setImage:[UIImage imageNamed:@"back_blue"] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backBtn];
    
    
    questionView=[[UIView alloc]init];
    questionView.backgroundColor=[UIColor lightGrayColor];
    [questionView setFrame:CGRectMake(0, nav.navigationView.frame.size.height+searchView.frame.size.height+12,self.view.frame.size.width,(self.view.frame.size.height-(90+searchView.frame.size.height+10)))];
    [self.view addSubview:questionView];
    
    questionsTableView=[[UITableView alloc]init];
    [questionsTableView setFrame:CGRectMake(0, 0, 320, questionView.frame.size.height)];
    questionsTableView.dataSource=self;
    questionsTableView.delegate=self;
    [questionView addSubview:questionsTableView];
    
    
    categoryTableView=[[UITableView alloc]init];
    categoryTableView.frame=CGRectMake(searchView.frame.origin.x, searchView.frame.origin.y+searchView.frame.size.height, searchView.frame.size.width, 120);
    categoryTableView.dataSource=self;
    categoryTableView.delegate=self;
    categoryTableView.layer.borderWidth=0.5f;
    categoryTableView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    categoryTableView.layer.cornerRadius=5.0f;
    
}

#pragma mark webservice Method
-(void) fetchData
{
    NSArray *userData=[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil];
    NSString *ids=[[userData valueForKey:@"id"]objectAtIndex:0];
    NSMutableArray *array = [[[WebServiceSingleton sharedMySingleton]fetchData:_friendID]mutableCopy];
    NSLog(@"%@",array);
    
    
    userDetailData=[[array valueForKey:@"userinfo"]objectAtIndex:0];
 

    
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
        
        
       // NSString *viewTitle=ViewAllBtn.titleLabel.text;
//        NSString *stringValue;
//        if ([viewTitle rangeOfString:@"Filter:"].location!=NSNotFound)
//        {
//            filteredResults=[[[array valueForKey:@"questions"]objectAtIndex:0]mutableCopy];
//            stringValue=[viewTitle substringWithRange:NSMakeRange(7, viewTitle.length-7)];
//        }
//        else
//        {
//            
//            int intValue=[categoryTblArray indexOfObject:viewTitle];
//            NSString *pickerValue=[NSString stringWithFormat:@"%d",(intValue-1)];
//            NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF.categoryId contains[c] %@",pickerValue]; // Creating filter condition
//            //questionArray=[questionArray filteredArrayUsingPredicate:filterPredicate];
//            filteredResults=[NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:filterPredicate]];
//        }
        [questionsTableView reloadData];
        
        
        
    }
    [ProgressHUD dismiss];

}


#pragma mark Action Methods

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
    // filteredResults=[NSMutableArray arrayWithArray:[questionArray
    
    filteredResults=[NSMutableArray arrayWithArray:questionArray];
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
        filteredResults=[NSMutableArray arrayWithArray:questionArray];
    }
    
    [categorySubview setHidden:YES];
    [questionsTableView reloadData];
    
    
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


-(void)backClick
{
    UserProfileViewController *controller = [[UserProfileViewController alloc]init];
    [self.navigationController pushViewController:controller animated:NO];
    // [self.navigationController popViewControllerAnimated:NO];
}



-(void) profileView:(id)sender
{
    NSInteger i=[sender tag];
    NSString *userId=[[filteredResults valueForKey:@"userId"]objectAtIndex:i];
    
//    AddFriendViewController *addFriend=[[AddFriendViewController alloc]init];
//    addFriend.friendUserId=userId;
//    [self.navigationController pushViewController:addFriend animated:NO];
    
    [[AppDelegate sharedDelegate].TabBarView gotoFriendProfileScreenWithFriendID:userId];
    
}

#pragma TextFieldMethods
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
        
    
//            filteredResults=[NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:filterPredicate]];
//        }
        
        //filteredResults=[NSMutableArray arrayWithArray:questionArray];
        //[postedFriends setTitle:[NSString stringWithFormat:@"Saved Questions[%d]",filteredResults.count] forState:UIControlStateNormal];
        filteredResults=questionArray;
    }
    else
    {
       // NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF.question contains [c]%@",string];
        
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF.question contains [c]%@",string];
        NSPredicate  *predicate1=[NSPredicate predicateWithFormat:@"SELF.hashtag contains [c]%@",searchTextStr];
        
        
        NSPredicate *predicate2 = [NSCompoundPredicate orPredicateWithSubpredicates:@[predicate1, predicate]];
        
        filteredResults=[NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:predicate2]];

        
        
        //filteredResults=[NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:predicate]];
        //filteredResults=[NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:predicate]];
       // [postedFriends setTitle:[NSString stringWithFormat:@"Saved Questions[%d]",filteredResults.count] forState:UIControlStateNormal];
        NSLog(@"%@",filteredResults);
    }
    [questionsTableView reloadData];
    
    return YES;

    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

#pragma mark Table View Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
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
        [cell.questionLabel setText:[[filteredResults objectAtIndex:indexPath.row]valueForKey:@"question"]];
        
        
        
        
        
        
        
        [cell.totalAnswersLabel setText:[NSString stringWithFormat:@"[%@]",[[filteredResults objectAtIndex:indexPath.row]valueForKey:@"totalAnswers"]]];
        
        
        NSString *user_name=[userDetailData valueForKey:@"name"];
        
        [cell.userNameBtn setTitle:user_name forState:UIControlStateNormal];
        
//        [cell.userNameBtn addTarget:self action:@selector(profileView:) forControlEvents:UIControlEventTouchUpInside];
//        cell.userNameBtn.tag=indexPath.row;
        
        
        
        
        
        
        
        NSString *timeStampString=[NSString stringWithFormat:@"%@",[[filteredResults objectAtIndex:indexPath.row]valueForKey:@"question_date"]];
        
        
        
        
        NSString *dateStr=[[AppDelegate sharedDelegate]localDateFromDate:timeStampString];
        
        NSString *resultString=[dateStr substringWithRange:NSMakeRange(0, 10)];
        [cell.dateLabel setText:resultString];
        
        
        
        //Time Label
        NSString *resultTime=[dateStr substringWithRange:NSMakeRange(11, dateStr.length-11)];
        
        [cell.timeLabel setText:resultTime];
        
        
        
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        if (tableView==questionsTableView)
        {
            NSLog(@"%@",questionArray);
            PostQuestionDetailViewController *profileView=[[PostQuestionDetailViewController alloc]init];
            profileView.generalViewValue=6;
            NSMutableArray *questionArr=[filteredResults objectAtIndex:indexPath.row];
            profileView.generalQuestionArray=questionArr;
            //profileView.ViewAllTitle=ViewAllBtn.titleLabel.text;
           // profileView.generalQuestionArray=[NSMutableArray arrayWithObjects:questionArr,totalAnswers, nil];
            NSString *userID=[[filteredResults valueForKey:@"userId"]objectAtIndex:indexPath.row];
            profileView.userIdGeneral=userID;
            
            [self.navigationController pushViewController:profileView animated:NO];
        }
        
   
   
    
    
     else  if (tableView==categoryTableView)
     {
         //Filtered table View
         
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
                 //[ViewAllBtn setTitle:[NSString stringWithFormat:@"Filter:%@",[categoryTblArray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
                // [postedFriends setTitle:[NSString stringWithFormat:@"Posted Questions[%lu]",(unsigned long)[filteredResults count]] forState:UIControlStateNormal];
                 
                 
                 
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
                 
                 
                // [ViewAllBtn setTitle:[NSString stringWithFormat:@"%@",[categoryTblArray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
                // [postedFriends setTitle:[NSString stringWithFormat:@"Posted Questions[%lu]",(unsigned long)[filteredResults count]] forState:UIControlStateNormal];
                 
                 
                 
             }
             //[self tableViewScrollToTop];
             [questionsTableView reloadData];
             [categoryTableView removeFromSuperview];
            // [viewPicker removeFromSuperview];
             
         }
        
        
        //[self tableViewScrollToTop];
    
    
    
    else
    {
       // [searchBar resignFirstResponder];
       // [viewPicker removeFromSuperview];
    }
    [categoryTableView removeFromSuperview];
    [searchTextField resignFirstResponder];
  
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==categoryTableView)
    {
        return 30.0f;
    }
    else
    {
       return 80.0f;
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


- (void)didReceiveMemoryWarning {
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

@end
