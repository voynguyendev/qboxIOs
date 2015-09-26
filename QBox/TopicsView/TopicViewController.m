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



@interface TopicViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MNMPullToRefreshManagerClient>
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
}

@end

@implementation TopicViewController;
@synthesize pullToRefreshManager = pullToRefreshManager_;

- (void)viewDidLoad
{
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
    
    
    
    // Do any additional setup after loading the view.
    
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [pullToRefreshManager_ tableViewScrolled];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y >=360.0f)
     {
     }
     else
    [pullToRefreshManager_ tableViewReleased];
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
    
    [pullToRefreshManager_ tableViewReloadFinishedAnimated:YES];
    
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
    searchView=[[UIView alloc]initWithFrame:CGRectMake(10,10, self.view.frame.size.width-20, 30)];
    searchView.layer.borderColor=[UIColor whiteColor].CGColor;
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
    searchTextField.textColor=[UIColor whiteColor];
    [searchTextField setPlaceholder:@"Search Filter"];
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
    buddiesBtn.frame=CGRectMake(5,(optionsView.frame.size.height-20)/2,80,20);
    [buddiesBtn setTitle:@"Buddy's" forState:UIControlStateNormal];
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
    [topicsBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 5.0, 0, 5.0)];
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
    questionTableView.frame=CGRectMake(10,optionsView.frame.origin.y+optionsView.frame.size.height+5,self.view.frame.size.width-20, (self.view.frame.size.height-(50+searchView.frame.size.height+12+optionsView.frame.size.height+5)));
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
    
    [self buddiesBtnAction:buddiesBtn ];
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

-(void)filterBtnCategory:(id)sender
{
    issearchcategory=YES;
    filteredArrayCategory=[[NSMutableArray alloc]init];
    NSMutableString *str=[[NSMutableString alloc]init];
    questionArray=[NSMutableArray arrayWithArray:questionInfoArray];
    searchTextField.text=@"";
    hasall=NO;
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
        
        questionArray=[NSMutableArray arrayWithArray:[questionInfoArray filteredArrayUsingPredicate:predicatecategory]];
        // Creating filter condition
    }
    else
    {
        questionArray=[NSMutableArray arrayWithArray:questionInfoArray];
    }
    
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
    btaction=@"global";
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
    [self globalQuesWebservice];
    
    
}
-(void)topicsBtnAction:(id)sender
{
    btaction=@"topic";
    
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
    
    [self hotTopicsWebservice];
    
    
    //WEbserVice
    // http://108.175.148.221/question_app_test/hot_topics.php
}
-(void)buddiesBtnAction:(id)sender
{
    btaction=@"buddies";
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
    [self friendsQuesWebservice];
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
        id dic=[[WebServiceSingleton sharedMySingleton]getHotTopicsQuestions];
        if ([[dic objectForKey:@"success"]boolValue])
        {
            questionArray=[dic objectForKey:@"data"];
            questionInfoArray=questionArray;
           if(issearchcategory==YES)
            {
                if(filteredArrayCategory.count>0 && hasall==NO)
                {
                    NSPredicate *predicatecategory = [NSCompoundPredicate orPredicateWithSubpredicates:filteredArrayCategory];
                    
                    questionArray=[NSMutableArray arrayWithArray:[questionInfoArray filteredArrayUsingPredicate:predicatecategory]];
                    // Creating filter condition
                }
                else
                {
                    questionArray=[NSMutableArray arrayWithArray:questionInfoArray];
                }
            
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
    
    NSArray *userData=[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil];
    NSString *userId=[[userData valueForKey:@"id"]objectAtIndex:0];
    [ProgressHUD show:@"Please Wait..." Interaction:NO];
    if ([ProjectHelper internetAvailable])
    {
        id dic= [[WebServiceSingleton sharedMySingleton]getAllQuestions:userId];
        if ([[dic objectForKey:@"success"]boolValue])
        {
            questionArray=[dic objectForKey:@"questions"];
            questionInfoArray=questionArray;
            
            if(issearchcategory==YES)
            {
                if(filteredArrayCategory.count>0 && hasall==NO)
                {
                    NSPredicate *predicatecategory = [NSCompoundPredicate orPredicateWithSubpredicates:filteredArrayCategory];
                    
                    questionArray=[NSMutableArray arrayWithArray:[questionInfoArray filteredArrayUsingPredicate:predicatecategory]];
                    // Creating filter condition
                }
                else
                {
                    questionArray=[NSMutableArray arrayWithArray:questionInfoArray];
                }
                
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
    NSArray *userData=[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil];
    NSString *userId=[[userData valueForKey:@"id"]objectAtIndex:0];
    [ProgressHUD show:@"Please Wait..." Interaction:NO];
    if ([ProjectHelper internetAvailable])
    {
        id dic= [[WebServiceSingleton sharedMySingleton]privateFriendPost:userId];
        
        if ([[dic objectForKey:@"success"]boolValue])
        {
            questionArray=[dic objectForKey:@"questions"];
            questionInfoArray=questionArray;
            
            
            if(issearchcategory==YES)
            {
                if(filteredArrayCategory.count>0 && hasall==NO)
                {
                    NSPredicate *predicatecategory = [NSCompoundPredicate orPredicateWithSubpredicates:filteredArrayCategory];
                    
                    questionArray=[NSMutableArray arrayWithArray:[questionInfoArray filteredArrayUsingPredicate:predicatecategory]];
                    // Creating filter condition
                }
                else
                {
                    questionArray=[NSMutableArray arrayWithArray:questionInfoArray];
                }
                
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
#pragma mark Delegate Methods

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
        NSPredicate  *predicate1=[NSPredicate predicateWithFormat:@"SELF.hashtag contains [c]%@",searchTextStr];
        
        
        NSPredicate *predicate2 = [NSCompoundPredicate orPredicateWithSubpredicates:@[predicate1, predicate]];
        
        questionArray=[NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:predicate2]];
        
        
    }
    [questionTableView reloadData];
    
    return YES;
}
#pragma mark Table View Methods
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

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==questionTableView)
    {
        static NSString *cellIdentifier = @"Cell";
        CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
            cell=[nib objectAtIndex:0];
            
            UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,79.0, questionTableView.frame.size.width, 0.5f)];
            [lineView setBackgroundColor:[UIColor lightGrayColor]];
            [cell.contentView addSubview:lineView];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        NSArray *questionInfo=[questionArray objectAtIndex:indexPath.row];
        
        //QuestionImage
        NSString *urlString = [questionInfo valueForKey:@"thumb"];
        if ([urlString rangeOfString:@"http://"].location == NSNotFound)
        {
            urlString = [NSString stringWithFormat:@"http://%@", urlString];
        }
        NSURL *imageUrl=[NSURL URLWithString:urlString];
        
        
        
        
        
        
        //Question Label
        NSString *hashtagquestion=@"";
        if(![[questionInfo valueForKey:@"hashtag"] isEqualToString:@""])
        {
            hashtagquestion =[NSString stringWithFormat:@"%@ (%@)",[questionInfo valueForKey:@"question"],[questionInfo valueForKey:@"hashtag"]];
            
        }
        else
        {
            hashtagquestion=[questionInfo valueForKey:@"question"];
        }
        
        [cell.questionLabel setText:hashtagquestion];
        
        if([urlString containsString:@".png"] || [urlString containsString:@".jpg"])
        {
            [cell.questionImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"name_icon"]];
            [cell.questionLabelNoImage removeFromSuperview];
        }
        else
        {
            [cell.questionImageView removeFromSuperview];
            
            [cell.questionLabel removeFromSuperview];
            
            [cell.questionLabelNoImage setText:hashtagquestion];
            
        }
        
        
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
        
        
        
        
        [cell.ReliesLabel setText:@"Replies"];
        //Total Answers
        //[cell.totalAnswersLabel setText:[questionInfo valueForKey:@"answercount"]];
        [cell.totalAnswersLabel setText:[NSString stringWithFormat:@"[%@]",[questionInfo valueForKey:@"answercount"]]];
        //[cell.totalAnswersLabel
        //User Name
        NSString *user_name=[questionInfo valueForKey:@"name"];
        [cell.userNameBtn setTitle:user_name forState:UIControlStateNormal];
        [cell.userNameBtn addTarget:self action:@selector(profileView:) forControlEvents:UIControlEventTouchUpInside];
        cell.userNameBtn.tag=indexPath.row;
        
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
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
