//
//  TopicViewController.m
//  QBox
//
//  Created by iApp1 on 28/01/15.
//  Copyright (c) 2015 iapp. All rights reserved.
//

#import "PageViewContentController.h"
#import "NavigationView.h"
#import "CustomTableViewCell.h"
#import "AppDelegate.h"
#import "ProgressHUD.h"
#import "WebServiceSingleton.h"
#import "ProjectHelper.h"
#import "UIImageView+WebCache.h"
#import "UpdatesViewController.h"
#import "AddFriendViewController.h"
#import "QuestionCustomTableViewCell.h"
#import "NoImageQuestionCustomTableViewCell.h"
#import "CCHLinkTextView.h"
#import "CCHLinkTextViewDelegate.h"
#import "CCHLinkGestureRecognizer.h"



@interface PageViewContentController ()<UIScrollViewDelegate>
{
    UIScrollView *imageScrollView;
    UIView *popImageView;
    UIImageView *ImagePostQuestion;
        
    
}

@end

@implementation PageViewContentController;
@synthesize pageIndex;

- (void)viewDidLoad
{
    
    imageScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
   
    [self.view addSubview:imageScrollView];
    
    
    
    
    //************************ NEW **************************
    //specify this class as the delegate
    imageScrollView.delegate = self;
    //allow shrinking to 1/10 orginal size
    imageScrollView.minimumZoomScale = .1;
    //allow zooming to 4x
    imageScrollView.maximumZoomScale = 4;
    //set the default zoom scale to 1, no zoom
    imageScrollView.zoomScale = 1;
    
    
    
    popImageView=[[UIView alloc]init];
    popImageView.frame=CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height);
    //[self.view addSubview:popImageView];
    ImagePostQuestion=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, popImageView.frame.size.width, popImageView.frame.size.height)];
    [imageScrollView addSubview:ImagePostQuestion];
    
     imageScrollView.contentSize = popImageView.bounds.size;
    
    
    NSString* questionImageStr=self.ImageURL;
    NSString* questionthumbImageStr=self.ImagethumbURL;
    
    if ([questionImageStr rangeOfString:@"http://"].location == NSNotFound)
    {
        questionImageStr = [NSString stringWithFormat:@"http://%@", questionImageStr];
    }
    
    if ([questionthumbImageStr rangeOfString:@"http://"].location == NSNotFound)
    {
        questionthumbImageStr = [NSString stringWithFormat:@"http://%@", questionthumbImageStr];
    }
    
    NSURL *imagethumbUrl=[NSURL URLWithString:questionthumbImageStr];
    NSURL *imageUrl=[NSURL URLWithString:questionImageStr];
    UIImage *thumbImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:imagethumbUrl]];
    if (imageUrl)
    {
        [ImagePostQuestion setImageWithURL:imageUrl placeholderImage:thumbImage];
        
    }
    
   

}

-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return popImageView;
}
@end
