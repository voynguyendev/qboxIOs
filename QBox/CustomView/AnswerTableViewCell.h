//
//  AnswerTableViewCell.h
//  QBox
//
//  Created by iApp1 on 12/01/15.
//  Copyright (c) 2015 iapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *answerLabel;

@property(strong,nonatomic) IBOutlet UIImageView *userImage;
@property(strong,nonatomic) IBOutlet UIButton *userNameBtn;
@property(strong,nonatomic) IBOutlet UILabel *dateLabel;
@property(strong,nonatomic) IBOutlet UILabel *timeLabel;
@property(strong,nonatomic) IBOutlet UIButton *acceptBtn;
@property(strong,nonatomic) IBOutlet UIButton *likeBtn;
@property(strong,nonatomic) IBOutlet UIButton *dislikeBtn;
@property(strong,nonatomic) IBOutlet UIButton *flagBtn;
@property (strong, nonatomic) IBOutlet UIButton *btEdit;
@property (strong, nonatomic) IBOutlet UIButton *btDelete;
@property (strong, nonatomic) IBOutlet UIImageView *imgowner;
@property (strong, nonatomic) IBOutlet UILabel *lblAnswerNoImages;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcquestiontextheight;


@property (weak, nonatomic) IBOutlet UIImageView *imgbordergood;
@property (weak, nonatomic) IBOutlet UIImageView *imggood;
@property (weak, nonatomic) IBOutlet UILabel *lbcountlike;
@property (weak, nonatomic) IBOutlet UIImageView *imgborderaccept;
@property (weak, nonatomic) IBOutlet UILabel *lbaccept;
@property (weak, nonatomic) IBOutlet UILabel *lbactions;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcviewquestion;

@end
