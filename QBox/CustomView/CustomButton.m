//
//  CustomButton.m
//  QBox
//
//  Created by iApp1 on 12/01/15.
//  Copyright (c) 2015 iapp. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton
@synthesize customBtn;



-(id)init
{
    self=[super init];
    if (self)
    {
        customBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        customBtn.frame=CGRectMake(100, 300, 30, 30);
        [customBtn setBackgroundColor:BUTTONCOLOR];
        customBtn.layer.cornerRadius=4.0f;
        customBtn.titleLabel.font=LABELFONT;
        customBtn.titleLabel.font=[UIFont boldSystemFontOfSize:15.0f];
        [customBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:customBtn];
    }
    return self;
}

@end
