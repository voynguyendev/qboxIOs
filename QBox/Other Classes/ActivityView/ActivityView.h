//
//  ActivityView.h
//  thatcloud
//
//  Created by IrØn∏∏anill on 27/12/13.
//  Copyright (c) 2013 Ink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol ActivityViewDelegate <NSObject>

-(void)activityDidAppear;

@end

@interface ActivityView : UIView

@property (strong, nonatomic) id<ActivityViewDelegate>delegate;

+(ActivityView *)activityView;

-(void)setTitle:(NSString *)title;
-(void)showActivityInView:(UIView *)view;
-(void)hideActivity;
-(void)showBorder;

@end
