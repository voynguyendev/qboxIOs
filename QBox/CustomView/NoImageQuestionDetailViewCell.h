//
//  CustomTableViewCell.h
//  QBox
//
//  Created by iApp1 on 09/01/15.
//  Copyright (c) 2015 iapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoImageQuestionDetailViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imggood;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcheightquestiontext;

@property(strong,nonatomic) IBOutlet UIImageView *questionImageView;

@property(strong,nonatomic) IBOutlet UIButton *userNameBtn;
@property(strong,nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgbordergood;
@property (weak, nonatomic) IBOutlet UIView *viewquestion;

@property (weak, nonatomic) IBOutlet UITextView *tvQuestionText;

@property (weak, nonatomic) IBOutlet UILabel *lbcountgood;

@property(strong,nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *clviewquestion;

@property (weak, nonatomic) IBOutlet UILabel *lbactions;

@property (strong, nonatomic) IBOutlet UIButton *btSave;

@property (strong, nonatomic) IBOutlet UIButton *btShare;


@property (strong, nonatomic) IBOutlet UIButton *btEdit;
@property (strong, nonatomic) IBOutlet UIButton *btDelete;
@property (strong, nonatomic) IBOutlet UIButton *btlike;
@property (strong, nonatomic) IBOutlet UIButton *btflag;

@end
