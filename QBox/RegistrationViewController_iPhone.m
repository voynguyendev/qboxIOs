//
//  RegistrationViewController_iPhone.m
//  QBox
//
//  Created by iapp on 12/06/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

#import "RegistrationViewController_iPhone.h"
#import "WebServiceSingleton.h"
#import "NavigationView.h"
#import "TaBBarViewController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "NavigationViewClass.h"
#import "LoginViewController_iPhone.h"

@interface RegistrationViewController_iPhone ()<UITextFieldDelegate,registrationDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    UIScrollView    *backgroundScrollview;
    UITextField     *firstNameTextField;
    UITextField     *emailTextfield;
    UITextField     *passwordTextfield;
    UITextField     *confirmPasswordTextfield;
    UITextField     *mobileNumberTextField;
    UITextField     *schoolTextField;
    UITextField     *gradeTextField;
    UITextField     *cityTextField;
    UITextField     *lastNameTextField;
    
    UIButton        *professionButton;
    UIButton        *registerButton;
    UIButton        *studentButton;
    UIButton *doneButton;

    UIAlertView *registartionAlertView;
    
    NSArray *studentArray;
    UITableView *studentTable;
    NSString *studentTitle;
}
@end

@implementation RegistrationViewController_iPhone

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
    [super viewDidLoad];
    //[self createUI];
    [self registerCreateUI];
    [self createDoneButton];
    
    studentArray=[[NSArray alloc]initWithObjects:@"Student",@"Teacher" ,nil];
    // Do any additional setup after loading the view from its nib.
    
   studentTitle=@"Student";
    
    
}

-(void)registerCreateUI
{
    
    //BackgroundImageView
    UIImageView *backgroundImageView=[[UIImageView alloc]initWithFrame:self.view.frame];
    [backgroundImageView setImage:[UIImage imageNamed:@"bg"]];
    [self.view addSubview:backgroundImageView];
    
    
 
    
    //backgroundScrollview.scrollEnabled=YES;
   // backgroundScrollview.userInteractionEnabled=YES;
    //290.340
    
    //Scroll View
    
    CGFloat scrollViewFrameWidth=self.view.frame.size.width-60;
    CGFloat scrollViewFrameHeight=self.view.frame.size.height-60;
    
    backgroundScrollview=[[UIScrollView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-300)/2,30,300,360)];
    // backgroundScrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, 320, 700)];
   // backgroundScrollview.showsVerticalScrollIndicator=YES;
    backgroundScrollview.backgroundColor = [UIColor clearColor];
//    backgroundScrollview.layer.borderColor=[UIColor whiteColor].CGColor;
//    backgroundScrollview.layer.borderWidth=2.0f;
//    backgroundScrollview.layer.cornerRadius=4.0f;
    ///backgroundScrollview.contentSize=CGSizeMake(320, self.view.frame.size.height+30);
    [self.view addSubview:backgroundScrollview];
    
    UIImageView *scrollBackgroundImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, backgroundScrollview.frame.size.width, backgroundScrollview.frame.size.height)];
    [scrollBackgroundImageView setImage:[UIImage imageNamed:@"create_free_box"]];
    [backgroundScrollview addSubview:scrollBackgroundImageView];
    
    
    
    
    
    //Navigation View
//    NavigationViewClass *navView = [[NavigationViewClass alloc]initWithFrame:CGRectMake(0, 0, backgroundScrollview.frame.size.width, 44)];
//    navView.titleView.text = @"Create your Free Account";
//    [backgroundScrollview addSubview:navView.navigationView];

    
    
    CGFloat textFieldWidth=backgroundScrollview.frame.size.width-40;
    CGFloat textFieldHeight=30;
    //First Name
    firstNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20,70,textFieldWidth,textFieldHeight)];
    firstNameTextField.borderStyle=UITextBorderStyleRoundedRect;
    firstNameTextField.tag=1;
    firstNameTextField.font = TEXTFIELDFONT;
    firstNameTextField.font=[UIFont italicSystemFontOfSize:15.0f];
    firstNameTextField.placeholder=@"Enter your first name...";
    firstNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    firstNameTextField.keyboardType = UIKeyboardTypeDefault;
    firstNameTextField.returnKeyType = UIReturnKeyDone;
    firstNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    firstNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //firstNameTextField.layer.borderWidth=0.1;
    firstNameTextField.delegate = self;
    [backgroundScrollview addSubview:firstNameTextField];
    
    //Last Name
    lastNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, firstNameTextField.frame.origin.y+firstNameTextField.frame.size.height+10,textFieldWidth,textFieldHeight)];
    lastNameTextField.borderStyle=UITextBorderStyleRoundedRect;
    lastNameTextField.tag=2;
    lastNameTextField.font = TEXTFIELDFONT;
    lastNameTextField.font=[UIFont italicSystemFontOfSize:15.0f];
    lastNameTextField.placeholder = @"Enter your last name...";
    lastNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    lastNameTextField.keyboardType = UIKeyboardTypeEmailAddress;
    lastNameTextField.returnKeyType = UIReturnKeyDone;
    lastNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    lastNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    lastNameTextField.delegate = self;
    [backgroundScrollview addSubview:lastNameTextField];
    
    
    //Email Address
    
    emailTextfield = [[UITextField alloc] initWithFrame:CGRectMake(20, lastNameTextField.frame.origin.y+lastNameTextField.frame.size.height+10,textFieldWidth,textFieldHeight)];
    emailTextfield.borderStyle=UITextBorderStyleRoundedRect;
    emailTextfield.tag=3;
    emailTextfield.font = TEXTFIELDFONT;
    emailTextfield.font=[UIFont italicSystemFontOfSize:15.0f];
    
    emailTextfield.placeholder = @"Enter your email address...";
    emailTextfield.autocapitalizationType=UITextAutocapitalizationTypeNone;
    emailTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
    emailTextfield.keyboardType = UIKeyboardTypeEmailAddress;
    emailTextfield.returnKeyType = UIReturnKeyDone;
    emailTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    emailTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    emailTextfield.delegate = self;
    [backgroundScrollview addSubview:emailTextfield];
    
    
    //Password
    
    passwordTextfield = [[UITextField alloc] initWithFrame:CGRectMake(20, emailTextfield.frame.origin.y+emailTextfield.frame.size.height+10,textFieldWidth,textFieldHeight)];
    passwordTextfield.borderStyle=UITextBorderStyleRoundedRect;
    passwordTextfield.tag=3;
    passwordTextfield.font = TEXTFIELDFONT;
    passwordTextfield.font=[UIFont italicSystemFontOfSize:15.0f];
    passwordTextfield.placeholder = @"Choose your password...";
    passwordTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
    passwordTextfield.keyboardType = UIKeyboardTypeDefault;
    passwordTextfield.returnKeyType = UIReturnKeyDone;
    passwordTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordTextfield.delegate = self;
    passwordTextfield.secureTextEntry=YES;
    [backgroundScrollview addSubview:passwordTextfield];
    
    //Confirm Password
    confirmPasswordTextfield = [[UITextField alloc] initWithFrame:CGRectMake(20, passwordTextfield.frame.origin.y+passwordTextfield.frame.size.height+10,textFieldWidth,textFieldHeight)];
    confirmPasswordTextfield.borderStyle=UITextBorderStyleRoundedRect;
    confirmPasswordTextfield.tag=4;
    confirmPasswordTextfield.font = TEXTFIELDFONT;
    confirmPasswordTextfield.font=[UIFont italicSystemFontOfSize:15.0f];
    
    confirmPasswordTextfield.placeholder = @"Confirm your password...";
    confirmPasswordTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
    confirmPasswordTextfield.keyboardType = UIKeyboardTypeDefault;
    confirmPasswordTextfield.returnKeyType = UIReturnKeyDone;
    confirmPasswordTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    confirmPasswordTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    confirmPasswordTextfield.delegate = self;
    confirmPasswordTextfield.secureTextEntry=YES;
    [backgroundScrollview addSubview:confirmPasswordTextfield];
    
    //Mobile Number
    mobileNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(20,  confirmPasswordTextfield.frame.origin.y+confirmPasswordTextfield.frame.size.height+10, textFieldWidth, textFieldHeight)];
    mobileNumberTextField.tag=5;
    mobileNumberTextField.borderStyle=UITextBorderStyleRoundedRect;
    mobileNumberTextField.font = TEXTFIELDFONT;
    mobileNumberTextField.font=[UIFont italicSystemFontOfSize:15.0f];
    mobileNumberTextField.placeholder = @"Enter your mobile number...";
    mobileNumberTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    mobileNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    mobileNumberTextField.returnKeyType = UIReturnKeyDone;
    mobileNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    mobileNumberTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    mobileNumberTextField.delegate = self;
    mobileNumberTextField.layer.borderWidth=0;
    //[backgroundScrollview addSubview:mobileNumberTextField];
    
    
    
    
    //Create Account Button
    
    CGFloat createBtnFrameWidth=backgroundScrollview.frame.size.width-100;
    registerButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
    registerButton.frame = CGRectMake((backgroundScrollview.frame.size.width-createBtnFrameWidth)/2,confirmPasswordTextfield.frame.origin.y+ confirmPasswordTextfield.frame.size.height+20,createBtnFrameWidth,30);
    [registerButton addTarget:self action:@selector(registrionCheck) forControlEvents:UIControlEventTouchUpInside];
    [registerButton setBackgroundColor:[UIColor colorWithRed:228.0f/255.0 green:0.0/255.0f blue:49.0f/255.0f alpha:1.0]];
    registerButton.layer.cornerRadius=5.0f;
    registerButton.titleLabel.font=LABELFONT;
    registerButton.titleLabel.font=[UIFont boldSystemFontOfSize:15.0f];
    [registerButton setTitle:@"Create a FREE Account" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backgroundScrollview addSubview:registerButton];
    
    
    
    //How It Works
    CGFloat settingsBtnFrameWidth=backgroundScrollview.frame.size.width-120;
    UIButton *settingsBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    settingsBtn.frame = CGRectMake((backgroundScrollview.frame.size.width-settingsBtnFrameWidth)/2,registerButton.frame.origin.y+ registerButton.frame.size.height+5,settingsBtnFrameWidth,30);
    [settingsBtn setImage:[UIImage imageNamed:@"how_works_button"] forState:UIControlStateNormal];
    [backgroundScrollview addSubview:settingsBtn];
    
    
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.navigationController popViewControllerAnimated:NO];
}
//-(void)createUI
//{
//
//    
//    NavigationView *nav = [[NavigationView alloc] init];
//    nav.titleView.text = @"Create your Free Account";
//    [self.view addSubview:nav.navigationView];
//    
//    backgroundScrollview.scrollEnabled=YES;
//    backgroundScrollview.userInteractionEnabled=YES;
//    
//    UIButton *titleBckBtn=[[UIButton alloc]init];
//    titleBckBtn.frame=CGRectMake(0, 10, 45, 30);
//    [titleBckBtn setImage:[UIImage imageNamed:@"back_blue"] forState:UIControlStateNormal];
//    [titleBckBtn addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:titleBckBtn];
//    
//    
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor whiteColor],[UIFont systemFontOfSize:24.0f], nil] forKeys:[NSArray arrayWithObjects:UITextAttributeTextColor,UITextAttributeFont, nil]]];
//    
//    backgroundScrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-20)];
//   // backgroundScrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, 320, 700)];
//    backgroundScrollview.showsVerticalScrollIndicator=YES;
//   
//    backgroundScrollview.backgroundColor = [UIColor clearColor];
//    backgroundScrollview.contentSize=CGSizeMake(320, self.view.frame.size.height+30);
//    [self.view addSubview:backgroundScrollview];
//    
//    
//    
//    
//    firstNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 20, 280, 40)];
//    //nameTextField.borderStyle = UITextBorderStyleLine;
//   // nameTextField.borderStyle=UITextBorderStyleRoundedRect;
//    
//    firstNameTextField.tag=1;
//    firstNameTextField.font = [UIFont systemFontOfSize:15];
//    firstNameTextField.placeholder=@"Name";
//    
//  
//    firstNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
//    firstNameTextField.keyboardType = UIKeyboardTypeDefault;
//    firstNameTextField.returnKeyType = UIReturnKeyDone;
//    firstNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    firstNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    firstNameTextField.layer.borderWidth=0.1;
//    
//    firstNameTextField.delegate = self;
//    
//    UIImageView *nameImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, firstNameTextField.frame.origin.y+10, 20, 20)];
//    nameImg.image=[UIImage imageNamed:@"name_icon1"];
//    [backgroundScrollview addSubview:nameImg];
//    //nameTextField.leftView=nameImg;
//    //nameTextField.leftViewMode=UITextFieldViewModeAlways;
//    
//    [backgroundScrollview addSubview:firstNameTextField];
//    
//    
//    
//    UIImageView *nameLineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, firstNameTextField.frame.origin.y+firstNameTextField.frame.size.height, firstNameTextField.frame.size.width-10, 1)];
//    nameLineImageView.backgroundColor=[UIColor lightGrayColor];
//    [backgroundScrollview addSubview:nameLineImageView];
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    emailTextfield = [[UITextField alloc] initWithFrame:CGRectMake(30, firstNameTextField.frame.origin.y+firstNameTextField.frame.size.height+20, 280, 40)];
//   // emailTextfield.borderStyle=UITextBorderStyleRoundedRect;
//   
//    emailTextfield.tag=2;
//    emailTextfield.font = [UIFont systemFontOfSize:15];
//    emailTextfield.placeholder = @"Email";
//    emailTextfield.autocapitalizationType=UITextAutocapitalizationTypeNone;
//    emailTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
//    emailTextfield.keyboardType = UIKeyboardTypeEmailAddress;
//    emailTextfield.returnKeyType = UIReturnKeyDone;
//    emailTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
//    emailTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    emailTextfield.delegate = self;
//    
//    UIImageView *emailImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, emailTextfield.frame.origin.y+10, 20, 20)];
//    emailImg.image=[UIImage imageNamed:@"email_icon"];
////    emailTextfield.leftView=emailImg;
////    emailTextfield.leftViewMode=UITextFieldViewModeAlways;
//    [backgroundScrollview addSubview:emailImg];
//    
//    [backgroundScrollview addSubview:emailTextfield];
//    
//    
//    
//    UIImageView *emailLineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, emailTextfield.frame.origin.y+emailTextfield.frame.size.height, emailTextfield.frame.size.width-10, 1)];
//    emailLineImageView.backgroundColor=[UIColor lightGrayColor];
//    [backgroundScrollview addSubview:emailLineImageView];
//
//    
//    
//    
//    
//    
//    passwordTextfield = [[UITextField alloc] initWithFrame:CGRectMake(30, emailTextfield.frame.origin.y+emailTextfield.frame.size.height+20, 280, 40)];
//   // passwordTextfield.borderStyle=UITextBorderStyleRoundedRect;
//    passwordTextfield.tag=3;
//    passwordTextfield.font = [UIFont systemFontOfSize:15];
//    passwordTextfield.placeholder = @"Password(min 6 characters)";
//    passwordTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
//    passwordTextfield.keyboardType = UIKeyboardTypeDefault;
//    passwordTextfield.returnKeyType = UIReturnKeyDone;
//    passwordTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
//    passwordTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    passwordTextfield.delegate = self;
//    passwordTextfield.secureTextEntry=YES;
//    
//    UIImageView *passwordImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, passwordTextfield.frame.origin.y+10, 20, 20)];
//    passwordImg.image=[UIImage imageNamed:@"password_icon"];
//    [backgroundScrollview addSubview:passwordImg];
//    [backgroundScrollview addSubview:passwordImg];
//    
//    [backgroundScrollview addSubview:passwordTextfield];
//    
//    
//    
//    UIImageView *passwordLineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, passwordTextfield.frame.origin.y+passwordTextfield.frame.size.height, passwordTextfield.frame.size.width-10, 1)];
//    passwordLineImageView.backgroundColor=[UIColor lightGrayColor];
//    [backgroundScrollview addSubview:passwordLineImageView];
//    
//    
//    
//    
//    
//    confirmPasswordTextfield = [[UITextField alloc] initWithFrame:CGRectMake(30, passwordTextfield.frame.origin.y+passwordTextfield.frame.size.height+20, 280, 40)];
//    //confirmPasswordTextfield.borderStyle=UITextBorderStyleRoundedRect;
//      confirmPasswordTextfield.tag=4;
//    confirmPasswordTextfield.font = [UIFont systemFontOfSize:15];
//    confirmPasswordTextfield.placeholder = @"Confirm Password";
//    confirmPasswordTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
//    confirmPasswordTextfield.keyboardType = UIKeyboardTypeDefault;
//    confirmPasswordTextfield.returnKeyType = UIReturnKeyDone;
//    confirmPasswordTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
//    confirmPasswordTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    confirmPasswordTextfield.delegate = self;
//    confirmPasswordTextfield.secureTextEntry=YES;
//    
//    UIImageView *confirmPasswordImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, confirmPasswordTextfield.frame.origin.y+10, 20, 20)];
//    confirmPasswordImg.image=[UIImage imageNamed:@"password_icon"];
//    [backgroundScrollview addSubview:confirmPasswordImg];
//    
//    [backgroundScrollview addSubview:confirmPasswordTextfield];
//    
//    
//    UIImageView *confirmPasswordLineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, confirmPasswordTextfield.frame.origin.y+confirmPasswordTextfield.frame.size.height, confirmPasswordTextfield.frame.size.width-10, 1)];
//    confirmPasswordLineImageView.backgroundColor=[UIColor lightGrayColor];
//    [backgroundScrollview addSubview:confirmPasswordLineImageView];
//    
//    mobileNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(30,  confirmPasswordTextfield.frame.origin.y+confirmPasswordTextfield.frame.size.height+20, 280, 40)];
//    mobileNumberTextField.tag=5;
//    //mobileNumberTextField.borderStyle=UITextBorderStyleRoundedRect;
//    mobileNumberTextField.font = [UIFont systemFontOfSize:15];
//    mobileNumberTextField.placeholder = @"Mobile Number";
//    mobileNumberTextField.autocorrectionType = UITextAutocorrectionTypeNo;
//    mobileNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
//    mobileNumberTextField.returnKeyType = UIReturnKeyDone;
//    mobileNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    mobileNumberTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    mobileNumberTextField.delegate = self;
//    mobileNumberTextField.layer.borderWidth=0;
//    
//    
//    
//    UIImageView *mobileImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, mobileNumberTextField.frame.origin.y+10, 20, 20)];
//    mobileImg.image=[UIImage imageNamed:@"mobile_icon"];
//    [backgroundScrollview addSubview:mobileImg];
//    
//    [backgroundScrollview addSubview:mobileNumberTextField];
//    
//    UIImageView *mobileLineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, mobileNumberTextField.frame.origin.y+mobileNumberTextField.frame.size.height, mobileNumberTextField.frame.size.width-10, 1)];
//    mobileLineImageView.backgroundColor=[UIColor lightGrayColor];
//    [backgroundScrollview addSubview:mobileLineImageView];
//    
//    
//    
//    studentButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//    studentButton.frame = CGRectMake(10,   mobileNumberTextField.frame.origin.y+  mobileNumberTextField.frame.size.height+20, 300, 40);
//    // [studentButton addTarget:self action:@selector(registrionCheck) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    
//    
//    [studentButton setTitle:@"Student" forState:UIControlStateNormal];
//    [studentButton setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
//    [studentButton addTarget:self action:@selector(studentAction) forControlEvents:UIControlEventTouchUpInside];
//    [studentButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [backgroundScrollview addSubview:studentButton];
//    
//    
//    
//    
//    
//    
//    registerButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
//    registerButton.frame = CGRectMake(10,   studentButton.frame.origin.y+  studentButton.frame.size.height+20, 300, 42.0);
//    [registerButton addTarget:self action:@selector(registrionCheck) forControlEvents:UIControlEventTouchUpInside];
//    [registerButton setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
//    [registerButton setTitle:@"Register" forState:UIControlStateNormal];
//    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [backgroundScrollview addSubview:registerButton];
//    
//   // backgroundScrollview.contentSize=CGSizeMake(0, mobileNumberTextField.frame.size.height+mobileNumberTextField.frame.origin.y+backgroundScrollview.frame.origin.y+50);
//    
//    
//    NSLog(@"backgroundScrollview.contentSize %@",NSStringFromCGSize(backgroundScrollview.contentSize));
//    
//    
//    
//
//}
//
-(void) studentAction
{
    [mobileNumberTextField resignFirstResponder];
   
    studentTable=[[UITableView alloc]init];
    studentTable.frame=CGRectMake(10, studentButton.frame.origin.y,studentButton.frame.size.width , 100);
    [studentTable setBackgroundColor:[UIColor lightGrayColor]];
    studentTable.dataSource=self;
    studentTable.delegate=self;
    studentTable.layer.borderColor=[UIColor blackColor].CGColor;
    studentTable.layer.cornerRadius=4.0f;
    
    
    [[studentTable layer]addAnimation:[AppDelegate popupAnimation] forKey:@"popupAnimation"];
    [backgroundScrollview addSubview:studentTable];
    
    NSLog(@"%@",studentTitle);
}

#pragma mark Table View Methods
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [studentArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text=[studentArray objectAtIndex:indexPath.row];
    cell.backgroundColor=[UIColor lightGrayColor];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    studentTitle=[studentArray objectAtIndex:indexPath.row];
    [studentButton setTitle:studentTitle forState:UIControlStateNormal];
    [studentTable removeFromSuperview];

}

-(void) backView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(BOOL) prefersStatusBarHidden
{
    return YES;
}

-(void)professionButtonClick
{
    
    [professionButton setTitle:@"School" forState:UIControlStateNormal];
    
}

-(void) createDoneButton
{
    if (doneButton == nil)
    {
        
        doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        doneButton.frame = CGRectMake(0, 163, 106, 53);
        doneButton.adjustsImageWhenHighlighted = NO;
        [doneButton setImage:[UIImage imageNamed:@"done_button"] forState:UIControlStateNormal];
        [doneButton setImage:[UIImage imageNamed:@"done_button"] forState:UIControlStateHighlighted];
        
        [doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
        
        doneButton.hidden = YES;  // we hide/unhide him from here on in with the appropriate method
    }

}
-(void) doneButton:(id) sender
{
    [mobileNumberTextField resignFirstResponder];
     [backgroundScrollview setContentOffset:CGPointMake(0, 0)];
    [self textFieldShouldReturn:mobileNumberTextField];
}


- (void)hideDoneButton
{
    [doneButton removeFromSuperview];
    doneButton.hidden = YES;
}

- (void)unhideDoneButton
{
    // this here is a check that prevents NSRangeException crashes that were happening on retina devices
    int windowCount = [[[UIApplication sharedApplication] windows] count];
    if (windowCount < 2)
    {
        return;
    }
    
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex: 1];
    UIView* keyboard;
    for(int i=0; i<[tempWindow.subviews count]; i++) {
        keyboard = [tempWindow.subviews objectAtIndex:i];
        // keyboard found, add the button
        
        // so the first time you unhide, it gets put on one subview, but in subsequent tries, it gets put on another.  this is why we have to keep adding and removing him from its superview.
        
        // THIS IS THE HACK BELOW.  I MEAN, PROPERLY HACKY!
        if([[keyboard description] hasPrefix:@"<UIPeripheralHost"] == YES)
        {
            [keyboard addSubview: doneButton];
        }
        else if([[keyboard description] hasPrefix:@"<UIKeyboardA"] == YES)
        {
            [keyboard addSubview: doneButton];
        }
        
        else if([[keyboard description] hasPrefix:@"<UIInputSetContainerView"] == YES)
        {
            //[keyboard addSubview:doneButton];
            for(int i = 0 ; i < [keyboard.subviews count] ; i++)
            {
                UIView* hostkeyboard = [keyboard.subviews objectAtIndex:i];
                if([[hostkeyboard description] hasPrefix:@"<UIInputSetHost"] == YES)
                {
                    BOOL isPortrait = UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
                    doneButton.frame = CGRectMake(((isPortrait) ? 0 : -1),((int) (hostkeyboard.frame.size.height*3)/4) + ((isPortrait) ? 0 : 1),(int) hostkeyboard.frame.size.width/3-1, (isPortrait) ? 60 : 40);
                    [hostkeyboard addSubview:doneButton];
                }
            }
        }
    }
    doneButton.hidden = NO;
}


-(void) viewWillAppear:(BOOL)animated
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [super viewWillAppear:animated];
}


-(void)keyboardDidShow:(NSNotification*) note
{
    
    if (mobileNumberTextField.isFirstResponder)
    {
        [self unhideDoneButton];  // self.numField is firstResponder and the one that caused the keyboard to pop up
    }
    else
    {
        [self hideDoneButton];
    }
    
    CGSize screenSize=[UIScreen mainScreen].bounds.size;
    if (screenSize.height<=568)
    {
      backgroundScrollview.contentSize=CGSizeMake(backgroundScrollview.frame.size.width,backgroundScrollview.frame.size.height+150);
    }
    else
    {
        
    }
    
   
   
    
    
   
}

-(void)keyboardDidHide:(NSNotification*) note
{
   
    
    CGSize screenSize=[UIScreen mainScreen].bounds.size;
    if (screenSize.height<=568)
    {
        backgroundScrollview.contentSize=CGSizeMake(backgroundScrollview.frame.size.width,backgroundScrollview.frame.size.height-150);
    }
    else
    {
        
    }
    
    // backgroundScrollview.contentSize=CGSizeMake(320, self.view.frame.size.height+30);
}








-(void)registrionCheck
{
    BOOL validationBool= [self validationCheck];
    if (validationBool==YES)
{
        [self registerAPICall];
        
}
    
    
    
}





-(void)registerAPICall
{
   // http://108.175.148.221/question_app_test/user_reg.php?name=&lname=&email=&password=&confirmpassword=&action=
//    NSArray *registraiondetailArray=[[NSArray alloc]initWithObjects:firstNameTextField.text,emailTextfield.text ,passwordTextfield.text,mobileNumberTextField.text,studentTitle,@"grade",@"city",nil];
    
    NSArray *registraiondetailArray=[[NSArray alloc]initWithObjects:firstNameTextField.text,lastNameTextField.text,emailTextfield.text ,passwordTextfield.text,nil];
    [WebServiceSingleton sharedMySingleton].registrationDelegate=self;
    [[WebServiceSingleton sharedMySingleton]registraionWEbService:registraiondetailArray];
    
    
    
}



#pragma mark TextFieldDelegates

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [studentTable removeFromSuperview];
    
    int scrollheight;
    
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    CGRect screenSize =[UIScreen mainScreen].bounds;
    
   CGSize screenSize1 = [UIScreen mainScreen].bounds.size;
   // CGFloat screenHeight = [UIScreen mainScreen].nativeBounds.size.height;
    
    if (screenSize.size.height == 568)
    {
        scrollheight=20;
    }
    else if(screenSize.size.height ==480)
    {
        scrollheight=30;
        
    }
    else
    {
        scrollheight=0;
    }
    
    
    
    [UIView animateWithDuration:0.3
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseIn
                     animations:^{
                         [backgroundScrollview setContentOffset:CGPointMake(0, textField.tag*scrollheight)];
                     }
                     completion:^(BOOL finished) {
                         
                         
                     }];

    
    if (textField==mobileNumberTextField)
    {
        [self unhideDoneButton];
    }
    
   
    
        
    
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    
    CGSize result=[[UIScreen mainScreen]bounds].size;
    //if (result.height==480)
    //{
        
        [backgroundScrollview setContentOffset:CGPointMake(0, 0)];
        
        
   //}
    
    
    
    BOOL validationBool= [self validationCheck];
    if (validationBool==YES)
    {
        
    }
    [textField resignFirstResponder];
    
    

    
    return YES;
    
}
-(BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
    [studentTable removeFromSuperview];
    if (textField==mobileNumberTextField)
    {
        [self hideDoneButton];
    }
    //[self validationCheck];
    return YES;
}



#pragma validation

-(BOOL)validationCheck

{
    NSString *errorMessage;
    int validateNumber=0;
    
    
    if (firstNameTextField.text.length==0)
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
    else if (emailTextfield.text.length==0)
    {
        validateNumber++;
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Please enter e-mail" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
    }
    else if ([self isValidEmail:emailTextfield.text]==NO)
    {
        validateNumber++;
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Please enter valid email" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
        
    }
    else if (passwordTextfield.text.length==0)
    {
        validateNumber++;
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Please choose a password" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
    }
    else if ([self isPasswordValid:passwordTextfield.text]==NO)
    {
        validateNumber++;
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Password should be 6 characters" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
        
    }
    else if (confirmPasswordTextfield.text.length==0)
    {
        validateNumber++;
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Please enter confirm password" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
    }
    else if (![passwordTextfield.text isEqualToString:confirmPasswordTextfield.text])
    {
        validateNumber++;
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Confirm Password does not match with entered password " delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
        
    }
    

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


-(BOOL)phoneANumberValidation:(NSString *)phoneNumberText
{
    NSString *mobileNumberPattern = @"[789][0-9]{9}";
    NSPredicate *mobileNumberPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileNumberPattern];
    
    BOOL matched = [mobileNumberPred evaluateWithObject:phoneNumberText];
    return matched;
    
}

- (BOOL) isPasswordValid:(NSString *)strPasswordText
{
    // too long or too short
    if ( [strPasswordText length] < 6 || [strPasswordText length] > 32 )
    {
        return NO;
    }
    
//    NSRange rang;
//    
//    // no  Uppercase letter
//    rang = [strPasswordText rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]];
//    if ( !rang.length )
//        return NO;
//    
//    // no lowercase letter
//    rang = [strPasswordText rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]];
//    if ( !rang.length )
//        return NO;
//    
//    // no letter
//    rang = [strPasswordText rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
//    if ( !rang.length )
//        return NO;
//    
//    // no number;
//    rang = [strPasswordText rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
//    if ( !rang.length )
//        return NO;
    
    return YES;
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


#pragma mark Registration Delegate Methods

-(void)successFullyRegistered :(NSArray *)array
{
    NSArray *arr=array;
    NSLog(@"%@",arr);
    
    //[[WebServiceSingleton sharedMySingleton]notificationList];
    
    registartionAlertView=[[UIAlertView alloc]initWithTitle:@"Registration" message:@"Registration Successful" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [registartionAlertView show];
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==registartionAlertView)
    {
        if (buttonIndex==0)
        {
            
            TaBBarViewController *TabVC=[[TaBBarViewController alloc]init];
            TabVC.nameValue=1;
            [self.navigationController pushViewController:TabVC animated:YES];
//            HomeViewController *homeView=[[HomeViewController alloc]init];
//            [self.navigationController pushViewController:homeView animated:NO];
            
        }
    }
   
}
-(void)failedToLogin
{
//    UIAlertView *erroralertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Enter Valid Entries" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [erroralertView show];
    
    [self resignFirstResponder];
}
-(void)mobilenumberExistes
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Mobile number already exist" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alertView show];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
