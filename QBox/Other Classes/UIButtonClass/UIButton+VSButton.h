//
//  UIButton+VSButton.h
//  Fixit
//
//  Created by Vakul on 14/07/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (VSButton)

// This method is for custom button and without any image
-(void)setSelectedBackgroundColor:(UIColor *)selectedBakcgroundColor
                        textColor:(UIColor *)selectedTextColor
     andUnselectedBackgroundColor:(UIColor *)unselectedBackgroundColor
                        textColor:(UIColor *)unselectedTextColor;

@end
