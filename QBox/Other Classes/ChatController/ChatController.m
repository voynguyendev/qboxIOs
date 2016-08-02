//
//  ChatController.m
//  LowriDev
//
//  Created by Logan Wright on 3/17/14
//  Copyright (c) 2014 Logan Wright. All rights reserved.
//


/*
 Mozilla Public License
 Version 2.0
 */


#import "ChatController.h"
#import "MessageCell.h"
#import "MyMacros.h"
#import "AppDelegate.h"
#import "UserDetailViewController.h"
#import "NavigationView.h"
#import "HomeViewController.h"
static NSString * kMessageCellReuseIdentifier = @"MessageCell";
static int connectionStatusViewTag = 1701;
static int chatInputStartingHeight = 40;


@interface ChatController ()

{
    // Used for scroll direction
    CGFloat lastContentOffset;
    UserDetailViewController *userDetail;
}

// View Properties
@property (strong, nonatomic) TopBar * topBar;
@property (strong, nonatomic) ChatInput * chatInput;
@property (strong, nonatomic) UICollectionView * myCollectionView;

@end

@implementation ChatController
@synthesize senderId,receiverId;
@synthesize messageValue;

#pragma mark INITIALIZATION

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        // TopBar
        _topBar = [[TopBar alloc]init];
        //NSString *titleLabel=@"";
        _topBar.title = @"Chataa";
        
        _topBar.backgroundColor = [UIColor colorWithWhite:1 alpha:1.0];
  
        _topBar.delegate = self;
        
        
  
        
        // ChatInput
        _chatInput = [[ChatInput alloc]init];
        _chatInput.stopAutoClose = NO;
        _chatInput.placeholderLabel.text=@" Send A Message";
        _chatInput.delegate = self;
        _chatInput.frame=CGRectMake(0, self.view.frame.size.height-90, 320, chatInputStartingHeight);
        
        _chatInput.backgroundColor = [UIColor colorWithWhite:1 alpha:0.825f];
        
        // Set Up Flow Layout
        UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc]init];
        flow.sectionInset = UIEdgeInsetsMake(80, 0, 10, 0);
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        flow.minimumLineSpacing = 6;
        
        // Set Up CollectionView

       CGRect myFrame = (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication]statusBarOrientation])) ? CGRectMake(0, 0, ScreenHeight(), ScreenWidth() - height(_chatInput)) : CGRectMake(0, 0 , ScreenWidth(), ScreenHeight() - height(_chatInput));
     
        CGRect rect=CGRectMake(0, 0, 0, height(_chatInput));
        NSLog(@"%@",NSStringFromCGRect(rect));
        
        _myCollectionView = [[UICollectionView alloc]initWithFrame:myFrame collectionViewLayout:flow];
        //_myCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
        _myCollectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 2, 0, -2);
        _myCollectionView.allowsSelection = YES;
       // _myCollectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [_myCollectionView registerClass:[MessageCell class]
              forCellWithReuseIdentifier:kMessageCellReuseIdentifier];
        
        
        
        // Register Keyboard Notifications
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
      
    
        
    }
    return self;
}

- (void)viewDidLoad
{
    
    //[userdetail fetchData];
  //  [self fetchdata];
//    UserDetailViewController *userDetail=[[UserDetailViewController alloc]init];
//    [userDetail receiveMessage];
    
   // userDetail=[[UserDetailViewController alloc]init];
    NSLog(@"%@",_messagesArray);
    NSLog(@"%@",senderId);
    NSLog(@"%@",receiverId);
    //[self fetchdata];
    
     
   // NSManagedObject *matches;
     //[_messagesArray addObject:[matches valueForKey:@"message"]];
    
//    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyboard)];
//    tapGesture.numberOfTapsRequired=1;
//    tapGesture.enabled=YES;
  //  [self.view addGestureRecognizer:tapGesture];
    
   


    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

//-(void)resignKeyboard
//{
//    [_chatInput.textView resignFirstResponder];
//}



-(BOOL) prefersStatusBarHidden
{
    return YES;
}

-(void) fetchdata
{
    
    NSLog(@"receiverId %@",receiverId);
    NSLog(@"sender Id %@",senderId);
    
    AppDelegate *appDelegate=[AppDelegate sharedDelegate];
    
    
    NSManagedObjectContext *context =
    [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"QboxData"
                inManagedObjectContext:context];

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
   // NSLog(@"%@",request);
 
    NSPredicate *pred =
    [NSPredicate predicateWithFormat:@"(receiverId = %@)",receiverId];
//    [NSPredicate predicateWithFormat:@"(senderId=%@)",senderId];
    [request setPredicate:pred];
   //NSManagedObject *matches = nil;
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    
    if ([objects count] == 0)
    {
        //_status.text = @"No matches";
    }
    else
    {
    NSManagedObject *matches = nil;
        _messagesArray=[[NSMutableArray alloc]init];
        for (int i=0; i<[objects count]; i++)
        {
                matches = objects[i];
            
            NSMutableDictionary *message=[[NSMutableDictionary alloc]init];
            message[kMessageContent]=[matches valueForKey:@"message"];
            message[kMessageTimestamp]=[matches valueForKey:@"time"];
            message[kMessageRuntimeSentBy]=[matches valueForKey:@"status"];
            //message[kMessageRuntimeSentBy]=[matches valueForKey:@"senderId"];
            message[@"sentByUserId"]=[matches valueForKey:@"senderId"];
            
            //new data
            //message[kMessageRuntimeSentBy]=[matches valueForKey:@"receiverId"];
            //message[kMessageStatus]=[matches valueForKey:@"status"];
            
            
           
            [_messagesArray addObject:message];
        }
        
        NSLog(@"%@",_messagesArray);
      
     
       
        NSLog(@"%@",[matches valueForKey:@"receiverId"]);
       
        
        NSLog(@"%@",[matches valueForKey:@"message"]);
        NSLog(@"%@",[matches valueForKey:@"receiverId"]);
        NSLog(@"%@",[matches valueForKey:@"senderId"]);
        

        
       
        
        
        
        
 
      
    }
   
}
//


- (void) viewWillAppear:(BOOL)animated
{
    [self fetchdata];
  
    [userDetail receiveMessage];
  
    
    // Add views here, or they will create problems when launching in landscape
   
    [self.view addSubview:_myCollectionView];
    [self scrollToBottom];
    
    [self.view addSubview:_topBar];
    
    // Scroll CollectionView Before We Start
    [self.view addSubview:_chatInput];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark CLEAN UP

- (void) removeFromParentViewController
{
    
    [_chatInput removeFromSuperview];
    _chatInput = nil;
    
    [_messagesArray removeAllObjects];
    _messagesArray = nil;
    
    [_myCollectionView removeFromSuperview];
    _myCollectionView.delegate = nil;
    _myCollectionView.dataSource = nil;
    _myCollectionView = nil;
    
    _opponentImg = nil;
    
    [_topBar removeFromSuperview];
    _topBar = nil;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [super removeFromParentViewController];
}

#pragma mark ROTATION CALLS

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    // Help Animation
    [_chatInput willRotate];
}
- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [_chatInput isRotating];
    _myCollectionView.frame = (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) ? CGRectMake(0, 0, ScreenHeight(), ScreenWidth() - height(_chatInput)) : CGRectMake(0, 0, ScreenWidth(), ScreenHeight() - chatInputStartingHeight);
    [_myCollectionView reloadData];
}
- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [_chatInput didRotate];
    [self scrollToBottom];
}

#pragma mark CHAT INPUT DELEGATE

- (void) chatInputNewMessageSent:(NSString *)messageString
{
    
    NSLog(@"%@",messageString);

   
    if([messageString hasSuffix:@" "]||[messageString hasSuffix:@"\n"])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Enter some text" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
  
        
    else
    {
    //[self fetchdata];
    NSMutableDictionary * newMessageOb = [NSMutableDictionary new];
    newMessageOb[kMessageContent] = messageString;
    newMessageOb[kMessageTimestamp] = TimeStamp();
    
    if ([(NSObject *)_delegate respondsToSelector:@selector(chatController:didSendMessage:)])
    {
       
        [_delegate chatController:self didSendMessage:newMessageOb];
        [_chatInput.textView resignFirstResponder];
     
    }
    else
    {
        NSLog(@"ChatController: ** DELEGATE OR PROTOCOL METHOD NOT SET ** ");
    }
    }
    
    [self scrollToBottom];
    [_chatInput resizeView];
    
}

#pragma mark TOP BAR DELEGATE
- (void) topLeftPressed
{
    if ([(NSObject *)_delegate respondsToSelector:@selector(closeChatController:)]) {
        [_delegate closeChatController:self];
        
    }
    else {
        NSLog(@"ChatController: AutoClosing");
        
        
        
      
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[AppDelegate sharedDelegate] setHaveToStop:YES];
        }];
        //int messageValue=userDetail.messageValue;
        if (messageValue==1)
        {
            HomeViewController *homeView=[[HomeViewController alloc]init];
            [self.navigationController pushViewController:homeView animated:NO];
        }
        else
        {
        
        
        
        //[self dismissViewControllerAnimated:YES completion:nil];
        //[self.navigationController popViewControllerAnimated:YES];
       [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
       
       
        
       
    }
}

- (void) topMiddlePressed
{
    // Currently Inactive
}

- (void) topRightPressed {
    // Currently Inactive
}

#pragma mark ADD NEW MESSAGE

- (void) addNewMessage:(NSDictionary *)message
{
    
   
   
    
    if (_messagesArray == nil)
        
        _messagesArray = [NSMutableArray new];
    
    // preload message into array;
//    NSString *senderId=[_messagesArray valueForKey:@"sentByUserId"];
//    if (senderId) {
//        <#statements#>
//    }
    [_messagesArray addObject:message];
    
    // add extra cell, and load it into view;
    [_myCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:_messagesArray.count -1 inSection:0]]];
    
    // show us the message
    [self scrollToBottom];
}

#pragma mark KEYBOARD NOTIFICATIONS

- (void) keyboardWillShow:(NSNotification *)note
{
    
    if (!_chatInput.shouldIgnoreKeyboardNotifications) {
        
        NSDictionary *keyboardAnimationDetail = [note userInfo];
        UIViewAnimationCurve animationCurve = [keyboardAnimationDetail[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        CGFloat duration = [keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        
        NSValue* keyboardFrameBegin = [keyboardAnimationDetail valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
        int keyboardHeight = (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication]statusBarOrientation])) ? keyboardFrameBeginRect.size.height : keyboardFrameBeginRect.size.width;
        
        _myCollectionView.scrollEnabled = NO;
        _myCollectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        [UIView animateWithDuration:duration delay:0.0 options:(animationCurve << 16) animations:^{
            
            _myCollectionView.frame = (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication]statusBarOrientation])) ? CGRectMake(0, 0, ScreenHeight(), ScreenWidth() - chatInputStartingHeight - keyboardHeight) : CGRectMake(0, 0, ScreenWidth(), ScreenHeight() - chatInputStartingHeight - keyboardHeight);
            
        } completion:^(BOOL finished) {
            if (finished) {
                
                [self scrollToBottom];
                _myCollectionView.scrollEnabled = YES;
                _myCollectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
            }
        }];
    }
}

- (void) keyboardWillHide:(NSNotification *)note
{
    
    if (!_chatInput.shouldIgnoreKeyboardNotifications) {
        NSDictionary *keyboardAnimationDetail = [note userInfo];
        UIViewAnimationCurve animationCurve = [keyboardAnimationDetail[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        CGFloat duration = [keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        
        _myCollectionView.scrollEnabled = NO;
        _myCollectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        [UIView animateWithDuration:duration delay:0.0 options:(animationCurve << 16) animations:^{
           
            _myCollectionView.frame = (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication]statusBarOrientation])) ? CGRectMake(0, 0, ScreenHeight(), ScreenWidth() - height(_chatInput)) : CGRectMake(0, 0, ScreenWidth(), ScreenHeight() - height(_chatInput));
            
        } completion:^(BOOL finished) {
            if (finished) {
                _myCollectionView.scrollEnabled = YES;
                _myCollectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
                [self scrollToBottom];
            }
        }];
    }
}

#pragma mark CONNECTION NOTIFICATIONS

- (void) isOffline {
    if ([self.view viewWithTag:connectionStatusViewTag] == nil) {
        UILabel * offlineStatus = [[UILabel alloc]init];
        offlineStatus.frame = CGRectMake(0, 0, ScreenWidth(), 30);
        offlineStatus.backgroundColor = [UIColor colorWithRed:0.322311 green:0.347904 blue:0.424685 alpha:1];
        offlineStatus.textColor = [UIColor whiteColor];
        offlineStatus.font = [UIFont boldSystemFontOfSize:16.0];
        offlineStatus.textAlignment = NSTextAlignmentCenter;
        offlineStatus.minimumScaleFactor = .3;
       
        
        offlineStatus.text = @"You're offline! Messages may not send.";
        offlineStatus.tag = connectionStatusViewTag;
        [self.view insertSubview:offlineStatus belowSubview:_topBar];
        [UIView animateWithDuration:.25 animations:^{
            offlineStatus.center = CGPointMake(self.view.center.x, offlineStatus.center.y + _topBar.bounds.size.height);
        }];
    }
}

- (void) isOnline {
    UILabel * offlineStatus = (UILabel *)[self.view viewWithTag:connectionStatusViewTag];
    if (offlineStatus != nil) {
        [UIView animateWithDuration:.25 animations:^{
            offlineStatus.center = CGPointMake(self.view.center.x, offlineStatus.center.y - _topBar.bounds.size.height);
        } completion:^(BOOL finished) {
            if (finished) {
                [offlineStatus removeFromSuperview];
            }
        }];
    }
}

#pragma mark COLLECTION VIEW METHODS

- (void) scrollToBottom
{
    if (_messagesArray.count > 0)
    {
        static NSInteger section = 0;
        NSInteger item = [self collectionView:_myCollectionView numberOfItemsInSection:section] - 1;
        NSLog(@"%ld",(long)item);
        if (item < 0) item = 0;
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
        NSLog(@"%@",lastIndexPath);
        [_myCollectionView scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    }
}

/* Scroll To Top
- (void) scrollToTop {
    if (_myCollectionView.numberOfSections >= 1 && [_myCollectionView numberOfItemsInSection:0] >= 1) {
        NSIndexPath *firstIndex = [NSIndexPath indexPathForRow:0 inSection:0];
        [_myCollectionView scrollToItemAtIndexPath:firstIndex atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }
}
*/

/* To Monitor Scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat difference = lastContentOffset - scrollView.contentOffset.y;
    if (lastContentOffset > scrollView.contentOffset.y && difference > 10) {
        // scrolled up
    }
    else if (lastContentOffset < scrollView.contentOffset.y && scrollView.contentOffset.y > 0) {
        // scrolled down
        
    }
    lastContentOffset = scrollView.contentOffset.y;
}
*/

#pragma mark COLLECTION VIEW DELEGATE

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableDictionary * message = _messagesArray[[indexPath indexAtPosition:1]];
 
    static int offset = 20;
    
    
    if (!message[kMessageSize])
    {
        NSString * content = [message objectForKey:kMessageContent];
        
        NSMutableDictionary * attributes = [NSMutableDictionary new];
        attributes[NSFontAttributeName] = [UIFont systemFontOfSize:15.0f];
        attributes[NSStrokeColorAttributeName] = [UIColor darkTextColor];
        
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithString:content
                                                                       attributes:attributes];
        
        // Here's the maximum width we'll allow our outline to be // 260 so it's offset
        int maxTextLabelWidth = maxBubbleWidth - outlineSpace;
        
        // set max width and height
        // height is max, because I don't want to restrict it.
        // if it's over 100,000 then, you wrote a fucking book, who even does that?
        CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(maxTextLabelWidth, 100000)
                                            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                            context:nil];
        
        message[kMessageSize] = [NSValue valueWithCGSize:rect.size];
        
        return CGSizeMake(width(_myCollectionView), rect.size.height + offset);
    }
    else {
        return CGSizeMake(_myCollectionView.bounds.size.width, [message[kMessageSize] CGSizeValue].height + offset);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"%@",_messagesArray);
    
    return _messagesArray.count;
    //return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Get Cell
    
   // NSString *cellidentifier=[NSString stringWithFormat:@"cellidentifier%d",indexPath.row];
    MessageCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMessageCellReuseIdentifier
                                                                  forIndexPath:indexPath];
    
   
//    cell=nil;
//    
//    if (cell==nil)
//    {
//        cell=[[MessageCell alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
//    }

    // Set Who Sent Message
    NSMutableDictionary * message = _messagesArray[[indexPath indexAtPosition:1]];
    
    
    

   // if (!message[kMessageRuntimeSentBy])
   // {
        
        // Random just for now, set at runtime
       // int sentByNumb = arc4random() % 2;
   // int sentByNumb=[message[kMessageRuntimeSentBy] intValue];
    
    
        //message[kMessageRuntimeSentBy] = [NSNumber numberWithInt:(sentByNumb == 0) ? kSentByOpponent : kSentByUser];
        
        /* EXAMPLE IMPLEMENTATION
         // See if the sentBy associated with the message matches our currentUserId
         if ([_currentUserId isEqualToString:message[@"sentByUserId"]]) {
            message[kMessageRuntimeSentBy] = [NSNumber numberWithInt:kSentByUser];
         }
         else {
            message[kMessageRuntimeSentBy] = [NSNumber numberWithInt:kSentByOpponent];
         }
         */
//}
    
    
    cell.count=_messagesArray.count;
    cell.message = message;
    
    // Set the cell
    cell.opponentImage = _opponentImg;
    cell.userImage=_opponentImg;
    
    
    
    if (_opponentBubbleColor) cell.opponentColor = _opponentBubbleColor;
    if (_userBubbleColor) cell.userColor = _userBubbleColor;
   

    
    return cell;
     
}

#pragma mark SETTERS | GETTERS

- (void) setMessagesArray:(NSMutableArray *)messagesArray
{
    _messagesArray = messagesArray;
    
    
    // Fix if we receive Null
    if (![_messagesArray.class isSubclassOfClass:[NSArray class]]) {
        _messagesArray = [NSMutableArray new];
    }
    
    [_myCollectionView reloadData];
}

- (void) setChatTitle:(NSString *)chatTitle{
    _topBar.title = chatTitle;
    _chatTitle = chatTitle;
}

- (void) setTintColor:(UIColor *)tintColor
{
    _chatInput.sendBtnActiveColor = tintColor;
    _topBar.tintColor = tintColor;
    _tintColor = tintColor;
}

@end
