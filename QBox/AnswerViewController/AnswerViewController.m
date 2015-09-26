//
//  AnswerViewController.m
//  QBox
//
//  Created by iApp1 on 12/01/15.
//  Copyright (c) 2015 iapp. All rights reserved.
//

#import "AnswerViewController.h"

@interface AnswerViewController ()

@end

@implementation AnswerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
    // Do any additional setup after loading the view.
}

-(void)createUI
{
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(2, 5, self.view.frame.size.width, 2)];
    [lineView setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:lineView];
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
