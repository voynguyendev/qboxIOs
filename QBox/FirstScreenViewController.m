//
//  firstScreenViewController.m
//  QBox
//
//  Created by iapp on 22/05/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

#import "firstScreenViewController.h"
#import "NavigationView.h"
#import "LoginViewController_iPhone.h"
#import "RegistrationViewController_iPhone.h"


@interface FirstScreenViewController ()
{
    UIImageView *ImagePostQuestion;

    
}


@end

@implementation FirstScreenViewController

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
//    [self createUI];
    // Do any additional setup after loading the view.
    
    
    
    self.navigationController.navigationBarHidden=YES;
    NavigationView *nav=[[NavigationView alloc]init];
    nav.titleView.text=@"QBOX";
    [self.view addSubview:nav.navigationView];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
//    loginButton.layer.borderWidth=0.5;
//    //loginButton.frame = CGRectMake(60, 100, 200, 30.0);
//    loginButton.backgroundColor=[UIColor whiteColor];
//    loginButton.layer.cornerRadius=10.0f;
//    loginButton.layer.borderColor=[[UIColor blackColor]CGColor];

    loginButton.frame = CGRectMake((self.view.frame.size.width-150)/2,100, 150, 30.0);
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:loginButton];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
  
    registerButton.frame = CGRectMake((self.view.frame.size.width-150)/2,200, 150, 30.0);
    [registerButton setBackgroundColor:[UIColor whiteColor]];
    //registerButton.layer.cornerRadius=10.0f;
    //registerButton.layer.borderWidth=0.5;
    //registerButton.layer.borderColor=[[UIColor blackColor]CGColor];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerButton setTitle:@"Register" forState:UIControlStateNormal];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registrationClick:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:registerButton];


}


-(void)createUI
{
//    
//    NavigationView *nav = [[NavigationView alloc] init];
//    nav.titleView.text = @"Home";
//    [self.view addSubview:nav.navigationView];

   



}

-(void)loginClick:(UIButton *)sender
{


    LoginViewController_iPhone *_loginViewiPhone = [[LoginViewController_iPhone alloc] init];
    [self.navigationController pushViewController:_loginViewiPhone animated:NO];

}

-(void)registrationClick:(UIButton *)sender
{
    RegistrationViewController_iPhone *_registerViewCon=[[RegistrationViewController_iPhone alloc]init];
    [self.navigationController pushViewController:_registerViewCon animated:NO];

}

-(BOOL) prefersStatusBarHidden
{
    return NO;
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
