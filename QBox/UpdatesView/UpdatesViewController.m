//
//  UpdatesViewController.m
//  QBox
//
//  Created by iApp1 on 05/02/15.
//  Copyright (c) 2015 iapp. All rights reserved.
//

#import "UpdatesViewController.h"
#import "NavigationView.h"
#import "CustomTableViewCell.h"
#import "ProgressHud.h"
#import "WebServiceSingleton.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "PostQuestionDetailViewController.h"
#import "AddFriendViewController.h"
#import "PushTableViewCell.h"
#import "NotifycationCustomTableViewCell.h"
#import "SPHViewController.h"





@interface UpdatesViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIView *searchView;
    UITextField *searchTextField;
    UITableView *questionTableView;
    UITableView *categoryTableView;
    NSArray *categoryTblArray;
    NSArray *postedQuestionArray;
    NSMutableArray *filteredResults;
    NSString *searchTextStr;
  
    
}

@end

@implementation UpdatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [ProgressHUD show:@"Please Wait..." Interaction:NO];
    [self getUpdatesData];
    
    categoryTblArray=[NSMutableArray arrayWithObjects:@"All",@"Science",@"Math",@"Arts" ,nil];
    
    [self createUI];
}
#pragma mark UIView
-(void)createUI
{
    //Navigation View
        NavigationView  *nav = [[NavigationView alloc] init];
    
        [self.view addSubview:nav.navigationView];
    
    
    CGRect iconFrame=nav.iconImageView.frame;
    iconFrame.origin.x+=20;
    nav.iconImageView.frame=iconFrame;
    
    CGRect titleFrame=nav.titleView.frame;
    titleFrame.origin.x+=15;
    nav.titleView.frame=titleFrame;
    nav.titleView.text = @"Updates";
    nav.iconImageView.image=[UIImage imageNamed:@"nav_updates_icon"];
        
        UIButton *titleBckBtn=[[UIButton alloc]init];
        titleBckBtn.frame=CGRectMake(0,(nav.navigationView.frame.size.height-30)/2+15,45,30);
        [titleBckBtn setImage:[UIImage imageNamed:@"back_blue"] forState:UIControlStateNormal];
        //backBtnValue=0;
    
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
        [searchView setHidden:YES];
    
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
       // [self.view addSubview:lineView];
   
        
        questionTableView=[[UITableView alloc]init];
        CGSize result=[[UIScreen mainScreen]bounds].size;
        if (result.height==568)
        {
            questionTableView.frame=CGRectMake(0, nav.navigationView.frame.size.height+searchView.frame.size.height+12,self.view.frame.size.width, (self.view.frame.size.height-(90+searchView.frame.size.height+10)));
            
        }
        else
        {
            questionTableView.frame=CGRectMake(0, nav.navigationView.frame.size.height+searchView.frame.size.height+12,self.view.frame.size.width, (self.view.frame.size.height-(90+searchView.frame.size.height+10)));
        }
        //    questionTableView.frame=CGRectMake(0, nav.navigationView.frame.size.height+searchView.frame.size.height+12,self.view.frame.size.width, (self.view.frame.size.height-(90+searchView.frame.size.height+12)));
        questionTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        questionTableView.delegate=self;
        questionTableView.dataSource=self;
        questionTableView.rowHeight=80.0f;
        [self.view addSubview:questionTableView];
    
    categoryTableView=[[UITableView alloc]init];
    categoryTableView.frame=CGRectMake(searchView.frame.origin.x, searchView.frame.origin.y+searchView.frame.size.height,searchView.frame.size.width,120);
    categoryTableView.layer.borderWidth=0.5f;
    categoryTableView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    categoryTableView.layer.cornerRadius=5.0f;
    categoryTableView.dataSource=self;
    categoryTableView.delegate=self;
    categoryTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    categoryTableView.rowHeight=30.0f;
}

#pragma mark Action Methods
-(void)backClick
{
    /*
    TaBBarViewController *TabVC=[[TaBBarViewController alloc]init];
   // TabVC.nameValue=1;
    TabVC.notificationViewValue=4;//;
    [self.navigationController pushViewController:TabVC animated:NO];*/
    
    //Care
    //[AppDelegate sharedDelegate].TabBarView = TabVC;
    
    
    UserProfileViewController *controller = [[UserProfileViewController alloc]init];
    [self.navigationController pushViewController:controller animated:NO];
}

-(void)filterBtn:(id)sender
{
    
    if (![self.view.subviews containsObject:categoryTableView])
    {
      [self.view addSubview:categoryTableView];
    }
   
   
}

-(void)userAcceptBtn:(id)sender
{
    NSIndexPath *indexPath=[questionTableView indexPathForSelectedRow];
    NSInteger i=[indexPath row];
    NSString *senderId=[[filteredResults objectAtIndex:i]valueForKey:@"SenderId"];
    NSString *recieveId=[[filteredResults objectAtIndex:i]valueForKey:@"ReceiverId"];
    NSString *pushnotifycationidId=[[filteredResults objectAtIndex:i]valueForKey:@"id"];

    
    id updateData=[[[WebServiceSingleton sharedMySingleton]acceptRequest:recieveId senderId:senderId pushnotifycationid:pushnotifycationidId]objectAtIndex:0];
    int status=[[updateData objectForKey:@"status"]intValue];
    if (status==1)
    {
       // [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Accepted Successfully" delegate:nil /////cancelButtonTitle:@"Ok" otherButtonTitles: nil]show];
        [self getUpdatesData];
        [questionTableView reloadData];

    }
   
    
    
    
    [ProgressHUD dismiss];
    
    //    AddFriendViewController *addFriend=[[AddFriendViewController alloc]init];
    //    addFriend.friendUserId=friendId;
    //    [self.navigationController pushViewController:addFriend animated:NO];
    
    //[[AppDelegate sharedDelegate].TabBarView gotoFriendProfileScreenWithFriendID:senderId];
}


-(void)userRejectBtn:(id)sender
{
    NSIndexPath *indexPath=[questionTableView indexPathForSelectedRow];
    NSInteger i=[indexPath row];
    NSString *senderId=[[filteredResults objectAtIndex:i]valueForKey:@"SenderId"];
    NSString *recieveId=[[filteredResults objectAtIndex:i]valueForKey:@"ReceiverId"];
    NSString *pushnotifycationidId=[[filteredResults objectAtIndex:i]valueForKey:@"id"];
    
    
    id updateData=[[[WebServiceSingleton sharedMySingleton]rejectRequest:recieveId senderId:senderId pushnotifycationid:pushnotifycationidId]objectAtIndex:0];
    
    int status=[[updateData objectForKey:@"status"]intValue];
    if (status==1)
    {
        //[[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Rejected Successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]show];
        [self getUpdatesData];
        [questionTableView reloadData];
        
    }
    
    
    [ProgressHUD dismiss];
    
    //    AddFriendViewController *addFriend=[[AddFriendViewController alloc]init];
    //    addFriend.friendUserId=friendId;
    //    [self.navigationController pushViewController:addFriend animated:NO];
    
    //[[AppDelegate sharedDelegate].TabBarView gotoFriendProfileScreenWithFriendID:senderId];
}




-(void)userProfileBtn:(id)sender
{
    NSIndexPath *indexPath=[questionTableView indexPathForSelectedRow];
    NSInteger i=[indexPath row];
    NSString *friendId=[[filteredResults objectAtIndex:i]valueForKey:@"userId"];
    
//    AddFriendViewController *addFriend=[[AddFriendViewController alloc]init];
//    addFriend.friendUserId=friendId;
//    [self.navigationController pushViewController:addFriend animated:NO];
    
    [[AppDelegate sharedDelegate].TabBarView gotoFriendProfileScreenWithFriendID:friendId];
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
        return [filteredResults count];
    }
    else
    {
        return [categoryTblArray count];
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==questionTableView)
    {
        
      id questionArray=[filteredResults objectAtIndex:indexPath.row];
        NSString* pushnotifycationtype=[questionArray valueForKey:@"PushNotifycationType"];
    static NSString *cellIdentifier=@"CellIdentifier";
      if([pushnotifycationtype isEqualToString:@"friend request"])
       {
          
           PushTableViewCell *cell=(PushTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
           
           if (cell==nil)
           {
               NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"PushTableViewCell" owner:self options:nil];
               cell=[nib objectAtIndex:0];
               
               UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,79.0,questionTableView.frame.size.width,1.0)];
               [lineView setBackgroundColor:[UIColor lightGrayColor]];
               [cell.contentView addSubview:lineView];
               cell.selectionStyle=UITableViewCellSelectionStyleNone;
           }
           
           cell.questionLabel.text=[questionArray valueForKey:@"Message"];
           
           NSMutableString *imageUrlStr=[questionArray valueForKey:@"picturesender"];
           
           if ([imageUrlStr rangeOfString:@"http://"].location == NSNotFound)
           {
               imageUrlStr=[NSMutableString stringWithFormat:@"http://%@",imageUrlStr];
           }
           NSURL *imageUrl=[NSURL URLWithString:imageUrlStr];
           cell.questionImageView.layer.cornerRadius=cell.questionImageView.frame.size.width/2;
           cell.questionImageView.layer.borderColor=[UIColor lightGrayColor].CGColor;
           cell.questionImageView.layer.borderWidth=1.0f;
           cell.userImageView.clipsToBounds=YES;
           [cell.questionImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder"]];
          
           
           [cell.btAccept addTarget:self action:@selector(userAcceptBtn:) forControlEvents:UIControlEventTouchUpInside];
           [cell.btReject addTarget:self action:@selector(userRejectBtn:) forControlEvents:UIControlEventTouchUpInside];

           
           
           
           /*NSString *timeStampString=[NSString stringWithFormat:@"%@",[questionArray valueForKey:@"DateCreate"]];
           NSString *dateStr=[[AppDelegate sharedDelegate]localDateFromDate:timeStampString];
           NSString *resultString=[dateStr substringWithRange:NSMakeRange(0, 10)];
           [cell.dateLabel setText:resultString];
           
           //Time Label
           NSString *resultTime=[dateStr substringWithRange:NSMakeRange(11, dateStr.length-11)];
           [cell.timeLabel setText:resultTime];
           
           [cell.userNameBtn setTitle:[questionArray valueForKey:@"name"] forState:UIControlStateNormal];
           [cell.userNameBtn addTarget:self action:@selector(userProfileBtn:) forControlEvents:UIControlEventTouchUpInside];
           [cell.userNameBtn setTitleColor:BUTTONCOLOR forState:UIControlStateSelected];
           //cell.userNameBtn
           */
           return cell;
           
       } else if(
                 [pushnotifycationtype isEqualToString:@"accepted friend request"]
                 
                 ||
                 
                 [pushnotifycationtype isEqualToString:@"accept answer"]
                 
                 ||
                 
                 [pushnotifycationtype isEqualToString:@"replay question"]
                 
                 ||
                 
                 [pushnotifycationtype isEqualToString:@"reject answer"]
                 ||
                 
                 [pushnotifycationtype isEqualToString:@"like question"]
                 
                 ||
                 
                 [pushnotifycationtype isEqualToString:@"dislike question"]
                 
                 ||
                 
                 [pushnotifycationtype isEqualToString:@"follower"]
                 
                 ||
                 
                 [pushnotifycationtype isEqualToString:@"chat"]
                 
                 ||
                 
                 [pushnotifycationtype isEqualToString:@"tagged post"]
                 
                 ||
                 
                 [pushnotifycationtype isEqualToString:@"admin repot question"]
                 
                 ||
                 
                 [pushnotifycationtype isEqualToString:@"admin repot comment"]

                )
       {
           NotifycationCustomTableViewCell *cell=(NotifycationCustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
           
           if (cell==nil)
           {
               NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"NotifycationCustomTableViewCell" owner:self options:nil];
               cell=[nib objectAtIndex:0];
               
               UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,79.0,questionTableView.frame.size.width,1.0)];
               [lineView setBackgroundColor:[UIColor lightGrayColor]];
               [cell.contentView addSubview:lineView];
               cell.selectionStyle=UITableViewCellSelectionStyleNone;
           }
           
           cell.questionLabel.text=[questionArray valueForKey:@"Message"];
           
            if([pushnotifycationtype isEqualToString:@"admin repot question"]==false && [pushnotifycationtype isEqualToString:@"admin repot comment"]==false)
           {
               
               cell.questionImageView.layer.cornerRadius=cell.questionImageView.frame.size.width/2;
               cell.questionImageView.layer.borderColor=[UIColor lightGrayColor].CGColor;
               cell.questionImageView.layer.borderWidth=1.0f;
               cell.questionImageView.clipsToBounds=YES;

               NSMutableString *imageUrlStr=[questionArray valueForKey:@"picturesender"];
               
               if ([imageUrlStr rangeOfString:@"http://"].location == NSNotFound)
               {
                   imageUrlStr=[NSMutableString stringWithFormat:@"http://%@",imageUrlStr];
               }
               NSURL *imageUrl=[NSURL URLWithString:imageUrlStr];

               [cell.questionImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
           }
           NSString *timeStampString=[NSString stringWithFormat:@"%@",[questionArray valueForKey:@"DateCreate"]];
           // NSString *dateStr=[[AppDelegate sharedDelegate]localDateFromDate:timeStampString];
           // NSString *resultString=[dateStr substringWithRange:NSMakeRange(0, 10)];
            [cell.dateLabel setText:timeStampString];
            
            //Time Label
            //NSString *resultTime=[dateStr substringWithRange:NSMakeRange(11, dateStr.length-11)];
          //  [cell.timeLabel setText:resultTime];
            /*
            [cell.userNameBtn setTitle:[questionArray valueForKey:@"name"] forState:UIControlStateNormal];
            [cell.userNameBtn addTarget:self action:@selector(userProfileBtn:) forControlEvents:UIControlEventTouchUpInside];
            [cell.userNameBtn setTitleColor:BUTTONCOLOR forState:UIControlStateSelected];
            //cell.userNameBtn
            */
           return cell;
       
       }
      
    }
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
    [categoryTableView removeFromSuperview];
    if (tableView==questionTableView)
    {
        
        NSIndexPath *indexPath=[questionTableView indexPathForSelectedRow];
        NSInteger i=[indexPath row];
        NSString *questionId=[[filteredResults objectAtIndex:i]valueForKey:@"Parmaster"];
        NSString *senderId=[[filteredResults objectAtIndex:i]valueForKey:@"SenderId"];
        NSString *ReceiverIdId=[[filteredResults objectAtIndex:i]valueForKey:@"ReceiverId"];
        
        NSString *pushnotifycationtype=[[filteredResults objectAtIndex:i]valueForKey:@"PushNotifycationType"];
        
        if(
           [pushnotifycationtype isEqualToString:@"accept answer"]
           ||
           [pushnotifycationtype isEqualToString:@"replay question"]
           
           ||
          
           [pushnotifycationtype isEqualToString:@"reject answer"]
           
           ||
           
            [pushnotifycationtype isEqualToString:@"like question"]
           
           ||
           
           [pushnotifycationtype isEqualToString:@"dislike question"]
           
           ||
           
           [pushnotifycationtype isEqualToString:@"tagged post"]
           
           ||
           
           [pushnotifycationtype isEqualToString:@"admin repot question"]
           
           ||
           
           [pushnotifycationtype isEqualToString:@"admin repot comment"]
         )
        {
            
            NSArray *detailArray;
            detailArray=[[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"], nil]objectAtIndex:0];
            NSString *userId=[detailArray valueForKey:@"id"];
            NSString *totalQues=[detailArray valueForKey:@"no_of_ques"];
            
            
            PostQuestionDetailViewController *postQues=[[PostQuestionDetailViewController alloc]init];
            postQues.ques=totalQues;
            postQues.ids=userId;
            //profileView.value=true;
            postQues.generalViewValue=1;
            postQues.acceptQuestId=questionId;
            
            [self.navigationController pushViewController:postQues animated:NO];
        
        }
        else if([pushnotifycationtype isEqualToString:@"chat"])
        {
            SPHViewController *postView=[[SPHViewController alloc]init];
            postView.receiverId=senderId;
            postView.senderId=   ReceiverIdId;
            
            [self.navigationController pushViewController:postView animated:NO];

        
        
        }
        
        
       
    }
    else
    {
        //Filtered table View
        
        searchTextField.text=[categoryTblArray objectAtIndex:indexPath.row];
        if (indexPath.row==0)
        {
            
            filteredResults=[NSMutableArray arrayWithArray:postedQuestionArray];
            
//            NSPredicate *predicate;
//            if ([searchTextStr isEqualToString:@""])
//            {
//                
//            }
//            else
//            {
//                predicate=[NSPredicate predicateWithFormat:@"SELF.question contains [c]%@",searchTextStr];
//                filteredResults=[NSMutableArray arrayWithArray:[filteredResults filteredArrayUsingPredicate:predicate]];
//            }
            //[ViewAllBtn setTitle:[NSString stringWithFormat:@"Filter:%@",[categoryTblArray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
            // [postedFriends setTitle:[NSString stringWithFormat:@"Posted Questions[%lu]",(unsigned long)[filteredResults count]] forState:UIControlStateNormal];
            
            
            
        }
        else
        {
            NSString *str=[NSString stringWithFormat:@"%ld",(indexPath.row-1)];
            NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF.categoryId contains[c] %@",str]; // Creating filter
            filteredResults=[NSMutableArray arrayWithArray:[postedQuestionArray filteredArrayUsingPredicate:filterPredicate]];
        }
        //[self tableViewScrollToTop];
        [questionTableView reloadData];
        [categoryTableView removeFromSuperview];
        // [viewPicker removeFromSuperview];
        
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


#pragma mark TextFieldMethods
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
        
        //NSString *viewTitle=ViewAllBtn.titleLabel.text;
        NSString *stringValue;
        //        if ([viewTitle rangeOfString:@"Filter:"].location!=NSNotFound)
        //        {
        //            filteredResults=questionArray;
        //            //filteredResults=[[mainArray valueForKey:@"data"]objectAtIndex:0];
        //            stringValue=[viewTitle substringWithRange:NSMakeRange(7, viewTitle.length-7)];
        //        }
        //        else
        //        {
        //sad
        //            int intValue=(int)[categoryTblArray indexOfObject:viewTitle];
        //            NSString *pickerValue=[NSString stringWithFormat:@"%d",(intValue-1)];
        //            NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF.categoryId contains[c] %@",pickerValue]; // Creating filter condition
        //            //questionArray=[questionArray filteredArrayUsingPredicate:filterPredicate];
        //            filteredResults=[NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:filterPredicate]];
        //        }
        
        //filteredResults=[NSMutableArray arrayWithArray:questionArray];
        //[postedFriends setTitle:[NSString stringWithFormat:@"Saved Questions[%d]",filteredResults.count] forState:UIControlStateNormal];
        filteredResults=[NSMutableArray arrayWithArray:postedQuestionArray];

    }
    else
    {
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF.question contains [c]%@",searchTextStr];
        //filteredResults=[NSMutableArray arrayWithArray:[questionArray filteredArrayUsingPredicate:predicate]];
        filteredResults=[NSMutableArray arrayWithArray:[postedQuestionArray filteredArrayUsingPredicate:predicate]];
        // [postedFriends setTitle:[NSString stringWithFormat:@"Saved Questions[%d]",filteredResults.count] forState:UIControlStateNormal];
        NSLog(@"%@",filteredResults);
    }
    [questionTableView reloadData];

    return YES;
    
    
}


#pragma mark Webservice Method
-(void)getUpdatesData
{
    id updateData=[[[WebServiceSingleton sharedMySingleton]getPushNotificationByUserId:_friendID]objectAtIndex:0];
    int status=[[updateData objectForKey:@"status"]intValue];
    if (status==1)
    {
        postedQuestionArray=[updateData valueForKey:@"PushNotifycation"];
        filteredResults=[NSMutableArray arrayWithArray:postedQuestionArray];
    }
    else
    {
        [filteredResults removeAllObjects];
    }
    
    if (filteredResults.count<=0)
    {
        [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"No Push Notifycations at this time" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]show];
    }
    
    [ProgressHUD dismiss];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

/*
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=(UITouch*)[event allTouches];
    if (touch.view==self.view)
    {
        [categoryTableView removeFromSuperview];
    }
    
    
    
}*/

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
