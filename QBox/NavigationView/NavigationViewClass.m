//
//  NavigationViewClass.m
//  QBox
//
//  Created by iApp1 on 06/01/15.
//  Copyright (c) 2015 iapp. All rights reserved.
//

#import "NavigationViewClass.h"

@implementation NavigationViewClass

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        
        self.navigationView=[[UIView alloc]init];
        //self.navigationView.frame=CGRectMake(0.0, 0.0, 320.0, 44.0);
        self.navigationView.frame=frame;
        self.navigationView.backgroundColor=[UIColor clearColor];
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.navigationView.bounds];
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
        self.imageView.image=[UIImage imageNamed:@"header"];
        [self.navigationView addSubview:self.imageView];
        
        
        self.titleView=[[UILabel alloc]initWithFrame:self.navigationView.bounds];
        // CGRect frame=self.navigationView.bounds;
        
        self.titleView.backgroundColor=[UIColor clearColor];
        self.titleView.textAlignment = NSTextAlignmentCenter;
        [self.titleView setFont:[UIFont fontWithName:@"Helvetica" size:17.0f]];
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
