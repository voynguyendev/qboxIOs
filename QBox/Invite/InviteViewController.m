//
//  InviteViewController.m
//  QBox
//
//  Created by iapp on 29/05/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

#import "InviteViewController.h"
#import "NavigationView.h"
#import "WebServiceSingleton.h"
#import "UserDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "ActivityView.h"


@interface InviteViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    UITextField *searchFriends;
    NSMutableArray *searchData;
    UIView *inviteView;
   
    UIButton *backBtn;
    
    NSArray *personalDetailarray;
    UITableView *inviteTbl;
    NSArray *array;
    NSDictionary *dict;
    UIButton *navBackBtn;
    NSArray *mainArray;
    ActivityView *activity;
    
    UIAlertView *requestAlertView;
    
    UIAlertView *inviteFriendAlert;
    UIAlertView *deleteUserAlertView;
    NSString *alertText;
    UIButton *correctBtn;
}

@end

@implementation InviteViewController
@synthesize searchData;


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
    
    NSLog(@"%@",searchData);
    personalDetailarray=[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil];
   
  
   
    self.navigationController.navigationBarHidden=YES;
    [self createUI];
    
    
    [super viewDidLoad];
    
    //[self.view]
    // Do any additional setup after loading the view.
}

-(BOOL) prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [[[SDWebImageManager sharedManager] imageCache] clearDisk];
    [[[SDWebImageManager sharedManager] imageCache] clearMemory];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Action Methods
-(void) createUI
{
  
    NavigationView *nav = [[NavigationView alloc] init];
    nav.titleView.text = @"Invite Friends";
    
    navBackBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 10, 45, 30)];
    [navBackBtn setImage:[UIImage imageNamed:@"back_blue"] forState:UIControlStateNormal];
    [navBackBtn addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    [nav.navigationView addSubview:navBackBtn];
    [self.view addSubview:nav.navigationView];


    
    
    
    
    inviteTbl=[[UITableView alloc]init];
    inviteTbl.frame=CGRectMake(0, 44, 320,self.view.frame.size.height-90);
    inviteTbl.dataSource=self;
    inviteTbl.delegate=self;
    [self.view addSubview:inviteTbl];
    [self hideActivity];
    

    
   

}


-(void) backButton
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark Table View Methods

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return [[searchData valueForKey:@"name"]count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier=[NSString stringWithFormat:@"Cell %ld",(long)indexPath.row];
    UITableViewCell *cell=(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
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
    NSURL *url=[[searchData valueForKey:@"profile_pic"]objectAtIndex:indexPath.row];
    
    //[nameImg setImageWithURL:url placeholderImage:[UIImage imageNamed:@"name_icon"]];
    [nameImg setImage:[UIImage imageNamed:@"name_icon"]];

    [cell.contentView addSubview:nameImg];
    
    UILabel *nameLbl=[[UILabel alloc]init];
    nameLbl.text=[[searchData valueForKey:@"name"]objectAtIndex:indexPath.row];
    nameLbl.frame=CGRectMake(nameImg.frame.size.width+30, 0, 100, 30);
    nameLbl.font=[UIFont fontWithName:@"Helvetica" size:14.0f];
    [cell.contentView addSubview:nameLbl];
  

    
    UILabel *emailLbl=[[UILabel alloc]init];
    emailLbl.text=[[searchData valueForKey:@"email"]objectAtIndex:indexPath.row];
    emailLbl.frame=CGRectMake(nameLbl.frame.size.width+10, 20, 150, 30);
     emailLbl.font=[UIFont fontWithName:@"Helvetica" size:12.0f];
    [cell.contentView addSubview:emailLbl];
   
    NSLog(@"%@",searchData);
    
   
 
    correctBtn=[[UIButton alloc]init];
    correctBtn.frame=CGRectMake(emailLbl.frame.origin.x+emailLbl.frame.size.width, 10, 25, 25);
   
    
    correctBtn.tag=indexPath.row;
    
    NSString *pastRequest=[[searchData valueForKey:@"pastRequest"]objectAtIndex:indexPath.row];
    int requestStatus=[pastRequest integerValue];
    if (requestStatus==0)
    {
         [correctBtn setBackgroundImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
        correctBtn.userInteractionEnabled=YES;
        [correctBtn addTarget:self action:@selector(sendRequest:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
         [correctBtn setBackgroundImage:[UIImage imageNamed:@"right1"] forState:UIControlStateNormal];
         correctBtn.userInteractionEnabled=NO;
    }
    [cell.contentView addSubview:correctBtn];
    
    UIButton *errorBtn=[[UIButton alloc]init];
    errorBtn.frame=CGRectMake(correctBtn.frame.origin.x+30, 10, 25, 25);
    [errorBtn setBackgroundImage:[UIImage imageNamed:@"error"] forState:UIControlStateNormal];
    [errorBtn addTarget:self action:@selector(deleteUser:) forControlEvents:UIControlEventTouchUpInside];
    errorBtn.tag=indexPath.row;
    [cell.contentView addSubview:errorBtn];
    
    return cell;
    
    
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",searchData);
    NSString *userID=[[searchData valueForKey:@"id"]objectAtIndex:indexPath.row];
    
    
   NSArray *UserDetailArray=[[WebServiceSingleton sharedMySingleton]getUserInfo:userID];
    
    //UserDetailArray=[dic objectForKey:@"userdata"];
    NSLog(@"%@",UserDetailArray);
    
    UserDetailViewController *userDetail=[[UserDetailViewController alloc]init];
    userDetail.personalDetailarray=UserDetailArray;
    
    [self.navigationController pushViewController:userDetail animated:NO];

}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

#pragma mark Webservice Methods

-(void) sendRequest:(id) sender
{
    
    requestAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"You want to send friend request" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [requestAlertView show];
     NSInteger i=[sender tag];
    requestAlertView.tag=i;
}



-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==requestAlertView)
    {
        if (buttonIndex==1)
        {
            
            NSLog(@"%@",personalDetailarray);
            NSString *senderId=[[personalDetailarray valueForKey:@"id"]objectAtIndex:0];
            NSString *receiverId=[[searchData valueForKey:@"id"]objectAtIndex:requestAlertView.tag];
            
            
            
            NSArray *successArray=[[WebServiceSingleton sharedMySingleton]sendFriendRequest:senderId receiverId:receiverId];
            if (successArray)
            {
                
            
            int success=[[successArray objectAtIndex:0]intValue];
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
                UIAlertView *msg1=[[UIAlertView alloc]initWithTitle:@"Alert" message:[successArray objectAtIndex:1] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [msg1 show];
                
                     NSIndexPath *index=[NSIndexPath indexPathForRow:requestAlertView.tag inSection:0];
                
             
              
                
            }
            }
            

        }
        else
        {
           
        }
    }
    
    else if (alertView==deleteUserAlertView)
    {
        if (buttonIndex==1)
        {
            [searchData removeObject:[searchData objectAtIndex:deleteUserAlertView.tag]];
            [inviteTbl reloadData];
        }
    }
    
}







-(void) deleteUser:(id) sender
{
    NSInteger i=[sender tag];
    deleteUserAlertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"You want to delete user from list" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    deleteUserAlertView.tag=i;
    [deleteUserAlertView  show];
    

   
  

   
}

-(void) showActivity
{
    activity = [ActivityView activityView];
    [activity setTitle:@"Loading..."];
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
