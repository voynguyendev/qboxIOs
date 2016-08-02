
//
//  TaBBarViewController.m
//  QBox
//
//  Created by iapp on 26/05/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//
#import "CustomnavigationController.h"
#import "TaBBarViewController.h"
#import "AddFriendViewController.h"
#import "AppDelegate.h"




@interface TaBBarViewController ()

@end

@implementation TaBBarViewController
{
    UITabBar *tabBar;
    UITabBarController *tabBarController;
    UITabBarItem *tabItem3;
    CustomnavigationController *friendNav;
    
}

@synthesize homeVC,postquestionVC;
@synthesize profileVC;
@synthesize friendListVC,inviteVC;
@synthesize userDetail;
@synthesize searchFriends;
@synthesize nameValue;
@synthesize notificationViewValue;
@synthesize 
questionId;

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
    [self showtabar];
    NSLog(@"%d",nameValue);
    tabBarController = [[UITabBarController alloc] init];
   //[tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar"]];
    
    
    tabBarController.delegate = self;
    [tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar_bottom"]];
    
    tabBar=[[UITabBar alloc]init];
    NSLog(@"tab:...%@",NSStringFromCGRect(tabBarController.tabBar.frame));
    
  //  [tabBarController.tabBar setFrame:<#(CGRect)#>
    
    
    
    
    //tabBar.backgroundColor=[UIColor whiteColor];
    
 
//    if (notificationViewValue==1)
//    {
//        tabBarController.selectedIndex=1;
//        
////        PostQuestionDetailViewController *postQuestion=[[PostQuestionDetailViewController alloc]init];
////        postQuestion.notificationQuesId=questionId;
////        postQuestion.generalViewValue=5;
////        [self.navigationController pushViewController:profileVC animated:YES];
////        [self.view addSubview:tabBarController.view];
//    }
    
     [self CreateUI];
 
   
    
    [super viewDidLoad];
    
        // Do any additional setup after loading the view.
}
-(BOOL) prefersStatusBarHidden
{
    return NO;
}

-(void)CreateUI
{
    self.view.backgroundColor=[UIColor whiteColor];
    
    
   //Save User id
    //NSArray *userId=[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"], nil];
   // NSLog(@"%@",userId);
    
    //Home,UserProfile,Post Questions,Friends,Notification
    
 
      
    float systemVersion=[[[UIDevice currentDevice]systemVersion]floatValue];;
    if (systemVersion>7.0f)
    {
        
        
        postquestionVC = [[PostQuestionViewController alloc] init];
        postquestionVC.questionId=questionId;
         CustomnavigationController *postNav=[[CustomnavigationController alloc]initWithRootViewController:postquestionVC];
        
        UITabBarItem *tabItem1=[[UITabBarItem alloc]init];
        [tabItem1 setTag:0];
        
        
        UIImage *post1=[UIImage imageNamed:@"tab_question"];
        UIImage *post2=[UIImage imageNamed:@"active_tab_question"];
        
        post1=[post1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        post2=[post2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [tabItem1 setFinishedSelectedImage:post2 withFinishedUnselectedImage:post1];
        //postquestionVC.tabBarItem=tabItem1;
        
        tabItem1.imageInsets=UIEdgeInsetsMake(6.0, 0, -6.0, 0.0);
          postNav.tabBarItem=tabItem1;
        
      
        
        userDetail=[[UserProfileViewController alloc]init];
//        id info=[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"];
//        NSString *userID=[info valueForKey:@"id"];
//        userDetail.friendID = userID;
        userDetail.Indexredirect=self.questionId;
         CustomnavigationController *userDetailNav=[[CustomnavigationController alloc]initWithRootViewController:userDetail];
        
        
        UITabBarItem *tabItem2=[[UITabBarItem alloc]init];
        
        UIImage *profile1=[UIImage imageNamed:@"tab_user"];
        UIImage *profile2=[UIImage imageNamed:@"active_tab_user"];
        
        profile1=[profile1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        profile2=[profile2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [tabItem2 setFinishedSelectedImage:profile2 withFinishedUnselectedImage:profile1];
        //profileVC.tabBarItem=tabItem2;
        tabItem2.imageInsets=UIEdgeInsetsMake(6.0, 0, -6.0, 0.0);
         userDetailNav.tabBarItem=tabItem2;
        
        
        searchFriends=[[SearchFriendsViewController alloc]init];
         CustomnavigationController *searchNav=[[CustomnavigationController alloc]initWithRootViewController:searchFriends];
        
        tabItem3=[[UITabBarItem alloc]init];
        
        UIImage *invite1=[UIImage imageNamed:@"tab_menu"];
        UIImage *invite2=[UIImage imageNamed:@"active_tab_menu"];
        
        invite1=[invite1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        invite2=[invite2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [tabItem3 setFinishedSelectedImage:invite2 withFinishedUnselectedImage:invite1];
        
        //inviteVC.tabBarItem=tabItem3;
        tabItem3.imageInsets=UIEdgeInsetsMake(6.0, 0, -6.0, 0.0);
        searchNav.tabBarItem=tabItem3;
        
        homeVC=[[TopicViewController alloc]init];
        homeVC.Indexredirect=self.questionId;
        CustomnavigationController *homeNav=[[CustomnavigationController alloc]initWithRootViewController:homeVC];
       
        //homeNav.v
        
        UITabBarItem *tabItem4=[[UITabBarItem alloc]init];
        
        UIImage *home1=[UIImage imageNamed:@"tab_home"];
        UIImage *home2=[UIImage imageNamed:@"active_tab_home"];
        
        home1=[home1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        home2=[home2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabItem4.imageInsets=UIEdgeInsetsMake(6.0, 0.0, -6.0, 0.0);
        
        // tabItem4.imageInsets=UIEdgeInsetsMake(6.0, 0, 6.0, 0.0);
        
        [tabItem4 setFinishedSelectedImage:home2 withFinishedUnselectedImage:home1];
        //homeVC.tabBarItem=tabItem4;
        
        
        
        homeNav.tabBarItem=tabItem4;
        
        
        
        
        
        
        
        //
        
        
        
        // CustomnavigationController *inviteNav=[[CustomnavigationController alloc]initWithRootViewController:inviteVC];
        
        friendListVC=[[FriendListViewController alloc]init];
       
        friendNav=[[CustomnavigationController alloc]initWithRootViewController:friendListVC];
        UITabBarItem *tabItem5=[[UITabBarItem alloc]init];
        
        UIImage *friend1=[UIImage imageNamed:@"tab_set_user"];
        UIImage *friend2=[UIImage imageNamed:@"active_tab_set_user"];
        
        friend1=[friend1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        friend2=[friend2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [tabItem5 setFinishedSelectedImage:friend2 withFinishedUnselectedImage:friend1];
        //friendListVC.tabBarItem=tabItem5;
        friendNav.tabBarItem=tabItem5;
         tabItem5.imageInsets=UIEdgeInsetsMake(6.0, 0, -6.0, 0.0);
        
        
        
        NSArray *controllers=[NSArray arrayWithObjects:homeNav,userDetailNav,postNav,friendNav,nil];
        tabBarController.viewControllers = controllers;
        if (notificationViewValue==1)
        {
             tabBarController.selectedIndex=1;
          
//Care
//            userDetail.messageValue=4;
//            NSArray *user_id=[NSArray arrayWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"], nil];
//            NSString *sender_id=[user_id objectAtIndex:0];
//            NSString *receiver_id=questionId;
//            userDetail.senderId=sender_id;
//            userDetail.receiverId=receiver_id;

           
            
        }
        else if (notificationViewValue==2)
        {
//            homeVC.notificationsViewValue=1;
//            homeVC.notificationQuesId=questionId;
            tabBarController.selectedIndex=2;
            
         
            
        }
        else if (notificationViewValue==3)
        {
            
            //SearchFriendsViewController *searchFriends=[[SearchFriendsViewController alloc]init];
            //[searchFriends viewFriends];
            
            //searchFriends.friendsValue=0;
            tabBarController.selectedIndex=3;
            //[self.navigationController pushViewController:searchFriends animated:NO];
        }
        
        else if (notificationViewValue==4)
        {
           //Care
//            userDetail.messageValue=2;
//            userDetail.user_id=questionId;
            tabBarController.selectedIndex=1;
        }
        else
        {
        tabBarController.selectedIndex=0;
        }
     
    }
    else
    {
     postquestionVC = [[PostQuestionViewController alloc] init];
        postquestionVC.questionId=questionId;
     CustomnavigationController *postNav=[[CustomnavigationController alloc]initWithRootViewController:postquestionVC];
    
    UITabBarItem *tabItem1=[[UITabBarItem alloc]init];

    
        UIImage *post1=[UIImage imageNamed:@"tab_question"];
        UIImage *post2=[UIImage imageNamed:@"active_tab_question"];
    //[tabItem1 initWithTitle:@"" image:post1 selectedImage:post2];
    
  
    [tabItem1 setFinishedSelectedImage:post2 withFinishedUnselectedImage:post1];
    //postquestionVC.tabBarItem=tabItem1;
    
    tabItem1.imageInsets=UIEdgeInsetsMake(6.0, 0, -6.0, 0.0);
    postNav.tabBarItem=tabItem1;
  
    
    
    userDetail=[[HomeViewController alloc]init];
    CustomnavigationController *userDetailNav=[[CustomnavigationController alloc]initWithRootViewController:userDetail];

    
    UITabBarItem *tabItem2=[[UITabBarItem alloc]init];
    
    UIImage *profile1=[UIImage imageNamed:@"tab_user"];
    UIImage *profile2=[UIImage imageNamed:@"active_tab_user"];
    
   
    [tabItem2 setFinishedSelectedImage:profile2 withFinishedUnselectedImage:profile1];
    //profileVC.tabBarItem=tabItem2;
     tabItem2.imageInsets=UIEdgeInsetsMake(6.0, 0, -6.0, 0.0);
    userDetailNav.tabBarItem=tabItem2;
    
    
    searchFriends=[[SearchFriendsViewController alloc]init];
    CustomnavigationController *searchNav=[[CustomnavigationController alloc]initWithRootViewController:searchFriends];
    
    tabItem3=[[UITabBarItem alloc]init];
    
        UIImage *invite1=[UIImage imageNamed:@"tab_menu"];
        UIImage *invite2=[UIImage imageNamed:@"active_tab_menu"];
    

    [tabItem3 setFinishedSelectedImage:invite2 withFinishedUnselectedImage:invite1];
    //inviteVC.tabBarItem=tabItem3;
     tabItem3.imageInsets=UIEdgeInsetsMake(6.0, 0, -6.0, 0.0);
    searchNav.tabBarItem=tabItem3;
    
    homeVC=[[TopicViewController alloc]init];
       // homeVC.nameValue=nameValue;
    CustomnavigationController *homeNav=[[CustomnavigationController alloc]initWithRootViewController:homeVC];
    
    UITabBarItem *tabItem4=[[UITabBarItem alloc]init];
    
    UIImage *home1=[UIImage imageNamed:@"tab_home"];
    UIImage *home2=[UIImage imageNamed:@"active_tab_home"];
    
   
     tabItem4.imageInsets=UIEdgeInsetsMake(6.0, 0.0, -6.0, 0.0);
   
   // tabItem4.imageInsets=UIEdgeInsetsMake(6.0, 0, 6.0, 0.0);
 
    [tabItem4 setFinishedSelectedImage:home2 withFinishedUnselectedImage:home1];
   // homeVC.tabBarItem=tabItem4;
    
    
    
    homeNav.tabBarItem=tabItem4;
  
   
    
  
    
 
    
   //
    
    
    
   // CustomnavigationController *inviteNav=[[CustomnavigationController alloc]initWithRootViewController:inviteVC];
  
    friendListVC=[[FriendListViewController alloc]init];
    friendNav=[[CustomnavigationController alloc]initWithRootViewController:friendListVC];
    UITabBarItem *tabItem5=[[UITabBarItem alloc]init];
    
    UIImage *friend1=[UIImage imageNamed:@"tab_set_user"];
    UIImage *friend2=[UIImage imageNamed:@"active_tab_set_user"];
       
    
    [tabItem5 setFinishedSelectedImage:friend2 withFinishedUnselectedImage:friend1];
    //friendListVC.tabBarItem=tabItem5;
     tabItem5.imageInsets=UIEdgeInsetsMake(6.0, 0, -6.0, 0.0);
        
    friendNav.tabBarItem=tabItem5;
    
        NSArray *controllers=[NSArray arrayWithObjects:homeNav,userDetailNav,postNav,friendNav,nil];
        tabBarController.viewControllers = controllers;
        
        if (notificationViewValue==1)
        {
            
  
             tabBarController.selectedIndex=1;
            //Care
//            userDetail.messageValue=4;
//            NSArray *user_id=[NSArray arrayWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"], nil];
//            NSString *sender_id=[user_id objectAtIndex:0];
//            NSString *receiver_id=questionId;
//            userDetail.senderId=sender_id;
//            userDetail.receiverId=receiver_id;
            
           
           
            
        }
        else if (notificationViewValue==2)
        {
          
            PostQuestionDetailViewController *postQuestion=[[PostQuestionDetailViewController alloc]init];
            postQuestion.notificationQuesId=questionId;
            postQuestion.generalViewValue=5;
              tabBarController.selectedIndex=2;
            //[self.navigationController pushViewController:postQuestion animated:NO];
            
        }
        
        else if (notificationViewValue==3)
        {
          
            //[searchFriends viewFriends];
           // searchFriends.friendsValue=0;
            tabBarController.selectedIndex=3;
            
        }
        
        else if (notificationViewValue==4)
        {
            //Care
            /*
            userDetail.messageValue=2;
            
            //           userDetail.senderId=sender_id;
            //           userDetail.receiverId=receiver_id;
            userDetail.user_id=questionId;
            */
            tabBarController.selectedIndex=1;
        }
        else
        {
            tabBarController.selectedIndex=0;
        }
       // tabBarController.selectedIndex=3;
   
  
    }
    [self.view addSubview:tabBarController.view];

    

  
    [tabBarController didMoveToParentViewController:self];
    //[self addChildViewController:tabBarController];
    //[tabBarController didMoveToParentViewController:self];

}

-(void)showtabar
{
    [tabBarController.tabBar setHidden:NO];
}
-(void)hidetabar
{
       [tabBarController.tabBar setHidden:YES];
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
    if(tabBarController.selectedIndex==1)
    {
    TaBBarViewController *TabVC=[[TaBBarViewController alloc]init];
    TabVC.notificationViewValue=1;
        TabVC.questionId=@"";

    
      [AppDelegate sharedDelegate].window.rootViewController=TabVC;
   
       // [self.navigationController pushViewController:TabVC animated:NO];
        [AppDelegate sharedDelegate].TabBarView=TabVC;

    //Care
    //[AppDelegate sharedDelegate].TabBarView = TabVC;
        
    }
    else if(tabBarController.selectedIndex==0)
    {
        
        TaBBarViewController *TabVC=[[TaBBarViewController alloc]init];
        TabVC.notificationViewValue=0;
        
        TabVC.questionId=@"";
        
        [AppDelegate sharedDelegate].window.rootViewController=TabVC;
               //[self.navigationController pushViewController:TabVC animated:NO];
        [AppDelegate sharedDelegate].TabBarView=TabVC;

        //Care
       // [AppDelegate sharedDelegate].TabBarView = TabVC;
    }
    else if(tabBarController.selectedIndex==2)
    {
        TaBBarViewController *TabVC=[[TaBBarViewController alloc]init];
        TabVC.notificationViewValue=2;
        TabVC.questionId=@"";

        
        [AppDelegate sharedDelegate].window.rootViewController=TabVC;
        [AppDelegate sharedDelegate].TabBarView=TabVC;
        
       // [self.navigationController pushViewController:TabVC animated:NO];
        
        //Care
        //[AppDelegate sharedDelegate].TabBarView = TabVC;

    
    }
    else if(tabBarController.selectedIndex==3)
    {
        TaBBarViewController *TabVC=[[TaBBarViewController alloc]init];
        TabVC.notificationViewValue=3;
        
        TabVC.questionId=@"";

        [AppDelegate sharedDelegate].window.rootViewController=TabVC;

        
        //[self.navigationController pushViewController:TabVC animated:NO];
        
        //Care
        //[AppDelegate sharedDelegate].TabBarView = TabVC;
        [AppDelegate sharedDelegate].TabBarView=TabVC;

        
    }
    

    
}

-(void)selectTab :(int)value
{
    [tabBarController setSelectedIndex:value];
    //[homeVC navigateToGenralQuestion];

}

- (void)gotoFriendProfileScreenWithFriendID:(NSString *)friendID{
    [self selectTab:3];
    
    AddFriendViewController *controller = [[AddFriendViewController alloc] init];
    controller.friendUserId = friendID;
    friendNav.navigationBarHidden = YES;
    [friendNav pushViewController:controller animated:NO];
}

- (void)didReceiveMemoryWarning
{
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
