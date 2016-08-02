//
//  CustomTableViewCell.h
//  QBox
//
//  Created by iApp1 on 09/01/15.
//  Copyright (c) 2015 iapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUserTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblworkat;
@property (strong, nonatomic) IBOutlet UITextView *tvabout;

@property (strong, nonatomic) IBOutlet UILabel *lblbth;
@property (strong, nonatomic) IBOutlet UILabel *lblcity;
@property (strong, nonatomic) IBOutlet UILabel *lblstate;

@property (strong, nonatomic) IBOutlet UILabel *lblschool;
@property (strong, nonatomic) IBOutlet UILabel *lblskill;
@property (strong, nonatomic) IBOutlet UITableView *imagesuserTableView;

@end
