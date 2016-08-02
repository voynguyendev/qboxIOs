//
//  IndexBar.m
//  ShopFinder
//
//  Created by iApp1 on 09/10/14.
//  Copyright (c) 2014 iApp1. All rights reserved.
//

#import "IndexBar.h"
@interface IndexBar()
{
    NSString *selectedTitle;
    UIButton *indexBarBtn;
}
@end


@implementation IndexBar
@synthesize indexBarBtn;
@synthesize warehouseValue;





-(id)initWithFrame:(CGRect)frame target:(id)target selector:(SEL)sel alphabetArray:(NSMutableArray*)array
{
    
    self = [super init];
    if (self) {
        [self setFrame:frame];
         self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:1.0];
        int a=0;
        

        CGRect btnFrame=CGRectMake(0,5, 20, self.frame.size.height/array.count-1);
        for (int i=0; i<array.count; i++)
        {
            indexBarBtn=[[UIButton alloc]init];
            indexBarBtn.frame=btnFrame;
            indexBarBtn.tag=a;

            
            NSString *currentTitle=[array objectAtIndex:a];
            [indexBarBtn setTitle:currentTitle forState:UIControlStateNormal];
           
            
            [indexBarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            indexBarBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:10.0f];
            [indexBarBtn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:indexBarBtn];
            btnFrame.origin.y=indexBarBtn.frame.origin.y+indexBarBtn.frame.size.height+1;
            a++;
        }
        
        
     

    }
    
    return self;
}














/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
