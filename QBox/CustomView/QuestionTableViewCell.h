//
//  QuestionTableViewCell.h
//  QBox
//
//  Created by Tony Truong on 4/3/15.
//  Copyright (c) 2015 iapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionTableViewCell : UITableViewCell

@property(strong, nonatomic) IBOutlet UIImageView *questionImageView;
@property(strong, nonatomic) IBOutlet UILabel *questionContentLabel;
@property(strong, nonatomic) IBOutlet UILabel *questionDateLabel;
@property(strong, nonatomic) IBOutlet UILabel *questionTimeLabel;
@property(strong, nonatomic) IBOutlet UILabel *answerCountLabel;
@property(strong, nonatomic) IBOutlet UILabel *replyLabel;

- (void)reloadDataWithDictionary:(NSDictionary *)dictionary;

@end
