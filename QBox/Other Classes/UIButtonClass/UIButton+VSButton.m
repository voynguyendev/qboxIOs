//
//  UIButton+VSButton.m
//  Fixit
//
//  Created by Vakul on 14/07/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import "UIButton+VSButton.h"


@implementation UIButton (VSButton)


#pragma mark - Methods
UIColor *selectedBackgroundCol;
UIColor *selectedTextCol;
UIColor *unselectedBackgroundCol;
UIColor *unselectedTextCol;


// This method is for custom button and without any image
-(void)setSelectedBackgroundColor:(UIColor *)selectedBakcgroundColor
                        textColor:(UIColor *)selectedTextColor
     andUnselectedBackgroundColor:(UIColor *)unselectedBackgroundColor
                        textColor:(UIColor *)unselectedTextColor {
    
    selectedBackgroundCol    = selectedBakcgroundColor;
    selectedTextCol          = selectedTextColor;
    unselectedBackgroundCol  = unselectedBackgroundColor;
    unselectedTextCol        = unselectedTextColor;
    
    [self setBackgroundColor:unselectedBackgroundCol];
    [self setTitleColor:unselectedTextCol forState:UIControlStateNormal];
    
    [self addTarget:self action:@selector(touchStart:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(touchStart:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(touchEnded:) forControlEvents:UIControlEventTouchDragExit];
    [self addTarget:self action:@selector(touchEnded:) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)touchStart:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if (selectedBackgroundCol)
        [button setBackgroundColor:selectedBackgroundCol];

    if (selectedTextCol)
        [button setTitleColor:selectedTextCol forState:UIControlStateNormal];
    
}

-(void)touchEnded:(id)sender
{
    UIButton *button = (UIButton *)sender;
   
    if (unselectedBackgroundCol)
        [button setBackgroundColor:unselectedBackgroundCol];
    
    if (unselectedTextCol)
        [button setTitleColor:unselectedTextCol forState:UIControlStateNormal];
}

@end
