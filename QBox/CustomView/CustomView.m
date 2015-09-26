//
//  CustomView.m
//  QBox
//
//  Created by iApp on 6/18/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView

@synthesize tableView;
@synthesize notificationTableView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    self.tableView=[[UIView alloc]init];
    self.tableView.backgroundColor=[UIColor clearColor];
        
    self.notificationTableView=[[UITableView alloc]init];
    [self.tableView addSubview:notificationTableView];
    
   
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
