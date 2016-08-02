//
//  UserDetailViewController.m
//  QBox
//
//  Created by iApp on 6/20/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

#import "UserDetailViewController.h"
#import "NavigationView.h"
#import "WebServiceSingleton.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "FriendListViewController.h"
#import "ActivityView.h"
#import "Base64.h"
#import "CustomButton.h"
#import "ProgressHUD.h"
#import "SPHViewController.h"
#import "ImagesUserTableViewCell.h"


@interface UserDetailViewController()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate,ActivityViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITextField *nameTextfield;
    UITextField *emailTextfield;
    UITextField *passwordTextfield;
    UITextField *mobileNumberTextfield;
    UITextField *cityTextfield;
    UITextField *idTextfield;
    UITextField *schoolTextfield;
    UITextField *gradeTextfield;
    UITextField *occupationTextfield;
    UITextField *zipCodeTextfield;
    UITextField *lastNameTextField;
    UITextField *stateTextField;
    UITextField *skillsTextField;
    UIScrollView *imageScrollView;
    UIImageView *ImagePostQuestion;
    UIScrollView *backgroundScrollview;
    NSArray *imagesuser;
    UIImage *convertedImage;
    UIImageView *profileImage;
    UIAlertView *deleteimageuser;
    
    NSArray *personalDetailarray;
    NSArray *profileData;
    
    UIButton *deleteButton;
    UIButton *makeprofileButton;
    UIButton *addphotoButton;
    UIButton *editBtn;
    UIButton *saveButton;
    UIButton *addFriend;
    UIButton *backBtn;
    UIButton   *friendSentBtn;
    UIButton *friendRequestBtn;
    UIButton *sendMessage;
    
    NSString *messageData;
    NSString *senderId;
    NSString *receiverId;
    NSString *time;
    NSString *status;
    NSString *imageString;
    
    int  outlineSpace;
    int  maxBubbleWidth ;
    int chatValue;
    int friendStatusVal;
    
    ActivityView *activity;
    NSMutableDictionary *messageText;
    UIView *popImageView;
    UIButton *backImageBtn;
    
    UIAlertView *friendRequest;
    
    UIAlertView *friendRequestSentAlertView;
    UIAlertView *friendRequestAlertView;
    NSArray *userDetail;
    
    NavigationView *nav;
    
    UIView *transparentView;
    UILabel *selectedDobLabel;
    UILabel *galleryLabel;
    UITextField *workLabel;
    UITextField *aboutmeTextview;


    
    UIView *dateView;
    UIDatePicker  *dobPickerView;
    
    UITableView *timezoneTableView;
    UITableView *imagesuserTableView;
    UITableView *genderTableView;
    UILabel *genderLabel;
    UILabel *timezoneLabel;
    
    NSArray *genderArray;
    NSArray *timezoneArray;
    
    UIButton *pickImageBtn;
    bool isfirstload;
    NSString *imageidselected;
    
   
}

@end

@implementation UserDetailViewController
@synthesize personalDetailarray;
@synthesize senderId,receiverId;
@synthesize messageValue;
@synthesize user_id;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    isfirstload=YES;
    NSArray *userData=[[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil]objectAtIndex:0];
    imageidselected=0;
   //QuestionsView
    if (messageValue==2)
    {
        
        self.user_id=[userData valueForKey:@"id"];
        
        NSArray *userDetailnew=[self getUserData:self.user_id];
        
        int userStatus=[[userDetailnew valueForKey:@"success"] intValue];
        // int successValue=[userStatus intValue];
        
        
        if (userStatus ==1)
        {
            self.personalDetailarray=[userDetailnew valueForKey:@"userdata"];
        }

 
    }
    //Notifications View of profile View
    else if(messageValue==3)
    {
        self.navigationController.navigationBarHidden=YES;
        nav=[[NavigationView alloc]init];
        nav.titleView.text=@"PROFILE";
        [self.view addSubview:nav.navigationView];
        
        [self sendMessage:nil];
    }
//Notification view of message view
    else if (messageValue==4)
    {
        
    }
    else
    {
       
       
    }
    if (self.personalDetailarray)
    {
    receiverId=[self.personalDetailarray valueForKey:@"id"];
    }
  
    senderId=[userData valueForKey:@"id"];
    outlineSpace = 22;
    maxBubbleWidth = 260;
    NSLog(@"%@",self.personalDetailarray);
    
    _chatController.receiverId=receiverId;
    _chatController.senderId=senderId;
    _chatController.delegate=self;
 
    //[self createUI];
    
    [self profileUI];
    
    
    //Notification View
/*if (messageValue==3)
    {
        self.navigationController.navigationBarHidden=YES;
        NavigationView *nav=[[NavigationView alloc]init];
        nav.titleView.text=@"PROFILE";
        [self.view addSubview:nav.navigationView];
        
        [self sendMessage:nil];
      
        
    
        
    }
    else
        
    {
    
    
    outlineSpace = 22;
    maxBubbleWidth = 260;
    NSLog(@"%@",self.personalDetailarray);
        if (messageValue==4)
        {
            
        }
        else
        {
            receiverId=[self.personalDetailarray valueForKey:@"id"];
            NSArray *userData=[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil];
            senderId=[[userData valueForKey:@"id"]objectAtIndex:0];
        }

    
  
    
    _chatController.receiverId=receiverId;
    _chatController.senderId=senderId;
    _chatController.delegate=self;
    NSLog(@"%@",user_id);
    if (messageValue==2)
    {
        //[self friendInfo];
        userDetail=[self getUserData:user_id];
        
        NSString *userStatus=[[userDetail valueForKey:@"success"]objectAtIndex:0];
        int successValue=[userStatus intValue];
        if (successValue==1)
        {
            self.personalDetailarray=[[userDetail valueForKey:@"userdata"]objectAtIndex:0];
            receiverId=[self.personalDetailarray valueForKey:@"id"];
        }
      
    }
   
   
    [self createUI];
    }*/
  
    

   /*
    
    
    */
   [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    genderArray=[[NSArray alloc]initWithObjects:@"Male",@"Female", nil];
    timezoneArray=[[NSArray alloc]initWithObjects:@"America/New_York",@"America/Chicago",@"America/Denver",@"America/Phoenix",@"America/Los_Angeles",@"America/Anchorage",@"America/Adak",@"Pacific/Honolulu",@"Asia/Ho_Chi_Minh", nil];

}


-(NSArray*) getUserData:(NSString*)userId
{
       
    NSArray *userArray =[[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil]objectAtIndex:0];
    NSString *loginUserId=[userArray valueForKey:@"id"];
    NSArray *detailArray=[[WebServiceSingleton sharedMySingleton]getFriendInfo:userId friend:loginUserId];
    
     if (detailArray)
    {
        imagesuser=[[detailArray valueForKey:@"userdata"] valueForKey:@"imagesuser" ];

        return detailArray;
        
    }
    else
    {
        return nil;
    }

}








-(void) viewWillAppear:(BOOL)animated
{
    editBtn.tag=0;
}

-(void)CreateGalleryImage
{
    
    int rowcount=(imagesuser.count%3==0?imagesuser.count/3:(imagesuser.count/3+1));
    
    int x=galleryLabel.frame.origin.x;
    int y=galleryLabel.frame.origin.y+galleryLabel.frame.size.height;
    CGFloat fullTextFieldWidth=backgroundScrollview.frame.size.width-20;
    for(int i=0;i<rowcount;i++)
    {
        ImagesUserTableViewCell *cell =[[ImagesUserTableViewCell alloc]initWithFrame:CGRectMake(x, y,fullTextFieldWidth, 80)];
        if(i*3<=imagesuser.count-1)
        {
            NSArray *imagesuserinfor=[imagesuser objectAtIndex:i*3];
            NSString *urlString = [imagesuserinfor valueForKey:@"thumb"];
            if ([urlString rangeOfString:@"http://"].location == NSNotFound)
            {
                urlString = [NSString stringWithFormat:@"http://%@", urlString];
            }
            NSURL *imageUrl=[NSURL URLWithString:urlString];
            [cell.imageuserone setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"name_icon"]];
            cell.imageuserone.userInteractionEnabled = YES;
            UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectimage:)];
            [cell.imageuserone addGestureRecognizer:imageTap];
            
            if(isfirstload==YES)
            {
                if([[imagesuserinfor valueForKey:@"isselected"] isEqualToString:@"1"])
                {
                    [cell.imageselectedone setHidden:NO];
                    
                }
                else
                {
                    [cell.imageselectedone setHidden:YES];
                }
            }
            else
            {
                if([[imagesuserinfor valueForKey:@"id"] isEqualToString:imageidselected])
                {
                    [cell.imageselectedone setHidden:NO];
                }
                else
                {
                    [cell.imageselectedone setHidden:YES];
                }
            }
            
            cell.imageuserone.tag=(i*3);
            
            
        }
        else
        {
            
            [cell.imageselectedone removeFromSuperview];
            [cell.imageuserone removeFromSuperview];
            
            
        }
        
        //images 1
        if((i*3+1)<=imagesuser.count-1)
        {
            NSArray *imagesuserinfor=[imagesuser objectAtIndex:(i*3 +1)];
            NSString *urlString = [imagesuserinfor valueForKey:@"thumb"];
            if ([urlString rangeOfString:@"http://"].location == NSNotFound)
            {
                urlString = [NSString stringWithFormat:@"http://%@", urlString];
            }
            NSURL *imageUrl=[NSURL URLWithString:urlString];
            [cell.imageusertwo setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"name_icon"]];
            
            cell.imageusertwo.tag=(i*3+1);
            
            if(isfirstload==YES)
            {
                if([[imagesuserinfor valueForKey:@"isselected"] isEqualToString:@"1"])
                {
                    [cell.imageselectedtwo setHidden:NO];
                    
                }
                else
                {
                    [cell.imageselectedtwo setHidden:YES];
                }
            }
            else
            {
                if([[imagesuserinfor valueForKey:@"id"] isEqualToString:imageidselected])
                {
                    [cell.imageselectedtwo setHidden:NO];
                }
                else
                {
                    [cell.imageselectedtwo setHidden:YES];
                }
            }
            cell.imageusertwo.tag=(i*3+1);
            
            cell.imageusertwo.userInteractionEnabled = YES;
            UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectimage:)];
            [cell.imageusertwo addGestureRecognizer:imageTap];
            
        }
        else
        {
            [cell.imageselectedtwo removeFromSuperview];
            [cell.imageusertwo removeFromSuperview];
            
        }
        
        if((i*3+2)<=imagesuser.count-1)
        {
            NSArray *imagesuserinfor=[imagesuser objectAtIndex:(i*3 +2)];
            NSString *urlString = [imagesuserinfor valueForKey:@"thumb"];
            if ([urlString rangeOfString:@"http://"].location == NSNotFound)
            {
                urlString = [NSString stringWithFormat:@"http://%@", urlString];
            }
            NSURL *imageUrl=[NSURL URLWithString:urlString];
            [cell.imageuserthree setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"name_icon"]];
            
            if(isfirstload)
            {
                if([[imagesuserinfor valueForKey:@"isselected"] isEqualToString:@"1"])
                {
                    [cell.imageselectedthree setHidden:NO];
                    
                }
                else
                {
                    [cell.imageselectedthree setHidden:YES];
                }
            }
            else
            {
                if([[imagesuserinfor valueForKey:@"id"] isEqualToString:imageidselected])
                {
                    [cell.imageselectedthree setHidden:NO];
                }
                else
                {
                    [cell.imageselectedthree setHidden:YES];
                }
            }
            cell.imageuserthree.userInteractionEnabled = YES;
            UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectimage:)];
            [cell.imageuserthree addGestureRecognizer:imageTap];
            cell.imageuserthree.tag=(i*3+2);
            
        }
        else
        {
            [cell.imageselectedthree removeFromSuperview];
            [cell.imageuserthree removeFromSuperview];
        }
        
        [backgroundScrollview addSubview:cell];

        y=y+80;
        
    }
 
}

-(void)profileUI
{
    
    
    self.navigationController.navigationBarHidden=YES;
    nav=[[NavigationView alloc]init];
    nav.titleView.text=@"Update Profile";
    [self.view addSubview:nav.navigationView];
    
    CGSize result=[[UIScreen mainScreen]bounds].size;
    
    //Scroll View
    backgroundScrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0,nav.navigationView.frame.origin.y+ nav.navigationView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    [backgroundScrollview setScrollEnabled:YES];
    
    [self.view addSubview:backgroundScrollview];
    
    UITapGestureRecognizer *resignGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignAllViews)];
    //[self.view addGestureRecognizer:resignGesture];
    
    //Profile Image
  /*  profileImage=[[UIImageView alloc]initWithFrame:CGRectMake((backgroundScrollview.frame.size.width-100)/2, 10, 100, 100)];
    profileImage.layer.cornerRadius=profileImage.frame.size.width/2;
    profileImage.layer.borderColor=[UIColor lightGrayColor].CGColor;
    profileImage.layer.borderWidth=1.0f;
    profileImage.clipsToBounds=YES;
    
    
    //[profileImage setBackgroundColor:[UIColor grayColor]];
    [backgroundScrollview addSubview:profileImage];*/
    
    [self userDetailsData];
    CGFloat fullTextFieldWidth=backgroundScrollview.frame.size.width-20;
   // CGFloat textFieldHeight=40;
    
  /*  profileImage.userInteractionEnabled=NO;
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(PickImage:)];
    tapGesture.numberOfTapsRequired=1;
    //[profileImage setImageWithURL:[self.personalDetailarray valueForKey:@"profile_pic"] placeholderImage:nil];
   [profileImage addGestureRecognizer:tapGesture];
    
    
    pickImageBtn=[[UIButton alloc]initWithFrame:CGRectMake(profileImage.frame.origin.x+70, profileImage.frame.origin.y+80,50, 30)];
    
    pickImageBtn.userInteractionEnabled=NO;
    [pickImageBtn setImage:[UIImage imageNamed:@"image_icon"] forState:UIControlStateNormal];
    [pickImageBtn addTarget:self action:@selector(PickImage:) forControlEvents:UIControlEventTouchUpInside];
    //[pickImageBtn setTitle:@"Image" forState:UIControlStateNormal];
    //[pickImageBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
   [backgroundScrollview addSubview:pickImageBtn];*/
    
    
    
   /* CGFloat halfTextFieldWidth=(backgroundScrollview.frame.size.width-30)/2;
    CGFloat fullTextFieldWidth=backgroundScrollview.frame.size.width-20;
    CGFloat textFieldHeight=40;
    //Name
    nameTextfield=[[UITextField alloc]initWithFrame:CGRectMake(10,10,halfTextFieldWidth,textFieldHeight)];
    nameTextfield.layer.borderColor=[UIColor lightGrayColor].CGColor;
    nameTextfield.layer.borderWidth=0.5f;
    nameTextfield.placeholder=@"First Name";
    nameTextfield.delegate=self;
    nameTextfield.tag=1;
    //nameTextfield.enabled=NO;
    nameTextfield.textColor=TEXTCOLOR;
    NSString *firstNameStr=[NSString stringWithFormat:@"%@",[self.personalDetailarray valueForKey:@"name"]];
    if ([firstNameStr isEqualToString:@""])
    {
        firstNameStr=@"";
    }
    else
    {
        
    }
    nameTextfield.text=firstNameStr;
    [backgroundScrollview addSubview:nameTextfield];
    
  //  UIView *paddingView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 5)];
   // nameTextfield.leftViewMode=UITextFieldViewModeAlways;
    //nameTextfield.leftView=paddingView;
    
    
    //last Name
    lastNameTextField=[[UITextField alloc]initWithFrame:CGRectMake(nameTextfield.frame.origin.x+nameTextfield.frame.size.width+10,nameTextfield.frame.origin.y, halfTextFieldWidth,textFieldHeight)];
    lastNameTextField.layer.borderColor=[UIColor lightGrayColor].CGColor;
    lastNameTextField.layer.borderWidth=0.5f;
    lastNameTextField.placeholder=@"Last Name";
    lastNameTextField.delegate=self;
   // lastNameTextField.enabled=NO;
    lastNameTextField.tag=1;
    
    NSString *lastNameStr=[NSString stringWithFormat:@"%@",[self.personalDetailarray valueForKey:@"lname"]];
    if ([lastNameStr isEqualToString:@""])
    {
        lastNameStr=@"";
    }
    else
    {
        
    }
    lastNameTextField.text=lastNameStr;
    lastNameTextField.textColor=TEXTCOLOR;
    [backgroundScrollview addSubview:lastNameTextField];
    
  //  UIView *namePaddingView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 5)];
   // lastNameTextField.leftViewMode=UITextFieldViewModeAlways;
    //lastNameTextField.leftView=namePaddingView;
    
    
    
    //School
    schoolTextfield=[[UITextField alloc]initWithFrame:CGRectMake(nameTextfield.frame.origin.x,lastNameTextField.frame.origin.y+lastNameTextField.frame.size.height+10,fullTextFieldWidth,textFieldHeight)];
    schoolTextfield.layer.borderColor=[UIColor lightGrayColor].CGColor;
    schoolTextfield.layer.borderWidth=0.5f;
    schoolTextfield.placeholder=@"School";
    schoolTextfield.delegate=self;
    schoolTextfield.tag=2;
  //  schoolTextfield.enabled=NO;
    schoolTextfield.textColor=TEXTCOLOR;
    NSString *schoolStr=[NSString stringWithFormat:@"%@",[self.personalDetailarray valueForKey:@"school"]];
    if ([schoolStr isEqualToString:@""])
    {
        schoolStr=@"";
    }
    else
    {
        
    }
    schoolTextfield.text=schoolStr;
    
    [backgroundScrollview addSubview:schoolTextfield];
    
    //paddingView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 5)];
    //schoolTextfield.leftViewMode=UITextFieldViewModeAlways;
    //schoolTextfield.leftView=paddingView;
    
   
    
#pragma mark DOB

    
    //Date Of Birth
    selectedDobLabel = [[UILabel alloc] initWithFrame:CGRectMake(schoolTextfield.frame.origin.x,schoolTextfield.frame.origin.y+schoolTextfield.frame.size.height+10,120,textFieldHeight)];
    
    NSString *dobText=[NSString stringWithFormat:@" %@",[self.personalDetailarray valueForKey:@"dob"]];
    if ([dobText isEqualToString:@" "])
    {
        dobText=@"Date Of Birth";
    }
    else
    {
        
    }
    
    selectedDobLabel.text=dobText;
    //dobTextField.text=[AppDelegate sharedDelegate].currentUser.gender;
    selectedDobLabel.layer.borderColor=[UIColor lightGrayColor].CGColor;
   // selectedDobLabel.pla
    selectedDobLabel.layer.borderWidth=0.5f;
    //selectedDobLabel.layer.cornerRadius=5.0f;
    selectedDobLabel.textColor=TEXTCOLOR;
   // selectedDobLabel.enabled=NO;
    selectedDobLabel.userInteractionEnabled=YES;
    [backgroundScrollview addSubview:selectedDobLabel];
    
  
    
    
    UITapGestureRecognizer *dobTapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dobTapGesture:)];
    [selectedDobLabel addGestureRecognizer:dobTapGesture];
    
    transparentView=[[UIView alloc]initWithFrame:self.view.bounds];
    [transparentView setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.5]];
    
    dateView=[[UIView alloc]initWithFrame:CGRectMake(0, result.height-350, result.width, 250)];
    [dateView setBackgroundColor:[UIColor whiteColor]];
    dobPickerView=[[UIDatePicker alloc]initWithFrame:CGRectMake(0,50,250,200)];
    dobPickerView.datePickerMode=UIDatePickerModeDate;
    [dateView addSubview:dobPickerView];
    
    
    
    UIButton *donePickerBtn=[[UIButton alloc]initWithFrame:CGRectMake(dateView.frame.size.width-100, 0, 100, 50)];
    [donePickerBtn setTitle:@"Done" forState:UIControlStateNormal];
    donePickerBtn.titleLabel.textAlignment=NSTextAlignmentRight;
    [donePickerBtn setTitleColor:TEXTCOLOR forState:UIControlStateNormal];
    [donePickerBtn addTarget:self action:@selector(donePickerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [dateView addSubview:donePickerBtn];
    
    UIButton *cancelPickerbtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    [cancelPickerbtn setTitle:@"Cancel" forState:UIControlStateNormal];
    donePickerBtn.titleLabel.textAlignment=NSTextAlignmentLeft;
    [cancelPickerbtn setTitleColor:TEXTCOLOR forState:UIControlStateNormal];
    [cancelPickerbtn addTarget:self action:@selector(cancelPickerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [dateView addSubview:cancelPickerbtn];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, donePickerBtn.frame.origin.y+donePickerBtn.frame.size.height, dateView.frame.size.width, 1)];
   // [lineView setBackgroundColor:TEXTCOLOR];
    [dateView addSubview:lineView];
    

    
    //timezone
    
    
    
    
    
    
    //City
    cityTextfield=[[UITextField alloc]initWithFrame:CGRectMake(selectedDobLabel.frame.origin.x+selectedDobLabel.frame.size.width+10, selectedDobLabel.frame.origin.y,90, textFieldHeight)];
    cityTextfield.layer.borderColor=[UIColor lightGrayColor].CGColor;
    cityTextfield.layer.borderWidth=0.5f;
    cityTextfield.placeholder=@"City";
    cityTextfield.delegate=self;
    cityTextfield.tag=4;
   // cityTextfield.enabled=NO;
    cityTextfield.textColor=TEXTCOLOR;
    cityTextfield.text=[NSString stringWithFormat:@"%@",[self.personalDetailarray valueForKey:@"city"]];
    [backgroundScrollview addSubview:cityTextfield];
    
   // paddingView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 5)];
    //cityTextfield.leftViewMode=UITextFieldViewModeAlways;
    //cityTextfield.leftView=paddingView;
    
    
    //State
    stateTextField=[[UITextField alloc]initWithFrame:CGRectMake(cityTextfield.frame.origin.x+cityTextfield.frame.size.width+10, cityTextfield.frame.origin.y,halfTextFieldWidth-50,textFieldHeight)];
    stateTextField.layer.borderColor=[UIColor lightGrayColor].CGColor;
    stateTextField.layer.borderWidth=0.5f;
    stateTextField.placeholder=@"State";
    stateTextField.delegate=self;
    stateTextField.tag=4;
    //stateTextField.enabled=NO;
    stateTextField.textColor=TEXTCOLOR;
    stateTextField.text=[NSString stringWithFormat:@"%@",[self.personalDetailarray valueForKey:@"state"]];
    [backgroundScrollview addSubview:stateTextField];
    
  //  paddingView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 5)];
   // stateTextField.leftViewMode=UITextFieldViewModeAlways;
    //stateTextField.leftView=paddingView;
    
    //work at
    workLabel=[[UITextField alloc]initWithFrame:CGRectMake(selectedDobLabel.frame.origin.x, cityTextfield.frame.origin.y+cityTextfield.frame.size.height+10,fullTextFieldWidth,textFieldHeight)];
    workLabel.userInteractionEnabled=YES;
    workLabel.layer.borderColor=[UIColor lightGrayColor].CGColor;
    NSString *workatText=[NSString stringWithFormat:@"%@",[self.personalDetailarray valueForKey:@"workat"]];
    workLabel.delegate=self;
    workLabel.placeholder=@"Work at";

    workLabel.text=workatText;
    workLabel.layer.borderWidth=0.5f;
    //selectedDobLabel.layer.cornerRadius=5.0f;
    workLabel.textColor=TEXTCOLOR;
    //workLabel.enabled=NO;
   // workLabel.userInteractionEnabled=NO;
    [backgroundScrollview addSubview:workLabel];

    
    
    
    //timezone
    
    
    
    
    
    
    
    //Skills And Interest
    skillsTextField=[[UITextField alloc]initWithFrame:CGRectMake(workLabel.frame.origin.x, workLabel.frame.origin.y+workLabel.frame.size.height+10,fullTextFieldWidth,textFieldHeight)];
    skillsTextField.layer.borderColor=[UIColor lightGrayColor].CGColor;
    skillsTextField.layer.borderWidth=0.5f;
    skillsTextField.placeholder=@"Skills";
    skillsTextField.delegate=self;
    skillsTextField.tag=5;
    //skillsTextField.enabled=NO;
    skillsTextField.textColor=TEXTCOLOR;
    skillsTextField.text=[NSString stringWithFormat:@"%@",[self.personalDetailarray valueForKey:@"skill_and_interest"]];
    [backgroundScrollview addSubview:skillsTextField];
    
   // paddingView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 5)];
   // skillsTextField.leftViewMode=UITextFieldViewModeAlways;
    //skillsTextField.leftView=paddingView;
    
    
    //Skills And Interest
    aboutmeTextview=[[UITextField alloc]initWithFrame:CGRectMake(skillsTextField.frame.origin.x, skillsTextField.frame.origin.y+skillsTextField.frame.size.height+10,fullTextFieldWidth,textFieldHeight)];
    aboutmeTextview.layer.borderColor=[UIColor lightGrayColor].CGColor;
    aboutmeTextview.layer.borderWidth=0.5f;
    aboutmeTextview.placeholder=@"About Me";
    aboutmeTextview.delegate=self;
    aboutmeTextview.tag=5;
   // aboutmeTextview.enabled=NO;
    aboutmeTextview.textColor=TEXTCOLOR;
    aboutmeTextview.text=[NSString stringWithFormat:@"%@",[self.personalDetailarray valueForKey:@"aboutme"]];
    [backgroundScrollview addSubview:aboutmeTextview];
    
    
    
    galleryLabel=[[UILabel alloc]initWithFrame:CGRectMake(aboutmeTextview.frame.origin.x, aboutmeTextview.frame.origin.y+aboutmeTextview.frame.size.height+10,60,textFieldHeight)];
    //galleryLabel.userInteractionEnabled=NO;
    //galleryLabel.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    galleryLabel.text=@"Gallery";
   // galleryLabel.layer.borderWidth=0.5f;
    //selectedDobLabel.layer.cornerRadius=5.0f;
    galleryLabel.textColor=TEXTCOLOR;
    galleryLabel.enabled=NO;
    //galleryLabel.userInteractionEnabled=NO;
    [backgroundScrollview addSubview:galleryLabel];
    
    
    deleteButton=[[UIButton alloc]initWithFrame:CGRectMake(galleryLabel.frame.origin.x+galleryLabel.frame.size.width+10, galleryLabel.frame.origin.y+5,65,30)];
    [deleteButton setImage:[UIImage imageNamed:@"Delete.png"] forState:UIControlStateNormal];
    deleteButton.titleLabel.font=LABELFONT;
    [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    [deleteButton setBackgroundColor:BUTTONCOLOR];
    deleteButton.titleLabel.font=[UIFont boldSystemFontOfSize:10.0f];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deletephoto:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundScrollview addSubview:deleteButton];

    
    makeprofileButton=[[UIButton alloc]initWithFrame:CGRectMake(deleteButton.frame.origin.x+deleteButton.frame.size.width+10, deleteButton.frame.origin.y,80,30)];
    [makeprofileButton setImage:[UIImage imageNamed:@"MarkasProfile.png"] forState:UIControlStateNormal];
    makeprofileButton.titleLabel.font=LABELFONT;
    [makeprofileButton setTitle:@"Make as Profile" forState:UIControlStateNormal];
    [makeprofileButton setBackgroundColor:[UIColor greenColor]];
    makeprofileButton.titleLabel.font=[UIFont boldSystemFontOfSize:10.0f];
    [makeprofileButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [makeprofileButton addTarget:self action:@selector(markasphoto:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundScrollview addSubview:makeprofileButton];
    
    addphotoButton=[[UIButton alloc]initWithFrame:CGRectMake(makeprofileButton.frame.origin.x+makeprofileButton.frame.size.width+10, makeprofileButton.frame.origin.y,65,30)];
    [addphotoButton setImage:[UIImage imageNamed:@"AddPhoto.png"] forState:UIControlStateNormal];
    addphotoButton.titleLabel.font=LABELFONT;
    [addphotoButton setTitle:@"Add Photo" forState:UIControlStateNormal];
    [addphotoButton setBackgroundColor:[UIColor blueColor]];
    addphotoButton.titleLabel.font=[UIFont boldSystemFontOfSize:10.0f];
    [addphotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addphotoButton addTarget:self action:@selector(addphoto:) forControlEvents:UIControlEventTouchUpInside];
   [backgroundScrollview addSubview:addphotoButton];
    
    
   // [self CreateGalleryImage];
    */
    
   imagesuserTableView=[[UITableView alloc]initWithFrame:CGRectMake(galleryLabel.frame.origin.x, galleryLabel.frame.origin.y+galleryLabel.frame.size.height, fullTextFieldWidth+10, 440)];
    imagesuserTableView.dataSource=self;
    imagesuserTableView.delegate=self;
    imagesuserTableView.bounces=NO;
    //imagesuserTableView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    //imagesuserTableView.layer.borderWidth=0.5;
    imagesuserTableView.separatorStyle=UITableViewCellSeparatorStyleNone;

    [backgroundScrollview addSubview:imagesuserTableView];
    
    
    
    //SaveBtn
    saveButton=[[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width-90)/2, imagesuserTableView.frame.origin.y+imagesuserTableView.frame.size.height+5,90,25)];
    saveButton.titleLabel.font=LABELFONT;
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [saveButton setBackgroundColor:BUTTONCOLOR];
    saveButton.titleLabel.font=[UIFont boldSystemFontOfSize:13.0f];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [backgroundScrollview addSubview:saveButton];
    
    
    backgroundScrollview.contentSize=CGSizeMake(backgroundScrollview.frame.size.width, saveButton.frame.origin.y+saveButton.frame.size.height+50);
    
    
 
  
    
}

-(void)resignAllViews
{
    [nameTextfield resignFirstResponder];
    [aboutmeTextview resignFirstResponder];
    [workLabel resignFirstResponder];

    [lastNameTextField resignFirstResponder];
    [emailTextfield resignFirstResponder];
    [mobileNumberTextfield resignFirstResponder];
    [cityTextfield resignFirstResponder];
    [schoolTextfield resignFirstResponder];
    [gradeTextfield resignFirstResponder];
    [stateTextField resignFirstResponder];
    [skillsTextField resignFirstResponder];
    [genderTableView removeFromSuperview];
    
    
}

-(void)userDetailsData
{
    
    
    if (messageValue==50)
    {
        backBtn=[[UIButton alloc]init];
        backBtn.frame=CGRectMake(0, 2, 45, 30);
        [backBtn setImage:[UIImage imageNamed:@"back_blue"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        [nav.navigationView addSubview:backBtn];
    }
    
    
    editBtn=[[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 80.0), 4.0, 75
                                                      , 36)];
    editBtn.titleLabel.font=LABELFONT;
    editBtn.layer.borderWidth=1.0;
    editBtn.layer.cornerRadius = 3.0;
    editBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    editBtn.titleLabel.font=[UIFont boldSystemFontOfSize:15.0f];
    [editBtn setTitle:@"EDIT" forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editBtn:) forControlEvents:UIControlEventTouchUpInside];
    [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    editBtn.tag=0;
    
    
    if (self.personalDetailarray==nil)
    {
        NSArray *userData=[[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil]objectAtIndex:0];
        
        self.user_id=[userData valueForKey:@"id"];
        
        NSArray *userDetailnew=[self getUserData:self.user_id];
        
        int userStatus=[[userDetailnew valueForKey:@"success"] intValue];
        // int successValue=[userStatus intValue];
        
        
        if (userStatus ==1)
        {
            self.personalDetailarray=[userDetailnew valueForKey:@"userdata"];
        }

        
  
        
       // [self.view addSubview:editBtn];
        
        if (messageValue==5)
        {
            backBtn=[[UIButton alloc]init];
            backBtn.frame=CGRectMake(0, 2, 45, 30);
            [backBtn setImage:[UIImage imageNamed:@"back_blue"] forState:UIControlStateNormal];
            [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
            [nav.navigationView addSubview:backBtn];
        }
        
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(PickImage:)];
        tapGesture.numberOfTapsRequired=1;
        [profileImage setUserInteractionEnabled:NO];
        [profileImage addGestureRecognizer:tapGesture];
        
        
        
    }
    else
    {
        
        sendMessage=[UIButton buttonWithType:UIButtonTypeCustom];
        sendMessage.frame=CGRectMake((self.view.frame.size.width-95), 4.0, 90, 36);
        //sendMessage.layer.cornerRadius=10.0f;
        
        //sendMessage.backgroundColor=[UIColor clearColor];
        //UIButton *sendMessage=[[UIButton alloc]initWithFrame:CGRectMake((nav.navigationView), <#CGFloat y#>, <#CGFloat width#>, //)];
        [sendMessage setTitle:@"Message" forState:UIControlStateNormal];
        sendMessage.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:17.0f];
        [sendMessage addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        
        sendMessage.layer.borderWidth=1.0;
        sendMessage.layer.cornerRadius = 3.0;
        sendMessage.layer.borderColor=[UIColor whiteColor].CGColor;
        [sendMessage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sendMessage.tag=0;
        
        
        
        backBtn=[[UIButton alloc]init];
        backBtn.frame=CGRectMake(0, 2, 45, 30);
        [backBtn setImage:[UIImage imageNamed:@"back_blue"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        [nav.navigationView addSubview:backBtn];
        if (messageValue==1)
        {
            [nav.navigationView addSubview:sendMessage];
        }
        
        else if (messageValue==2)
        {
            
            addFriend=[UIButton buttonWithType:UIButtonTypeCustom];
            addFriend.frame=CGRectMake(220, 7, 100, 30);
            addFriend.layer.cornerRadius=10.0f;
            //sendMessage.backgroundColor=[UIColor clearColor];
            //UIButton *sendMessage=[[UIButton alloc]initWithFrame:CGRectMake((nav.navigationView), <#CGFloat y#>, <#CGFloat width#>, //)];
            [addFriend setTitle:@"Add Friend" forState:UIControlStateNormal];
            addFriend.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:15.0f];
            [addFriend addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
            addFriend.layer.borderWidth=1.0;
            addFriend.layer.cornerRadius = 3.0;
            addFriend.layer.borderColor=[UIColor whiteColor].CGColor;
            [addFriend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            addFriend.tag=0;
            
            
            friendSentBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            friendSentBtn.frame=CGRectMake(220, 7, 100, 30);
            friendSentBtn.layer.cornerRadius=10.0f;
            friendSentBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            [friendSentBtn setTitle:@"Friend Request\n         Sent" forState:UIControlStateNormal];
            
            friendSentBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:10.0f];
            [friendSentBtn addTarget:self action:@selector(FriendRequestSent:) forControlEvents:UIControlEventTouchUpInside];
            
            friendSentBtn.layer.borderWidth=1.0;
            friendSentBtn.layer.cornerRadius = 3.0;
            friendSentBtn.layer.borderColor=[UIColor whiteColor].CGColor;
            [friendSentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            friendSentBtn.tag=0;
            
            friendRequestBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            friendRequestBtn.frame=CGRectMake(200, 7, 120, 30);
            friendRequestBtn.layer.cornerRadius=10.0f;
            [friendRequestBtn setTitle:@"Friend Request" forState:UIControlStateNormal];
            friendRequestBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:10.0f];
            [friendRequestBtn addTarget:self action:@selector(FriendRequest:) forControlEvents:UIControlEventTouchUpInside];
            
            friendRequestBtn.layer.borderWidth=1.0;
            friendRequestBtn.layer.cornerRadius = 3.0;
            friendRequestBtn.layer.borderColor=[UIColor whiteColor].CGColor;
            [friendRequestBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            friendRequestBtn.tag=0;
            
            
            NSString *friendStatus=[self.self.personalDetailarray valueForKey:@"status"];
            friendStatusVal=[friendStatus intValue];
            NSLog(@"%@",userDetail);
            
            //Friend Request Sent
            if (friendStatusVal==0)
            {
                userDetail=[userDetail objectAtIndex:0];
                NSString *sender_id=[[userDetail valueForKey:@"userdata"]valueForKey:@"sender_id"];
                NSArray *userData=[[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil]objectAtIndex:0];
                NSString *loggedUserId=[userData valueForKey:@"id"];
                if ([sender_id isEqualToString:loggedUserId])
                {
                    [nav.navigationView addSubview:friendSentBtn];
                }
                else
                {
                    [nav.navigationView addSubview:friendRequestBtn];
                }
                
                
            }
            //Already in friend list
            else if(friendStatusVal==1)
            {
              [nav.navigationView addSubview:sendMessage];
            }
            //not in friend list
            else if (friendStatusVal==3)
            {
                //NSString *user_id=[self.self.personalDetailarray valueForKey:@"id"];
                self.self.personalDetailarray=[[userDetail valueForKey:@"userdata"]objectAtIndex:0];
                
                NSString *userIds=[self.self.personalDetailarray valueForKey:@"id"];
                NSArray *userData=[[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil]objectAtIndex:0];
                NSString *loggedUserId=[userData valueForKey:@"id"];
                if ([userIds isEqualToString:loggedUserId])
                {
                    //[self.view addSubview:editBtn];
                }
                else
                {
                    [nav.navigationView addSubview:addFriend];
                }
            }
        }
    }
    NSString *userProfileImage;
    userProfileImage=[self.self.personalDetailarray valueForKey:@"profile_pic"];
    if ([userProfileImage isEqualToString:@"(null)"])
    {
        userProfileImage=@"";
    }
    
    if (!userProfileImage.length==0)
    {
       /* NSURL *url=[NSURL URLWithString:userProfileImage];
        
        [profileImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"user_icon"]];
        
        NSData *imgdata=[[NSData alloc]initWithContentsOfURL:url];
        
        UIImage *image=[[UIImage alloc]initWithData:imgdata];
      
        profileImage.image=image;
        
        
        if (messageValue==0)
        {
            
        }
        else
        {
            UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popImageView:)];
            tapGesture.numberOfTapsRequired=1;
            [profileImage addGestureRecognizer:tapGesture];
            [profileImage setUserInteractionEnabled:YES];
        }*/
    }
    else
    {
       
        //If Login With Facebook Then login Id is 1
        //if Login with gmail then login id is 2
        //If sign in then login id is 3
        id loginData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginDetails"];
        NSString *loginId=[loginData objectForKey:@"loginId"];
        userProfileImage=[loginData objectForKey:@"profileImage"];
        //Sign In
        if ([loginId isEqualToString:@"3"])
        {
            
        }
        //Fb login or gmail login
        else
        {
          /*  if (![userProfileImage isEqualToString:@""])
            {
                NSURL *url=[NSURL URLWithString:userProfileImage];
                [profileImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"user_icon"]];
            }
            else
            {
                [profileImage setImage:[UIImage imageNamed:@"user_icon"]];
            }*/
        }
        
        
    }
    // [profileImage setImage:[UIImage imageNamed:@"name_icon"]];
    [backgroundScrollview addSubview:profileImage];
    
    
    //NSString *str=[self.self.personalDetailarray valueForKey:@"profile_pic"];
    //  NSString *imageStr=[NSString stringWithFormat:@"%@",[[self.personalDetailarray valueForKey:@"profile_pic"]objectAtIndex:0]];
    if (!userProfileImage.length==0)
    {
       /* NSURL *urls=[NSURL URLWithString:userProfileImage];
        NSData *data=[NSData dataWithContentsOfURL:urls];
        convertedImage=[UIImage imageWithData:data];*/
    }

//    NSString *urlString=[self.personalDetailarray valueForKey:@"profile_pic"];
//    if (!urlString.length==0)
//    {
//        NSURL *url=[NSURL URLWithString:urlString];
//        
//        
//        [profileImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"user_icon"]];
//        
//        if (messageValue==0)
//        {
//            
//        }
//        else
//        {
//            UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popImageView:)];
//            tapGesture.numberOfTapsRequired=1;
//            [profileImage addGestureRecognizer:tapGesture];
//            [profileImage setUserInteractionEnabled:YES];
//        }
//    }
//    else
//    {
//        [profileImage setImage:[UIImage imageNamed:@"user_icon"]];
//    }
//    // [profileImage setImage:[UIImage imageNamed:@"name_icon"]];
//    [backgroundScrollview addSubview:profileImage];
//    
//    
//    NSString *str=[self.personalDetailarray valueForKey:@"profile_pic"];
//    //  NSString *imageStr=[NSString stringWithFormat:@"%@",[[self.personalDetailarray valueForKey:@"profile_pic"]objectAtIndex:0]];
//    if (!str.length==0)
//    {
//        NSURL *urls=[NSURL URLWithString:str];
//        NSData *data=[NSData dataWithContentsOfURL:urls];
//        
//        convertedImage=[UIImage imageWithData:data];
//    }
    

}




-(void) addFriend:(id) sender
{
    if (friendStatusVal==0)
    {
        UIAlertView *friendAlert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"You have already send friend request to this user" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [friendAlert show];
    }
    else
    {
    friendRequest=[[UIAlertView alloc]initWithTitle:@"Friend Request" message:@"Do you want to send friend request?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [friendRequest show];
    }
}

-(void)FriendRequestSent:(id)sender
{
   friendRequestSentAlertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Do you want to reject friend request?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [friendRequestSentAlertView show];
}

-(void)FriendRequest:(id)sender
{
   friendRequestAlertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Do you want to accept friend request" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [friendRequestAlertView show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==friendRequest)
    {
        if (buttonIndex==1)
        {
            self.personalDetailarray=[[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil]objectAtIndex:0];
            NSString *sender_Id=[self.personalDetailarray valueForKey:@"id"];
           // NSString *receiverId=[[friendsData valueForKey:@"id"]objectAtIndex:acceptRequestAlert.tag];
            NSString *receiver_Id=user_id;
            NSArray *requestArray=[[[WebServiceSingleton sharedMySingleton]sendFriendRequest:sender_Id receiverId:receiver_Id]objectAtIndex:0];
            NSString *successArray=[requestArray valueForKey:@"success"];
            if (successArray)
            {
                
                
                int success=[successArray intValue];
                if (success==0)
                {
                 UIAlertView *msg=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"You have already send friend request to this user" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [msg show];
                }
                else
                {
                    NSString *message=[requestArray valueForKey:@"message"];
                    UIAlertView *msg1=[[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [msg1 show];
                    
                    [addFriend removeFromSuperview];
                    [self.view addSubview:friendSentBtn];
                }
            }

        }
    }
    
    
    else if (alertView==friendRequestSentAlertView)
    {
        if (buttonIndex==1)
        {
            self.personalDetailarray=[[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil]objectAtIndex:0];
            NSString *sender_Id=[self.personalDetailarray valueForKey:@"id"];
            // NSString *receiverId=[[friendsData valueForKey:@"id"]objectAtIndex:acceptRequestAlert.tag];
            NSString *receiver_Id=user_id;
         
            NSArray *rejectData=[[WebServiceSingleton sharedMySingleton]rejectFriendRequestSent:sender_Id receiverId:receiver_Id];
            int rejectStatus=[[[rejectData valueForKey:@"success"]objectAtIndex:0]intValue];
            if (rejectStatus==1)
            {
                UIAlertView *successMessage=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Friend Request Deleted" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [successMessage show];
                [friendSentBtn removeFromSuperview];
                [self.view addSubview:addFriend];
            }
            else
            {
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Friend Request Deletion Failed" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alertView show];
            }
            
            
        }
    }
    
    else if (alertView==friendRequestAlertView)
    {
        if (buttonIndex==1)
        {
            
        
        self.personalDetailarray=[[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil]objectAtIndex:0];
        NSString *sender_Id=[self.personalDetailarray valueForKey:@"id"];
        // NSString *receiverId=[[friendsData valueForKey:@"id"]objectAtIndex:acceptRequestAlert.tag];
        NSString *receiver_Id=user_id;
        
            NSArray *rejectData=[[WebServiceSingleton sharedMySingleton]acceptRequest:receiver_Id senderId:sender_Id pushnotifycationid:@"0"];
        int rejectStatus=[[[rejectData valueForKey:@"success"]objectAtIndex:0]intValue];
        if (rejectStatus==1)
        {
            UIAlertView *successMessage=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Friend Request Accepted" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [successMessage show];
            
            //[fri removeFromSuperview];
            [friendRequestBtn removeFromSuperview];
            [self.view addSubview:sendMessage];
            
        }
        }
    }
    
    else if (alertView==deleteimageuser)
    {
        if (buttonIndex==1)
        {
            profileData=[[NSArray alloc]initWithObjects:@"",@"",@"",@"",@"",[self.personalDetailarray valueForKey:@"id"],@"",@"",@"",@"",@"",@"",@"delete",imageidselected,@"",@"", nil];
            
            NSArray *array =  [[WebServiceSingleton sharedMySingleton]saveProfile:profileData imageBase64String:@""];
            imagesuser=[array valueForKey:@"imagesuse"];
            imageidselected=0;
            if(imagesuser)
                [ imagesuserTableView reloadData];
            
        }
    }
    
    
}

-(void) popImageView:(UIGestureRecognizer*)recognizer
{
   
    
   
    imageScrollView=[[UIScrollView alloc]init];
    imageScrollView.delegate=self;
    imageScrollView.frame=CGRectMake(0, 44, 320, self.view.frame.size.height-44);
    imageScrollView.maximumZoomScale=5.0;
    imageScrollView.minimumZoomScale=1.0;
    imageScrollView.delegate=self;
    [self.view addSubview:imageScrollView];
    
    
   
    popImageView=[[UIView alloc]init];
    popImageView.frame=CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44);
    [popImageView setBackgroundColor:[UIColor whiteColor]];
    //[self.view addSubview:popImageView];
   ImagePostQuestion=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, popImageView.frame.size.width, popImageView.frame.size.height)];
    [imageScrollView addSubview:ImagePostQuestion];
    // NSInteger i=
    
    NSString *userImageStr=[self.personalDetailarray valueForKey:@"profile_pic"];
    
    if ([userImageStr rangeOfString:@"http://"].location == NSNotFound)
    {
        userImageStr = [NSString stringWithFormat:@"http://%@", userImageStr];
    }
//    NSString *thumbUrlString=[[friendsData valueForKey:@"thumb"]objectAtIndex:recognizer
//                              .view.tag];
    
    NSURL *imageUrl=[NSURL URLWithString:userImageStr];
   // NSURL *thumbUrl=[NSURL URLWithString:thumbUrlString];
   // UIImage *thumbImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:thumbUrl]];
    if (imageUrl)
    {
        [ImagePostQuestion setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"name_icon"]];
    }
    else
    {
        
    }
    
    UITapGestureRecognizer *imageGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignImageView)];
    imageGesture.numberOfTapsRequired=1;
    [imageScrollView addGestureRecognizer:imageGesture];
    
    
    
    
//    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureDetected:)];
//    
//    [popImageView addGestureRecognizer:pinchGestureRecognizer];
    
    
    
    
    
    UIPinchGestureRecognizer *pinchGesture=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchImageGesture:)];
    [pinchGesture setDelegate:self];
    [imageScrollView addGestureRecognizer:pinchGesture];
    
    
    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
    [rotationRecognizer setDelegate:self];
    [imageScrollView addGestureRecognizer:rotationRecognizer];
    
    
//    backImageBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 10, 45, 30)];
//    [backImageBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    [backImageBtn addTarget:self action:@selector(backImageView) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backImageBtn];
    
    
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // if the gesture recognizers are on different views, don't allow simultaneous recognition
    if (gestureRecognizer.view != otherGestureRecognizer.view)
        return NO;
    
    // if either of the gesture recognizers is the long press, don't allow simultaneous recognition
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] || [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
        return NO;
    
    return YES;
}


- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer
{
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
}

- (void)handleRotate:(UIRotationGestureRecognizer *)recognizer
{
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    recognizer.rotation = 0;
}




-(void) resignImageView
{
    [imageScrollView removeFromSuperview];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return ImagePostQuestion;
}

-(void) backImageView
{
    [popImageView removeFromSuperview];
    [backImageBtn removeFromSuperview];
    
}

-(void)pinchImageGesture:(UIPinchGestureRecognizer*)recognizer
{
    UIGestureRecognizerState state=[recognizer state];
    if (state==UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGFloat scale = [recognizer scale];
        [recognizer.view setTransform:CGAffineTransformScale(recognizer.view.transform, scale, scale)];
        [recognizer setScale:1.0];
        
    }
    
}




#pragma  mark Action Methods
-(void)donePickerBtnAction:(id)sender
{
    NSDate *date=[dobPickerView date];
    NSDate *CD=[NSDate date];
    if ([date compare:CD]==NSOrderedDescending)
    {
        [[[UIAlertView alloc]initWithTitle:@"" message:@"Future date can't be chosen as a Date of birth." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]show];
    }
    else
    {
        
        NSDateFormatter *DF=[[NSDateFormatter alloc]init];
        [DF setDateFormat:@"MM/dd/yyyy"];
        
        NSString *currentDate=[NSString stringWithFormat:@" %@",[DF stringFromDate:date]];
        selectedDobLabel.text=currentDate;
    }
    
    
    [dateView removeFromSuperview];
    [transparentView removeFromSuperview];
}
-(void)cancelPickerBtnAction:(id)sender
{
    [dateView removeFromSuperview];
    [transparentView removeFromSuperview];
}
-(void)dobTapGesture:(UITapGestureRecognizer*)recognizer
{
    
    [nameTextfield resignFirstResponder];
    [lastNameTextField resignFirstResponder];
    [schoolTextfield resignFirstResponder];
    [cityTextfield resignFirstResponder];
    [genderTableView removeFromSuperview];
    [stateTextField resignFirstResponder];
    [skillsTextField resignFirstResponder];
    [self.view addSubview:transparentView];
    [dobPickerView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:dateView];
    
    
    
    
    UITapGestureRecognizer *transparentGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeTransparentView:)];
    [transparentView addGestureRecognizer:transparentGesture];
}

-(void)removeTransparentView:(UITapGestureRecognizer*)recognizer
{
    [transparentView removeFromSuperview];
    [dateView removeFromSuperview];
    [genderTableView removeFromSuperview];
}


-(void)genderTapGesture:(UITapGestureRecognizer*)recognizer
{
    [nameTextfield resignFirstResponder];
    [lastNameTextField resignFirstResponder];
    [schoolTextfield resignFirstResponder];
    [cityTextfield resignFirstResponder];
    [stateTextField resignFirstResponder];
    [skillsTextField resignFirstResponder];
    [dateView removeFromSuperview];
    if ([backgroundScrollview.subviews containsObject:genderTableView])
    {
        [genderTableView removeFromSuperview];
    }
    else
    {
        [backgroundScrollview addSubview:genderTableView];
    }
    
    
    //[self.view addSubview:transparentView];
    
    //    UITapGestureRecognizer *transparentGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeTransparentView:)];
    //    [transparentView addGestureRecognizer:transparentGesture];
}




-(void)timezoneTapGesture:(UITapGestureRecognizer*)recognizer
{
    [nameTextfield resignFirstResponder];
    [lastNameTextField resignFirstResponder];
    [schoolTextfield resignFirstResponder];
    [cityTextfield resignFirstResponder];
    [stateTextField resignFirstResponder];
    [skillsTextField resignFirstResponder];
    [dateView removeFromSuperview];
    if ([backgroundScrollview.subviews containsObject:timezoneTableView])
    {
        [timezoneTableView removeFromSuperview];
    }
    else
    {
       [backgroundScrollview addSubview:timezoneTableView];
    }
   
    
    //[self.view addSubview:transparentView];
  
//    UITapGestureRecognizer *transparentGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeTransparentView:)];
//    [transparentView addGestureRecognizer:transparentGesture];
}

-(void) backClick
{
// [self.navigationController popViewControllerAnimated:NO];
     UserProfileViewController *controller = [[UserProfileViewController alloc]init];
    [self.navigationController pushViewController:controller animated:NO];
    
}
-(void) markasphoto:(id)sender
{
    if(imageidselected<=0)
    {
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Please select a image" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [alert show];
        return;
    }
    
    profileData=[[NSArray alloc]initWithObjects:@"",@"",@"",@"",@"",[self.personalDetailarray valueForKey:@"id"],@"",@"",@"",@"",@"",@"",@"markprofile",imageidselected,@"",@"", nil];
    
    NSArray *array =  [[WebServiceSingleton sharedMySingleton]saveProfile:profileData imageBase64String:@""];
    UIAlertView *sucessUpdateAlert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Successfully updated" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
   // imageidselected
    [sucessUpdateAlert show];
    
}
-(void) deletephoto:(id)sender
{
    if(imageidselected<=0)
    {
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Please select a image" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [alert show];
        return;
    }
    deleteimageuser=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Do you want to delete this image" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [deleteimageuser show];

}
-(void) addphoto:(id)sender
{
    [nameTextfield resignFirstResponder];
    [lastNameTextField resignFirstResponder];
    [emailTextfield resignFirstResponder];
    [mobileNumberTextfield resignFirstResponder];
    [cityTextfield resignFirstResponder];
    [schoolTextfield resignFirstResponder];
    [gradeTextfield resignFirstResponder];
    [stateTextField resignFirstResponder];
    [skillsTextField resignFirstResponder];
    [genderTableView removeFromSuperview];
    
    
    
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"Action Sheet" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Open Camera" otherButtonTitles:@"Saved Photos", nil];
    //[actionSheet showInView:self.view];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

-(void) PickImage :(UITapGestureRecognizer*) recognizer
{
    [nameTextfield resignFirstResponder];
    [lastNameTextField resignFirstResponder];
    [emailTextfield resignFirstResponder];
    [mobileNumberTextfield resignFirstResponder];
    [cityTextfield resignFirstResponder];
    [schoolTextfield resignFirstResponder];
    [gradeTextfield resignFirstResponder];
    [stateTextField resignFirstResponder];
    [skillsTextField resignFirstResponder];
    [genderTableView removeFromSuperview];
    
    

    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"Action Sheet" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Open Camera" otherButtonTitles:@"Saved Photos", nil];
    //[actionSheet showInView:self.view];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
       
        
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *imagePicker =
            [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType =
            UIImagePickerControllerSourceTypeCamera;
            //imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
            imagePicker.allowsEditing = NO;
            [self presentViewController:imagePicker
                               animated:YES completion:nil];
            // _newMedia = YES;
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Camera is not available" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Ok", nil];
            [alert show];
        }

    }
    else if (buttonIndex==1)
    {
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeSavedPhotosAlbum])
        {
            UIImagePickerController *imagePicker =
            [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType =
            UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
            imagePicker.allowsEditing = NO;
            [self presentViewController:imagePicker
                               animated:YES completion:nil];
           
        }
    }
}

-(UIImage*)fixrotation:(UIImage *)image{
    
    
    if (image.imageOrientation == UIImageOrientationUp) return image;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage *) resizeimage :(UIImage *)originalImage
{
    
    CGSize newSize;
    UIGraphicsBeginImageContext(newSize);
    newSize.width=originalImage.size.width;
    newSize.height=originalImage.size.height;
    
    if (originalImage.size.width > 1920)
    {
        newSize.width = 1920;
        newSize.height = (1920 * originalImage.size.height) / originalImage.size.width;
        
    }
    
    if (originalImage.size.height > 1080)
    {
        
        newSize.width = (1080 * originalImage.size.width) / originalImage.size.height;
        newSize.height = 1080;
        
        
    }
    
    
    
    return [self imageWithImage :originalImage scaledToSize:newSize] ;
    
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
   
   
    convertedImage=[info valueForKey:UIImagePickerControllerOriginalImage];
   
    chatValue=3;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self showActivityInView:self.view];

    
//    CGRect rect = CGRectMake(0.0, 0.0, 320, self.view.frame.size.height);
//    UIGraphicsBeginImageContext(rect.size);
//    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];//here you can use your image view instead of self,view...
//    [convertedImage drawInRect:rect];
//    convertedImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    
    
}



-(void) save
{
    [nameTextfield resignFirstResponder];
    [lastNameTextField resignFirstResponder];
    [emailTextfield resignFirstResponder];
    [mobileNumberTextfield resignFirstResponder];
    [cityTextfield resignFirstResponder];
    [schoolTextfield resignFirstResponder];
    [gradeTextfield resignFirstResponder];
    [genderTableView removeFromSuperview];
    [stateTextField resignFirstResponder];
    [skillsTextField resignFirstResponder];
    [backgroundScrollview setContentOffset:CGPointMake(0, 0) animated:YES];
    
   
    BOOL validationBool= [self validationCheck];
    if (validationBool==YES)
    {
        
        [self saveClick];
        profileImage.userInteractionEnabled=NO;
      //  [saveButton removeFromSuperview];
        // saveButton.enabled=NO;
       // [saveButton setTitle:@"" forState:UIControlStateNormal];
       // [saveButton setBackgroundColor:[UIColor clearColor]];
        //[saveButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    }
  

}

-(void) saveClick
{
    [self showActivityInView:self.view];
}

-(void) activityDidAppear
{
    if (chatValue==0)
    {
        
     
    imageString=[self encodeToBase64String:convertedImage];
        NSString *genderStr=genderLabel.text;
        if ([genderStr rangeOfString:@"Male"].location!=NSNotFound)
        {
            genderStr=@"0";
        }
        else
        {
            genderStr=@"1";
        }
   
    if([selectedDobLabel.text isEqualToString:@"Date Of Birth"])
        selectedDobLabel.text=@"";
        
    //http://54.69.127.235/question_app/user_edit.php?name=&email=&school=&grade=&city=&user_id=&lname=&dob=&gender=&state=&skill_and_interest=&profile_pic=
    profileData=[[NSArray alloc]initWithObjects:nameTextfield.text,[self.personalDetailarray valueForKey:@"email"],schoolTextfield.text,@"",cityTextfield.text,[self.personalDetailarray valueForKey:@"id"],lastNameTextField.text,selectedDobLabel.text,genderStr,stateTextField.text,skillsTextField.text,@"null",@"saveprofile",@"",aboutmeTextview.text,workLabel.text, nil];
    
        
        //NSString * test=[profileData objectAtIndex:14];
        
    [[WebServiceSingleton sharedMySingleton]saveProfile:profileData imageBase64String:@""];
    
        
        
    
    if (imageString==nil)
    {
        NSLog(@"%@",self.personalDetailarray);
        NSString *str=[self.personalDetailarray valueForKey:@"profile_pic"];
        if (str)
        {
            //[profileImage setImage:[UIImage imageNamed:@"pic_upload"]];
        }
        else
        {
        NSURL *url=[self.personalDetailarray valueForKey:@"profile_pic"];
        [profileImage setImageWithURL:url];
        }
    }
    else
    {
        [profileImage setImage:convertedImage];
    }
    
    
    [editBtn setTitle:@"EDIT" forState:UIControlStateNormal];
    [self textfieldEnable];
    //[backgroundScrollview setContentOffset:CGPointMake(0, 0)];
    editBtn.tag=0;
        
        
        UIAlertView *sucessUpdateAlert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Successfully updated" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [sucessUpdateAlert show];
      
    
    }
    else if(chatValue==3)
    {
        if (convertedImage)
        {
            convertedImage=[self fixrotation:convertedImage];
            
            convertedImage=[self resizeimage:convertedImage];
            
            
            convertedImage = [UIImage imageWithData:UIImageJPEGRepresentation(convertedImage, 0)];
            
            imageString=[self encodeToBase64String:convertedImage];
        }
        
        
        //[profileImage setImage:convertedImage];
        
        //[imagePickerView removeFromSuperview];
        
        profileData=[[NSArray alloc]initWithObjects:@"",@"",@"",@"",@"",[self.personalDetailarray valueForKey:@"id"],@"",@"",@"",@"",@"",@"",@"addphoto",@"",@"",@"", nil];
        
        NSArray *array =  [[WebServiceSingleton sharedMySingleton]saveProfile:profileData imageBase64String:imageString];
        imagesuser=[array valueForKey:@"imagesuse"];
        if(imagesuser)
            [ imagesuserTableView reloadData];
        
        UIAlertView *sucessUpdateAlert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Add Successfully" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [sucessUpdateAlert show];
    
    }
    
    else
    {
        
        [self resignFirstResponder];
        
        // Messages come prepackaged with the contents of the message and a timestamp in milliseconds
        NSLog(@"Message Contents: %@", messageText);
        NSLog(@"Timestamp: %@", messageText[kMessageTimestamp]);
        time=messageText[kMessageTimestamp];
        messageData=messageText[kMessageContent];
        // Evaluate or add to the message here for example, if we wanted to assign the current userId:
        //message[@"sentByUserId"] = @"currentUserId";
        NSLog(@"%@",senderId);
        messageText[@"sentByUserId"] = senderId;
        
        [self sendMessage:messageData date:time];
        [_chatController addNewMessage:messageText];
        }
    


     [self hideActivity];
    
    
}






- (NSString *)encodeToBase64String:(UIImage *)image
{
    //return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return [UIImagePNGRepresentation(image) base64EncodedString];
}

-(void) selectimage:(UITapGestureRecognizer *)recognizer{
   
    int index=recognizer.view.tag;
    //ImagesUserTableViewCell *parentview=recognizer.view.superview;
    imageidselected=[[imagesuser objectAtIndex:index] valueForKey:@"id"];
    isfirstload=NO;
   [ imagesuserTableView reloadData];
    
}

-(void) editBtn:(id) sender
{
    [backgroundScrollview setContentOffset:CGPointMake(0, 0)];
    if (editBtn.tag==0)
    {
        [editBtn setTitle:@"CANCEL" forState:UIControlStateNormal];
        //saveButton.enabled=YES;
       // [saveButton setEnabled:YES];
//        [saveButton setTitle:@"Save" forState:UIControlStateNormal];
//        [saveButton setBackgroundColor:BUTTONCOLOR];
        [backgroundScrollview addSubview:saveButton];
        
        [self textfieldDisable];
        editBtn.tag=1;
        
        [profileImage setUserInteractionEnabled:YES];
        [backgroundScrollview setScrollEnabled:YES];
        
 
    }
    else if (editBtn.tag==1)
    {
         [editBtn setTitle:@"EDIT" forState:UIControlStateNormal];
        NSLog(@"%@",profileData);
     
        if (profileData)
        {
            nameTextfield.text=[profileData objectAtIndex:1];
            emailTextfield.text=[profileData objectAtIndex:2];
            schoolTextfield.text=[profileData objectAtIndex:3];
            gradeTextfield.text=[profileData objectAtIndex:4];
            cityTextfield.text=[profileData objectAtIndex:5];
           // [profileImage setImage:[UIImage imageNamed:imageString]];
        }
    else
    {
       
        nameTextfield.text=[self.personalDetailarray valueForKey:@"name"];
        emailTextfield.text=[self.personalDetailarray valueForKey:@"email"];
        cityTextfield.text=[self.personalDetailarray valueForKey:@"city"];
         gradeTextfield.text=[self.personalDetailarray valueForKey:@"grade"];
          schoolTextfield.text=[self.personalDetailarray valueForKey:@"school"];
        NSString *profileImageStr=[self.personalDetailarray valueForKey:@"profile_pic"];
         //NSURL *url=[self.personalDetailarray valueForKey:@"profile_pic"];
        if ([profileImageStr isEqualToString:@""] || [profileImageStr isEqualToString:@"(null)"])
        {
        id loginDetail=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginDetails"];
        NSString *loginId=[loginDetail valueForKey:@"loginId"];
        if ([loginId isEqualToString:@"3"])
        {
            
        }
        else
        {
            profileImageStr=[loginDetail valueForKey:@"profileImage"];
        }
        }
        else
        {
           
        }
        NSURL *url=[NSURL URLWithString:profileImageStr];
        [profileImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"user_icon"]];
    }
        //saveButton.enabled=NO;
        [profileImage setUserInteractionEnabled:NO];
        [saveButton removeFromSuperview];
//        [saveButton setTitle:@"" forState:UIControlStateNormal];
//        [saveButton setBackgroundColor:[UIColor clearColor]];
       // [saveButton setEnabled:NO];
        [self textfieldEnable];
        [backgroundScrollview setScrollEnabled:NO];
       
       editBtn.tag=0;
    }
    
    
   

}

-(void) textfieldEnable
{
  /*  nameTextfield.enabled=NO;
    lastNameTextField.enabled=NO;
    emailTextfield.enabled=NO;
    passwordTextfield.enabled=NO;
    selectedDobLabel.enabled=NO;
    cityTextfield.enabled=NO;
    idTextfield.enabled=NO;
    schoolTextfield.enabled=NO;
    gradeTextfield.enabled=NO;
    selectedDobLabel.userInteractionEnabled=NO;
    genderLabel.userInteractionEnabled=NO;
    stateTextField.enabled=NO;
    skillsTextField.enabled=NO;
    profileImage.userInteractionEnabled=NO;
    pickImageBtn.userInteractionEnabled=NO;
    timezoneLabel.userInteractionEnabled=NO;*/
    
    
    
}

-(void) textfieldDisable
{
 /*   timezoneLabel.userInteractionEnabled=YES;

    nameTextfield.enabled=YES;
    lastNameTextField.enabled=YES;
    emailTextfield.enabled=YES;
    cityTextfield.enabled=YES;
    schoolTextfield.enabled=YES;
    gradeTextfield.enabled=YES;
    selectedDobLabel.enabled=YES;
    selectedDobLabel.userInteractionEnabled=YES;
    genderLabel.userInteractionEnabled=YES;
    stateTextField.enabled=YES;
    skillsTextField.enabled=YES;
    profileImage.userInteractionEnabled=YES;
    pickImageBtn.userInteractionEnabled=YES;*/
    
   
}

-(void)updateYESNO
{
    [[AppDelegate sharedDelegate] setHaveToStop:NO];
}

-(void)sendMessage:(id) sender
{
    
    NSLog(@"%@",self.personalDetailarray);
    
    SPHViewController *chatView=[[SPHViewController alloc]initWithNibName:@"SPHViewController" bundle:nil];
    chatView.receiverId=receiverId;
    chatView.senderId=senderId;
    chatView.friendArray=self.personalDetailarray;
    [self.navigationController pushViewController:chatView animated:NO];
    
    
    
    
    
    
  
    
  /* [_chatController scrollToBottom];
    
  
 
    

    
    
    [self performSelectorOnMainThread:@selector(updateYESNO) withObject:nil waitUntilDone:YES];
   
    
    NSLog(@"haveToStop = %d", ([[AppDelegate sharedDelegate] haveToStop] ? 1 : 0));
    
    _chatController=[[ChatController alloc]init];
    NSLog(@"%@",receiverId);
    NSLog(@"%@",senderId);
    _chatController.receiverId=receiverId;
    _chatController.senderId=senderId;
    NSLog(@"%@",receiverId);
    NSLog(@"%@",senderId);
    
    if (!_chatController)
    _chatController = [ChatController new];
    
   
   
   // _chatController.delegate = self;
    [_chatController setDelegate:self];
  
    _chatController.opponentImg = [UIImage imageNamed:@"placeholder.png"];
    [_chatController fetchdata];
    if (messageValue==3)
    {
        [_chatController setMessageValue:1];
    }
    
   
//[self.navigationController pushViewController:_chatController animated:NO];
    [self.navigationController pushViewController:_chatController animated:YES];
    
    //[self presentViewController:_chatController animated:YES completion:nil];
 
  //  [self performSelectorInBackground:@selector(receiveMessage) withObject:nil];
    
   
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0lu);
    dispatch_async(queue, ^{
        [self receiveMessage];
    });*/
    
   
   
  
    
}

#pragma mark Table View Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     if(tableView==imagesuserTableView)
    {
        return 2;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==genderTableView)
    {
    return [genderArray count];
    }
    else if(tableView==timezoneTableView)
    {
        return [timezoneArray count];
    }
    else
    {
        if(section==1)
            return((imagesuser.count%3)==0?(imagesuser.count/3):(imagesuser.count/3+1));
        else
        {
            return 1;
        
        }
    }
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    
  if(tableView==genderTableView || tableView==timezoneTableView)
  {
    
    static NSString *cellIdentifier=@"CellIdentifier";
     UITableViewCell *cell=(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if(tableView==genderTableView)
       cell.textLabel.text=[genderArray objectAtIndex:indexPath.row];
    else
       cell.textLabel.text=[timezoneArray objectAtIndex:indexPath.row];
   
    cell.textLabel.font=LABELFONT;
    cell.textLabel.textColor=TEXTCOLOR;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
   }
  else
   {
       
       if(indexPath.section==0)
       {
           static NSString *cellIdentifier=@"CellIdentifier";
           UITableViewCell *cell=(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
           if (cell==nil)
           {
               cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
               cell.selectionStyle=UITableViewCellSelectionStyleNone;
               
           }
           CGSize result=[[UIScreen mainScreen]bounds].size;

           CGFloat halfTextFieldWidth=(backgroundScrollview.frame.size.width-30)/2;
           CGFloat fullTextFieldWidth=backgroundScrollview.frame.size.width-20;
           CGFloat textFieldHeight=40;
           //Name
           nameTextfield=[[UITextField alloc]initWithFrame:CGRectMake(10,10,halfTextFieldWidth,textFieldHeight)];
           nameTextfield.layer.borderColor=[UIColor lightGrayColor].CGColor;
           nameTextfield.layer.borderWidth=0.5f;
           UIView *paddingViewo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
           nameTextfield.leftView = paddingViewo;
           nameTextfield.leftViewMode = UITextFieldViewModeAlways;

           
           nameTextfield.placeholder=@"First Name";
           nameTextfield.delegate=self;
           nameTextfield.tag=1;
           //nameTextfield.enabled=NO;
           nameTextfield.textColor=TEXTCOLOR;
           NSString *firstNameStr=[NSString stringWithFormat:@"%@",[self.personalDetailarray valueForKey:@"name"]];
           if ([firstNameStr isEqualToString:@""])
           {
               firstNameStr=@"";
           }
           else
           {
               
           }
           nameTextfield.text=firstNameStr;
           [cell addSubview:nameTextfield];
           
           //  UIView *paddingView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 5)];
           // nameTextfield.leftViewMode=UITextFieldViewModeAlways;
           //nameTextfield.leftView=paddingView;
           
           
           //last Name
           lastNameTextField=[[UITextField alloc]initWithFrame:CGRectMake(nameTextfield.frame.origin.x+nameTextfield.frame.size.width+10,nameTextfield.frame.origin.y, halfTextFieldWidth,textFieldHeight)];
           lastNameTextField.layer.borderColor=[UIColor lightGrayColor].CGColor;
           lastNameTextField.layer.borderWidth=0.5f;
           lastNameTextField.placeholder=@"Last Name";
           lastNameTextField.delegate=self;
           // lastNameTextField.enabled=NO;
           lastNameTextField.tag=1;
           UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
           lastNameTextField.leftView = paddingView;
           lastNameTextField.leftViewMode = UITextFieldViewModeAlways;
           
           NSString *lastNameStr=[NSString stringWithFormat:@"%@",[self.personalDetailarray valueForKey:@"lname"]];
           if ([lastNameStr isEqualToString:@""])
           {
               lastNameStr=@"";
           }
           else
           {
               
           }
           lastNameTextField.text=lastNameStr;
           lastNameTextField.textColor=TEXTCOLOR;
           [cell addSubview:lastNameTextField];
           
           //  UIView *namePaddingView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 5)];
           // lastNameTextField.leftViewMode=UITextFieldViewModeAlways;
           //lastNameTextField.leftView=namePaddingView;
           
           
           
           //School
           schoolTextfield=[[UITextField alloc]initWithFrame:CGRectMake(nameTextfield.frame.origin.x,lastNameTextField.frame.origin.y+lastNameTextField.frame.size.height+10,fullTextFieldWidth,textFieldHeight)];
           schoolTextfield.layer.borderColor=[UIColor lightGrayColor].CGColor;
           schoolTextfield.layer.borderWidth=0.5f;
           schoolTextfield.placeholder=@"School";
           schoolTextfield.delegate=self;
           schoolTextfield.tag=2;
           //  schoolTextfield.enabled=NO;
           schoolTextfield.textColor=TEXTCOLOR;
           
           UIView *paddingView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
           schoolTextfield.leftView = paddingView5;
           schoolTextfield.leftViewMode = UITextFieldViewModeAlways;

           
           NSString *schoolStr=[NSString stringWithFormat:@"%@",[self.personalDetailarray valueForKey:@"school"]];
           if ([schoolStr isEqualToString:@""])
           {
               schoolStr=@"";
           }
           else
           {
               
           }
           schoolTextfield.text=schoolStr;
           
           [cell addSubview:schoolTextfield];
           
           //paddingView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 5)];
           //schoolTextfield.leftViewMode=UITextFieldViewModeAlways;
           //schoolTextfield.leftView=paddingView;
           
           
           
#pragma mark DOB
           
           
           //Date Of Birth
           selectedDobLabel = [[UILabel alloc] initWithFrame:CGRectMake(schoolTextfield.frame.origin.x,schoolTextfield.frame.origin.y+schoolTextfield.frame.size.height+10,120,textFieldHeight)];
          // UIView* paddingView20=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 5)];
           //selectedDobLabel.leftViewMode=UITextFieldViewModeAlways;
           //selectedDobLabel.leftView=paddingView20;

           NSString *dobText=[NSString stringWithFormat:@" %@",[self.personalDetailarray valueForKey:@"dob"]];
           if ([dobText isEqualToString:@" "])
           {
               dobText=@"Date Of Birth";
           }
           else
           {
               NSDateFormatter *df = [[NSDateFormatter alloc] init];
               [df setDateFormat:@"yyyy-MM-dd"];
               NSDate *myDate1 = [df dateFromString: dobText];
               if(myDate1!=nil)
               {
                   [df setDateFormat:@"MM/dd/yyyy"];
               
                    dobText=[NSString stringWithFormat:@" %@",[df stringFromDate:myDate1]];
               }
           }
          
           
          
           
           selectedDobLabel.text=dobText;
           //dobTextField.text=[AppDelegate sharedDelegate].currentUser.gender;
           selectedDobLabel.layer.borderColor=[UIColor lightGrayColor].CGColor;
           // selectedDobLabel.pla
           selectedDobLabel.layer.borderWidth=0.5f;
           //selectedDobLabel.layer.cornerRadius=5.0f;
           selectedDobLabel.textColor=TEXTCOLOR;
           // selectedDobLabel.enabled=NO;
           selectedDobLabel.userInteractionEnabled=YES;
          // selectedDobLabel.textAlignment = NSTextAlignmentLeft;
           [cell addSubview:selectedDobLabel];
           
           
           
           
           UITapGestureRecognizer *dobTapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dobTapGesture:)];
           [selectedDobLabel addGestureRecognizer:dobTapGesture];
           
           transparentView=[[UIView alloc]initWithFrame:self.view.bounds];
           [transparentView setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.5]];
           
           dateView=[[UIView alloc]initWithFrame:CGRectMake(0, result.height-350, result.width, 250)];
           [dateView setBackgroundColor:[UIColor whiteColor]];
           dobPickerView=[[UIDatePicker alloc]initWithFrame:CGRectMake(0,50,250,200)];
           dobPickerView.datePickerMode=UIDatePickerModeDate;
           [dateView addSubview:dobPickerView];
           
           
           
           UIButton *donePickerBtn=[[UIButton alloc]initWithFrame:CGRectMake(dateView.frame.size.width-100, 0, 100, 50)];
           [donePickerBtn setTitle:@"Done" forState:UIControlStateNormal];
           donePickerBtn.titleLabel.textAlignment=NSTextAlignmentRight;
           [donePickerBtn setTitleColor:TEXTCOLOR forState:UIControlStateNormal];
           [donePickerBtn addTarget:self action:@selector(donePickerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
           [dateView addSubview:donePickerBtn];
           
           UIButton *cancelPickerbtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
           [cancelPickerbtn setTitle:@"Cancel" forState:UIControlStateNormal];
           donePickerBtn.titleLabel.textAlignment=NSTextAlignmentLeft;
           [cancelPickerbtn setTitleColor:TEXTCOLOR forState:UIControlStateNormal];
           [cancelPickerbtn addTarget:self action:@selector(cancelPickerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
           [dateView addSubview:cancelPickerbtn];
           
           UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, donePickerBtn.frame.origin.y+donePickerBtn.frame.size.height, dateView.frame.size.width, 1)];
           // [lineView setBackgroundColor:TEXTCOLOR];
           [dateView addSubview:lineView];
           
           
           
           //timezone
           
           
           
           
           
           
           //City
           cityTextfield=[[UITextField alloc]initWithFrame:CGRectMake(selectedDobLabel.frame.origin.x+selectedDobLabel.frame.size.width+10, selectedDobLabel.frame.origin.y,90, textFieldHeight)];
           cityTextfield.layer.borderColor=[UIColor lightGrayColor].CGColor;
           cityTextfield.layer.borderWidth=0.5f;
           cityTextfield.placeholder=@"City";
           cityTextfield.delegate=self;
           cityTextfield.tag=4;
           // cityTextfield.enabled=NO;
           cityTextfield.textColor=TEXTCOLOR;
           cityTextfield.text=[NSString stringWithFormat:@"%@",[self.personalDetailarray valueForKey:@"city"]];
           
           UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
           cityTextfield.leftView = paddingView1;
           cityTextfield.leftViewMode = UITextFieldViewModeAlways;
           
           [cell addSubview:cityTextfield];
           
            UIView *paddingView7 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
           
           // paddingView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 5)];
           cityTextfield.leftViewMode=UITextFieldViewModeAlways;
           cityTextfield.leftView=paddingView7;
           
           
           //State
           stateTextField=[[UITextField alloc]initWithFrame:CGRectMake(cityTextfield.frame.origin.x+cityTextfield.frame.size.width+10, cityTextfield.frame.origin.y,halfTextFieldWidth-75,textFieldHeight)];
           stateTextField.layer.borderColor=[UIColor lightGrayColor].CGColor;
           stateTextField.layer.borderWidth=0.5f;
           stateTextField.placeholder=@"State";
           stateTextField.delegate=self;
           stateTextField.tag=4;
           //stateTextField.enabled=NO;
           stateTextField.textColor=TEXTCOLOR;
           stateTextField.text=[NSString stringWithFormat:@"%@",[self.personalDetailarray valueForKey:@"state"]];
            UIView *paddingView8 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
           
           stateTextField.leftView = paddingView8;
           stateTextField.leftViewMode = UITextFieldViewModeAlways;
           [cell addSubview:stateTextField];
           
           //  paddingView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 5)];
           // stateTextField.leftViewMode=UITextFieldViewModeAlways;
           //stateTextField.leftView=paddingView;
           
           //work at
           workLabel=[[UITextField alloc]initWithFrame:CGRectMake(selectedDobLabel.frame.origin.x, cityTextfield.frame.origin.y+cityTextfield.frame.size.height+10,fullTextFieldWidth,textFieldHeight)];
           workLabel.userInteractionEnabled=YES;
           workLabel.layer.borderColor=[UIColor lightGrayColor].CGColor;
           NSString *workatText=[NSString stringWithFormat:@"%@",[self.personalDetailarray valueForKey:@"workat"]];
           workLabel.delegate=self;
           workLabel.placeholder=@"Work at";
           UIView *paddingView11 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
           
           workLabel.leftView = paddingView11;
           workLabel.leftViewMode = UITextFieldViewModeAlways;
           workLabel.text=workatText;
           workLabel.layer.borderWidth=0.5f;
           //selectedDobLabel.layer.cornerRadius=5.0f;
           workLabel.textColor=TEXTCOLOR;
           //workLabel.enabled=NO;
           // workLabel.userInteractionEnabled=NO;
           [cell addSubview:workLabel];
           
           
           
           
           //timezone
           
           
           
           
           
           
           
           //Skills And Interest
           skillsTextField=[[UITextField alloc]initWithFrame:CGRectMake(workLabel.frame.origin.x, workLabel.frame.origin.y+workLabel.frame.size.height+10,fullTextFieldWidth,textFieldHeight)];
           skillsTextField.layer.borderColor=[UIColor lightGrayColor].CGColor;
           skillsTextField.layer.borderWidth=0.5f;
           skillsTextField.placeholder=@"Skills";
           skillsTextField.delegate=self;
           skillsTextField.tag=5;
           UIView *paddingView9=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 5)];
           skillsTextField.leftView = paddingView9;
           skillsTextField.leftViewMode = UITextFieldViewModeAlways;
           
           //skillsTextField.enabled=NO;
           skillsTextField.textColor=TEXTCOLOR;
           skillsTextField.text=[NSString stringWithFormat:@"%@",[self.personalDetailarray valueForKey:@"skill_and_interest"]];
           [cell addSubview:skillsTextField];
           
           // paddingView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 5)];
           /// skillsTextField.leftViewMode=UITextFieldViewModeAlways;
          // skillsTextField.leftView=paddingView;
           
           
           //Skills And Interest
           aboutmeTextview=[[UITextField alloc]initWithFrame:CGRectMake(skillsTextField.frame.origin.x, skillsTextField.frame.origin.y+skillsTextField.frame.size.height+10,fullTextFieldWidth,textFieldHeight)];
           aboutmeTextview.layer.borderColor=[UIColor lightGrayColor].CGColor;
           aboutmeTextview.layer.borderWidth=0.5f;
           aboutmeTextview.placeholder=@"About Me";
           aboutmeTextview.delegate=self;
           aboutmeTextview.tag=5;
           // aboutmeTextview.enabled=NO;
           aboutmeTextview.textColor=TEXTCOLOR;
           UIView *paddingView10=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 5)];
           aboutmeTextview.leftView = paddingView10;
           aboutmeTextview.leftViewMode = UITextFieldViewModeAlways;
           
           aboutmeTextview.text=[NSString stringWithFormat:@"%@",[self.personalDetailarray valueForKey:@"aboutme"]];
           [cell addSubview:aboutmeTextview];
           
           
           
           galleryLabel=[[UILabel alloc]initWithFrame:CGRectMake(aboutmeTextview.frame.origin.x, aboutmeTextview.frame.origin.y+aboutmeTextview.frame.size.height+10,60,textFieldHeight)];
           //galleryLabel.userInteractionEnabled=NO;
           //galleryLabel.layer.borderColor=[UIColor lightGrayColor].CGColor;
           
           galleryLabel.text=@"Gallery";
           // galleryLabel.layer.borderWidth=0.5f;
           //selectedDobLabel.layer.cornerRadius=5.0f;
           galleryLabel.textColor=TEXTCOLOR;
           galleryLabel.enabled=NO;
           //galleryLabel.userInteractionEnabled=NO;
           [cell addSubview:galleryLabel];
           
           
           deleteButton=[[UIButton alloc]initWithFrame:CGRectMake(galleryLabel.frame.origin.x+galleryLabel.frame.size.width+10, galleryLabel.frame.origin.y+5,65,30)];
           [deleteButton setImage:[UIImage imageNamed:@"Delete.png"] forState:UIControlStateNormal];
           deleteButton.titleLabel.font=LABELFONT;
           [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
           [deleteButton setBackgroundColor:BUTTONCOLOR];
           deleteButton.titleLabel.font=[UIFont boldSystemFontOfSize:10.0f];
           [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
           [deleteButton addTarget:self action:@selector(deletephoto:) forControlEvents:UIControlEventTouchUpInside];
           [cell addSubview:deleteButton];
           
           
           makeprofileButton=[[UIButton alloc]initWithFrame:CGRectMake(deleteButton.frame.origin.x+deleteButton.frame.size.width+10, deleteButton.frame.origin.y,80,30)];
           [makeprofileButton setImage:[UIImage imageNamed:@"MakeasProfile.png"] forState:UIControlStateNormal];
           makeprofileButton.titleLabel.font=LABELFONT;
          
           [makeprofileButton addTarget:self action:@selector(markasphoto:) forControlEvents:UIControlEventTouchUpInside];
           [cell addSubview:makeprofileButton];
           
           addphotoButton=[[UIButton alloc]initWithFrame:CGRectMake(makeprofileButton.frame.origin.x+makeprofileButton.frame.size.width+10, makeprofileButton.frame.origin.y,65,30)];
           [addphotoButton setImage:[UIImage imageNamed:@"AddPhoto.png"] forState:UIControlStateNormal];
           addphotoButton.titleLabel.font=LABELFONT;
           [addphotoButton setTitle:@"Add Photo" forState:UIControlStateNormal];
           [addphotoButton setBackgroundColor:[UIColor blueColor]];
           addphotoButton.titleLabel.font=[UIFont boldSystemFontOfSize:10.0f];
           [addphotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
           [addphotoButton addTarget:self action:@selector(addphoto:) forControlEvents:UIControlEventTouchUpInside];
           [cell addSubview:addphotoButton];
           return cell;
           
       }
       
       
       static NSString *cellIdentifier = @"Cell";
       ImagesUserTableViewCell *cell = (ImagesUserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
       
       if (cell == nil)
       {
           NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ImagesUserTableViewCell" owner:self options:nil];
           cell=[nib objectAtIndex:0];
           //UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,99.0, imagesuserTableView.frame.size.width, 0.5f)];
           //[lineView setBackgroundColor:[UIColor lightGrayColor]];
           //[cell.contentView addSubview:lineView];
           //cell.selectionStyle=UITableViewCellSelectionStyleNone;
          // imagesuserTableView.
          
       }
       
       
       
       
       //images 0
       if(indexPath.row*3<=imagesuser.count-1)
       {
           NSArray *imagesuserinfor=[imagesuser objectAtIndex:indexPath.row*3];
           NSString *urlString = [imagesuserinfor valueForKey:@"thumb"];
           if ([urlString rangeOfString:@"http://"].location == NSNotFound)
           {
               urlString = [NSString stringWithFormat:@"http://%@", urlString];
           }
           NSURL *imageUrl=[NSURL URLWithString:urlString];
           [cell.imageuserone setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"name_icon"]];
          cell.imageuserone.userInteractionEnabled = YES;
           UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectimage:)];
         [cell.imageuserone addGestureRecognizer:imageTap];
         
        if(isfirstload==YES)
        {
           if([[imagesuserinfor valueForKey:@"isselected"] isEqualToString:@"1"])
           {
               [cell.imageselectedone setHidden:NO];
           
           }
           else
           {
               [cell.imageselectedone setHidden:YES];
           }
        }
        else
        {
            if([[imagesuserinfor valueForKey:@"id"] isEqualToString:imageidselected])
            {
                [cell.imageselectedone setHidden:NO];
            }
            else
            {
            [cell.imageselectedone setHidden:YES];
            }
        }
            
           cell.imageuserone.tag=(indexPath.row*3);

       
       }
       else
       {
           
               [cell.imageselectedone removeFromSuperview];
               [cell.imageuserone removeFromSuperview];
           
       
       }
       
       //images 1
       if((indexPath.row*3+1)<=imagesuser.count-1)
       {
           NSArray *imagesuserinfor=[imagesuser objectAtIndex:(indexPath.row*3 +1)];
           NSString *urlString = [imagesuserinfor valueForKey:@"thumb"];
           if ([urlString rangeOfString:@"http://"].location == NSNotFound)
           {
               urlString = [NSString stringWithFormat:@"http://%@", urlString];
           }
           NSURL *imageUrl=[NSURL URLWithString:urlString];
           [cell.imageusertwo setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"name_icon"]];
           
           cell.imageusertwo.tag=(indexPath.row*3+1);
           
           if(isfirstload==YES)
           {
               if([[imagesuserinfor valueForKey:@"isselected"] isEqualToString:@"1"])
               {
                   [cell.imageselectedtwo setHidden:NO];
                   
               }
               else
               {
                   [cell.imageselectedtwo setHidden:YES];
               }
           }
           else
           {
               if([[imagesuserinfor valueForKey:@"id"] isEqualToString:imageidselected])
               {
                   [cell.imageselectedtwo setHidden:NO];
               }
               else
               {
                   [cell.imageselectedtwo setHidden:YES];
               }
           }
           cell.imageusertwo.tag=(indexPath.row*3+1);

           cell.imageusertwo.userInteractionEnabled = YES;
           UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectimage:)];
           [cell.imageusertwo addGestureRecognizer:imageTap];

       }
       else
       {
           [cell.imageselectedtwo removeFromSuperview];
           [cell.imageusertwo removeFromSuperview];

       }
           
       if((indexPath.row*3+2)<=imagesuser.count-1)
       {
           NSArray *imagesuserinfor=[imagesuser objectAtIndex:(indexPath.row*3 +2)];
           NSString *urlString = [imagesuserinfor valueForKey:@"thumb"];
           if ([urlString rangeOfString:@"http://"].location == NSNotFound)
           {
               urlString = [NSString stringWithFormat:@"http://%@", urlString];
           }
           NSURL *imageUrl=[NSURL URLWithString:urlString];
           [cell.imageuserthree setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"name_icon"]];
           
           if(isfirstload)
           {
               if([[imagesuserinfor valueForKey:@"isselected"] isEqualToString:@"1"])
               {
                   [cell.imageselectedthree setHidden:NO];
                   
               }
               else
               {
                   [cell.imageselectedthree setHidden:YES];
               }
           }
           else
           {
               if([[imagesuserinfor valueForKey:@"id"] isEqualToString:imageidselected])
               {
                   [cell.imageselectedthree setHidden:NO];
               }
               else
               {
                   [cell.imageselectedthree setHidden:YES];
               }
           }
           cell.imageuserthree.userInteractionEnabled = YES;
           UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectimage:)];
           [cell.imageuserthree addGestureRecognizer:imageTap];
            cell.imageuserthree.tag=(indexPath.row*3+2);

       }
       else
       {
           [cell.imageselectedthree removeFromSuperview];
           [cell.imageuserthree removeFromSuperview];
       }
       return cell;
       
    
   }
   
}

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView==genderTableView )
    {
        [genderTableView removeFromSuperview];
         NSString *genderStr=[NSString stringWithFormat:@" %@",[genderArray objectAtIndex:indexPath.row]];
         [genderLabel setText:genderStr];
    }
    else
    {
        [timezoneTableView removeFromSuperview];
        NSString *genderStr=[NSString stringWithFormat:@" %@",[timezoneArray objectAtIndex:indexPath.row]];
        [timezoneLabel setText:genderStr];
    
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==genderTableView || tableView==timezoneTableView)
        return 20.0f;
    else
    {
        if(indexPath.section==0)
            return 360.0f;
        else
            return 80.0f;
    }
}








#pragma mark ChatViewController Delegate Methods
- (void) chatController:(ChatController *)chatController didSendMessage:(NSMutableDictionary *)message
{
    [_chatController resignFirstResponder];
   //
    
    if (message==nil)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter some text" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alert show];
        
    }
    else
    {
        chatValue=1;
        messageText=message;
        
       [self showActivityInView:chatController.view];
        
        // Messages come prepackaged with the contents of the message and a timestamp in milliseconds
  
  
      
    }
    
   
}

-(void) chatMessage:(NSDictionary*)message
{
    
}



-(void) sendMessage:(NSString*) message date:(NSString*)date
{
   
   
   // int timestamp = [[NSDate date] timeIntervalSince1970];
    NSArray *mainArray=[[WebServiceSingleton sharedMySingleton]sendMessage:senderId receiverId:receiverId message:message date:date];
    if (mainArray)
    {
        NSString *success=[mainArray objectAtIndex:0];
        // NSString *message=[mainArray objectAtIndex:1];
        int successValue=[success integerValue];
        if (successValue==1)
        {
            NSLog(@"%@",success);
            [self saveData];
        }
        else
        {
            
        }
    }
    else
    {
        
    }
  
    
   
  
}


- (void)saveData
{
    
    NSString *value=@"0";
    
    
    NSManagedObjectContext *context =
    [[AppDelegate sharedDelegate] managedObjectContext];
    NSManagedObject *message;
    message = [NSEntityDescription
                  insertNewObjectForEntityForName:@"QboxData"
                  inManagedObjectContext:context];
    //NSString *str=[message valueForKeyPath:@"message"];
    NSLog(@"%@",messageData);
    if (!messageData)
    {
        messageData=@"";
    }
    
    [message setValue:messageData forKeyPath:@"message"];
    [message setValue:receiverId forKeyPath:@"receiverId"];
    [message setValue:senderId forKeyPath:@"senderId"];
    [message setValue:time forKeyPath:@"time"];
    [message setValue:value forKeyPath:@"status"];
   
      
    
    

    NSError *error;
    [context save:&error];

}







//Receive Message Webservice
-(void) receiveMessage
{
    NSArray *receiveData=[[WebServiceSingleton sharedMySingleton]receiveMessage:senderId];
    NSArray *messaged=[[receiveData valueForKey:@"message"]objectAtIndex:0];
    NSString *status1=[[receiveData valueForKey:@"status"]objectAtIndex:0];
    
    [self recievedNewMessage:status1 messageArray:messaged];
    if ([[AppDelegate sharedDelegate] haveToStop] == NO)
    {
        [self performSelectorOnMainThread:@selector(callMetodeOnRepeat) withObject:self waitUntilDone:YES];
    }
}

-(void)callMetodeOnRepeat
{
    if ([[AppDelegate sharedDelegate] haveToStop] == NO)
        //Calls same method again and again for receive new messages
        [self performSelector:@selector(receiveMessage) withObject:nil afterDelay:2.0f];
}


-(void)recievedNewMessage  :(NSString *)status1 messageArray :(NSArray *)messaged
{
    
    int statusValue=[status1 intValue];
    if (statusValue==0)
    {
        
    }
    else
    {
       
        NSArray *messageDetail=[messaged valueForKey:@"message"];
        NSArray *senderIds=[messaged valueForKey:@"sender_id"];
        NSArray *receiverIds=[messaged valueForKey:@"receiver_id"];
        NSArray *times=[messaged valueForKey:@"date_time"];
        NSManagedObjectContext *context =
        [[AppDelegate sharedDelegate] managedObjectContext];
        NSManagedObject *message;
        for (int i=0; i<[messaged count]; i++)
        {
            
            message = [NSEntityDescription
                       insertNewObjectForEntityForName:@"QboxData"
                       inManagedObjectContext:context];
            NSString *value=@"1";
            [message setValue:[messageDetail objectAtIndex:i] forKeyPath:@"message"];
            [message setValue:[senderIds objectAtIndex:i] forKeyPath:@"receiverId"];
            [message setValue:[receiverIds objectAtIndex:i]  forKeyPath:@"senderId"];
            [message setValue:[times objectAtIndex:i] forKeyPath:@"time"];
            [message setValue:value forKeyPath:@"status"];
            [self showRecivedValue:[NSArray arrayWithObject:[messaged objectAtIndex:i]]];
            NSError *error;
            [context save:&error];
        }
        NSLog(@"messaged %@",messaged);
        NSString *lastMsgId=[[messaged valueForKey:@"message_id"]lastObject];
        NSLog(@"%@",lastMsgId);
        [self lastMsgRead:lastMsgId];
    }
}



-(void)showRecivedValue :(NSArray *)messageArray
{
    
    NSLog(@"%@",[messageArray objectAtIndex:0]);
    
    NSMutableDictionary * attributes = [NSMutableDictionary new];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:15.0f];
    attributes[NSStrokeColorAttributeName] = [UIColor darkTextColor];
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithString:[[messageArray valueForKey:@"message"] objectAtIndex:0]
                                                                   attributes:attributes];
    
    // Here's the maximum width we'll allow our outline to be // 260 so it's offset
    int maxTextLabelWidth = maxBubbleWidth - outlineSpace;
    
    // set max width and height
    // height is max, because I don't want to restrict it.
    // if it's over 100,000 then, you wrote a fucking book, who even does that?
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(maxTextLabelWidth, 100000)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        context:nil];
  

    
      NSDictionary *messageDictionary=[[NSDictionary alloc]initWithObjects:[NSArray arrayWithObjects:[[messageArray valueForKey:@"message"] objectAtIndex:0],[[messageArray valueForKey:@"receiver_id"]objectAtIndex:0],[[messageArray valueForKey:@"sender_id"] objectAtIndex:0], [NSValue valueWithCGSize:rect.size],[[messageArray valueForKey:@"date_time"] objectAtIndex:0], nil] forKeys:[NSArray arrayWithObjects:@"content",@"runtimeSentBy",@"sentByUserId",@"size",@"timestamp", nil]];
  
    
    NSString *sentByUserId=[messageDictionary objectForKey:@"sentByUserId"];

    
   
    if (_chatController)
    {
        if ([sentByUserId isEqualToString:receiverId])
        {
            [_chatController addNewMessage:messageDictionary];
        }
        
        
    }
    
    
    
}
-(void) lastMsgRead:(NSString*) msgId
{
 [[WebServiceSingleton sharedMySingleton]readMessage:msgId userId:senderId];
}




#pragma mark textview Methods
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    CGSize result=[[UIScreen mainScreen]bounds].size;
    if (result.height==480)
    {
        //[backgroundScrollview setContentOffset:CGPointMake(0, 0)];
    }
    else
    {
        //[backgroundScrollview setContentOffset:CGPointMake(0, 0)];
    }
    [textField resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
   
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
  
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [textField setReturnKeyType:UIReturnKeyDone];
    
    int scrollheight;
    
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    if (screenRect.size.height == 568)
    {
        scrollheight=30;
    }
    else if (screenRect.size.height == 480)
    {
       scrollheight=40;
    }
    else
    {
        scrollheight=20;
    }
    
    
    
    [UIView animateWithDuration:0.3
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseIn
                     animations:^{
                         [backgroundScrollview setContentOffset:CGPointMake(0, textField.tag*scrollheight)];
                     }
                     completion:^(BOOL finished) {
                         
                         
                     }];
    
   [backgroundScrollview setContentSize:CGSizeMake(backgroundScrollview.frame.size.width, backgroundScrollview.frame.size.height+200)];


    return YES;
    
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
//    [backgroundScrollview setContentSize:CGSizeMake(backgroundScrollview.frame.size.width, backgroundScrollview.frame.size.height-200)];
    
    return YES;
}

-(void) postmessage
{
    
}


#pragma mark Validation Methods
-(BOOL)validationCheck

{
    
    int validateNumber=0;
    
    
    if (nameTextfield.text.length==0)
    {
        validateNumber++;
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Please enter first name" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
        
    }
    else if (lastNameTextField.text.length==0)
    {
        validateNumber++;
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Please enter last name" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
    }
//    else if ([self isValidEmail:emailTextfield.text]==NO)
//    {
//        
//        validateNumber++;
//        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Please enter the valid email" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//        [alertView show];
//        
//    }
//   
//    else if (![self isPasswordValid:passwordTextfield.text]==NO)
//    {
//        
//        validateNumber++;
//        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Please enter the correct password" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//        [alertView show];
//        
//    }
    
    
//    else if ([self phoneANumberValidation:mobileNumberTextfield.text]==NO)
//    {
//        validateNumber++;
//        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Please enter the valid mobile number" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//        [alertView show];
//        
//    }

    else
    {
        
        
    }
    if (validateNumber !=0)
    {
//        errorMessage=@"Please Enter All fields Correctly";
//        UIAlertView *validationCheckAlertView=[[UIAlertView alloc]initWithTitle:@"Please" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [ validationCheckAlertView show];
        
        
        return NO;
    }
    
    
    
    
    return YES;
}

- (BOOL) isPasswordValid:(NSString *)strPasswordText
{
    // too long or too short
    if ( [strPasswordText length] < 6 || [strPasswordText length] > 32 )
    {
        return NO;
    }
    return YES;
}



-(BOOL)phoneANumberValidation:(NSString *)phoneNumberText
{
    
    NSString *mobileNumberPattern = @"[789][0-9]{9}";
    NSPredicate *mobileNumberPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileNumberPattern];
    
    BOOL matched = [mobileNumberPred evaluateWithObject:phoneNumberText];
    return matched;
    
}



-(BOOL)isValidEmail:(NSString *)strEmail
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:strEmail];
}


#pragma mark Activity View


-(void) showActivityInView:(UIView *)view
{
    activity = [ActivityView activityView];
    if (chatValue==0)
    {
         [activity setTitle:@"Loading"];
    }
    else if(chatValue==3)
    {
        [activity setTitle:@"Sending"];

    
    }
    else
    {
     [activity setTitle:@"Sending..."];
    }
   
    [activity setDelegate:self];
    [activity setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.9]];
    [activity showBorder];
    [activity showActivityInView:view];
    activity.center = view.center;
}

-(void)hideActivity
{
    [activity hideActivity];
}


- (void)didReceiveMemoryWarning
{
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
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
