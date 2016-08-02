//
//  MessageViewController.m
//  QBox
//
//  Created by iApp1 on 20/01/15.
//  Copyright (c) 2015 iapp. All rights reserved.
//

#import "SPHViewController.h"
#import "MessageViewController.h"
#import "NavigationView.h"
#import "CustomTableViewCell.h"
#import "WebServiceSingleton.h"
#import "UIImageView+WebCache.h"
#import "TopicViewController.h"
#import "NavigationView.h"
#import "CustomTableViewCell.h"
#import "AppDelegate.h"
#import "ProgressHUD.h"
#import "WebServiceSingleton.h"
#import "ProjectHelper.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"



@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate>
{
   id messageArray;
   id messageArray1;
   id messageArraysenderid;
    
}

@end

@implementation MessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    messageArray=[[NSArray alloc]init];
    messageArray1=[[NSMutableArray alloc]init];
    messageArraysenderid=[[NSArray alloc ]init];
    [ProgressHUD show:@"Please Wait.." Interaction:NO];
    [self receiveMessages];
    // Do any additional setup after loading the view.
    [self createUI];
}

#pragma mark UiView Methods
-(void)createUI
{
    NavigationView *nav=[[NavigationView alloc]init];
    nav.titleView.text=@"Messages";
    [self.view addSubview:nav.navigationView];
    
    
    UITableView *messagesTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, nav.navigationView.frame.origin.y+nav.navigationView.frame.size.height+5, self.view.frame.size.width, self.view.frame.size.height-(nav.navigationView.frame.size.height+55))];
    messagesTableView.dataSource=self;
    messagesTableView.delegate=self;
    [self.view addSubview:messagesTableView];
    
    UIButton *backBtn=[[UIButton alloc]init];
    backBtn.frame=CGRectMake(0, 10, 45, 30);
    [backBtn setImage:[UIImage imageNamed:@"back_blue"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    
                                                                                                                                                    
}

#pragma mark Action Methods
-(void)backClick
{
    
    UserProfileViewController *controller = [[UserProfileViewController alloc]init];
    [self.navigationController pushViewController:controller animated:NO];
   // [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark UITable View Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [messageArray1 count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    static NSString *cellIdentifier=@"CellIdentifier";
    UITableViewCell *cell=(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    UIImageView *userImageView;
    UIButton *userNameBtn;
    UILabel *messageTextLabel;
    UILabel *timeLabel;
    UILabel *dateLabel;
    if (cell==nil)
    {

        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        userImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 50, 50)];
        userImageView.layer.cornerRadius=(userImageView.frame.size.width)/2;
        userImageView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        userImageView.layer.borderWidth=1.0f;
        userImageView.clipsToBounds=YES;
        [userImageView viewWithTag:1];
        [cell.contentView addSubview:userImageView];
        
        
        userNameBtn=[[UIButton alloc]initWithFrame:CGRectMake(userImageView.frame.origin.x+userImageView.frame.size.width+10, 5,cell.frame.size.width-userImageView.frame.size.width,20)];
        userNameBtn.titleLabel.font=[UIFont fontWithName:@"Avenir" size:14.0f];
        [userNameBtn setTitleColor:BUTTONCOLOR forState:UIControlStateNormal];
        userNameBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        //userNameBtn.titleLabel.textAlignment=NSTextAlignmentLeft;
        [userNameBtn viewWithTag:2];
        [cell.contentView addSubview:userNameBtn];
        
        
        messageTextLabel=[[UILabel alloc]initWithFrame:CGRectMake(userImageView.frame.origin.x+userImageView.frame.size.width+10,userNameBtn.frame.origin.y+userNameBtn.frame.size.height ,cell.frame.size.width-(userImageView.frame.size.width+10), 30)];
        [messageTextLabel setTextColor:TEXTCOLOR];
        messageTextLabel.numberOfLines=0;
        messageTextLabel.font=[UIFont fontWithName:@"Avenir" size:12.0f];
        [messageTextLabel viewWithTag:3];
        [cell.contentView addSubview:messageTextLabel];
        
        timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(cell.frame.size.width-50, messageTextLabel.frame.origin.y+messageTextLabel.frame.size.height,50, 15)];
        [timeLabel viewWithTag:4];
        [timeLabel setTextColor:TEXTCOLOR];
        timeLabel.font=[UIFont fontWithName:@"Avenir" size:10.0f];
        [cell.contentView addSubview:timeLabel];
        
        UIImageView *timeImageView=[[UIImageView alloc]initWithFrame:CGRectMake(timeLabel.frame.origin.x-15, timeLabel.frame.origin.y, 15, 15)];
        [timeImageView setImage:[UIImage imageNamed:@"small_clock_icon"]];
        [cell.contentView addSubview:timeImageView];
        
        dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(timeImageView.frame.origin.x-60 ,timeLabel.frame.origin.y,60, 15)];
        [dateLabel setTextColor:TEXTCOLOR];
        dateLabel.font=[UIFont fontWithName:@"Avenir" size:10.0f];
        [dateLabel viewWithTag:5];
        [cell.contentView addSubview:dateLabel];
        
        UIImageView *dateImageView=[[UIImageView alloc]initWithFrame:CGRectMake(dateLabel.frame.origin.x-15, timeLabel.frame.origin.y, 15, 15)];
        [dateImageView setImage:[UIImage imageNamed:@"small_calendar_icon"]];
        [cell.contentView addSubview:dateImageView];
        
    }
    int size = [messageArray1 count];
    if(size==0)
        return cell;
   
    id msgArray=[messageArray1 objectAtIndex:indexPath.row];
    NSString* name=[msgArray valueForKey:@"name"];
    

   NSString *ImageURL = [msgArray valueForKey:@"user_image_thumb"];
  //  NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
  // userImageView.image = [UIImage imageWithData:imageData];
    [userImageView setImageWithURL:ImageURL placeholderImage:[UIImage imageNamed:@"name_icon"]];

    
    
  // [userImageView setImage    :[UIImage   imageNamed:@"placeholder"]];
    [userNameBtn setTitle:[msgArray valueForKey:@"name"] forState:UIControlStateNormal];
    [messageTextLabel setText:[msgArray valueForKey:@"message"]];
    NSString *date_Time=[msgArray valueForKey:@"date_time"];
    NSDateFormatter *DF=[[NSDateFormatter alloc]init];
    [DF setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
    NSDate *messageDate=[DF dateFromString:date_Time];
    
    [DF setDateFormat:@"MM/dd/yyyy hh:mm a"];
    NSString *finalDateStr=[DF stringFromDate:messageDate];
    NSMutableString *dateStr=[finalDateStr substringWithRange:NSMakeRange(0, 10)].mutableCopy;
    //dateStr=[date_Time substringWithRange:NSMakeRange(0, 10)];
    [dateStr replaceOccurrencesOfString:@"-" withString:@"/" options:NO range:NSMakeRange(0, dateStr.length)];
    
    NSString *timeStr=[finalDateStr substringWithRange:NSMakeRange(11, finalDateStr.length-11)];
    [dateLabel setText:dateStr];
    [timeLabel setText:timeStr];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPHViewController *postView=[[SPHViewController alloc]init];
    postView.friendArray=[messageArray1 objectAtIndex:indexPath.row];
    postView.receiverId=[[messageArray1 objectAtIndex:indexPath.row] valueForKey:@"sender_id"];
    postView.senderId= [[NSUserDefaults standardUserDefaults] objectForKey:@"userDetail"][@"id"];
    
    [self.navigationController pushViewController:postView animated:NO];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

#pragma mark WEbservice Methods
-(void)receiveMessages
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDetail"][@"id"];
   
    id messageArr=[[WebServiceSingleton sharedMySingleton]receiveMessage:userId];
    NSString *status=[[messageArr valueForKey:@"status"]objectAtIndex:0];
    if ([status isEqualToString:@"1"])
    {
        
        messageArray=[[messageArr valueForKey:@"message"]objectAtIndex:0];
        for(int i=0;i<[messageArray count];i++)
        {
        
        NSString* name=[[messageArray objectAtIndex:i] valueForKey:@"name" ];
        //if(![self checkexistsarray:name])
       // {
            [messageArray1 addObject:[messageArray objectAtIndex:i]];
        //}
        }
    }
    
    
    [ProgressHUD dismiss];
    
}

-(bool) checkexistsarray: (NSString *) namecompare
{
   
    for(int i=0;i<[messageArray1 count];i++)
    {
        NSString* name1=[[messageArray1 objectAtIndex:i] valueForKey:@"name"];
        if([namecompare isEqualToString:name1 ])
            {
                return YES;
            }
    }
    return NO;

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
