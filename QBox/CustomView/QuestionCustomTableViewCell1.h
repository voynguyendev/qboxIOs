//
//  CustomTableViewCell.h
//  QBox
//
//  Created by iApp1 on 09/01/15.
//  Copyright (c) 2015 iapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionCustomTableViewCell1 : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbmenuaction;
@property (weak, nonatomic) IBOutlet UILabel *totalLikeLabel;

@property(strong,nonatomic) IBOutlet UIImageView *questionImageView;
//@property(strong,nonatomic) IBOutlet UILabel *questionLabel;
@property(strong,nonatomic) IBOutlet UIButton *userNameBtn;
@property(strong,nonatomic) IBOutlet UILabel *dateLabel;
@property(strong,nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UITextView *questionLabel;

@property(strong,nonatomic) IBOutlet UIImageView *dateImageView;
@property(strong,nonatomic) IBOutlet UIImageView *timeImageView;
@property(strong,nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *ReliesLabel;
//@property (weak, nonatomic) IBOutlet UILabel *questionLabelNoImage;
@property (strong, nonatomic) IBOutlet UITextView *questionLabelNoImage;
@property (strong, nonatomic) IBOutlet UIImageView *imflag;
@property (weak, nonatomic) IBOutlet UIImageView *imgComent;

@property (weak, nonatomic) IBOutlet UILabel *totalAnswersLabel;
@end
