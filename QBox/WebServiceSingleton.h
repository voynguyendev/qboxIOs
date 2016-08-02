//
//  webServiceSingleton.h
//  QBox
//
//  Created by iapp on 22/05/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivityView.h"

@protocol loginDelegate <NSObject>


-(void)successFullyLogin :(NSArray *)array;
-(void)loginFailed;
@end


@protocol registrationDelegate <NSObject>

-(void)successFullyRegistered :(NSArray *)array;
-(void)failedToLogin;
-(void)mobilenumberExistes;
@end


@protocol HomeViewDelegate <NSObject>

-(void)successFullyUpdated :(NSArray *)array;
-(void)failedToupdate;
@end

@protocol postquestionViewDelegate <NSObject>
-(void)successposted;
-(void)failedToPost;
@end

@interface WebServiceSingleton : NSObject
{
    ActivityView *activity;
}

+(WebServiceSingleton*)sharedMySingleton;

-(NSArray*) getAllCategoriesByuserId:(NSString*)userId;
-(void)registraionWEbService :(NSArray *)array;
-(void)QBoxLoginWebService :(NSArray *)array;
-(NSArray*) getQuestionImagesByquestionId:(NSString*)questionId;
-(NSArray*)sendQuestionService :(NSArray *)array imageBase64String:(NSString *)base64string tabfriendids:(NSString *) tabfriendids guidimage:(NSString *) guidimage;
-(void)addAnswer :(NSArray *)array imageBase64String:(NSString *)base64string;
-(void) addFavorite:(NSArray*) array favouriteValue:(int)favouriteVal;

-(NSMutableArray*) fetchData:(NSString*) str;

-(void) questionRate:(NSArray*) array;

-(NSArray*) answerRate:(NSString*)answerId userId:(NSString*)userID rating:(int)rate;

-(id) usersaveImage:(NSString*)questionid action:(NSString*) action  attachment:(NSString*) attachment guid:(NSString*) guid imagequestionId:(NSString*) imagequestionId;

-(NSArray*) UpdateCategory:
(NSString*) categoryname userId:(NSString*)userId hastags:(NSString*)hastags tabfriends:(NSString*)tabfriends catId:(NSString*) catId action:(NSString*) action;

-(void)QBoxUserValueWebService:(NSString*)userID friendId:(NSString*)friendID;

-(NSArray*) sendFriendRequest:(NSString*) senderId receiverId:(NSString*) receiverId;

-(NSArray*) saveProfile:(NSArray*) array imageBase64String:(NSString *)base64string;

-(void) saveStatusText:(NSString *) statustext userId:(NSString *)userid;


-(NSArray*)flagAnswersQuestions:(NSString*)entityid entity:(NSString *)entity;

-(NSArray*)changepassword :(NSString *)email password:(NSString *)password;

-(NSMutableArray*) postData: (NSArray*) questionId userId:(NSString*)userId;

-(NSArray*) searchUser:(NSString*) str;

-(NSArray*) acceptRequest:(NSString*) receiverId senderId:(NSString*) senderId pushnotifycationid:(NSString*) pushnotifycationid;
-(NSArray*) rejectRequest:(NSString*) receiverId senderId:(NSString*) senderId pushnotifycationid:(NSString*) pushnotifycationid;

-(NSArray*) getUserInfo:(NSString*) userId;
-(NSArray*)getFriendInfo:(NSString*)userId friend:(NSString*)friendId;

-(NSMutableArray*) getAllFriendRequest:(NSString*) userId;
-(id)getPushNotificationByUserId:(NSString*)userID;

-(NSArray*) acceptAnswer:(NSString*) answerId;
-(NSArray*) unacceptAnswer:(NSString*) answerId;
-(NSArray*) getAllFriendList:(NSString*) userId;
-(NSArray*) sendMessage:(NSString*) senderId receiverId:(NSString*) receiverId message:(NSString*)message date:(NSString*)date;

-(NSArray*) receiveMessage:(NSString*) userId;
-(NSArray*) readMessage:(NSString*)messageId userId:(NSString*)userId;
-(NSArray*)sendmail_code :(NSString *)email;
-(NSArray*) receiveMessageUserIdFriendId:(NSString*) userId friendId:(NSString*) friendId;

 -(NSArray*) countAcceptedAnswer:(NSString*)userId;
-(void) saveQuestion:(NSString*)questionId userId:(NSString*)userId status:(int)status;
-(NSArray*) receiveMessagenew:(NSString*) userId;

-(id) getAllQuestions:(NSString*)userID categoriesId:(NSString*) categoriesId hashtag:(NSString*)hashtag rowget:(NSString*) rowget;

-(NSArray*) getAllSavedQuestion:(NSString*)userId;

-(id) privateFriendPost:(NSString*)userId categoriesId:(NSString*) categoriesId hashtag:(NSString*) hashtag rowget:(NSString*) rowget;


-(void) notificationList;
-(NSArray*)rejectFriendRequestSent:(NSString*)senderId receiverId:(NSString*)receiverID;
-(NSArray*) pushNotificationData:(NSString*)userId;

-(id)getFacebookLogin:(NSArray*)array;
-(id)getGmailLogin:(NSArray*)array;
-(void)resetpassword:(NSString*)email;
-(id)getUpdatesQuestion:(NSString*)friendID;

-(NSArray*)likeAndDislikeAnswers:(NSString *)answerId likeValue:(NSString*)value;
-(NSArray*)likeAndDislikeQuestions:(NSString *)questionId andDislikeValue:(NSString*)value;
-(void)flagQuestionsAndAnswers:(NSString*)answersId;

-(NSArray*)getFriendsPostsAndAnswers:(NSString*)FriendId andUserId:(NSString*)userID;
-(id)addFollowAccount:(NSString*)friendID andUserId:(NSString*)userId andStatus:(NSString*)status;
-(id)getHotTopicsQuestions :(NSString*) categoriesId hashtag:(NSString*)hashtag rowget:(NSString*) rowget;



//-(void)uploadImageViaBase64WithURL:(UIImage *)img urlString:(NSString *)urlString;
@property(nonatomic,assign)id<loginDelegate>loginDelegate;
@property(nonatomic,assign)id<registrationDelegate>registrationDelegate;
@property(nonatomic,assign)id<HomeViewDelegate>homeViewDelegate;
@property(nonatomic,assign)id<postquestionViewDelegate>postQuestionDelegate;

@end
