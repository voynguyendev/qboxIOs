//
//  ResetPassword_email.m
//  QBox
//
//  Created by admin on 7/19/15.
//  Copyright (c) 2015 iapp. All rights reserved.
//
#import "ResetPasswordController.h"
#import "ResetPasswordcodeController.h"
#import "ResetPasswordemailController.h"
#import "TaBBarViewController.h"
#import "WebServiceSingleton.h"
#import "NavigationView.h"
#import "NavigationViewClass.h"
#import "RegistrationViewController_iPhone.h"
#import "ProjectHelper.h"
#import "ProgressHUD.h"
#import <FacebookSDK/FacebookSDK.h>
#import "GTMOAuth2Authentication.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "AppDelegate.h"
//
//Latest Qbox(Jan)
#define GoogleClientID     @"694759495398-7a5g6ten3c10cau4hf5ukool6qetrl29.apps.googleusercontent.com"
#define GoogleClientSecret @"kgT8WG0WJJlQbEJjlYjuuGht"
#define GoogleAuthURL   @"https://accounts.google.com/o/oauth2/auth"
#define GoogleTokenURL  @"https://accounts.google.com/o/oauth2/token"

//#define GoogleClientID     @"776423537981.apps.googleusercontent.com"
//#define GoogleClientSecret @"v59k14jTicRLJzqCYeUZtrps"


@interface ResetPasswordcodeController ()<UITextFieldDelegate,loginDelegate,UIAlertViewDelegate>
{
    
    UIScrollView *backgroundScrollview;
    UITextField *emailTextField;
    UITextField *passwordTextField;
    UIButton *doneButton;
    UIAlertView *loginAlertView;
    GTMOAuth2Authentication * auth;
    UIAlertView *gmailLogin;
    NSString *accessToken;
    UIAlertView *resetPasswordAlertView;
    
}
@end

@implementation ResetPasswordcodeController

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
    
    
    
    self.navigationController.navigationBarHidden=YES;
    
    //    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(100, 300, 172, 33)];
    //    [imageView setImage:[UIImage imageNamed:@"loginfacebook_button"]];
    //    [self.view addSubview:imageView];
    // Do any additional setup after loading the view from its nib.
    
    // [self createUI];
    //[self createDoneButton];
    [self createLoginUI];
}





-(void) viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [super viewWillAppear:animated];
}
-(void) keyboardWillShow:(NSNotification*) note
{
    
}
-(void)keyboardDidShow:(NSNotification*) note
{
    if (emailTextField.isFirstResponder)
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
    //    [backgroundScrollview setContentSize:CGSizeMake(backgroundScrollview.frame.size.width, backgroundScrollview.frame.size.height+150)];
}
-(void)keyboardWillHide:(NSNotification*) note
{
    
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
    
}

-(void)createLoginUI
{
    UIImageView *backgroundImageView=[[UIImageView alloc]initWithFrame:self.view.frame];
    [backgroundImageView setImage:[UIImage imageNamed:@"new_bg_resetpassword.png"]];
    [self.view addSubview:backgroundImageView];
    
    backgroundScrollview.scrollEnabled=YES;
    backgroundScrollview.userInteractionEnabled=YES;
    
    
    
    //Scroll View
    
    //    CGFloat scrollViewFrameWidth=self.view.frame.size.width-40;
    //    CGFloat scrollViewFrameHeight=self.view.frame.size.height-100;
    
    backgroundScrollview=[[UIScrollView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-300)/2,70,300,320)];
    //backgroundScrollview.showsVerticalScrollIndicator=YES;
    backgroundScrollview.backgroundColor = [UIColor clearColor];
    //backgroundScrollview.contentSize=CGSizeMake(320, self.view.frame.size.height+30);
    [self.view addSubview:backgroundScrollview];
    
    
    UIImageView *scrollBackgroundImageView=[[UIImageView alloc]init];
    scrollBackgroundImageView.frame=CGRectMake(0, 0, backgroundScrollview.frame.size.width, backgroundScrollview.frame.size.height);
    //[scrollBackgroundImageView setImage:[UIImage imageNamed:@"main_box"]];
    [backgroundScrollview addSubview:scrollBackgroundImageView];
    
    
    
    
    
    CGFloat textFieldWidth=backgroundScrollview.frame.size.width-40;
    //Email Label
    UILabel *emailLabel=[[UILabel alloc]initWithFrame:CGRectMake(20,80,textFieldWidth,20)];
    emailLabel.text=[NSString stringWithFormat:@"%@ \n %@",@"we have emailed you a six-digit confirm code.",@""];
    emailLabel.textColor=[UIColor whiteColor];
    emailLabel.font=LABELFONT;
    emailLabel.font=[UIFont boldSystemFontOfSize:11.0f];
    emailLabel.lineBreakMode = NSLineBreakByWordWrapping;
   
    [backgroundScrollview addSubview:emailLabel];
    
   
    //Email Label
    UILabel *emailLabel1=[[UILabel alloc]initWithFrame:CGRectMake(emailLabel.frame.origin.x,emailLabel.frame.origin.y, textFieldWidth,40)];

    emailLabel1.text=[NSString stringWithFormat:@"%@ \n %@",@"Enter it below to continue reset your password.",@""];
    emailLabel1.textColor=[UIColor whiteColor];
    emailLabel1.font=LABELFONT;
    emailLabel1.font=[UIFont boldSystemFontOfSize:11.0f];
    emailLabel1.lineBreakMode = NSLineBreakByWordWrapping;
    
    [backgroundScrollview addSubview:emailLabel1];
   
    
    
    
    //Email TextField
    emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(emailLabel1.frame.origin.x,emailLabel1.frame.origin.y+emailLabel1.frame.size.height, textFieldWidth,40)];
    emailTextField.tag=1;
    [emailTextField setBackground:[UIImage imageNamed:@"text_field"]];
    emailTextField.font=TEXTFIELDFONT;
    emailTextField.font=[UIFont italicSystemFontOfSize:15.0f];
    emailTextField.placeholder =@" Enter your code...";
    emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    emailTextField.returnKeyType = UIReturnKeyDone;
    emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    emailTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    emailTextField.delegate = self;
    
    
    UIView *paddingView=[[UIView alloc]initWithFrame:CGRectMake(0,0,30, 20)];
    emailTextField.leftView=paddingView;
    emailTextField.leftViewMode=UITextFieldViewModeAlways;
    
    UIImageView *nameImg=[[UIImageView alloc]initWithFrame:CGRectMake(10,0, 20, 20)];
    nameImg.image=[UIImage imageNamed:@"enteremail_icon"];
    nameImg.contentMode=UIViewContentModeScaleAspectFit;
    [paddingView addSubview:nameImg];
    [backgroundScrollview addSubview:emailTextField];
    
    //Reset Password btn
    UIButton *resetPasswordBtn=[[UIButton alloc]initWithFrame:CGRectMake(emailTextField.frame.origin.x-10, emailTextField.frame.origin.y+emailTextField.frame.size.height+15, 120, 20)];
    [resetPasswordBtn setTitle:@"I didn't receive a code" forState:UIControlStateNormal];
    resetPasswordBtn.titleLabel.font=[UIFont fontWithName:@"Avenir" size:9.0f];
    resetPasswordBtn.titleLabel.font=[UIFont boldSystemFontOfSize:9.0f];
    [resetPasswordBtn addTarget:self action:@selector(resetPasswordBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundScrollview addSubview:resetPasswordBtn];
    
    
    //Continue Btn
    
    CGFloat textFieldMaxX=CGRectGetMaxX(emailTextField.frame);
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
    loginButton.frame = CGRectMake(textFieldMaxX-60, emailTextField.frame.origin.y+emailTextField.frame.size.height+10, 60,30);
    
    [loginButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setImage:[UIImage imageNamed:@"new_btcontinue.png"] forState:UIControlStateNormal];
    [backgroundScrollview addSubview:loginButton];
    
    //Cancel
    
    UIButton *loginFbBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    loginFbBtn.frame = CGRectMake(textFieldMaxX-150, emailTextField.frame.origin.y+emailTextField.frame.size.height+10, 60, 30);
    [loginFbBtn setImage:[UIImage imageNamed:@"Resetpassword_Cancel_button_new.png"] forState:UIControlStateNormal];
    [loginFbBtn addTarget:self action:@selector(loginFacebook) forControlEvents:UIControlEventTouchUpInside];
    [backgroundScrollview addSubview:loginFbBtn];
    
    
    
}





#pragma mark Action Methods

-(void)loginFacebook
{
    LoginViewController_iPhone *registerView=[[LoginViewController_iPhone alloc]init];
    [self.navigationController pushViewController:registerView animated:NO];
}

-(void)facebook
{
    
    
    ACAccountStore *accountStore = [[ACAccountStore alloc]init];
    ACAccountType *FBaccountType= [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    NSString *key = @"393657464134682";
    NSDictionary *dictFB = [NSDictionary dictionaryWithObjectsAndKeys:key,ACFacebookAppIdKey,@[@"user_about_me", @"email", @"user_birthday"],ACFacebookPermissionsKey, nil];
    
    [accountStore requestAccessToAccountsWithType:FBaccountType options:dictFB completion:
     ^(BOOL granted, NSError *e)
     {
         if (granted)
         {
             NSArray *accounts = [accountStore accountsWithAccountType:FBaccountType];
             
             
             //it will always be the last object with single sign on
             ACAccount *facebookAccount = [accounts lastObject];
             
             
             ACAccountCredential *facebookCredential = [facebookAccount credential];
             accessToken = [facebookCredential oauthToken];
             NSLog(@"Facebook Access Token: %@", accessToken);
             NSLog(@"facebook account =%@",facebookAccount);
             
             // if user is already login in facebook app.
             [self fb];
         }
         else
         {
             //Fail gracefully...
             NSLog(@"error getting permission yupeeeeeee %@",e);
             //sleep(10);
             NSLog(@"awake from sleep");
             
             // if user have no account
             [self doLoginWithFB];
             
         }
     }];
    
    
}

-(void)fb
{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/v2.0/me?fields=id,name,picture.type(large),email,location,gender,birthday,hometown,first_name,last_name&access_token=%@", accessToken]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5*60];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error)
    {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"An error occured. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    else
    {
        
        if (data)
        {
            
            // Facebook info
            
            id facebookInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"%@", facebookInfo);
            
            //[FBSession.activeSession closeAndClearTokenInformation];
            
            // [FBSession setActiveSession:nil];
            [self getFacebookLogin:facebookInfo];
        }
        
        
    }
}





-(void)doLoginWithFB
{
    
    
    // [self facebookDetails];
    
    
    // Do task asynchronously
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // Clear previously stored information... i.e. user can login with different id
        [FBSession.activeSession closeAndClearTokenInformation];
        
        [FBSession openActiveSessionWithReadPermissions:@[@"user_about_me", @"email", @"user_birthday"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error)
         {
             
             if (state == FBSessionStateOpen)
             {
                 
                 if (!error)
                 {
                     NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/v2.0/me?fields=id,name,picture.type(large),email,location,gender,birthday,hometown,first_name,last_name&access_token=%@", [FBSession activeSession].accessTokenData.accessToken]];
                     
                     NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5*60];
                     NSURLResponse *response = nil;
                     NSError *error = nil;
                     NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                     
                     if (error)
                     {
                         [[[UIAlertView alloc] initWithTitle:@"" message:@"An error occured. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                     }
                     else {
                         
                         if (data)
                         {
                             
                             // Facebook info
                             
                             id  facebookInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                             NSLog(@"%@", facebookInfo);
                             //[FBSession.activeSession closeAndClearTokenInformation];
                             [FBSession.activeSession close];
                             // [FBSession setActiveSession:nil];
                             
                             [self getFacebookLogin:facebookInfo];
                             
                             
                             
                             
                         }
                         
                     }
                 }
                 else
                 {
                     
                     NSLog(@"%@", error.localizedDescription);
                     NSLog(@"%ld", (long)error.code);
                     if (error.code == 2)
                     {
                         
                         // User cancel the facebook login
                         // [self backAction:nil];
                         [ProgressHUD dismiss];
                         
                     }
                     else
                     {
                         [[[UIAlertView alloc] initWithTitle:@"" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
                     }
                 }
                 
             }
             else
             {
                 //State ended
                 [ProgressHUD dismiss];
             }
             
             
         }];
        
    });
    
}

-(void)getFacebookLogin:(id)facebookInfo
{
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    // http://54.69.127.235/question_app/fb_user_reg.php?name=&lname=&email=&fbid=&action=1
    NSString *firstName=[facebookInfo valueForKey:@"first_name"];
    NSString *lastName=[facebookInfo valueForKey:@"last_name"];
    NSString *email=[facebookInfo valueForKey:@"email"];
    NSString *fbID=[facebookInfo valueForKey:@"id"];
    
    
    NSString *profileImage = [[[facebookInfo objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
    if ([profileImage isKindOfClass:[NSString class]] && profileImage.length > 0)
    {
        
    }
    else
    {
        profileImage = @"";
    }
    //Save Fb login id and profile image
    NSDictionary *loginDetails=@{@"profileImage":profileImage,@"loginId":@"1"};
    [[NSUserDefaults standardUserDefaults]setObject:loginDetails forKey:@"LoginDetails"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSArray *array=[[NSArray alloc]initWithObjects:firstName,lastName,email,fbID, nil];
    [WebServiceSingleton sharedMySingleton].loginDelegate=self;
    id userData=[[WebServiceSingleton sharedMySingleton]getFacebookLogin:array];
    //[self successFullyLogin:userData];
    [ProgressHUD dismiss];
    
    
    
}



- (GTMOAuth2Authentication * )authForGoogle
{
    //This URL is defined by the individual 3rd party APIs, be sure to read their documentation
    
    NSURL * tokenURL = [NSURL URLWithString:GoogleTokenURL];
    // We'll make up an arbitrary redirectURI.  The controller will watch for
    // the server to redirect the web view to this URI, but this URI will not be
    // loaded, so it need not be for any actual web page. This needs to match the URI set as the
    // redirect URI when configuring the app with Instagram.
    NSString * redirectURI = @"urn:ietf:wg:oauth:2.0:oob";
    //GTMOAuth2Authentication * auth;
    
    auth = [GTMOAuth2Authentication authenticationWithServiceProvider:@"Qbox"
                                                             tokenURL:tokenURL
                                                          redirectURI:redirectURI
                                                             clientID:GoogleClientID
                                                         clientSecret:GoogleClientSecret];
    auth.scope = @"https://www.googleapis.com/auth/userinfo.profile";
    return auth;
}


- (void)loginGmail
{
    if ([ProjectHelper internetAvailable])
    {
        [ProgressHUD show:@"Please wait..." Interaction:NO];
        [self performSelector:@selector(doLoginWithGmail) withObject:nil afterDelay:0.1];
        
    }
    else
    {
        SHOW_NO_INTERNET_ALERT(nil);
    }
    
    
}

-(void)doLoginWithGmail
{
    
    auth = [self authForGoogle];
    
    // Display the authentication view
    GTMOAuth2ViewControllerTouch * viewController = [[GTMOAuth2ViewControllerTouch alloc] initWithAuthentication:auth
                                                                                                authorizationURL:[NSURL URLWithString:GoogleAuthURL]
                                                                                                keychainItemName:@"GoogleKeychainName"
                                                                                                        delegate:self
                                                                                                finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    [self.navigationController pushViewController:viewController animated:YES];
    [ProgressHUD dismiss];
    
    
}

- (void)viewController:(GTMOAuth2ViewControllerTouch * )viewController
      finishedWithAuth:(GTMOAuth2Authentication * )auth1
                 error:(NSError * )error
{
    
    [ProgressHUD show:@"Please Wait..." Interaction:NO];
    NSLog(@"finished");
    NSLog(@"auth access token: %@", auth1.accessToken);
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"https://www.googleapis.com/oauth2/v1/userinfo?alt=json&access_token=%@",auth1.accessToken]];
    NSData *data=[NSData dataWithContentsOfURL:url];
    id gmailData=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@",gmailData);
    
    
    //
    
    NSMutableDictionary * parameters = auth1.userData;
    NSLog(@"%@",parameters);
    NSString * email = [parameters objectForKey:@"email"];
    
    [self.navigationController popToViewController:self animated:NO];
    
    if (error != nil)
    {
        gmailLogin= [[UIAlertView alloc] initWithTitle:@"Error Authorizing with Google"
                                               message:[error localizedDescription]
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
        [gmailLogin show];
    }
    else
    {
        
        
        NSData *responseData = [[error userInfo] objectForKey:@"data"]; // kGTMHTTPFetcherStatusDataKey
        if ([responseData length] > 0)
        {
            // show the body of the server's authentication failure response
            NSString *str = [[NSString alloc] initWithData:responseData
                                                  encoding:NSUTF8StringEncoding];
            NSLog(@"%@", str);
        }
        
        //        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Success Authorizing with Google"
        //                                                         message:[error localizedDescription]
        //                                                        delegate:nil
        //                                               cancelButtonTitle:@"OK"
        //                                               otherButtonTitles:nil];
        //        [alert show];
        
        
        [self getGmailLogin:gmailData];
        
        
    }
}

-(void)getGmailLogin:(id)gmailData
{
    
    // http://54.69.127.235/question_app/gmail_user_reg.php?name=&lname=&email=&gmailid=&action=1
    NSString *firstName=[gmailData valueForKey:@"given_name"];
    NSString *lastName=[gmailData valueForKey:@"family_name"];
    NSString *email=[gmailData valueForKey:@"email"];
    NSString *gmailID=[gmailData valueForKey:@"id"];
    NSString *profileImage=[gmailData valueForKey:@"picture"];
    
    //Save login id and profile image in NSUserdefault
    //Login Id 2 for gmail Login
    
    NSDictionary *loginDetails=@{@"profileImage":profileImage,@"loginId":@"2"};
    [[NSUserDefaults standardUserDefaults]setObject:loginDetails forKey:@"LoginDetails"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    NSArray *array=[[NSArray alloc]initWithObjects:firstName,lastName,email,gmailID, nil];
    [WebServiceSingleton sharedMySingleton].loginDelegate=self;
    id userData= [[WebServiceSingleton sharedMySingleton]getGmailLogin:array];
    //[self successFullyLogin:userData];
    [ProgressHUD dismiss];
    
}


-(void)resetPasswordBtn:(id)sender
{
    [ProgressHUD show:@"Please Wait" Interaction:NO];
    NSString* email=[[NSUserDefaults standardUserDefaults]valueForKey:@"email"];
    [WebServiceSingleton sharedMySingleton].loginDelegate=self;
    [[WebServiceSingleton sharedMySingleton]sendmail_code:email];
    //[self resetClick:@"rajni@gmail.com" andPassword:@"rajniarora"];
    [ProgressHUD dismiss];
}

-(void)resetClick:(NSString*)emailStr
{
    [[WebServiceSingleton sharedMySingleton]resetpassword:emailStr];
    [ProgressHUD dismiss];
}


//-(void)resetPasswordView
//{
//    UIView *resetPasswordView=[[UIView alloc]initWithFrame:CGRectMake(backgroundScrollview.frame.origin.x+10, backgroundScrollview.frame.origin.y, backgroundScrollview.frame.size.width-20, backgroundScrollview.frame.size.height)];
//    [resetPasswordView setBackgroundColor:[UIColor grayColor]];
//    [backgroundScrollview addSubview:resetPasswordView];
//
//
//    UITextField *emailtextField=[[UITextField alloc]initWithFrame:CGRectMake(10, 10, backgroundScrollview.frame.size.width-20, 30)];
//    emailtextField.placeholder=@"E-mail";
//    [resetPasswordView addSubview:emailtextField];
//
//
//    UITextField *resetPasswordTextField=[[UITextField alloc]initWithFrame:CGRectMake(10,emailtextField.frame.origin.y+emailtextField.frame.size.height+10, backgroundScrollview.frame.size.width-20, 30)];
//    resetPasswordTextField.placeholder=@"Password";
//    [resetPasswordView addSubview:resetPasswordTextField];
//
//
//    UIButton *submitBtn=[[UIButton alloc]initWithFrame:CGRectMake((resetPasswordView.frame.size.width-50)/2, resetPasswordTextField.frame.origin.y+resetPasswordTextField.frame.size.height+10, 50, 50)];
//    [submitBtn setTitle:@"Submit" forState:UIControlStateNormal];
//
//    [resetPasswordView addSubview:submitBtn];
//
//
//
//
//}



-(void)registrionCheck
{
    RegistrationViewController_iPhone *registerView=[[RegistrationViewController_iPhone alloc]init];
    [self.navigationController pushViewController:registerView animated:NO];
}

-(void) backView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(BOOL) prefersStatusBarHidden
{
    return NO;
}

-(void)loginClick
{
    [ProgressHUD show:@"Please Wait" Interaction:NO];
    
    BOOL validationBool=[self validationCheck];
    if (validationBool==YES)
    {
        
        
        NSString* code=[[[NSUserDefaults standardUserDefaults]valueForKey:@"code"] stringValue];
        NSString* newString = [emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if(![code isEqualToString:newString])
        {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"your code is incorrect" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alertView show];
        
        }
        else
        {
          
            
            //[[WebServiceSingleton sharedMySingleton]notificationList];
            ResetPasswordController *TabVC=[[ResetPasswordController alloc]init];
            [self.navigationController pushViewController:TabVC animated:NO];
        }
        
        
    }
   
    //NSDictionary *loginDetails=@{@"profileImage":@"",@"loginId":@"3"};
   // [[NSUserDefaults standardUserDefaults]setObject:loginDetails forKey:@"LoginDetails"];
   // [[NSUserDefaults standardUserDefaults]synchronize];
    [ProgressHUD dismiss];
    
    
    //    if (phoneNumberTextField.text.length&&passwordTextField.text.length)
    //    {
    //
    //
    //    }
    //    else
    //    {
    //
    //    }
    
    
    
}

-(BOOL) validationCheck
{
    
    if (![emailTextField.text isEqualToString:@""])
    {
        
        return YES;
        
    }
    else
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Please enter code" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
    }
   
    return NO;
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


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    //[backgroundScrollview setContentOffset:CGPointMake(0, 30)];
    if (textField==emailTextField)
    {
        [self unhideDoneButton];
    }
    
    
    int scrollheight;
    
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    if (screenRect.size.height == 568)
    {
        scrollheight=20;
    }
    else if(screenRect.size.height == 480)
    {
        scrollheight=30;
        
    }
    else
    {
        
    }
    [UIView animateWithDuration:0.3
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseIn
                     animations:^{
                         [backgroundScrollview setContentOffset:CGPointMake(0, textField.tag*scrollheight)];
                     }
                     completion:^(BOOL finished) {
                         
                         
                     }];
    
    
    return YES;
    
}

-(BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField==emailTextField)
    {
        [self hideDoneButton];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    
    [backgroundScrollview setContentOffset:CGPointMake(0, 0)];
    [textField resignFirstResponder];
    
    return YES;
    
}




- (void)createDoneButton
{
    // create custom button
    
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
    [emailTextField resignFirstResponder];
    
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
    if (windowCount < 2) {
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
        //This code will work on iOS 8.0
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










#pragma Delegaate Methods Login




-(void)successFullyLogin :(NSArray *)array
{
   // [ProgressHUD dismiss];
   
   
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"we sent again code to your mail,please check your mail" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alertView show];
    
    
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Login View Alert
    if (alertView==loginAlertView)
    {
        if (buttonIndex==0)
        {
            TaBBarViewController *TabVC=[[TaBBarViewController alloc]init];
            TabVC.nameValue=1;
            [self.navigationController pushViewController:TabVC animated:NO];
            
            //Care
            [AppDelegate sharedDelegate].TabBarView = TabVC;
            
            //        HomeViewController *homeView=[[HomeViewController alloc]init];
            //        [self.navigationController pushViewController:homeView animated:NO];
            
        }
        
    }
    //Gmail Login Alert
    else if(alertView==gmailLogin)
    {
        
    }
    //Reset Password Alert
    else
    {
        if (buttonIndex==1)
        {
            
            
            NSString *emailAddressStr=[[resetPasswordAlertView textFieldAtIndex:0].text stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            if (emailAddressStr.length>0)
            {
                NSString *emailStr=[resetPasswordAlertView textFieldAtIndex:0].text;
                if ([self isValidEmail:emailStr])
                {
                    if ([ProjectHelper internetAvailable])
                    {
                        [ProgressHUD show:@"Please Wait" Interaction:NO];
                        [self performSelector:@selector(resetClick:) withObject:emailStr];
                    }
                    else
                    {
                        SHOW_NO_INTERNET_ALERT(nil);
                    }
                }
                else
                {
                    [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Email not valid" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]show];
                }
            }
            else
            {
                [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter email" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]show];
            }
            
            
        }
    }
}



-(void)loginFailed
{
    
    //    UIAlertView *erroralertView=[[UIAlertView alloc]initWithTitle:@"Please" message:@"Enter Valid MobileNumber or Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [erroralertView show];
    
    [self resignFirstResponder];
    
    
}

-(void)resignallTextField
{
    
    
    [backgroundScrollview setContentOffset:CGPointMake(0, 0)];
    [emailTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    
}


-(void)createUI
{
    self.navigationController.navigationBarHidden=YES;
    NavigationView *nav = [[NavigationView alloc] init];
    nav.titleView.text = @"LOGIN";
    //    nav.titleView.textColor=[UIColor whiteColor];
    //    nav.imageView.image=[UIImage imageNamed:@""];
    
    [self.view addSubview:nav.navigationView];
    
    
    UIButton *titleBckBtn=[[UIButton alloc]init];
    titleBckBtn.frame=CGRectMake(0, 10, 45, 30);
    [titleBckBtn setImage:[UIImage imageNamed:@"back_blue"] forState:UIControlStateNormal];
    [titleBckBtn addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:titleBckBtn];
    
    
    
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor whiteColor],[UIFont systemFontOfSize:24.0f], nil] forKeys:[NSArray arrayWithObjects:UITextAttributeTextColor,UITextAttributeFont, nil]]];
    
    
    
    
    
    backgroundScrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-20)];
    backgroundScrollview.showsVerticalScrollIndicator=YES;
    backgroundScrollview.scrollEnabled=YES;
    backgroundScrollview.userInteractionEnabled=YES;
    backgroundScrollview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backgroundScrollview];
    
    
    
    
    emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 20, 280, 40)];
    
    emailTextField.font = [UIFont systemFontOfSize:15];
    emailTextField.placeholder =@"Phone Number";
    emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    emailTextField.keyboardType = UIKeyboardTypeNumberPad;
    emailTextField.returnKeyType = UIReturnKeyDone;
    emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    emailTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    emailTextField.delegate = self;
    
    UIImageView *nameImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, emailTextField.frame.origin.y+10, 20, 20)];
    nameImg.image=[UIImage imageNamed:@"mobile_icon"];
    
    [backgroundScrollview addSubview:nameImg];
    
    [backgroundScrollview addSubview:emailTextField];
    
    UIImageView *phoneNumberLineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, emailTextField.frame.origin.y+emailTextField.frame.size.height, emailTextField.frame.size.width-10, 1)];
    phoneNumberLineImageView.backgroundColor=[UIColor lightGrayColor];
    [backgroundScrollview addSubview:phoneNumberLineImageView];
    
    
    passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, emailTextField.frame.origin.y+emailTextField.frame.size.height+20, 280, 40)];
    // passwordTextField.borderStyle = UITextBorderStyleLine;
    passwordTextField.font = [UIFont systemFontOfSize:15];
    passwordTextField.placeholder = @"Password";
    passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    passwordTextField.keyboardType = UIKeyboardTypeDefault;
    passwordTextField.returnKeyType = UIReturnKeyDone;
    passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordTextField.secureTextEntry = YES;
    
    passwordTextField.delegate = self;
    [backgroundScrollview addSubview:passwordTextField];
    
    UIImageView *passwordImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, passwordTextField.frame.origin.y+10
                                                                          ,20, 20)];
    passwordImg.image=[UIImage imageNamed:@"password_icon"];
    [backgroundScrollview addSubview:passwordImg];
    
    UIImageView *passwordLineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, passwordTextField.frame.origin.y+passwordTextField.frame.size.height, passwordTextField.frame.size.width-10, 1)];
    passwordLineImageView.backgroundColor=[UIColor lightGrayColor];
    [backgroundScrollview addSubview:passwordLineImageView];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
    loginButton.frame = CGRectMake(10, passwordTextField.frame.origin.y+passwordTextField.frame.size.height+20, 275,42.0);
    [loginButton setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backgroundScrollview addSubview:loginButton];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
