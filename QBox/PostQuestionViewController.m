//
//  PostQuestionViewController.m
//  QBox
//
//  Created by iapp on 22/05/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

#import "PostQuestionViewController.h"
#import "WebServiceSingleton.h"
#import "NavigationView.h"
#import "ActivityView.h"
#import "NSData+Base64.h"
#import "Base64.h"
#import "HomeViewController.h"
#import "UIImage+fixOrientation.h"
#import "UIImagefixOrientation.h"
#import "GeneralViewController.h"

#import "AppDelegate.h"
#import "ACEViewController.h"
#define REVMOB_ID @"5106be9d0639b41100000052"

#define TEXTCOLOR [UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1.0f]




@interface PostQuestionViewController ()<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,postquestionViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,ActivityViewDelegate,UIActionSheetDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *categoryArray;
    NSArray *categoryofuserArray;
    
    NSMutableArray *subjectArray;
    UIScrollView *imageScrollView;
    NSString *categoryLabelString;
    UILabel  * categoryValuelabel;
    UIButton *categorySelectionButton;
    NSString *subjectLabelString;
    UILabel  * subjectValuelabel;
    UITextView *questiontextView;
    NSDictionary *subjectDictionary;
    UIImage *convertedImage;
    NSInteger cat;
    NSString *subId;
    UIView *imageView;
    UIButton *backImageBtn;
    UIView *categoryBackgroundView;
    UIView *subjectViewBackgroundView;
    UIButton *sendButton;
    UIImageView *ImagePostQuestion;
    
    UIAlertView *successAlert;
    UIAlertView *deleteCategoryAlert;
    UIAlertView *deleteImageAlert;
   
    UIButton *imageCaptureButton;
    UIButton *backBtn;
    UIButton *subjectSelectionButton;
    NSMutableArray *questionInfo;

    
    
    NSInteger subjectId;
    NSInteger categoryId;
    
    NSArray *scienceArray;
    NSArray *artsArray;
    NSArray *mathArray;
    NSArray *listfriends;
    NSString *imageString;
    NSString *friendsString;
    NSString *friendIdsString;
    
    
    NSString *createcategoryfriendsString;
    NSString *createcategoryfriendidsString;
    
    
    
    UIPickerView *subjectPicker;
    UIPickerView *categoryPicker;
    
    ActivityView *activity;
    
    UIView *mainBackgroundView;
    UIScrollView *backgroundScrollView;
    
    UIImageView *postQuestionImage;
    UIImageView *postQuestionImage1;

    UIImageView *postQuestionImage2;

    UIImageView *postQuestionImage3;

    UIImageView *postQuestionImage4;

    
    
    UIView *questionBackgroundView;
    
    //RevMobFullscreen *fs;
    GeneralViewController *generalView;
    
    NSMutableArray *friendsData;
    
    UIButton *createQuestionBtn;
    
    UIButton *categorySelectionBtn;
    UITextField *categoriesTextField;
    UITextField *tagFriendsTextField;
    
    UITableView *categoryTableView;
    UITableView *subjectTableView;
    UITableView *categoryfriendTableView;
    
      NSArray *userData;
    
    UIScrollView *questionsTextScrollView;
    
    UIButton *categoryBtn;
    NSMutableArray *selectedBtnArray;
    
    UIScrollView *categorySubview;
    
    UIScrollView *createcategorySubview;
    UILabel *postTitleLabel;
    
    UILabel *createcategoryTitleLabel;
    UITextField *createcategoriesnameTextField;
    
    UITextField *createcategorieshastagsTextField;
    
    UITextField *hastagsTextField;
    
    
    
    UITextField *createcategoriestagFriendsTextField;
    
    NSMutableString *multipleCategoriesStr;
    UIView *lineView;
    
    NSString *action;
    
    NSString *guidImage;
    
    NSMutableArray *imagelinksArray;
    NSMutableArray *imageidArray;
    NSUInteger indeximage;
}
@end

@implementation PostQuestionViewController
@synthesize categoryArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(NSString *)getUUID
{
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    NSString *guid = (__bridge NSString *)newUniqueIDString;
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    return([guid lowercaseString]);


}
- (void)viewDidLoad
{
    //[imagelinksArray removeObjectAtIndex:(NSUInteger)
    if (generalView)
    {
        [self.navigationController popToViewController:generalView animated:NO];
    }
     userData=[[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil]objectAtIndex:0];
    self.navigationController.navigationBarHidden=YES;
    [self questionValue];
    [super viewDidLoad];
    //[self CreateUI];
    [self postQuestionUI];
    friendsString=@"";
    imageString=@"";
    createcategoryfriendsString=@"";
      createcategoryfriendidsString=@"";
    multipleCategoriesStr=[[NSMutableString alloc]init];
    friendIdsString=@"";
    
    categoryValuelabel.text=@"";
    subjectValuelabel.text=@"";
   
   // questiontextView.text=@"";
    
    
    UITapGestureRecognizer *tapGestureCategory=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyboardAction)];
    tapGestureCategory.numberOfTapsRequired=1;
    categoryBackgroundView.userInteractionEnabled=YES;
    [categoryBackgroundView addGestureRecognizer:tapGestureCategory];
    
    UITapGestureRecognizer *tapGestureSubject=[[UITapGestureRecognizer alloc]init];
    subjectViewBackgroundView.userInteractionEnabled=YES;
    [tapGestureSubject addTarget:self action:@selector(resignKeyboardAction)];
    [subjectViewBackgroundView addGestureRecognizer:tapGestureSubject];
    
    
    //Fill list friends
    
     NSString *userid= [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    
     NSArray *listArray=[[WebServiceSingleton sharedMySingleton]getAllFriendList:userid];
    
    NSString *status=[[listArray valueForKey:@"status"]objectAtIndex:0];
    if ([status isEqualToString:@"0"])
    {
       // UIAlertView *friendsAlert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"No friends at this time" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
       // [friendsAlert show];
        friendsData=nil;
    }
    else
    {
        NSArray *mainArray=[[listArray valueForKey:@"data"]objectAtIndex:0];
        
        friendsData=[[NSMutableArray alloc]init];
        
        for (id arrayFr in mainArray)
        {
            if ([[arrayFr valueForKey:@"id"]isEqualToString:userid])
            {
                
            }
            else
            {
                [friendsData addObject:arrayFr];
            }
        }
    }
   
    
    
    imagelinksArray=[[NSMutableArray alloc] init];
    imageidArray=[[NSMutableArray alloc] init];
     [self loadquestiondetail];
    guidImage=[self getUUID];
    
    // Do any additional setup after loading the view.
}

-(void) loadquestiondetail
{
   if([self.questionId isEqualToString:@""])
   {
       return;
   }
    NSString *ids=[userData valueForKey:@"id"];
    NSArray *mainArray=[[WebServiceSingleton sharedMySingleton]postData:self.questionId userId:ids];
    NSString *success=[[mainArray valueForKey:@"success"]objectAtIndex:0];
    NSMutableArray *postData=nil;
    //[categorySelectionBtn setHidden:YES];
    [postTitleLabel setText:@"Edit Question"];
    [createQuestionBtn setTitle:@"Edit Question" forState:UIControlStateNormal];

    //if ([success isEqualToString:@"1"])
    //{
        questionInfo=[[NSMutableArray alloc]initWithObjects:[[mainArray valueForKey:@"question_info"]objectAtIndex:0], nil];
        questiontextView.text=[[questionInfo valueForKey:@"question"]objectAtIndex:0];
    NSString* categoriesname=@"";
     NSString* categoriesid=@"";
    for(id objectvalue in [[questionInfo valueForKey:@"categories"]objectAtIndex:0])
    {
         categoriesname=[categoriesname stringByAppendingString:[objectvalue objectForKey:@"category_name"]];
        categoriesname=[categoriesname stringByAppendingString:@","];
        categoriesid=[objectvalue objectForKey:@"id"];
        [multipleCategoriesStr appendString: categoriesid ];
        [multipleCategoriesStr appendString:@","];
        
    }
    hastagsTextField.text=[[questionInfo valueForKey:@"hashtag"]objectAtIndex:0];
    categoriesTextField.text=categoriesname;
    
    for(id objectvalue in [[questionInfo valueForKey:@"questionImages"]objectAtIndex:0])
    {
        NSString* imageurl=[objectvalue objectForKey:@"image"];
        [imagelinksArray addObject:imageurl];
        NSString* imageid=[objectvalue objectForKey:@"imagequestionid"];
        [imageidArray addObject:imageid];
    }
    [self viewimagesquestion];


}

-(void)resignKeyboardAction
{
    [questiontextView resignFirstResponder];
    [backgroundScrollView setContentOffset:CGPointMake(0, 0)];
}


-(void)questionValue
{
    //categoryArray=[[NSMutableArray alloc]initWithObjects:@"All",@"Science",@"Maths",@"Arts",nil];
   
    categoryArray=[[NSMutableArray alloc] init];
    // [categoryArray cl;
    
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
    else
    {
        categoryofuserArray=[NSArray array];
    }
    
    
    scienceArray=[[NSArray alloc]initWithObjects:@"Biology",@"Physics",@"Chemistry", nil];
    mathArray=[[NSArray alloc]initWithObjects:@"Algebra",@"Arithmetic",@"Trignometry", nil];
    artsArray=[[NSArray alloc]initWithObjects:@"Geography",@"Drawing", nil];
    
    NSMutableArray *allSubArray=[[NSMutableArray alloc]init];
    
    for (int i=0; i<[scienceArray count]; i++)
    {
        [allSubArray addObject:[scienceArray objectAtIndex:i]];
    }
    
    for (int i=0; i<[mathArray count]; i++)
    {
        [allSubArray addObject:[mathArray objectAtIndex:i]];
    }
    for (int i=0; i<[artsArray count]; i++)
    {
        [allSubArray addObject:[artsArray objectAtIndex:i]];
    }
    subjectDictionary=[[NSDictionary alloc]initWithObjects:[NSArray arrayWithObjects:allSubArray,scienceArray,mathArray,artsArray ,nil] forKeys:[NSArray arrayWithObjects:@"All",@"Science",@"Maths",@"Arts", nil]];

}

-(void)postQuestionUI
{
    
    //Navigation View
    NavigationView *nav = [[NavigationView alloc] init];
    
   // [self.view addSubview:nav.navigationView];
    
    CGRect iconFrame=nav.iconImageView.frame;
    iconFrame.origin.x+=20;
    nav.iconImageView.frame=iconFrame;
    
    CGRect titleFrame=nav.titleView.frame;
    titleFrame.origin.x+=15;
    nav.titleView.frame=titleFrame;
    
    nav.titleView.text = @"Questions";
    [nav.iconImageView setImage:[UIImage imageNamed:@"nav_question_icon"]];
    int val=self.view.frame.size.height;
    if(val>560)
    questionsTextScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    else
         questionsTextScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,-20, self.view.frame.size.width, self.view.frame.size.height)];
    questionsTextScrollView.scrollEnabled=YES;
    [self.view addSubview:questionsTextScrollView];
    
    [questionsTextScrollView addSubview:nav.navigationView];
    
    UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeAllSubviews)];
    tapGestureRecognizer.delegate=self;
    [questionsTextScrollView addGestureRecognizer:tapGestureRecognizer];
    
    backBtn=[[UIButton alloc]init];
    [backBtn setHidden:YES];
    backBtn.frame=CGRectMake(20, 33, 45,30);
    [backBtn setImage:[UIImage imageNamed:@"back_blue"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];

    
    //Line View
    /* lineView=[[UIView alloc]initWithFrame:CGRectMake(5,30, self.view.frame.size.width-10,1)];
    [lineView setBackgroundColor:BORDERCOLOR];
    [questionsTextScrollView addSubview:lineView];*/
    
    //Post Title
    postTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, backBtn.frame.origin.y+backBtn.frame.size.height+5, self.view.bounds.size.width, 30)];
    postTitleLabel.textAlignment=NSTextAlignmentCenter;
    [postTitleLabel setText:@"Post a New Question"];
    [postTitleLabel setFont:LABELFONT];
    [postTitleLabel setTextColor:[UIColor colorWithRed:25.0f/255.0f green:25.0f/255.0f blue:25.0f/255.0f alpha:1.0]];
    [questionsTextScrollView addSubview:postTitleLabel];
    
    //Categories View
    categoriesTextField=[[UITextField alloc]initWithFrame:CGRectMake(20, postTitleLabel.frame.origin.y+postTitleLabel.frame.size.height+10, (self.view.frame.size.width-40), 40)];
    categoriesTextField.delegate=self;
    [categoriesTextField setPlaceholder:@"Select Category"];
    [categoriesTextField setFont:LABELFONT];
    [categoriesTextField setTextColor:TEXTCOLOR];
    categoriesTextField.layer.borderColor=[UIColor lightGrayColor].CGColor;
    categoriesTextField.layer.borderWidth=1.0f;
    categoriesTextField.layer.cornerRadius=2.0f;
    categoriesTextField.userInteractionEnabled=NO;
    [questionsTextScrollView addSubview:categoriesTextField];
    
    
    UIColor *color=TEXTCOLOR;
    categoriesTextField.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"Select Category" attributes:@{NSForegroundColorAttributeName:color}];
    
    UIView *leftPaddingView=[[UIView alloc]initWithFrame:CGRectMake(5, categoriesTextField.frame.origin.y, 30, 40)];
    categoriesTextField.leftView=leftPaddingView;
    categoriesTextField.leftViewMode=UITextFieldViewModeAlways;
    
    UIImageView *categoryImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5,(leftPaddingView.frame.size.height-20)/2, 20, 20)];
    [categoryImageView setImage:[UIImage imageNamed:@"category_icon"]];
    [leftPaddingView addSubview:categoryImageView];
    
    UIView *rightPaddingView=[[UIView alloc]initWithFrame:CGRectMake(categoriesTextField.frame.size.width-30, categoriesTextField.frame.origin.y, 30, 40)];
    categoriesTextField.rightView=rightPaddingView;
    categoriesTextField.rightViewMode=UITextFieldViewModeAlways;
    
    
    
//    UIButton *categorySelectionBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, (rightPaddingView.frame.size.height-20)/2, 20, 20)];
//    [categorySelectionBtn addTarget:self action:@selector(categorySelectionAction:) forControlEvents:UIControlEventTouchUpInside];
//    [categorySelectionBtn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
//    [rightPaddingView addSubview:categorySelectionBtn];
    
       categorySelectionBtn=[[UIButton alloc]initWithFrame:CGRectMake(categoriesTextField.frame.size.width-10, categoriesTextField.frame.origin.y+10, 20, 20)];
        [categorySelectionBtn addTarget:self action:@selector(categorySelectionAction:) forControlEvents:UIControlEventTouchUpInside];
        [categorySelectionBtn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
        [questionsTextScrollView addSubview:categorySelectionBtn];

    
    //Tag Friends View
    tagFriendsTextField=[[UITextField alloc]initWithFrame:CGRectMake(20, categoriesTextField.frame.origin.y+categoriesTextField.frame.size.height+10, (self.view.frame.size.width-40), 40)];
    [tagFriendsTextField setPlaceholder:@"Tag Friends"];
    tagFriendsTextField.delegate=self;
    [tagFriendsTextField setFont:LABELFONT];
    [tagFriendsTextField setTextColor:TEXTCOLOR];
    tagFriendsTextField.layer.borderColor=[UIColor lightGrayColor].CGColor;
    tagFriendsTextField.layer.borderWidth=1.0f;
    tagFriendsTextField.layer.cornerRadius=2.0f;

    
    [questionsTextScrollView addSubview:tagFriendsTextField];
    
    UIView *paddingView1=[[UIView alloc]initWithFrame:CGRectMake(10, tagFriendsTextField.frame.origin.y, 30, 40)];
    tagFriendsTextField.leftView=paddingView1;
    tagFriendsTextField.leftViewMode=UITextFieldViewModeAlways;
    
    tagFriendsTextField.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"Tag Friends" attributes:@{NSForegroundColorAttributeName:color}];
    
    UIImageView *friendsImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5,(paddingView1.frame.size.height-20)/2, 20, 20)];
    [friendsImageView setImage:[UIImage imageNamed:@"tag_friend_icon"]];
    [paddingView1 addSubview:friendsImageView];
    
    
    UIView *rightPaddingView1=[[UIView alloc]initWithFrame:CGRectMake(tagFriendsTextField.frame.size.width-30, tagFriendsTextField.frame.origin.y, 30, 40)];
    tagFriendsTextField.rightView=rightPaddingView1;
    tagFriendsTextField.rightViewMode=UITextFieldViewModeAlways;
    
//    UIButton *subjectSelectionBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, (rightPaddingView1.frame.size.height-20)/2, 20, 20)];
//    [subjectSelectionBtn addTarget:self action:@selector(subjectSelectionAction:) forControlEvents:UIControlEventTouchUpInside];
//    [subjectSelectionBtn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
//    [rightPaddingView1 addSubview:subjectSelectionBtn];
    
    
    
    UIButton *subjectSelectionBtn=[[UIButton alloc]initWithFrame:CGRectMake(tagFriendsTextField.frame.size.width-10, tagFriendsTextField.frame.origin.y+10, 20, 20)];
    
   [subjectSelectionBtn addTarget:self action:@selector(subjectSelectionAction:) forControlEvents:UIControlEventTouchUpInside];
    [subjectSelectionBtn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
    [questionsTextScrollView addSubview:subjectSelectionBtn];
    
    
    
    hastagsTextField=[[UITextField alloc]initWithFrame:CGRectMake(20, tagFriendsTextField.frame.origin.y+tagFriendsTextField.frame.size.height+10, (self.view.frame.size.width-40), 40)];
    hastagsTextField.delegate=self;
    [hastagsTextField setPlaceholder:@"Hashtags"];
    [hastagsTextField setFont:LABELFONT];
    [hastagsTextField setTextColor:TEXTCOLOR];
    hastagsTextField.layer.borderColor=[UIColor lightGrayColor].CGColor;
    hastagsTextField.layer.borderWidth=1.0f;
    hastagsTextField.layer.cornerRadius=2.0f;
    [questionsTextScrollView addSubview:hastagsTextField];
    
    UIColor *color1=TEXTCOLOR;
   hastagsTextField.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"Hashtags" attributes:@{NSForegroundColorAttributeName:color1}];
    
    UIView *leftPaddingView1=[[UIView alloc]initWithFrame:CGRectMake(5, hastagsTextField.frame.origin.y, 30, 40)];
    hastagsTextField.leftView=leftPaddingView1;
    hastagsTextField.leftViewMode=UITextFieldViewModeAlways;
    
    UIImageView *categoryImageView1=[[UIImageView alloc]initWithFrame:CGRectMake(5,(leftPaddingView.frame.size.height-20)/2, 20, 20)];
    [categoryImageView1 setImage:[UIImage imageNamed:@"category_icon"]];
    [leftPaddingView1 addSubview:categoryImageView1];
    
    UIView *rightPaddingView2=[[UIView alloc]initWithFrame:CGRectMake(hastagsTextField.frame.size.width-30, hastagsTextField.frame.origin.y, 30, 40)];
    hastagsTextField.rightView=rightPaddingView2;
    hastagsTextField.rightViewMode=UITextFieldViewModeAlways;
    
    
    
    
    
    
    //Question Text View
    
    UIView *textViewPadding=[[UIView alloc]initWithFrame:CGRectMake(0, questiontextView.frame.origin.y, 30,30)];
    [questiontextView addSubview:textViewPadding];
    
    UIImageView *questionTextImage=[[UIImageView alloc]initWithFrame:CGRectMake(5,8,20, 20)];
    [questionTextImage setImage:[UIImage imageNamed:@"question_text_icon"]];
    [textViewPadding addSubview:questionTextImage];
    
    
    questiontextView =[[UITextView alloc]initWithFrame:CGRectMake(20,hastagsTextField.frame.origin.y+hastagsTextField.frame.size.height+10,(self.view.frame.size.width-40),100)];
    questiontextView.text = @"Question Text";
    questiontextView.font=LABELFONT;
    questiontextView.textColor = TEXTCOLOR;
    [questiontextView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [questiontextView setDelegate:self];
    questiontextView.scrollEnabled=YES;
    [questiontextView setReturnKeyType:UIReturnKeyDone];
    [questiontextView setTag:1];
    questiontextView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    questiontextView.layer.borderWidth=1.0f;
    questiontextView.layer.cornerRadius=2.0f;
    questiontextView.textContainer.lineFragmentPadding=30.0f;
    [questionsTextScrollView addSubview:questiontextView];
    [questiontextView addSubview:textViewPadding];
    
    //Camera Button
    UIButton *cameraBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    cameraBtn.frame=CGRectMake(categoriesTextField.frame.origin.x,questiontextView.frame.origin.y+questiontextView.frame.size.height+10, 25, 25);
    
    [cameraBtn setImage:[UIImage imageNamed:@"image_icon"] forState:UIControlStateNormal];
    
    [cameraBtn addTarget:self action:@selector(openCamera:) forControlEvents:UIControlEventTouchUpInside];
    [cameraBtn setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
    [questionsTextScrollView addSubview:cameraBtn];
    
    //Send Button
    UIButton *calciBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    calciBtn.frame=CGRectMake(cameraBtn.frame.origin.x+cameraBtn.frame.size.width+5,cameraBtn.frame.origin.y,25, 25);
    [calciBtn setBackgroundColor:[UIColor clearColor]];
    [calciBtn setImage:[UIImage imageNamed:@"calc_icon"] forState:UIControlStateNormal];
    [calciBtn setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
   // [questionsTextScrollView addSubview:calciBtn];
   // [calciBtn displayLayer:false];
//    postQuestionImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, questionBackgroundView.frame.size.height-40, 30, 30)];
//    // postQuestionImage.image=convertedImage;
//    [questionBackgroundView addSubview:postQuestionImage];
    
    CGFloat maxWidth=CGRectGetMaxX(categoriesTextField.frame);
//    UIButton *askBtn=[[UIButton alloc]initWithFrame:CGRectMake(maxWidth-180, calciBtn.frame.origin.y, 180, 25)];
//    [askBtn setTitle:@"Ask Anonymously" forState:UIControlStateNormal];
//    askBtn.titleLabel.font=LABELFONT;
//    askBtn.titleEdgeInsets=UIEdgeInsetsMake(0,20, 0, 5);
//    askBtn.titleLabel.textAlignment=NSTextAlignmentRight;
//    [askBtn setTitleColor:TEXTCOLOR forState:UIControlStateNormal];
//    [askBtn setImage:[UIImage imageNamed:@"new_uncheck"] forState:UIControlStateNormal];
//    [askBtn setImage:[UIImage imageNamed:@"new_check"] forState:UIControlStateSelected];
//    [askBtn addTarget:self action:@selector(askBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [questionsTextScrollView addSubview:askBtn];
    
    
    //Create Question Button
    createQuestionBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    createQuestionBtn.frame =CGRectMake((questionsTextScrollView.frame.size.width-150)/2, calciBtn.frame.origin.y+calciBtn.frame.size.height+10,150,30);
    [createQuestionBtn setBackgroundColor:[UIColor colorWithRed:228.0f/255.0 green:0.0/255.0f blue:49.0f/255.0f alpha:1.0]];
    //createQuestionBtn.layer.cornerRadius=4.0f;
    createQuestionBtn.titleLabel.font=LABELFONT;
    createQuestionBtn.titleLabel.font=[UIFont boldSystemFontOfSize:15.0f];
    [createQuestionBtn addTarget:self action:@selector(postQuestionButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [createQuestionBtn setTitle:@"Create Question" forState:UIControlStateNormal];
    [createQuestionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [questionsTextScrollView addSubview:createQuestionBtn];
    
    
    //Category Table View
    categoryTableView=[[UITableView alloc]init];
    [categoryTableView setFrame:CGRectMake(categoriesTextField.frame.origin.x, categoriesTextField.frame.origin.y+categoriesTextField.frame.size.height, categoriesTextField.frame.size.width, 120)];
    categoryTableView.dataSource=self;
    categoryTableView.delegate=self;
    categoryTableView.bounces=NO;
    categoryTableView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    categoryTableView.layer.borderWidth=0.5;
    categoryTableView.layer.cornerRadius=2.0f;
    categoryTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    subjectTableView=[[UITableView alloc]init];
    [subjectTableView setFrame:CGRectMake(tagFriendsTextField.frame.origin.x, tagFriendsTextField.frame.origin.y+tagFriendsTextField.frame.size.height, tagFriendsTextField.frame.size.width,120)];
    subjectTableView.dataSource=self;
    subjectTableView.delegate=self;
    subjectTableView.bounces=NO;
    subjectTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    subjectTableView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    subjectTableView.layer.borderWidth=0.5;
    subjectTableView.layer.cornerRadius=2.0f;
    
    
    postQuestionImage=[[UIImageView alloc]init];
    [postQuestionImage setImage:[UIImage imageNamed:@""]];
    postQuestionImage.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    postQuestionImage.frame=CGRectMake(maxWidth-25, calciBtn.frame.origin.y, 25, 25);
    postQuestionImage.tag=0;
    
    postQuestionImage.layer.borderWidth=0.5;
    [postQuestionImage setHidden:true];
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteimage:)];
    postQuestionImage.tag=0;
    [postQuestionImage setUserInteractionEnabled:YES];
    [postQuestionImage addGestureRecognizer:tapGesture];
    
    // postQuestionImage.image=convertedImage;
    [questionsTextScrollView addSubview:postQuestionImage];
    
    
    postQuestionImage1=[[UIImageView alloc]init];
    [postQuestionImage1 setImage:[UIImage imageNamed:@""]];
    postQuestionImage1.layer.borderColor=[UIColor lightGrayColor].CGColor;
    postQuestionImage1.tag=1;
    postQuestionImage1.frame=CGRectMake(postQuestionImage.frame.origin.x-35, calciBtn.frame.origin.y, 25, 25);
    
    postQuestionImage1.layer.borderWidth=0.5;
    [postQuestionImage1 setHidden:true];
    UITapGestureRecognizer *tapGesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteimage:)];
   
    [postQuestionImage1 setUserInteractionEnabled:YES];
    [postQuestionImage1 addGestureRecognizer:tapGesture1];
    // postQuestionImage.image=convertedImage;
    [questionsTextScrollView addSubview:postQuestionImage1];
    

    
    postQuestionImage2=[[UIImageView alloc]init];
    [postQuestionImage2 setImage:[UIImage imageNamed:@""]];
    postQuestionImage2.layer.borderColor=[UIColor lightGrayColor].CGColor;
    postQuestionImage2.tag=2;
    postQuestionImage2.frame=CGRectMake(postQuestionImage1.frame.origin.x-35, calciBtn.frame.origin.y, 25, 25);
    
    
    postQuestionImage2.layer.borderWidth=0.5;
    [postQuestionImage2 setHidden:true];
    UITapGestureRecognizer *tapGesture2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteimage:)];
 
    [postQuestionImage setUserInteractionEnabled:YES];
    [postQuestionImage addGestureRecognizer:tapGesture2];

    
    [questionsTextScrollView addSubview:postQuestionImage2];
    
    
    postQuestionImage3=[[UIImageView alloc]init];
    [postQuestionImage3 setImage:[UIImage imageNamed:@""]];
    postQuestionImage3.layer.borderColor=[UIColor lightGrayColor].CGColor;
    postQuestionImage3.tag=3;
    
    postQuestionImage3.frame=CGRectMake(postQuestionImage2.frame.origin.x-35, calciBtn.frame.origin.y, 25, 25);
    
    
    postQuestionImage3.layer.borderWidth=0.5;
    [postQuestionImage3 setHidden:true];
    UITapGestureRecognizer *tapGesture3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteimage:)];
    
    [postQuestionImage3 setUserInteractionEnabled:YES];
    [postQuestionImage3 addGestureRecognizer:tapGesture3];
    [questionsTextScrollView addSubview:postQuestionImage3];
    
    postQuestionImage4=[[UIImageView alloc]init];
    [postQuestionImage4 setImage:[UIImage imageNamed:@""]];
    postQuestionImage4.layer.borderColor=[UIColor lightGrayColor].CGColor;
    postQuestionImage4.tag=4;
    
    
    
    postQuestionImage4.layer.borderWidth=0.5;
    [postQuestionImage4 setHidden:true];
    UITapGestureRecognizer *tapGesture4=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteimage:)];
    
    [postQuestionImage setUserInteractionEnabled:YES];
    [postQuestionImage addGestureRecognizer:tapGesture4];
    
    
    postQuestionImage4.frame=CGRectMake(postQuestionImage3.frame.origin.x-35, calciBtn.frame.origin.y, 25, 25);
    [questionsTextScrollView addSubview:postQuestionImage4];
    
}
-(void)backBtn:(id) sender
{
    [createcategorySubview removeFromSuperview];
    [backBtn setHidden:YES];
    
}

-(void) deleteimage:(UITapGestureRecognizer *)recognizer

{
    indeximage=recognizer.view.tag;
    
    deleteImageAlert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Do you want to delete this image?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [deleteImageAlert show];
    
    // UserDetailViewController *userProfile=[[UserDetailViewController alloc]init];
    //recognizer.view.tag
 
}
-(void )viewimagesquestion
{
    [postQuestionImage setHidden:true];
     [postQuestionImage2 setHidden:true];
    [postQuestionImage3 setHidden:true];
    [postQuestionImage4 setHidden:true];
    [postQuestionImage1 setHidden:true];

    

    for (int i=0; i<imagelinksArray.count; i++)
    {
        NSString *imageurl = [imagelinksArray objectAtIndex:i] ;
        
      imageurl = [NSString stringWithFormat:@"http://%@", imageurl];
        NSURL *url = [NSURL URLWithString:imageurl];
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        

        if(i==0)
        {
            [postQuestionImage  setImage:image ];
            [postQuestionImage setHidden:false];
            
        }else if(i==1)
        {
             [postQuestionImage1  setImage:image ];
            [postQuestionImage1 setHidden:false];
            
        }
        else if(i==2)
        {
            [postQuestionImage2  setImage:image ];
            [postQuestionImage2 setHidden:false];
            
        }
        else if(i==3)
        {
            [postQuestionImage3  setImage:image ];
             [postQuestionImage3 setHidden:false];
            
        }
        else if(i==4)
        {
            [postQuestionImage4 setImage:image ];
            [postQuestionImage4 setHidden:false];
            
        }
    }

}
-(void)postImageUser:(NSString*)questionid action:(NSString*) action  attachment:(NSString*) attachment guid:(NSString*) guid imagequestionId:(NSString*) imagequestionId
{
    NSArray *mainArray= [[WebServiceSingleton sharedMySingleton]usersaveImage:questionid action:action attachment:attachment guid:guid imagequestionId:imagequestionId ];
    if ([[mainArray valueForKey:@"status"] isEqualToString:@"1"])
    {
        if(![action isEqualToString:@"delete"])
           {
                NSString *imageurl =[mainArray valueForKey:@"ImageURL"];
                [imagelinksArray addObject:imageurl];
                NSString *imagequestionid =[mainArray valueForKey:@"imagequestionid"];
                [imageidArray addObject:imagequestionid];
           }
           else
           {
               [imagelinksArray removeObjectAtIndex:indeximage];
              
               [imageidArray removeObjectAtIndex:indeximage];
           
           }
        
           [self viewimagesquestion];
    }
     [self hideActivity];
}

-(void)CreateUI
{
    
    
    NavigationView *nav = [[NavigationView alloc] init];
    nav.titleView.text = @"POST QUESTION";
   
    
  
    [self.view addSubview:nav.navigationView];
    
    
    backgroundScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    
    
    [backgroundScrollView setScrollEnabled:YES];
    [self.view addSubview:backgroundScrollView];
    
    
    mainBackgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height)];
    [mainBackgroundView setBackgroundColor:[UIColor lightGrayColor]];
    //[self.view addSubview:mainBackgroundView];
    [backgroundScrollView addSubview:mainBackgroundView];
    
    categoryBackgroundView=[[UIView alloc]init];
    categoryBackgroundView.frame=CGRectMake(10, 10, 300, 50);
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:categoryBackgroundView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:(CGSize){10.0, 10.0}].CGPath;
    maskLayer.borderWidth=1.0f;
    maskLayer.borderColor=[UIColor blackColor].CGColor;
    categoryBackgroundView.layer.mask = maskLayer;
    categoryBackgroundView.backgroundColor=[UIColor whiteColor];
    [mainBackgroundView addSubview:categoryBackgroundView];
    
    UILabel  * categoryLabel = [[UILabel alloc] init];
    categoryLabel.backgroundColor = [UIColor clearColor];
    categoryLabel.frame=CGRectMake(10, 0, 80, 50);
    categoryLabel.textAlignment = 2; // UITextAlignmentCenter, UITextAlignmentLeft
    categoryLabel.textColor=[UIColor blackColor];
    categoryLabel.text = @"Category:";
    [categoryBackgroundView addSubview:categoryLabel];
    
    categoryValuelabel = [[UILabel alloc] init];
    categoryValuelabel.backgroundColor = [UIColor clearColor];
    categoryValuelabel.frame=CGRectMake(categoryBackgroundView.frame.size.width-100, 0, 100, 50);
    categoryValuelabel.textAlignment = 0; // UITextAlignmentCenter, UITextAlignmentLeft
    categoryValuelabel.textColor=[UIColor blackColor];
    [categoryBackgroundView addSubview:categoryValuelabel];
    
    
    categorySelectionButton=[UIButton buttonWithType:UIButtonTypeCustom];
    categorySelectionButton.frame=CGRectMake(categoryBackgroundView.frame.size.width-90, 0, 90, 50);
    [categorySelectionButton setTitle:@"Select   >" forState:UIControlStateNormal];
    
  
    [categorySelectionButton addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [categorySelectionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [categorySelectionButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
   // categorySelectionButton.titleLabel.textColor=[UIColor lightGrayColor];
   // categorySelectionButton.backgroundColor=[UIColor clearColor];
    [categoryBackgroundView addSubview:categorySelectionButton];
    
    
   subjectViewBackgroundView=[[UIView alloc]init];
    subjectViewBackgroundView.frame=CGRectMake(10, categoryBackgroundView.frame.origin.y+categoryBackgroundView.frame.size.height+10, 300, 50);
    CAShapeLayer *maskSubjectLayer = [CAShapeLayer layer];
    maskSubjectLayer.path = [UIBezierPath bezierPathWithRoundedRect:categoryBackgroundView.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:(CGSize){10.0, 10.0}].CGPath;
    maskSubjectLayer.borderWidth=1.0f;
    maskSubjectLayer.borderColor=[UIColor blackColor].CGColor;
    subjectViewBackgroundView.layer.mask = maskSubjectLayer;
    subjectViewBackgroundView.backgroundColor=[UIColor whiteColor];
    [mainBackgroundView addSubview:subjectViewBackgroundView];

    UILabel  * subjectLabel = [[UILabel alloc] init];
    subjectLabel.backgroundColor = [UIColor clearColor];
    subjectLabel.frame=CGRectMake(10, 0, 70, 50);
    subjectLabel.textAlignment = 2;
    subjectLabel.textColor=[UIColor blackColor];
    subjectLabel.text = @"Subject:";
    [subjectViewBackgroundView addSubview:subjectLabel];
   
    subjectValuelabel = [[UILabel alloc] init];
    subjectValuelabel.backgroundColor = [UIColor clearColor];
    subjectValuelabel.frame=CGRectMake(categoryBackgroundView.frame.size.width-100, 0, 100, 50);
    subjectValuelabel.textAlignment = 0; // UITextAlignmentCenter, UITextAlignmentLeft
    subjectValuelabel.textColor=[UIColor blackColor];
    [subjectViewBackgroundView addSubview:subjectValuelabel];
    
    
    subjectSelectionButton=[UIButton buttonWithType:UIButtonTypeCustom];
    subjectSelectionButton.frame=CGRectMake(categoryBackgroundView.frame.size.width-90, 0, 90, 50);
    [subjectSelectionButton setTitle:@"Select   >" forState:UIControlStateNormal];
    //[subjectSelectionButton setTitle:@"Select  >" forState:UIControlStateHighlighted];
    [subjectSelectionButton addTarget:self action:@selector(subjectSelection:) forControlEvents:UIControlEventTouchUpInside];
    [subjectSelectionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   // [subjectSelectionButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
 
    [subjectViewBackgroundView addSubview:subjectSelectionButton];
    
    
  
  questionBackgroundView=[[UIView alloc]init];
   // questionBackgroundView.frame=CGRectMake(10, 180, 300, 200);
    questionBackgroundView.frame=CGRectMake(10, subjectViewBackgroundView.frame.origin.y+subjectViewBackgroundView.frame.size.height+10, 300, 250);
    questionBackgroundView.backgroundColor=[UIColor whiteColor];
    [mainBackgroundView addSubview:questionBackgroundView];
    
   
    
    questiontextView =[[UITextView alloc]initWithFrame:CGRectMake(0,0,300,200)];
    questiontextView.text = @"Enter your question";
   // questiontextView.backgroundColor=[UIColor grayColor];
    questiontextView.font=[UIFont fontWithName:@"Helvetica" size:16.0f];
    questiontextView.textColor = [UIColor lightGrayColor];
    [questiontextView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [questiontextView setDelegate:self];
   
    
    questiontextView.scrollEnabled=YES;
   
    [questiontextView setReturnKeyType:UIReturnKeyDone];
    [questiontextView setTag:1];
    [questionBackgroundView addSubview:questiontextView];
    
    
    imageCaptureButton=[UIButton buttonWithType:UIButtonTypeCustom];
    imageCaptureButton.frame=CGRectMake(180, questionBackgroundView.frame.size.height-40, 30, 30);
    
    [imageCaptureButton setImage:[UIImage imageNamed:@"camera_icon"] forState:UIControlStateNormal];
    
    [imageCaptureButton addTarget:self action:@selector(openCamera:) forControlEvents:UIControlEventTouchUpInside];
    [imageCaptureButton setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
    [questionBackgroundView addSubview:imageCaptureButton];
    
    sendButton=[UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame=CGRectMake(imageCaptureButton.frame.origin.x+imageCaptureButton.frame.size.width,questionBackgroundView.frame.size.height-48, 90, 50);
    [sendButton setBackgroundColor:[UIColor clearColor]];
    [sendButton setImage:[UIImage imageNamed:@"send_button"] forState:UIControlStateNormal];

    [sendButton addTarget:self action:@selector(postQuestionButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
    [questionBackgroundView addSubview:sendButton];
    
    postQuestionImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, questionBackgroundView.frame.size.height-40, 30, 30)];
   // postQuestionImage.image=convertedImage;
    [questionBackgroundView addSubview:postQuestionImage];
   
}



-(void) textViewDidBeginEditing:(UITextView *)textView
{
    [categoryTableView removeFromSuperview];
    [subjectTableView removeFromSuperview];
    
    if ([subjectValuelabel.text isEqualToString:@""])
    {
         [subjectSelectionButton setTitle:@"Select >" forState:UIControlStateNormal];
    }
   
    
    
    if ([questiontextView.text isEqualToString:@"Question Text"])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    
    
    CGSize result=[[UIScreen mainScreen]bounds].size;
    if (result.height==568)
    {
    [questionsTextScrollView setContentOffset:CGPointMake(questionsTextScrollView.frame.origin.x, categoriesTextField.frame.origin.y+categoriesTextField.frame.size.height)];
    }
    else
    {

      [questionsTextScrollView setContentOffset:CGPointMake(questionsTextScrollView.frame.origin.x, categoriesTextField.frame.origin.y+categoriesTextField.frame.size.height)];
    }
    
    NSString *categoryStr=categoryValuelabel.text;
    if ([categoryStr isEqualToString:@""])
    {
        [categorySelectionButton setTitle:@"Select >" forState:UIControlStateNormal];
    }
    
    backgroundScrollView.contentOffset=CGPointMake(0,0);
    
    [questionsTextScrollView setContentSize:CGSizeMake(questionsTextScrollView.frame.size.width, questionsTextScrollView.frame.size.height+200)];
}

-(void) textViewDidEndEditing:(UITextView *)textView
{
    
    if ([questiontextView.text isEqualToString:@""])
    {
        textView.text = @"Question Text";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    
    
    CGSize result=[[UIScreen mainScreen]bounds].size;
    if (result.height==568)
    {
    [questionsTextScrollView setContentSize:CGSizeMake(questionsTextScrollView.frame.size.width, questionsTextScrollView.frame.size.height-200)];
    }
    else
    {
    [questionsTextScrollView setContentSize:CGSizeMake(questionsTextScrollView.frame.size.width, questionsTextScrollView.frame.size.height-200)];
    }
    [questionsTextScrollView setContentOffset:CGPointMake(questionsTextScrollView.frame.origin.x,0)];
//
  
   
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}






-(void) viewWillAppear:(BOOL)animated
{
    
    
     //categoryValuelabel.text=categoryLabelString;
//    categoryValuelabel.text=@"";
//    subjectValuelabel.text=@"";
//    questiontextView.text=@"";
    //[postQuestionImage setImage:[UIImage imageNamed:@""]];
//    categoryValuelabel.text=@"";
//    subjectValuelabel.text=@"";
   
//
        /*[ImagePostQuestion removeFromSuperview];
     
    if (convertedImage)
    {
        [postQuestionImage setImage:convertedImage];
        postQuestionImage.layer.borderWidth=0.5;
        
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]init];
        [tapGesture addTarget:self action:@selector(popImageView)];
        [postQuestionImage addGestureRecognizer:tapGesture];
        postQuestionImage.userInteractionEnabled=YES;
    }*/
    
    _postImage=[[AppDelegate sharedDelegate]postedImage];
    
    
    UIImage *quesImage=_postImage;
    if (quesImage)
    {
        convertedImage=quesImage;
        action=@"insertimageuser";
        [self showActivity];
    }
    
    
}

#pragma mark Action Methods

-(void)askBtnAction:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    UIImage *image=[UIImage imageNamed:@"new_uncheck"];
    if ([[btn imageForState:UIControlStateNormal] isEqual:image])
    {
        [btn setImage:[UIImage imageNamed:@"new_check"] forState:UIControlStateNormal];
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"new_uncheck"] forState:UIControlStateNormal];
    }
}
-(void)removeAllSubviews
{
    [categoryTableView removeFromSuperview];
    [subjectTableView removeFromSuperview];
    [questiontextView resignFirstResponder];
    
    
}

-(void)createcategorySelectionAction:(id)sender
{
    [questiontextView resignFirstResponder];
   //selectedBtnArray=[[NSMutableArray alloc]init];
    [categoriesTextField resignFirstResponder];
    
    //    if (![questionsTextScrollView.subviews containsObject:categoryTableView])
    //    {
    //     [questionsTextScrollView addSubview:categoryTableView];
    //    }
    //
    [self createCategoryActionSubview];
    
    
    
    
    [subjectTableView removeFromSuperview];
}


-(void)categorySelectionAction:(id)sender
{
    [questiontextView resignFirstResponder];
    selectedBtnArray=[[NSMutableArray alloc]init];
    [categoriesTextField resignFirstResponder];
    
//    if (![questionsTextScrollView.subviews containsObject:categoryTableView])
//    {
//     [questionsTextScrollView addSubview:categoryTableView];
//    }
//
    [self categorySubview];

   
    
   // [questiontextView resignFirstResponder];
    //[subjectTableView removeFromSuperview];
}
-(void)subjectSelectionAction:(id)sender
{
    
    [tagFriendsTextField resignFirstResponder];
    
    if (![questionsTextScrollView.subviews containsObject:subjectTableView])
    {
        [questionsTextScrollView addSubview:subjectTableView];
    }
    else
    {
        [subjectTableView removeFromSuperview];
    }
    
    
    [questiontextView resignFirstResponder];
    [categoryTableView removeFromSuperview];
}

-(void)CreateCategoryTabFriendSelectionAction:(id)sender
{
    [createcategoriestagFriendsTextField resignFirstResponder];
    
    if (![createcategorySubview.subviews containsObject:categoryfriendTableView])
    {
        [createcategorySubview addSubview:categoryfriendTableView];
    }
    else
    {
        [categoryfriendTableView removeFromSuperview];
    }
    
    
    //[questiontextView resignFirstResponder];
    
    //[categoryTableView removeFromSuperview];
}


-(void) selectBtn:(UIButton *)sender
{
    [subjectPicker removeFromSuperview];
    categoryPicker=[[UIPickerView alloc]init];
    categoryPicker.frame=CGRectMake(150, 50, 162, 162);
    categoryPicker.delegate=self;
    categoryPicker.dataSource=self;
    [categoryPicker setBackgroundColor:[UIColor whiteColor]];
    [backgroundScrollView addSubview:categoryPicker];
    subjectValuelabel.text=@"";
    NSString *categoryStr=categorySelectionButton.titleLabel.text;
    if ([categoryStr isEqualToString:@""])
    {
        [categorySelectionButton setTitle:@"Select >" forState:UIControlStateNormal];
    }
    [categorySelectionButton setTitle:@"" forState:UIControlStateNormal];
    [subjectSelectionButton setTitle:@"Select  >" forState:UIControlStateNormal];
    
}

-(void) subjectSelection:(UIButton *)sender
{
    [subjectPicker removeFromSuperview];
    
    [backgroundScrollView setContentOffset:CGPointMake(0, 0)];
    [questiontextView resignFirstResponder];
    
    if (!categoryLabelString.length)
    {
      NSString *errorMessage=@"Please Select Category";
        UIAlertView *errorAlertView=[[UIAlertView alloc]initWithTitle:@"" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [errorAlertView show];
       
    }
    else
    {
    subjectArray=[[NSMutableArray alloc]initWithArray:[subjectDictionary objectForKey:categoryLabelString]];
        
    subjectPicker=[[UIPickerView alloc]init];
    
        subjectPicker.frame=CGRectMake(150, 150, 162, 162);
        subjectPicker.dataSource=self;
        subjectPicker.delegate=self;
        [subjectPicker setBackgroundColor:[UIColor whiteColor]];
        [backgroundScrollView addSubview:subjectPicker];
        [subjectSelectionButton setTitle:@"" forState:UIControlStateNormal];
     
    }
}


-(void)createCategoryActionSubview
{
    [backBtn setHidden:NO];
    createcategorySubview=[[UIScrollView alloc]initWithFrame:CGRectMake(postTitleLabel.frame.origin.x, postTitleLabel.frame.origin.y+20, postTitleLabel.frame.size.width, self.view.frame.size.height-(postTitleLabel.frame.origin.y+100))];
    [createcategorySubview setBackgroundColor:[UIColor whiteColor]];
    //createcategorySubview.layer.borderColor=[UIColor grayColor].CGColor;
    //createcategorySubview.layer.borderWidth=2.0f;
    //createcategorySubview.layer.cornerRadius=4.0f;
    [self.view addSubview:createcategorySubview];
    
    createcategoryTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, lineView.frame.origin.y+lineView.frame.size.height+5, self.view.bounds.size.width, 30)];
    createcategoryTitleLabel.textAlignment=NSTextAlignmentCenter;
    [createcategoryTitleLabel setText:@"Create a New Category"];
    [createcategoryTitleLabel setFont:LABELFONT];
    [createcategoryTitleLabel setTextColor:[UIColor colorWithRed:25.0f/255.0f green:25.0f/255.0f blue:25.0f/255.0f alpha:1.0]];
    [createcategorySubview addSubview:createcategoryTitleLabel];
    
    createcategoriesnameTextField=[[UITextField alloc]initWithFrame:CGRectMake(20, createcategoryTitleLabel.frame.origin.y+createcategoryTitleLabel.frame.size.height+10, (self.view.frame.size.width-40), 40)];
    createcategoriesnameTextField.delegate=self;
    [createcategoriesnameTextField setPlaceholder:@"Category Name"];
    [createcategoriesnameTextField setFont:LABELFONT];
    [createcategoriesnameTextField setTextColor:TEXTCOLOR];
    createcategoriesnameTextField.layer.borderColor=[UIColor lightGrayColor].CGColor;
    createcategoriesnameTextField.layer.borderWidth=1.0f;
    createcategoriesnameTextField.layer.cornerRadius=2.0f;
    [createcategorySubview addSubview:createcategoriesnameTextField];
    
    UIColor *color=TEXTCOLOR;
    createcategoriesnameTextField.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"Category Name" attributes:@{NSForegroundColorAttributeName:color}];
    
    UIView *leftPaddingView=[[UIView alloc]initWithFrame:CGRectMake(5, createcategoriesnameTextField.frame.origin.y, 30, 40)];
    createcategoriesnameTextField.leftView=leftPaddingView;
    createcategoriesnameTextField.leftViewMode=UITextFieldViewModeAlways;
    
    UIImageView *categoryImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5,(leftPaddingView.frame.size.height-20)/2, 20, 20)];
    [categoryImageView setImage:[UIImage imageNamed:@"category_icon"]];
    [leftPaddingView addSubview:categoryImageView];
    
    UIView *rightPaddingView=[[UIView alloc]initWithFrame:CGRectMake(createcategoriesnameTextField.frame.size.width-30, createcategoriesnameTextField.frame.origin.y, 30, 40)];
    createcategoriesnameTextField.rightView=rightPaddingView;
    createcategoriesnameTextField.rightViewMode=UITextFieldViewModeAlways;
    
    
    
    createcategorieshastagsTextField=[[UITextField alloc]initWithFrame:CGRectMake(20, createcategoriesnameTextField.frame.origin.y+createcategoriesnameTextField.frame.size.height+10, (self.view.frame.size.width-40), 40)];
    createcategorieshastagsTextField.delegate=self;
    [createcategorieshastagsTextField setPlaceholder:@"Hashtags"];
    [createcategorieshastagsTextField setFont:LABELFONT];
    [createcategorieshastagsTextField setTextColor:TEXTCOLOR];
    createcategorieshastagsTextField.layer.borderColor=[UIColor lightGrayColor].CGColor;
    createcategorieshastagsTextField.layer.borderWidth=1.0f;
    createcategorieshastagsTextField.layer.cornerRadius=2.0f;
    [createcategorySubview addSubview:createcategorieshastagsTextField];
    
    UIColor *color1=TEXTCOLOR;
    createcategorieshastagsTextField.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"Hashtags" attributes:@{NSForegroundColorAttributeName:color1}];
    
    UIView *leftPaddingView1=[[UIView alloc]initWithFrame:CGRectMake(5, createcategoriesnameTextField.frame.origin.y, 30, 40)];
    createcategorieshastagsTextField.leftView=leftPaddingView1;
    createcategorieshastagsTextField.leftViewMode=UITextFieldViewModeAlways;
    
    UIImageView *categoryImageView1=[[UIImageView alloc]initWithFrame:CGRectMake(5,(leftPaddingView.frame.size.height-20)/2, 20, 20)];
    [categoryImageView1 setImage:[UIImage imageNamed:@"category_icon"]];
    [leftPaddingView1 addSubview:categoryImageView1];
    
    UIView *rightPaddingView1=[[UIView alloc]initWithFrame:CGRectMake(createcategorieshastagsTextField.frame.size.width-30, createcategorieshastagsTextField.frame.origin.y, 30, 40)];
    createcategorieshastagsTextField.rightView=rightPaddingView1;
    createcategorieshastagsTextField.rightViewMode=UITextFieldViewModeAlways;
    
    
    
    createcategoriestagFriendsTextField=[[UITextField alloc]initWithFrame:CGRectMake(20, createcategorieshastagsTextField.frame.origin.y+createcategorieshastagsTextField.frame.size.height+10, (self.view.frame.size.width-40), 40)];
    [createcategoriestagFriendsTextField setPlaceholder:@"Tag Friends"];
    createcategoriestagFriendsTextField.delegate=self;
    [createcategoriestagFriendsTextField setFont:LABELFONT];
    [createcategoriestagFriendsTextField setTextColor:TEXTCOLOR];
    createcategoriestagFriendsTextField.layer.borderColor=[UIColor lightGrayColor].CGColor;
    createcategoriestagFriendsTextField.layer.borderWidth=1.0f;
    createcategoriestagFriendsTextField.layer.cornerRadius=2.0f;
    
    [createcategorySubview addSubview:createcategoriestagFriendsTextField];
    
    UIView *paddingView2=[[UIView alloc]initWithFrame:CGRectMake(10, createcategoriestagFriendsTextField.frame.origin.y, 30, 40)];
    createcategoriestagFriendsTextField.leftView=paddingView2;
    createcategoriestagFriendsTextField.leftViewMode=UITextFieldViewModeAlways;
    
    createcategoriestagFriendsTextField.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"Tag Friends" attributes:@{NSForegroundColorAttributeName:color}];
    
    UIImageView *friendsImageView2=[[UIImageView alloc]initWithFrame:CGRectMake(5,(paddingView2.frame.size.height-20)/2, 20, 20)];
    [friendsImageView2 setImage:[UIImage imageNamed:@"tag_friend_icon"]];
    [paddingView2 addSubview:friendsImageView2];
    
    
    UIView *rightPaddingView2=[[UIView alloc]initWithFrame:CGRectMake(createcategoriestagFriendsTextField.frame.size.width-30, createcategoriestagFriendsTextField.frame.origin.y, 30, 40)];
    createcategoriestagFriendsTextField.rightView=rightPaddingView2;
    createcategoriestagFriendsTextField.rightViewMode=UITextFieldViewModeAlways;
    
    //    UIButton *subjectSelectionBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, (rightPaddingView1.frame.size.height-20)/2, 20, 20)];
    //    [subjectSelectionBtn addTarget:self action:@selector(subjectSelectionAction:) forControlEvents:UIControlEventTouchUpInside];
    //    [subjectSelectionBtn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
    //    [rightPaddingView1 addSubview:subjectSelectionBtn];
    
    
    
    UIButton *subjectSelectionBtn=[[UIButton alloc]initWithFrame:CGRectMake(createcategoriestagFriendsTextField.frame.size.width-10, createcategoriestagFriendsTextField.frame.origin.y+10, 20, 20)];
    
    [subjectSelectionBtn addTarget:self action:@selector(CreateCategoryTabFriendSelectionAction:) forControlEvents:UIControlEventTouchUpInside];
    [subjectSelectionBtn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
    [createcategorySubview addSubview:subjectSelectionBtn];
    
    
    categoryfriendTableView=[[UITableView alloc]init];
    [categoryfriendTableView setFrame:CGRectMake(createcategoriestagFriendsTextField.frame.origin.x, createcategoriestagFriendsTextField.frame.origin.y+createcategoriestagFriendsTextField.frame.size.height, createcategoriestagFriendsTextField.frame.size.width,120)];
    categoryfriendTableView.dataSource=self;
    categoryfriendTableView.delegate=self;
    categoryfriendTableView.bounces=NO;
    categoryfriendTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    categoryfriendTableView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    categoryfriendTableView.layer.borderWidth=0.5;
    categoryfriendTableView.layer.cornerRadius=2.0f;
    
    
    
    UIButton *createcategoryBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    createcategoryBtn.frame =CGRectMake((createcategorySubview.frame.size.width-150)/2-30, createcategoriestagFriendsTextField.frame.origin.y+createcategoriestagFriendsTextField.frame.size.height+10,200,30);
    [createcategoryBtn setBackgroundColor:[UIColor colorWithRed:228.0f/255.0 green:0.0/255.0f blue:49.0f/255.0f alpha:1.0]];
    //createQuestionBtn.layer.cornerRadius=4.0f;
    createcategoryBtn.titleLabel.font=LABELFONT;
    createcategoryBtn.titleLabel.font=[UIFont boldSystemFontOfSize:15.0f];
    [createcategoryBtn addTarget:self action:@selector(createcategoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [createcategoryBtn setTitle:@"Create New Category" forState:UIControlStateNormal];
    [createcategoryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [createcategorySubview addSubview:createcategoryBtn];
    
    
    
    
    
    
    
    
    

}
-(void)categorySubview
{
    categorySubview=[[UIScrollView alloc]initWithFrame:CGRectMake(categoriesTextField.frame.origin.x, categoriesTextField.frame.origin.y+10, categoriesTextField.frame.size.width, self.view.frame.size.height-(categoriesTextField.frame.origin.y+100))];
    [categorySubview setBackgroundColor:[UIColor whiteColor]];
    categorySubview.layer.borderColor=[UIColor grayColor].CGColor;
    categorySubview.layer.borderWidth=2.0f;
    categorySubview.layer.cornerRadius=4.0f;
    [self.view addSubview:categorySubview];
    
    CGRect btnFrame=CGRectMake(10, 0, 120,30);
   // NSArray *titleArray=[[NSArray alloc]initWithObjects:@"All",@"Science",@"Maths",@"Arts", nil];
    NSInteger rowCount=categoryofuserArray.count/2;
    NSInteger columnCount;
    columnCount=2;
    if (categoryofuserArray.count%2!=0)
    {
        rowCount=rowCount+1;
    }
    
    int a=0;
    for (int i=0; i<rowCount; i++)
    {
        
       
        for (int j=0; j<columnCount; j++)
        {
            if(a==categoryofuserArray.count)
                break;
        categoryBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        categoryBtn.frame=btnFrame;
        categoryBtn.tag=a;
       
        [categoryBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
       // [categoryBtn setImage:[UIImage imageNamed:@"unselected_box"] forState:UIControlStateNormal];
        categoryBtn.titleLabel.font=LABELFONT;
             categoryBtn.titleLabel.textAlignment=NSTextAlignmentLeft;
        //
      
        categoryBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
              NSString * categoryname=[[categoryofuserArray objectAtIndex:a] valueForKey:@"category_name"];
            categoryBtn.titleEdgeInsets=UIEdgeInsetsMake(0,30, 0, -10);
        [categoryBtn setTitle:categoryname forState:UIControlStateNormal];
        [categoryBtn addTarget:self action:@selector(multipleCategorySelection:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *boxImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10,(categoryBtn.frame.size.height-15)/2,17, 15)];
        [boxImageView setImage:[UIImage imageNamed:@"unselected_box"]];
        [categoryBtn addSubview:boxImageView];
        UILabel *categoryLabel=[[UILabel alloc]initWithFrame:CGRectMake(boxImageView.frame.origin.x+boxImageView.frame.size.width+5, 0, categoryBtn.frame.size.width-22, categoryBtn.frame.size.height)];
          
        [categoryLabel setText:categoryname];
        [categoryLabel setTextColor:[UIColor lightGrayColor]];
       // [categoryBtn addSubview:categoryLabel];
        [categorySubview addSubview:categoryBtn];
        a++;
            
            
        btnFrame.origin.x=btnFrame.origin.x+btnFrame.size.width+10;
        }
        
        btnFrame.origin.y=btnFrame.origin.y+btnFrame.size.height+10;
        btnFrame.origin.x=10;
    }
    
    
    
    
 

    
    UIButton *filterBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    filterBtn.frame=CGRectMake((categorySubview.frame.size.width-50)/2-30, categorySubview.frame.size.height-100, 100, 30);
   // [filterBtn setTitle:@"Filter" forState:UIControlStateNormal];
    [filterBtn setBackgroundImage:[UIImage imageNamed:@"btDone"] forState:UIControlStateNormal];
    filterBtn.titleLabel.font=LABELFONT;
    [filterBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    filterBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    filterBtn.layer.borderWidth=1.0f;
    filterBtn.layer.cornerRadius=4.0f;
    [filterBtn addTarget:self action:@selector(doneBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [categorySubview addSubview:filterBtn];
    
    UIButton *deleteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame=CGRectMake((categorySubview.frame.size.width-50)/2-80, categorySubview.frame.size.height-50, 100, 30);
   // [deleteBtn setTitle:@"Delete" forState:UIControlStateNormal];
    //[deleteBtn setba];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"btDelete"] forState:UIControlStateNormal];
    deleteBtn.titleLabel.font=LABELFONT;
    [deleteBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    deleteBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    deleteBtn.layer.borderWidth=1.0f;
    deleteBtn.layer.cornerRadius=4.0f;
    [deleteBtn addTarget:self action:@selector(deletecategoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [categorySubview addSubview:deleteBtn];
    
    
    UIButton *createBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    createBtn.frame=CGRectMake((categorySubview.frame.size.width-50)/2+30, categorySubview.frame.size.height-50, 100, 30);
   // [createBtn setTitle:@"Create" forState:UIControlStateNormal];
    
    [createBtn setBackgroundImage:[UIImage imageNamed:@"btCreate"] forState:UIControlStateNormal];
    
    createBtn.titleLabel.font=LABELFONT;
    [createBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    createBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    createBtn.layer.borderWidth=1.0f;
    createBtn.layer.cornerRadius=4.0f;
    [createBtn addTarget:self action:@selector(createcategorySelectionAction:) forControlEvents:UIControlEventTouchUpInside];
    [categorySubview addSubview:createBtn];


    
    
    
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
              //  [selectedBtnArray removeObjectsAtIndexes:<#(nonnull NSIndexSet *)#>
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
-(void)deletecategoryButtonClick:(id)sender
{
   
    action=@"deletecategory";
    [self showActivity];
    [activity setTitle:@"Deleting..."];

    
}


-(void)createcategoryButtonClick:(id)sender
{
   
    action=@"createcategory";
    [self showActivity];
    [activity setTitle:@"Creating..."];


}
-(void)doneBtnAction:(id)sender
{
    

    NSLog(@"%@",selectedBtnArray);
    UIView *v=[sender superview];
    if ([v isKindOfClass:[UIView class]])
    {
      [v removeFromSuperview];
    }
    NSMutableString *str=[[NSMutableString alloc]init];
    multipleCategoriesStr =[[NSMutableString alloc]init];
    for (int i=0; i<selectedBtnArray.count; i++)
    {
       /* if ([[selectedBtnArray objectAtIndex:i] isEqualToString:@"0"])
        {
            [str appendString:@"All"];
            [str appendString:@","];
        }
        else if ([[selectedBtnArray objectAtIndex:i] isEqualToString:@"1"])
        {
            [str appendString:@"Science"];
            [str appendString:@","];
        }
        else if ([[selectedBtnArray objectAtIndex:i] isEqualToString:@"2"])
        {
            [str appendString:@"Maths"];
            [str appendString:@","];
        }
        else if ([[selectedBtnArray objectAtIndex:i] isEqualToString:@"3"])
        {
            [str appendString:@"Arts"];
            [str appendString:@","];
        }*/
        int value = [[selectedBtnArray objectAtIndex:i] intValue];
        [str appendString:[[categoryofuserArray objectAtIndex:value] valueForKey:@"category_name"]];
        
      
        NSString *categoryid=[[categoryofuserArray objectAtIndex:value] valueForKey:@"id"];
        [multipleCategoriesStr appendString: categoryid ];
        [multipleCategoriesStr appendString:@","];
        
        
        [str appendString:@","];
        
    }
    if (![str isEqualToString:@""])
    {
     [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];
        categoriesTextField.text=str;
    }
    else
    {
       categoriesTextField.text=@"";
    }

    
    
    
    
    
}


#pragma mark UITableView Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==categoryTableView)
    {
        return [categoryArray count];
    }
    else
    {
      return [friendsData count];
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(tableView==categoryTableView)
//    {
    static NSString *cellIdentifier=@"Cell Identifier";
    UITableViewCell *cell=(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font=LABELFONT;
        cell.textLabel.textColor=TEXTCOLOR;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 29.5, categoryTableView.frame.size.width, 0.5)];
        [lineView setBackgroundColor:[UIColor grayColor]];
        [cell.contentView addSubview:lineView];
        [lineView setBackgroundColor:[UIColor lightGrayColor]];
    }
        
        if (tableView==categoryTableView)
        {
         cell.textLabel.text=[categoryArray objectAtIndex:indexPath.row];
        }
        else
        {
            NSString *valueshow=[[friendsData valueForKey:@"name"]objectAtIndex:indexPath.row];
            if([valueshow isEqualToString:@""])
            {
                valueshow=[[friendsData valueForKey:@"email"]objectAtIndex:indexPath.row];

            }
            
          cell.textLabel.text=valueshow;
        }
    
    return cell;
//    }
//    else
//    {
//        static NSString *cellIdentifier=@"Cell Identifier";
//        UITableViewCell *cell=(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        if (cell==nil)
//        {
//            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//            cell.textLabel.font=LABELFONT;
//            cell.textLabel.textColor=TEXTCOLOR;
//            cell.selectionStyle=UITableViewCellSelectionStyleNone;
//        }
//        
//        return cell;
//    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==categoryTableView)
    {
         categoryId=indexPath.row;
        [categoryTableView removeFromSuperview];
        categoriesTextField.text=[categoryArray objectAtIndex:indexPath.row];
    }
    else
    {
        subjectId=indexPath.row;
       
        if(tableView==subjectTableView)
        {
            [subjectTableView removeFromSuperview];
            friendsString=tagFriendsTextField.text;
            friendsString=[friendsString stringByAppendingString:[[friendsData valueForKey:@"name"]objectAtIndex:indexPath.row]];
            friendIdsString=[friendIdsString stringByAppendingString:[[friendsData valueForKey:@"id"]objectAtIndex:indexPath.row]];
            friendsString=[friendsString stringByAppendingString:@","];
            friendIdsString=[friendIdsString stringByAppendingString:@","];

        
            tagFriendsTextField.text=friendsString;
        }
        else
        {
            [categoryfriendTableView removeFromSuperview];
            createcategoryfriendsString=createcategoriestagFriendsTextField.text;
            createcategoryfriendsString=[createcategoryfriendsString stringByAppendingString:[[friendsData valueForKey:@"name"]objectAtIndex:indexPath.row]];
            
            createcategoryfriendidsString=[createcategoryfriendidsString stringByAppendingString:[[friendsData valueForKey:@"id"]objectAtIndex:indexPath.row]];
            
            
            createcategoryfriendsString=[createcategoryfriendsString stringByAppendingString:@","];
            
            createcategoryfriendidsString=[createcategoryfriendidsString stringByAppendingString:@","];

            
            createcategoriestagFriendsTextField.text=createcategoryfriendsString;
        }
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0f;
}



#pragma mark PickerView Methods
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView==categoryPicker)
    {
        return [categoryArray count];
    }
    else
    {
        return [subjectArray count];
    }
   
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView==categoryPicker)
    {
            return [categoryArray objectAtIndex:row];
    }
    else
    {
        return [subjectArray objectAtIndex:row];
    }

}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView==categoryPicker)
    {
        categoryId=row;
        [categoryPicker removeFromSuperview];
        categoryLabelString=[categoryArray objectAtIndex:row];
        
        categoryValuelabel.text=categoryLabelString;
     
        
       
    }
    else
    {
        subjectId=row;
        
        [subjectPicker removeFromSuperview];
        subjectLabelString=[subjectArray objectAtIndex:row];
        subjectValuelabel.text=subjectLabelString;
        
  
    }
    
    
}






-(void) popImageView
{
    [imageScrollView setContentOffset:CGPointMake(0, 0)];
    [questiontextView resignFirstResponder];
    
    imageScrollView=[[UIScrollView alloc]init];
    imageScrollView.delegate=self;
    imageScrollView.frame=CGRectMake(0,44, 320, self.view.frame.size.height-44);
    imageScrollView.maximumZoomScale=10.0;
    imageScrollView.minimumZoomScale=1.0;
    imageScrollView.bounces=NO;
    [imageScrollView setContentSize: CGSizeMake(self.view.frame.size.width, 1000)];
    if (imageScrollView.minimumZoomScale)
    {
        ImagePostQuestion.frame=CGRectMake(100, 100, 320, 1000);
    }
    else
    {
         ImagePostQuestion.frame=CGRectMake(0, 0, 320, 1000);
    }
    
    
    ImagePostQuestion.layer.borderWidth=2.0f;
    ImagePostQuestion.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    imageScrollView.backgroundColor=[UIColor lightGrayColor];
    
    
   
    [self.view addSubview:imageScrollView];
   
    ImagePostQuestion=[[UIImageView alloc]init];
    ImagePostQuestion.frame=CGRectMake(0, 0, 320, self.view.frame.size.height-44);
    [imageScrollView addSubview:ImagePostQuestion];
    if (_postImage)
    {
        ImagePostQuestion.image=_postImage;
    }
    
    UITapGestureRecognizer *imageGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignImageView)];
    imageGesture.numberOfTapsRequired=1;
    [imageScrollView addGestureRecognizer:imageGesture];
    
    
    
    UIPinchGestureRecognizer *pinchGesture=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchImageGesture:)];
    [pinchGesture setDelegate:self];
    [imageScrollView addGestureRecognizer:pinchGesture];
    
    
    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
    [rotationRecognizer setDelegate:self];
    [imageScrollView addGestureRecognizer:rotationRecognizer];
    

    
    
    
    
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:categoryTableView] || [touch.view isDescendantOfView:subjectTableView])
    {
        
        // Don't let selections of auto-complete entries fire the
        // gesture recognizer
        return NO;
    }
    
    
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





//lastRotation is a cgfloat member variable

-(void)rotate:(id)sender
{
    CGFloat lastRotation;
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded)
    {
     lastRotation = 0.0;
        return;
    }
    
    CGFloat rotation = 0.0 - (lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
    
    CGAffineTransform currentTransform = ImagePostQuestion.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    
    [ImagePostQuestion setTransform:newTransform];
    
    lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
}

-(void) resignImageView
{
    [imageScrollView removeFromSuperview];
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return ImagePostQuestion;
}

-(void) pinchImageGesture:(UIPinchGestureRecognizer*)recognizer
{
    UIGestureRecognizerState state = [recognizer state];
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGFloat scale = [recognizer scale];
        [recognizer.view setTransform:CGAffineTransformScale(recognizer.view.transform, scale, scale)];
        [recognizer setScale:1.0];
    }
}




-(void) backImageView
{
    [imageView removeFromSuperview];
    [backImageBtn removeFromSuperview];
}
-(void)openCamera :(UIButton *)sender
{
    [backgroundScrollView setContentOffset:CGPointMake(0, 0)];
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"Action Sheet" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Open Camera" otherButtonTitles:@"Saved Photos",@"Draw Sketch" ,nil];
    //[actionSheet showInView:self.view];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
   
}






-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        
       // [self startCameraControllerFromViewController:self usingDelegate:self];
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeCamera])
        {
           // [self startCameraControllerFromViewController:self usingDelegate:self];
            UIImagePickerController *imagePicker =
            [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType =
            UIImagePickerControllerSourceTypeCamera;
            imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
            imagePicker.allowsEditing = NO;
            [self presentViewController:imagePicker
                               animated:YES completion:nil];
            [[AppDelegate sharedDelegate]setPostedImage:nil];
            
            
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
            
            [[AppDelegate sharedDelegate]setPostedImage:nil];
            
        }
    }
    
    else if (buttonIndex==2)
    {
        ACEViewController *sketchView=[[ACEViewController alloc]initWithNibName:@"ACEViewController" bundle:nil];
        sketchView.postImageValue=1;
        [self.navigationController pushViewController:sketchView animated:NO];
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
  /*  convertedImage=[info valueForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:NO completion:nil];
    
if (convertedImage)
    {
        postQuestionImage.image=convertedImage;
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]init];
        tapGesture.numberOfTapsRequired=1;
        [tapGesture addTarget:self action:@selector(popImageView)];
        [postQuestionImage addGestureRecognizer:tapGesture];
        postQuestionImage.userInteractionEnabled=YES;
    }
    
    */
    
  convertedImage=[info valueForKey:UIImagePickerControllerOriginalImage];
    

     
     [picker dismissViewControllerAnimated:NO completion:nil];
       action=@"insertimageuser";
    [self showActivity];

  
  
}









-(void)postQuestionButtonClick
{
   
    [questiontextView resignFirstResponder];
    [ImagePostQuestion removeFromSuperview];
    [ImagePostQuestion setImage:[UIImage imageNamed:@""]];
    action=@"createquestion";
    [self showActivity];
  
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
-(void) activityDidAppear
{
    if([action isEqualToString:@"createquestion"])
       {
    //begin
    //multipleCategoriesStr=[[NSMutableString alloc]init];
    
   /* for (int i=0; i<selectedBtnArray.count; i++)
    {
        NSInteger k=[[selectedBtnArray objectAtIndex:i]integerValue];
        NSString *categoryid=[[categoryofuserArray objectAtIndex:k] valueForKey:@"id"];
        [multipleCategoriesStr appendString: categoryid ];
        [multipleCategoriesStr appendString:@","];

    }*/
    if (![multipleCategoriesStr isEqualToString:@""])
    {
      [multipleCategoriesStr deleteCharactersInRange:NSMakeRange(multipleCategoriesStr.length-1, 1)];
    }
           
           
    
           
    [questiontextView resignFirstResponder];
    [backgroundScrollView setContentOffset:CGPointMake(0, 0)];
    [ImagePostQuestion removeFromSuperview];
    
    
    
    if (convertedImage)
    {
        convertedImage=[self fixrotation:convertedImage];
        
        convertedImage=[self resizeimage:convertedImage];
        
     
        convertedImage = [UIImage imageWithData:UIImageJPEGRepresentation(convertedImage, 0)];
        
        imageString=[self encodeToBase64String:convertedImage];
    }
    
    
    
    
    if ([self validationCheck])
    {
        [self postWebservice];
       
    }
    else
    {
        
//        NSString *errorMessage=@"Please Fill all Values";
//        UIAlertView *attenstionAlertView=[[UIAlertView alloc]initWithTitle:@"" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [attenstionAlertView show];
    }
   }
    else if(([action isEqualToString:@"deletecategory"]))
    {
       

        
        
            if(selectedBtnArray.count<=0 || selectedBtnArray.count>=2)
            {
                successAlert=[[UIAlertView alloc]initWithTitle:@"" message:@"please choose at least one category" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [successAlert show];
                [self hideActivity];
                return;
            }
        
            NSInteger k=[[selectedBtnArray objectAtIndex:0]integerValue];
        
        deleteCategoryAlert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Do you want to delete this category?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
       [deleteCategoryAlert show];
        
            //[self hideActivity];
        
    }

    else if(([action isEqualToString:@"insertimageuser"]))
    {
        if(imagelinksArray.count >=5)
        {
            successAlert=[[UIAlertView alloc]initWithTitle:@"" message:@"You can't upload more images beacause maximun images of question is 5" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [successAlert show];
            return;
        }
        if (convertedImage)
        {
            convertedImage=[self fixrotation:convertedImage];
            
            convertedImage=[self resizeimage:convertedImage];
            
            
            convertedImage = [UIImage imageWithData:UIImageJPEGRepresentation(convertedImage, 0)];
            
            imageString=[self encodeToBase64String:convertedImage];
            
            [self  postImageUser:@"" action:@"" attachment:imageString guid:guidImage imagequestionId:@""];
            
        }
       
        
       
        
    }
    else if(([action isEqualToString:@"deleteimage"]))
    {
        NSString *imagequestionId=[imageidArray objectAtIndex:indeximage];
        [self  postImageUser:@"" action:@"delete" attachment:@"" guid:guidImage imagequestionId:imagequestionId];
        
    }


    
  else
  {
      if ([self CreateCategoryvalidationCheck])
      {
      
          NSMutableString *mutableStringfriends = [createcategoryfriendidsString mutableCopy];
          
          
          if (![mutableStringfriends isEqualToString:@""])
          {
              [mutableStringfriends deleteCharactersInRange:NSMakeRange(mutableStringfriends.length-1, 1)];
          }
          createcategoryfriendidsString=[NSString stringWithString:mutableStringfriends];
          
          NSString *hashtag=createcategorieshastagsTextField.text;
          hashtag=[hashtag stringByReplacingOccurrencesOfString:@"#"
                                                     withString:@""];

          
          NSString *userid= [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
          NSArray *mainArray=[[WebServiceSingleton sharedMySingleton]UpdateCategory: createcategoriesnameTextField.text userId:userid hastags:hashtag tabfriends:createcategoryfriendidsString catId:@"" action:@"create"];
          
          if ([[mainArray valueForKey:@"status"] isEqualToString:@"1"])
          {
              
              successAlert=[[UIAlertView alloc]initWithTitle:@"" message:@"Create Category Successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
              [successAlert show];
               [backBtn setHidden:YES];
              [createcategorySubview removeFromSuperview];
              [categorySubview removeFromSuperview];
              [self questionValue];
              [self categorySubview];
              
          }
          else
          {
              
              NSString *message=[mainArray valueForKey:@"message"];
              successAlert=[[UIAlertView alloc]initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
              [successAlert show];

          }
          
          //[self hideActivity];
      }
  }
       //end
    
    [self hideActivity];
}

-(void) postWebservice
{
    // return strDateTime;
    
    NSDateComponents *comps = [[NSCalendar currentCalendar]
                               components:NSDayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit
                               fromDate:[NSDate date]];
    [comps setHour:0];
    [comps setMinute:0];
    //[comps setSecond:[[NSTimeZone systemTimeZone] secondsFromGMT]];
    //[comps setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
     [comps setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
   
  int timestamp= [[[NSCalendar currentCalendar] dateFromComponents:comps] timeIntervalSince1970];
    
    
/*if(![self.questionId isEqualToString:@""])
{
    multipleCategoriesStr=[[NSMutableString alloc]init];
    
    [multipleCategoriesStr appendString:[[questionInfo valueForKey:@"categoryId"]objectAtIndex:0]];



}*/
    NSString *hashtag=hastagsTextField.text;
    hashtag=[hashtag stringByReplacingOccurrencesOfString:@"#"
                                               withString:@""];
   // NSString *timestamp= [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
    NSMutableString *questionText=[NSMutableString stringWithFormat:@"%@",questiontextView.text];
    [questionText replaceOccurrencesOfString:@"+" withString:@"%2b" options:NO range:NSMakeRange(0, questionText.length-1)];
    
     NSArray *questionArray=nil;
        questionArray=[[NSArray alloc]initWithObjects:questionText,multipleCategoriesStr,@"0",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"],@""/*[NSString stringWithFormat:@"%d",timestamp]*/,imageString,self.questionId,@"",hashtag,nil];
    //
    NSMutableString *mutableStringfriends = [friendIdsString mutableCopy];

    
    if (![mutableStringfriends isEqualToString:@""])
    {
        [mutableStringfriends deleteCharactersInRange:NSMakeRange(mutableStringfriends.length-1, 1)];
    }
    friendIdsString=[NSString stringWithString:mutableStringfriends];

//[friendIdsString del
    [WebServiceSingleton sharedMySingleton].postQuestionDelegate=self;
    NSArray *mainArray=[[WebServiceSingleton sharedMySingleton]sendQuestionService:questionArray imageBase64String:@"" tabfriendids:friendIdsString guidimage:guidImage ];
  
    
    //friendIdsString
    if ([[mainArray valueForKey:@"status"] isEqualToString:@"1"])
    {
        
        TaBBarViewController *TabBarView=[[TaBBarViewController alloc]init];
        [AppDelegate sharedDelegate].navController=[[CustomnavigationController alloc]initWithRootViewController:TabBarView];
        [AppDelegate sharedDelegate].navController.navigationBarHidden = YES;
        
       // TabBarView.questionId=@"1";
        TabBarView.notificationViewValue=0;
        // TabBarView.
        
        
        //UpdatesViewController *loginView=[[UpdatesViewController alloc]init];
        
        //self.navController=[[UINavigationController alloc]initWithRootViewController:loginView];
        // self.window.rootViewController=self.navController;
        
        
        //
        // UpdatesViewController *updatesView=[[UpdatesViewController alloc]init];
        //updatesView.friendID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDetail"][@"id"];
        //[self.window.rootViewController.navigationController pushViewController:updatesView animated:NO];
        
        
        [AppDelegate sharedDelegate].window.rootViewController=TabBarView;
        //[self successposted];
    }
    else
    {
        
        //[self failedToPost];
        [self successposted];
    }
    
    [self hideActivity];
    
}











-(BOOL)validationCheck
{
    NSLog(@"%@",questiontextView.text);
    
    int validateNumber=0;
    if (!categoriesTextField.text.length)
    {
        validateNumber++;
        UIAlertView *postQuestionAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select category" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [postQuestionAlertView show];
    }
//    else if (!tagFriendsTextField.text.length)
//    {
//        validateNumber++;
//        UIAlertView *postQuestionAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please select subject" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//        [postQuestionAlertView show];
//    
//    }
//    else if([subjectValuelabel.text isEqualToString:@""])
//    {
//        validateNumber++;
//    }
    else if([questiontextView.text isEqualToString:@"Question Text"])
    {
        validateNumber++;
        
        UIAlertView *postQuestionAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Enter Question" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [postQuestionAlertView show];
    }
    else if (!questiontextView.text.length)
    {
       validateNumber++;
        UIAlertView *postQuestionAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please Enter Question" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [postQuestionAlertView show];
    }
    
    if (validateNumber==0)
    {
        return YES;
    }
    else
    {
        return NO;
        
        }

}

-(BOOL)CreateCategoryvalidationCheck
{
    //NSLog(@"%@",questiontextView.text);
    
    int validateNumber=0;
    if (!createcategoriesnameTextField.text.length)
    {
        validateNumber++;
        UIAlertView *postQuestionAlertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter category name" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [postQuestionAlertView show];
    }
    
    if (validateNumber==0)
    {
        return YES;
    }
    else
    {
        return NO;
        
    }
    
}





- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        backgroundScrollView.contentOffset=CGPointMake(0,0);

        return YES;
    }
   
//    
//    int textLength=questiontextView.text.length;
//    
//  if (textLength>150)
//  {
//      backgroundScrollView.contentOffset=CGPointMake(0, 50);
//  }
//
//  NSUInteger maxNumberOfLines = 3;
//  NSUInteger numLines = textView.contentSize.height/textView.font.lineHeight;
//  if (numLines>maxNumberOfLines)
//  {
//      [backgroundScrollView setContentOffset:CGPointMake(0, numLines*10)];
//  }
   
  
    
    return YES;
    

}

- (NSString *)encodeToBase64String:(UIImage *)image
{

    return [UIImagePNGRepresentation(image) base64EncodedString];
   
   
   // return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
   // return [UIImagePNGRepresentation(image) initWithBase64EncodedData:NSDataBase64Encoding64CharacterLineLength options:NSDataBase64Encoding64CharacterLineLength];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)successposted
{
   
    
    successAlert=[[UIAlertView alloc]initWithTitle:@"" message:@"Question Successfully Posted" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [successAlert show];
    
    
    categoriesTextField.text=@"";
    tagFriendsTextField.text=@"";
    categoryValuelabel.text=@"";
    subjectValuelabel.text=@"";
    
    questiontextView.text=@"";
    categoryLabelString=@"";
    [postQuestionImage setImage:[UIImage imageNamed:@""]];
    
    convertedImage=nil;
    imageString=@"";
    //[postQuestionImage removeFromSuperview];
    [categorySelectionButton setTitle:@"Select   >" forState:UIControlStateNormal];
    [subjectSelectionButton setTitle:@"Select   >" forState:UIControlStateNormal];
    //[questiontextView.text setT @"Enter your question"]
    questiontextView.text=@"Question Text";
    questiontextView.textColor=[UIColor lightGrayColor];
    [ImagePostQuestion setImage:[UIImage imageNamed:@""]];
    [ImagePostQuestion removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
    [questiontextView resignFirstResponder];
    
    postQuestionImage.layer.borderWidth=0.0f;
    
    
    
  
    
    
    
   

}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    
    if (alertView==deleteCategoryAlert)
    {
        if(buttonIndex==1)
        {
        NSInteger k=[[selectedBtnArray objectAtIndex:0]integerValue];
        
        NSString *catId=[self GetCategoryIdByIndex:k] ;
        NSString *userid= [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
            
           // return;

        NSArray *mainArray=[[WebServiceSingleton sharedMySingleton]UpdateCategory: createcategoriesnameTextField.text userId:userid hastags:createcategorieshastagsTextField.text tabfriends:createcategoriestagFriendsTextField.text catId:catId action:@"delete"];
        
        if ([[mainArray valueForKey:@"status"] isEqualToString:@"1"])
        {
            successAlert=[[UIAlertView alloc]initWithTitle:@"" message:@"Delete Category Successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [successAlert show];
            [createcategorySubview removeFromSuperview];
            [categorySubview removeFromSuperview];
            [selectedBtnArray removeAllObjects];
            [self questionValue];
            [self categorySubview];
            
        }
        else
        {
            NSString *message=[mainArray valueForKey:@"message"];
            
            successAlert=[[UIAlertView alloc]initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [successAlert show];
            return;
            
        }
        }
    }
    
    else if(alertView==deleteImageAlert)
    {
    
        if(buttonIndex==1)
        {
            action=@"deleteimage";
            [self showActivity];
           
        
        }
    
    
    }
    
}

- (void)showFullscreenWithDelegate
{
    
//    HomeViewController *homeView=[[HomeViewController alloc]init];
//    [self.navigationController ]
   
    [[AppDelegate sharedDelegate].TabBarView selectTab:0];
    
// generalView=[[GeneralViewController alloc]init];
//    generalView.callFromView=@"PostQuestion";
//    [self.navigationController pushViewController:generalView animated:NO];
    
    
    
}




-(void)failedToPost
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"" message:@"Failed To Send Data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

-(void) showActivity
{
    activity = [ActivityView activityView];
    [activity setTitle:@"Creating..."];
    if([action isEqualToString:@"deleteimage"])
    {
        [activity setTitle:@"Deleting..."];
    
    }
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


#pragma mark - RevMobAdsDelegate methods

- (void)revmobSessionIsStarted
{
    NSLog(@"[RevMob Sample App] Session started again.");
}

- (void)revmobSessionNotStarted:(NSError *)error {
    NSLog(@"[RevMob Sample App] Session not started again: %@", error);
}

- (void)revmobAdDidReceive
{
    NSLog(@"[RevMob Sample App] Ad loaded.");
}

- (void)revmobAdDidFailWithError:(NSError *)error {
    NSLog(@"[RevMob Sample App] Ad failed: %@", error);
}

- (void)revmobAdDisplayed
{
    [self performSelector:@selector(removeAdd) withObject:nil afterDelay:10.0f ];
    NSLog(@"[RevMob Sample App] Ad displayed.");
}

- (void)revmobUserClosedTheAd {
    NSLog(@"[RevMob Sample App] User clicked in the close button.");
}

- (void)revmobUserClickedInTheAd {
    NSLog(@"[RevMob Sample App] User clicked in the Ad.");
}

- (void)installDidReceive {
    NSLog(@"[RevMob Sample App] Install did receive.");
}

- (void)installDidFail {
    NSLog(@"[RevMob Sample App] Install did fail.");
}

-(void)removeAdd
{
    //[fs hideAd];
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
