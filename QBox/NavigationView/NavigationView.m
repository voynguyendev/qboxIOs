//
//  NavigationView.m
//  QBox
//
//  Created by iapp on 02/06/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

#import "NavigationView.h"
#import "LoginViewController_iPhone.h"

@interface NavigationView ()

@end

@implementation NavigationView
@synthesize imageView,titleView,backButton;
@synthesize iconImageView;


-(id)init
{
    self = [super init];
    if (self)
    {
    
       
        self.navigationView=[[UIView alloc]init];
        self.navigationView.frame=CGRectMake(0.0, 0.0, 320.0, 44.0);
        self.navigationView.backgroundColor=[UIColor clearColor];
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.navigationView.bounds];
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
        self.imageView.image=[UIImage imageNamed:@"tabbar"];
        [self.navigationView addSubview:self.imageView];
        
        
        self.iconImageView=[[UIImageView alloc]init];
        self.iconImageView.frame=CGRectMake((self.navigationView.frame.size.width-170)/2,(self.navigationView.frame.size.height-30)/2, 30, 30);
        //[self.iconImageView setImage:[UIImage imageNamed:@"posted_question"]];
        [self.navigationView addSubview:self.iconImageView];
        
        
        CGFloat maxWidth=CGRectGetMaxY(self.navigationView.frame);
        CGFloat maxiconFrame=CGRectGetMaxX(iconImageView.frame);
        self.titleView=[[UILabel alloc]initWithFrame:self.navigationView.bounds];
        self.titleView.frame=CGRectMake(iconImageView.frame.origin.x+iconImageView.frame.size.width+10,0,self.navigationView.frame.size.width-maxiconFrame, self.navigationView.frame.size.height);
        
        
       // CGRect frame=self.navigationView.bounds;
        
        self.titleView.backgroundColor=[UIColor clearColor];
        self.titleView.textAlignment = NSTextAlignmentLeft;
        [self.titleView setFont:LABELFONT];
        [self.titleView setFont:[UIFont boldSystemFontOfSize:15.0f]];
        [self.titleView setTextColor:[UIColor whiteColor]];
        [self.navigationView addSubview:self.titleView];
        
        
        
       
        
        
//        self.backButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
//        self.backButton.backgroundColor=[UIColor clearColor];
//        [self.backButton setImage:[UIImage imageNamed:@"back_blue"] forState:UIControlStateNormal];
//       [self.navigationView addSubview:self.backButton];
        
       
        
        
        
      
}
    
    return self;
}







@end
