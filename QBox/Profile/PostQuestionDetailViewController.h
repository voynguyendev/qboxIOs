//
//  PostquestionViewController.h
//  QBox
//
//  Created by iapp on 29/05/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "GADBannerViewDelegate.h"
@class GADBannerView, GADRequest;

@interface PostQuestionDetailViewController : UIViewController
{
    UIView *containerView;
    HPGrowingTextView *textView;
}
@property (weak, nonatomic) IBOutlet UIView *viewmenu;

@property(strong,nonatomic) NSString *ques;
@property(strong,nonatomic) NSString *ids;
@property(strong,nonatomic) NSString *userIdlogin;
//@property(nonatomic) BOOL value;
@property(strong,nonatomic) NSString *acceptQuestId;
@property(strong,nonatomic) NSMutableArray *generalQuestionArray;
@property(nonatomic) int generalViewValue;
@property(strong,nonatomic) UIImageView *nameImg;
@property(strong,nonatomic) NSString *notificationQuesId;
@property(strong,nonatomic) NSString *ViewAllTitle;

@property(strong,nonatomic) NSString *userIdGeneral;

@property(strong,nonatomic) UIImage *postImage;

@property(strong, nonatomic) GADBannerView *adBanner;
- (GADRequest *)createRequest;




//-(BOOL)validationCheck;
//-(void) createUI;

-(void)postAction:(id)sender;

@end
