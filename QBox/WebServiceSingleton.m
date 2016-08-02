
//
//  webServiceSingleton.m
//  QBox
//
//  Created by iapp on 22/05/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

#import "WebServiceSingleton.h"
#import "SBJson.h"
#import "ActivityView.h"
#import "AppDelegate.h"
static WebServiceSingleton* _sharedMySingleton = nil;

@implementation WebServiceSingleton
@synthesize loginDelegate,registrationDelegate,homeViewDelegate,postQuestionDelegate;
+(WebServiceSingleton*)sharedMySingleton
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


-(void)registraionWEbService :(NSArray *)array
{
    
    //http://54.69.127.235/question_app/user_reg.php";//?name=&email=&password=&confirmpassword=&mobile=&school=&grade=&city=;
    
    //http://54.69.127.235/question_app/user_reg.php?name=&lname=&email=&password=&confirmpassword=&action=
    NSString *urlString=[NSString stringWithFormat:@"%@user_reg.php?name=%@&lname=%@&email=%@&password=%@&confirmpassword=%@&action=0",webserviceBaseUrl,[array objectAtIndex:0],[array objectAtIndex:1],[array objectAtIndex:2],[array objectAtIndex:3],[array objectAtIndex:3]];
    NSLog(@"%@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLResponse *res;
    NSError *error;
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60*5];
    NSData *responseData=[NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&error];
    if (!responseData)
    {
        UIAlertView *errorAlert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Error!!!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [errorAlert show];
    }
    else
    {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NO error:nil];
       
            
       
        NSArray *mainArray=[[NSArray arrayWithObject:dic]objectAtIndex:0];
        
        
           if ([[mainArray valueForKey:@"message"]isEqualToString:@"Add successfully"])
           {
       
       
               [[NSUserDefaults standardUserDefaults]setObject:[[mainArray valueForKey:@"userdata"]valueForKey:@"id"] forKey:@"userid"];
               [[NSUserDefaults standardUserDefaults]synchronize];
               [self.registrationDelegate successFullyRegistered:[mainArray valueForKey:@"userdata"]];
       
           }
           else if([[mainArray valueForKey:@"message"]isEqualToString:@"Mobile number already exists."])
           {
               [self.registrationDelegate mobilenumberExistes];
           }
           else
           {
               
               
               [self.registrationDelegate failedToLogin];
               [[[UIAlertView alloc]initWithTitle:@"Alert!" message:[mainArray valueForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
           }
       
    }
    
  
    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//    
//    NSString *boundary = @"--6ee875e2289c91234567";
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
//    NSString *accept = @"application/json";
//    
//    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
//    [request setValue:accept forHTTPHeaderField: @"Accept"];
//    [request setHTTPMethod:@"POST"];
//    
//    NSMutableData *body = [NSMutableData data];
//    
//    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"name\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[array  objectAtIndex:0] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//
//   
//    
//    
//    
//    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"email\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[array  objectAtIndex:1] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//
//    
//    
//    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"password\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[array  objectAtIndex:2] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//
//
//    
//    
//    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"confirmpassword\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[array  objectAtIndex:2] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//
//    
//    
//    
//    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"mobile\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[array  objectAtIndex:3] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//
//    
//    
//    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"school\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[array  objectAtIndex:4] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//
//
//    
//    
//    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"grade\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[array  objectAtIndex:5] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//
//
//    
//    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"city\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[array  objectAtIndex:6] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//
//    
//    
//    
//  
//    
//    [request setHTTPBody:body];
    
//    NSURLConnection *Connection=[NSURLConnection connectionWithRequest:request delegate:self];
//    [Connection start];
//    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//    NSLog(@"returnString %@",returnString);
//    // parse the JSON string into an object - assuming json_string is a NSString of JSON data
//    NSArray *resultArray = [returnString JSONValue];
//    
//    NSLog(@"%@",[resultArray valueForKey:@"Userdata"]);
//   
//    if ([[resultArray valueForKey:@"message"]isEqualToString:@"Add successfully"])
//    {
//     
//      
//        [[NSUserDefaults standardUserDefaults]setObject:[[resultArray valueForKey:@"userdata"]valueForKey:@"id"] forKey:@"userid"];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//        [self.registrationDelegate successFullyRegistered:[resultArray valueForKey:@"userdata"]];
//       
//    }
//    else if([[resultArray valueForKey:@"message"]isEqualToString:@"Mobile number already exists."])
//    {
//        [self.registrationDelegate mobilenumberExistes];
//    }
//    else
//    {
//        [self.registrationDelegate failedToLogin];
//    }
    
    
  
    
    

}


-(void)QBoxLoginWebService :(NSArray *)array
{
    
    //user_reg.php?mobile=%@&password=%@&action=1
     NSString *urlString=[NSString stringWithFormat:@"%@user_reg.php?email=%@&password=%@&action=1",webserviceBaseUrl,[array objectAtIndex:0],[array objectAtIndex:1]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSURLConnection *Connection=[NSURLConnection connectionWithRequest:request delegate:self];
    [Connection start];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];

      NSArray *resultArray = [returnString JSONValue];
    
    if ([[resultArray valueForKey:@"status"]isEqualToString:@"1"])
    {
        [[NSUserDefaults standardUserDefaults]setObject:[[resultArray valueForKey:@"userdata"]valueForKey:@"id"] forKey:@"userid"];
        [[NSUserDefaults standardUserDefaults]setObject:[[resultArray valueForKey:@"userdata"]valueForKey:@"token"] forKey:@"token"];
        
        
        [[NSUserDefaults standardUserDefaults]setObject:[resultArray valueForKey:@"userdata"] forKey:@"userDetail"];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [self.loginDelegate successFullyLogin:[resultArray valueForKey:@"userdata"]];
    }
    else
    {
        [self.loginDelegate loginFailed];
        NSString *messageString=[resultArray valueForKey:@"message"];
        if (!messageString)
        {
         messageString=@"Insert Proper User Info";
        }
        UIAlertView *messageAlertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:messageString delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [messageAlertView show];
        
    }
    
  
    

    
    
    
//    if ([[resultArray valueForKey:@"message"] isEqualToString:@"login successful."])
//    {
//       
//        
//        
//    }
//    else
//    {
//        
//    
//    }
    
    
}



-(NSString*) BuiltUrlRequesthavetokent:(NSString*) url
{
    
    NSString *token=[[NSUserDefaults standardUserDefaults]valueForKey:@"token"];
    NSString *userIdchecktoken=[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"];
    NSString *urlString=[NSString stringWithFormat:@"%@&token=%@&userIdchecktoken=%@",url,token,userIdchecktoken];

    return urlString;
}

-(void)QBoxUserValueWebService:(NSString*)userID friendId:(NSString*)friendID
{
    //http://54.69.127.235/question_app/getUserInfoById.php?mobile=155&friend_id=84
    
//    NSString *urlString=[NSString stringWithFormat:@"%@/getUserInfoById.php?mobile=%@",webserviceBaseUrl,[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]];
  
  
    
    NSString *urlString=[NSString stringWithFormat:@"%@/getUserInfoById.php?mobile=%@&friend_id=%@",webserviceBaseUrl,userID,friendID];
    urlString=[self BuiltUrlRequesthavetokent:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSURLConnection *Connection=[NSURLConnection connectionWithRequest:request delegate:self];
    [Connection start];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
  
    NSArray *resultArray = [returnString JSONValue];
    
    if ([[resultArray valueForKey:@"status"] isEqualToString:@"1"])
    {
        [[NSUserDefaults standardUserDefaults]setObject:[[resultArray valueForKey:@"userdata"]valueForKey:@"id"] forKey:@"userid"];
        [[NSUserDefaults standardUserDefaults]setObject:[resultArray valueForKey:@"userdata"] forKey:@"userDetail"];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [[AppDelegate sharedDelegate]setUserDetail:[resultArray valueForKey:@"userdata"]];
        
        
//        NSArray *array=[[NSArray alloc]initWithObjects:[resultArray valueForKey:@"userdata"],[resultArray valueForKey:@"friendData"], nil];
        [self.homeViewDelegate successFullyUpdated:[resultArray valueForKey:@"frienddata"]];
        //[self.homeViewDelegate successFullyUpdated:[resultArray valueForKey:@"userdata"]];
        
    }
    else
    {
        [self.homeViewDelegate failedToupdate];
    }
    
    
}

-(id) usersaveImage:(NSString*)questionid action:(NSString*) action  attachment:(NSString*) attachment guid:(NSString*) guid imagequestionId:(NSString*) imagequestionId
{
   /* NSString *str=[NSString stringWithFormat:@"%@imagequestionsave.php?questionId=%@&action=%@&attachment=%@&guid=%@",webserviceBaseUrl,questionid,action,attachment,guid];
    str=[self BuiltUrlRequesthavetokent:str];
    NSString* encodedUrl = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:encodedUrl];
    return [self webserviceUrlMethod:url];*/
    NSString *urlString=[NSString stringWithFormat:@"%@imagequestionsave.php",webserviceBaseUrl];
    NSString *paramDataString = [NSString stringWithFormat:@"questionId=%@&action=%@&attachment=%@&guid=%@&imagequestionId=%@",questionid,action,attachment,guid,imagequestionId];
    
    //%@&attachment=
    NSData *requestBody = [paramDataString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[requestBody length]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60*5];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:requestBody];
    
    NSURLResponse *res;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&error];
    
    
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"response %@",response);
    NSArray *resultArray = [response JSONValue];
    
    
    
    
    
    
    if ([[resultArray valueForKey:@"status"] isEqualToString:@"1"])
    {
        //[self.postQuestionDelegate successposted];
    }
    else
    {
        
        //[self.postQuestionDelegate failedToPost];
    }
    return resultArray;

    
    
}
-(NSArray*)sendQuestionService :(NSArray *)array imageBase64String:(NSString *)base64string tabfriendids:(NSString *) tabfriendids guidimage:(NSString *) guidimage
{
    
    NSString *urlString=[NSString stringWithFormat:@"%@questions.php",webserviceBaseUrl];
    
    
    NSString *paramDataString = [NSString stringWithFormat:@"question=%@&categoryId=%@&subjectId=%@&userId=%@&date=%@&tagfriends=%@&questionId=%@&action=%@&hashtag=%@&guidimage=%@",[array objectAtIndex:0],[array objectAtIndex:1],[array objectAtIndex:2],[array objectAtIndex:3],[array objectAtIndex:4],tabfriendids,[array objectAtIndex:6],[array objectAtIndex:7],[array objectAtIndex:8],guidimage];
    
    //paramDataString=[self BuiltUrlRequesthavetokent:paramDataString];
    paramDataString=[NSString stringWithFormat:@"%@&attachment=%@",paramDataString,base64string];
    
    //%@&attachment=
    NSData *requestBody = [paramDataString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[requestBody length]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60*5];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:requestBody];
    
    NSURLResponse *res;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&error];
    
    
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"response %@",response);
    NSArray *resultArray = [response JSONValue];
    
    
    
    
    
    
    if ([[resultArray valueForKey:@"status"] isEqualToString:@"1"])
    {
        //[self.postQuestionDelegate successposted];
    }
    else
    {
        
        //[self.postQuestionDelegate failedToPost];
    }
    return resultArray;
    //
    
}

-(NSArray*)changepassword :(NSString *)email password:(NSString *)password
{
    
    NSString *urlString=[NSString stringWithFormat:@"%@change_password.php",webserviceBaseUrl];
    
    NSString *paramDataString = [NSString stringWithFormat:@"email=%@&password=%@&",email,password];
   

    
    NSData *requestBody = [paramDataString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[requestBody length]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60*5];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:requestBody];
    
    NSURLResponse *res;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&error];
    
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"response %@",response);
    NSArray *resultArray = [response JSONValue];
    
    
    
    if ([[resultArray valueForKey:@"status"]isEqualToString:@"1"])
    {
        [self.loginDelegate successFullyLogin:nil];
    }
   
    else
    {
        NSString *messageString=[resultArray valueForKey:@"message"];
        
        messageString=@"server error";
        
        UIAlertView *messageAlertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:messageString delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [messageAlertView show];
    }
    
    return resultArray;
}



-(NSArray*)sendmail_code :(NSString *)email
{

    NSString *urlString=[NSString stringWithFormat:@"%@sendmail_code_password.php",webserviceBaseUrl];
   
    NSString *paramDataString = [NSString stringWithFormat:@"email=%@",email];
    
    
   
    NSData *requestBody = [paramDataString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[requestBody length]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60*5];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:requestBody];
    
    NSURLResponse *res;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&error];
    
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"response %@",response);
    NSArray *resultArray = [response JSONValue];
    
    
    
    if ([[resultArray valueForKey:@"status"]isEqualToString:@"1"])
    {
        
       [[NSUserDefaults standardUserDefaults]setObject:[resultArray valueForKey:@"code"] forKey:@"code"];
       [[NSUserDefaults standardUserDefaults]setObject:email forKey:@"email"];
       [[NSUserDefaults standardUserDefaults]synchronize];
       [self.loginDelegate successFullyLogin:nil];
    }
    else if ([[resultArray valueForKey:@"status"]isEqualToString:@"-1"])
    {
        //[self.loginDelegate loginFailed];
        NSString *messageString=[resultArray valueForKey:@"message"];
       
            messageString=@"your email does not exist";
       
        UIAlertView *messageAlertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:messageString delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [messageAlertView show];
        
    }
    else
    {
        NSString *messageString=[resultArray valueForKey:@"message"];
        
        messageString=@"server error";
        
        UIAlertView *messageAlertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:messageString delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [messageAlertView show];
    }
    
    return resultArray;
}


-(void) saveStatusText:(NSString *) statustext userId:(NSString *)userid
{
    
    //http://54.69.127.235/question_app/user_edit.php?name=&email=&school=&grade=&city=&user_id=&lname=&dob=&gender=&state=&skill_and_interest=&profile_pic=
    NSString *urlString=[NSString stringWithFormat:@"%@user_updatestatustext.php?",webserviceBaseUrl];
 
    
    NSString *paramDataString = [NSString stringWithFormat:@"statustext=%@&user_id=%@&",statustext,userid];
     paramDataString=[self BuiltUrlRequesthavetokent:paramDataString];
    
    NSData *requestBody = [paramDataString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[requestBody length]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60*5];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:requestBody];
    
    NSURLResponse *res;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&error];
    
    
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"response %@",response);
    NSArray *resultArray = [response JSONValue];
    NSLog(@"%@",resultArray);
}




-(NSArray*) saveProfile:(NSArray*) array imageBase64String:(NSString *)base64string
{
    
    //http://54.69.127.235/question_app/user_edit.php?name=&email=&school=&grade=&city=&user_id=&lname=&dob=&gender=&state=&skill_and_interest=&profile_pic=
    NSString *urlString=[NSString stringWithFormat:@"%@user_edit.php?",webserviceBaseUrl];
    NSLog(@"%@",urlString);
    NSLog(@"%@",array);
    
    NSString *paramDataString = [NSString stringWithFormat:@"name=%@&email=%@&school=%@&grade=%@&city=%@&user_id=%@&lname=%@&dob=%@&gender=%@&state=%@&skill_and_interest=%@&img=%@&timezone=%@&action=%@&imageid=%@&about=%@&workat=%@",[array objectAtIndex:0],[array objectAtIndex:1],[array objectAtIndex:2],[array objectAtIndex:3],[array objectAtIndex:4],[array objectAtIndex:5],[array objectAtIndex:6],[array objectAtIndex:7],[array objectAtIndex:8],[array objectAtIndex:9],[array objectAtIndex:10],base64string,[array objectAtIndex:11],[array objectAtIndex:12],[array objectAtIndex:13],[array objectAtIndex:14],[array objectAtIndex:15]];
    
     paramDataString=[self BuiltUrlRequesthavetokent:paramDataString];
    
    
    NSData *requestBody = [paramDataString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[requestBody length]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60*5];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:requestBody];
    
    NSURLResponse *res;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&error];
    
    
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"response %@",response);
    NSArray *resultArray = [response JSONValue];
    return resultArray;
    NSLog(@"%@",resultArray);
}

-(void)addAnswer :(NSArray *)array imageBase64String:(NSString *)base64string
{
    NSString *urlString=[NSString stringWithFormat:@"%@addAnswer.php?",webserviceBaseUrl];
    NSLog(@"%@",urlString);
    
  NSString *paramDataString = [NSString stringWithFormat:@"answer=%@&questionId=%@&userId=%@&date=%@&attachment=%@&status=pending&answerid=%@&action=%@",[array objectAtIndex:0],[array objectAtIndex:1],[array objectAtIndex:2],[array objectAtIndex:3],base64string,[array objectAtIndex:6],[array objectAtIndex:7]];
    
     paramDataString=[self BuiltUrlRequesthavetokent:paramDataString];
    
    NSData *requestBody = [paramDataString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[requestBody length]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60*5];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:requestBody];
    
    NSURLResponse *res;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&error];
    
    
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
   // NSString *status=[response valueForKey:@"status"];
    //NSLog(@"%@",status);
   // if ([status isEqualToString:@"1"])
    //{
        NSArray *resultArray = [response JSONValue];
        NSLog(@"%@",resultArray);
   // }
  
   
    
    
    

    
}

-(void) addFavorite:(NSArray*) array favouriteValue:(int)favouriteVal
{
    NSString *urlString=[NSString stringWithFormat:@"%@favoriteQuestion.php?questionId=%@&userId=%@&status=%@",webserviceBaseUrl,[array objectAtIndex:0],[array objectAtIndex:1],[NSString stringWithFormat:@"%d",favouriteVal]];
    NSLog(@"%@",urlString);
  
     urlString=[self BuiltUrlRequesthavetokent:urlString];
    
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLResponse *res;
    NSError *error;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60*5];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&error];
    
    
  
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NO error:nil];
    
    NSLog(@"%@",dic);
   
}

-(id)getFacebookLogin:(NSArray*)array
{
    //http://54.69.127.235/question_app/fb_user_reg.php?name=&lname=&email=&fbid=&action=1


    NSString *urlString=[NSString stringWithFormat:@"%@fb_user_reg.php?name=%@&lname=%@&email=%@&fbid=%@",webserviceBaseUrl,[array objectAtIndex:0],[array objectAtIndex:1],[array objectAtIndex:2],[array objectAtIndex:3]];
    NSLog(@"%@",urlString);
    
    NSURL *url=[NSURL URLWithString:urlString];
    id dic=[self webserviceMethod:url];
    NSArray *resultArray=[dic objectAtIndex:0];
    NSString *status=[[dic valueForKey:@"status"]objectAtIndex:0];
    NSLog(@"%@",dic);
    
    
    if ([[resultArray valueForKey:@"status"] isEqualToString:@"1"])
    {
        [[NSUserDefaults standardUserDefaults]setObject:[[resultArray valueForKey:@"userdata"]valueForKey:@"id"] forKey:@"userid"];
        [[NSUserDefaults standardUserDefaults]setObject:[resultArray valueForKey:@"userdata"] forKey:@"userDetail"];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [self.loginDelegate successFullyLogin:[resultArray valueForKey:@"userdata"]];
    }
    else
    {
        [self.loginDelegate loginFailed];
        NSString *messageString=[dic valueForKey:@"message"];
        UIAlertView *messageAlertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:messageString delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [messageAlertView show];
        
    }
    return [resultArray valueForKey:@"userdata"];

    
   
    
}

-(id)getGmailLogin:(NSArray*)array
{
    //http://54.69.127.235/question_app/gmail_user_reg.php?name=&lname=&email=&gmailid=&action=1
    NSString *urlString=[NSString stringWithFormat:@"%@gmail_user_reg.php?name=%@&lname=%@&email=%@&gmailid=%@",webserviceBaseUrl,[array objectAtIndex:0],[array objectAtIndex:1],[array objectAtIndex:2],[array objectAtIndex:3]];
    NSLog(@"%@",urlString);
    
    NSURL *url=[NSURL URLWithString:urlString];
    id dic=[self webserviceMethod:url];
    
    NSArray *resultArray=[dic objectAtIndex:0];
   
    NSLog(@"%@",dic);
    
    
    if ([[resultArray valueForKey:@"status"] isEqualToString:@"1"])
    {
        [[NSUserDefaults standardUserDefaults]setObject:[[resultArray valueForKey:@"userdata"]valueForKey:@"id"] forKey:@"userid"];
        [[NSUserDefaults standardUserDefaults]setObject:[resultArray valueForKey:@"userdata"] forKey:@"userDetail"];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [self.loginDelegate successFullyLogin:[resultArray valueForKey:@"userdata"]];
    }
    else
    {
        [self.loginDelegate loginFailed];
        NSString *messageString=[dic valueForKey:@"message"];
        UIAlertView *messageAlertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:messageString delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [messageAlertView show];
        
    }
    return [resultArray valueForKey:@"userdata"];
    
    return dic;
}

-(void)resetpassword:(NSString*)email
{
   // http://54.69.127.235/question_app/reset_password.php?email=&password=//
    NSString *urlString=[NSString stringWithFormat:@"%@reset_password.php?email=%@",webserviceBaseUrl,email];
    NSLog(@"%@",urlString);
    
    NSURL *url=[NSURL URLWithString:urlString];
    id response=[self webserviceMethod:url];
    id array=[response objectAtIndex:0];
    NSString *success=[array objectForKey:@"success"];
    int successValue=[success intValue];
    if (successValue==1)
    {
        [[[UIAlertView alloc]initWithTitle:@"Alert!" message:[array valueForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]show];
    }
    else
    {
      [[[UIAlertView alloc]initWithTitle:@"Alert!" message:[array valueForKey:@"message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]show];
    }
    
}




-(NSMutableArray*) fetchData:(NSString*) str
{
    NSString *str1=[NSString stringWithFormat:@"%@getAllQuestionsInfoByUser.php?userId=%@",webserviceBaseUrl,str];
    str1=[self BuiltUrlRequesthavetokent:str1];
    NSURL *url=[NSURL URLWithString:str1];
    
    
   

    NSURLResponse *res;
    NSError *error;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60*5];
     // NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLReque timeoutInterval:60*5];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&error];
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NO error:nil];
    if (!dic)
    {
        UIAlertView *errorAlert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Error!!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [errorAlert show];
    }
    else
    {
       // NSMutableArray *questionArray=[[dic objectForKey:@"questions"]mutableCopy];
        NSMutableArray *questionArray=[NSMutableArray arrayWithObject:dic];
 
    return questionArray;
    }
    return nil;
    
    
   
}





-(void) questionRate:(NSArray*) array

{
    NSString *str1=[NSString stringWithFormat:@"%@addQuestionRating.php?questionId=%@&userId=%@&rating=5",webserviceBaseUrl,[array objectAtIndex:0],[array objectAtIndex:1]];
    
    str1=[self BuiltUrlRequesthavetokent:str1];

    NSURL *url=[NSURL URLWithString:str1];
    NSData *data=[NSData dataWithContentsOfURL:url];
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NO error:nil];
    NSLog(@"%@",dic);
  
   
}

-(NSArray*) answerRate:(NSString*)answerId userId:(NSString*)userID rating:(int)rate
{
    NSString *str1=[NSString stringWithFormat:@"%@addAnswerRating.php?answerId=%@&userId=%@&rating=%d",webserviceBaseUrl,answerId,userID,rate];
    str1=[self BuiltUrlRequesthavetokent:str1];

    NSURL *url=[NSURL URLWithString:str1];
    return [self webserviceMethod:url];

    
}

-(NSArray*) getAllCategoriesByuserId:(NSString*)userId
{
    NSString *str1=[NSString stringWithFormat:@"%@getAllCategoryByUserId.php?user_id=%@",webserviceBaseUrl,userId];
    str1=[self BuiltUrlRequesthavetokent:str1];
    
    NSURL *url=[NSURL URLWithString:str1];
    return [self webserviceMethod:url];
    
    
}

-(NSArray*) getQuestionImagesByquestionId:(NSString*)questionId
{
    NSString *str1=[NSString stringWithFormat:@"%@getQuestionImagesbyquestionid.php?questionid=%@",webserviceBaseUrl,questionId];
    str1=[self BuiltUrlRequesthavetokent:str1];
    
    NSURL *url=[NSURL URLWithString:str1];
    return [self webserviceMethod:url];
    
    
}

-(NSMutableArray*) postData: (NSArray*) questionId userId:(NSString*)userId
{
    NSString *str=[NSString stringWithFormat:@"%@getAllAnswersByQuestionId.php?questionId=%@&userId=%@",webserviceBaseUrl,questionId,userId];
    str=[self BuiltUrlRequesthavetokent:str];
    NSURL *url=[NSURL URLWithString:str];
    

    return [self webserviceMethod:url];
}
-(NSArray*) UpdateCategory:
(NSString*) categoryname userId:(NSString*)userId hastags:(NSString*)hastags tabfriends:(NSString*)tabfriends catId:(NSString*) catId action:(NSString*) action
{
    NSString *urlString=[NSString stringWithFormat:@"%@categories.php",webserviceBaseUrl];
    
    
    NSString *paramDataString = [NSString stringWithFormat:@"userId=%@&hastags=%@&action=%@&catId=%@&tabfriend=%@&category_name=%@",userId,hastags,action,catId,tabfriends,categoryname];
    
    paramDataString=[self BuiltUrlRequesthavetokent:paramDataString];
    
    NSData *requestBody = [paramDataString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[requestBody length]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60*5];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:requestBody];
  
    NSURLResponse *res;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&error];
    
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"response %@",response);
    NSArray *resultArray = [response JSONValue];
    return resultArray;
}




-(NSArray*) searchUser:(NSString*) str
{
    NSArray *userData=[[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil]objectAtIndex:0];
    
   NSString *userId=[userData valueForKey:@"id"];
    NSString *str1=[NSString stringWithFormat:@"%@searchUsers.php?search_keyword=%@&user_id=%@",webserviceBaseUrl,str,userId];
  str1=[self BuiltUrlRequesthavetokent:str1];
   NSURL *url=[NSURL URLWithString:str1];
    
    
    return [self webserviceMethod:url];
}

-(NSArray*) sendFriendRequest:(NSString*) senderId receiverId:(NSString*) receiverId
{
    
    NSString *str1=[NSString stringWithFormat:@"%@sendFriendRequest.php?sender_id=%@&receiver_id=%@&status=0",webserviceBaseUrl,senderId,receiverId];
     str1=[self BuiltUrlRequesthavetokent:str1];
    NSURL *url=[NSURL URLWithString:str1];
    return [self webserviceMethod:url];
}

-(NSArray*) acceptRequest:(NSString*) receiverId senderId:(NSString*) senderId pushnotifycationid:(NSString*) pushnotifycationid
{
    NSString *str1=[NSString stringWithFormat:@"%@sendFriendRequest.php?receiver_id=%@&sender_id=%@&status=1&pushnotifycationid=%@",webserviceBaseUrl,receiverId,senderId,pushnotifycationid];
    str1=[self BuiltUrlRequesthavetokent:str1];
    NSURL *url=[NSURL URLWithString:str1];
    return [self webserviceMethod:url];

    
}

-(NSArray*) rejectRequest:(NSString*) receiverId senderId:(NSString*) senderId pushnotifycationid:(NSString*) pushnotifycationid
{
    NSString *str1=[NSString stringWithFormat:@"%@sendFriendRequest.php?receiver_id=%@&sender_id=%@&status=2&pushnotifycationid=%@",webserviceBaseUrl,receiverId,senderId,pushnotifycationid];
    str1=[self BuiltUrlRequesthavetokent:str1];
    NSURL *url=[NSURL URLWithString:str1];
    return [self webserviceMethod:url];

}

-(NSArray*) getUserInfo:(NSString*) userId
{
    
    NSString *str1=[NSString stringWithFormat:@"%@/getUserInfoById.php?mobile=%@",webserviceBaseUrl,userId];
    str1=[self BuiltUrlRequesthavetokent:str1];

    NSURL *url=[NSURL URLWithString:str1];
    return [self webserviceMethod:url];
    
}

-(NSArray*)getFriendInfo:(NSString*)userId friend:(NSString*)friendId
{
    //http://54.69.127.235/question_app//get_clicked_user_info.php?mobile=155&user_id=28
    
    NSString *str1=[NSString stringWithFormat:@"%@/get_clicked_user_info.php?mobile=%@&user_id=%@",webserviceBaseUrl,userId,friendId];
    str1=[self BuiltUrlRequesthavetokent:str1];
    NSURL *url=[NSURL URLWithString:str1];
    return [self webserviceUrlMethod:url];
}

-(NSMutableArray*) getAllFriendRequest:(NSString*) userId
{
    NSString *str1=[NSString stringWithFormat:@"%@getAllFriendRequests.php?user_id=%@",webserviceBaseUrl,userId];
     str1=[self BuiltUrlRequesthavetokent:str1];
    NSURL *url=[NSURL URLWithString:str1];
    NSData *data=[NSData dataWithContentsOfURL:url];
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NO error:nil];
    
//    NSString *status=[dic objectForKey:@"status"];
//    if ([status isEqualToString:@"1"])
//    {
        NSMutableArray *friendsData=[[dic objectForKey:@"data"]mutableCopy];
        return friendsData;
//    }
//    else
//    {
//        return nil;
//    }
   
    
   
    //return [self webserviceMethod:url];

}

-(NSArray*) acceptAnswer:(NSString*) answerId
{
    NSArray *userDetail=[[NSArray arrayWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"], nil]objectAtIndex:0];
    NSString *user_id=[userDetail valueForKey:@"id"];
    NSString *str1=[NSString stringWithFormat:@"%@acceptAnswer.php?answer_id=%@&status=accepted&logged_in_user_id=%@",webserviceBaseUrl,answerId,user_id];
    str1=[self BuiltUrlRequesthavetokent:str1];
    NSURL *url=[NSURL URLWithString:str1];
    return [self webserviceMethod:url];
}
-(NSArray*) unacceptAnswer:(NSString*) answerId
{
   NSArray *userDetail=[[NSArray arrayWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"], nil]objectAtIndex:0];
    NSString *user_id=[userDetail valueForKey:@"id"];
    
    NSString *str1=[NSString stringWithFormat:@"%@acceptAnswer.php?answer_id=%@&status=rejected&logged_in_user_id=%@",webserviceBaseUrl,answerId,user_id];
     str1=[self BuiltUrlRequesthavetokent:str1];
    NSURL *url=[NSURL URLWithString:str1];
    
    
    return [self webserviceMethod:url];
}

-(NSArray*) getAllFriendList:(NSString*) userId
{
    NSString *str1=[NSString stringWithFormat:@"%@getAllFriends.php?user_id=%@",webserviceBaseUrl,userId];
    str1=[self BuiltUrlRequesthavetokent:str1];
    NSURL *url=[NSURL URLWithString:str1];

    return [self webserviceMethod:url];
}

-(NSArray*) sendMessage:(NSString*) senderId receiverId:(NSString*) receiverId message:(NSString*)message date:(NSString*)date
{
    
//send message
    
//    NSString *str=[NSString stringWithFormat:@"%@messaging.php?sender_id=%@&receiver_id=%@&message=%@&date_time=%@",webserviceBaseUrl,senderId,receiverId,message,date];
//    
//    NSString *encodedString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url=[NSURL URLWithString:encodedString];
//    return [self webserviceMethod:url];
    
    NSString *str=[NSString stringWithFormat:@"%@messaging.php?sender_id=%@&receiver_id=%@&message=%@&date_time=%@",webserviceBaseUrl,senderId,receiverId,message,date];
    str=[self BuiltUrlRequesthavetokent:str];
    NSString *encodedString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:encodedString];
    
    
    
    
    
    
    NSData *data=[NSData dataWithContentsOfURL:url];
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NO error:nil];
    
    NSArray *messageArray=[dic objectForKey:@"status"];
    NSArray *successArray=[dic objectForKey:@"message"];
    NSArray *mainArray=[NSArray arrayWithObjects:messageArray,successArray, nil];
    return mainArray;
}

-(NSArray*) receiveMessageUserIdFriendId:(NSString*) userId friendId:(NSString*) friendId
{
    NSString *str=[NSString stringWithFormat:@"%@messagesReceiveByUserIdFriendId.php?user_id=%@&friend_id=%@&limitrow=%@",webserviceBaseUrl,userId,friendId,@"20"];
    str=[self BuiltUrlRequesthavetokent:str];
    NSURL *url=[NSURL URLWithString:str];
    return [self webserviceMethod:url];
    
}


-(NSArray*) receiveMessage:(NSString*) userId
{
    NSString *str=[NSString stringWithFormat:@"%@messagesReceiveByUserId_new.php?user_id=%@",webserviceBaseUrl,userId];
    str=[self BuiltUrlRequesthavetokent:str];
    NSURL *url=[NSURL URLWithString:str];
    return [self webserviceMethod:url];

}

-(NSArray*) receiveMessagenew:(NSString*) userId
{
    NSString *str=[NSString stringWithFormat:@"%@messagesReceiveByUserId.php?user_id=%@",webserviceBaseUrl,userId];
    str=[self BuiltUrlRequesthavetokent:str];
    NSURL *url=[NSURL URLWithString:str];
    
    return [self webserviceMethod:url];
    
}

-(NSArray*) readMessage:(NSString*)messageId userId:(NSString*)userId
{
    NSString *str=[NSString stringWithFormat:@"%@markPreviousMessagesAsRead.php?message_id=%@&user_id=%@",webserviceBaseUrl,messageId,userId];
     str=[self BuiltUrlRequesthavetokent:str];
    NSURL *url=[NSURL URLWithString:str];
    return [self webserviceMethod:url];

   
}


-(NSArray*) countAcceptedAnswer:(NSString*)userId
{
    NSString *str=[NSString stringWithFormat:@"%@countAcceptedAnswersByUserId.php?user_id=%@",webserviceBaseUrl,userId];
    str=[self BuiltUrlRequesthavetokent:str];

    NSURL *url=[NSURL URLWithString:str];

    return [self webserviceMethod:url];
}

-(void) saveQuestion:(NSString*)questionId userId:(NSString*)userId status:(int)status
{
    NSString *str=[NSString stringWithFormat:@"%@saveQuestionByUserId.php?question_id=%@&user_id=%@&status=%d",webserviceBaseUrl,questionId,userId,status];
    str=[self BuiltUrlRequesthavetokent:str];

    NSURL *url=[NSURL URLWithString:str];
    [self webserviceMethod:url];

}

-(id) getAllQuestions:(NSString*)userID categoriesId:(NSString*) categoriesId hashtag:(NSString*) hashtag rowget:(NSString*) rowget
{
    
    NSString *urlstring=[NSString stringWithFormat:@"%@getAllQuestionsInfo.php?user_id=%@&categoriesId=%@&hashtag=%@&rowget=%@",webserviceBaseUrl,userID,categoriesId,hashtag,rowget];
     urlstring=[self BuiltUrlRequesthavetokent:urlstring];
    NSString* encodedUrl = [urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:encodedUrl];
    return [self webserviceUrlMethod:url];

}

-(NSArray*) getAllSavedQuestion:(NSString*)userId
{
    
    NSString *str=[NSString stringWithFormat:@"%@getAllSavedQuestionsByUserId.php?user_id=%@",webserviceBaseUrl,userId];
    str=[self BuiltUrlRequesthavetokent:str];
    NSURL *url=[NSURL URLWithString:str];

    return [self webserviceMethod:url];
    
}

-(id) privateFriendPost:(NSString*)userId categoriesId:(NSString*) categoriesId hashtag:(NSString*) hashtag rowget:(NSString*) rowget
{
    NSString *str=[NSString stringWithFormat:@"%@getAllFriendsQuestionsByUserId.php?userId=%@&categoriesId=%@&hashtag=%@&rowget=%@",webserviceBaseUrl,userId,categoriesId,hashtag,rowget];
      str=[self BuiltUrlRequesthavetokent:str];
    NSString* encodedUrl = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:encodedUrl];
    return [self webserviceUrlMethod:url];
}

-(void) notificationList
{
    NSArray *userData=[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"],nil];
    //NSArray *deviceToken=[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"], nil];
    NSString *ids=[userData objectAtIndex:0];
   
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // getting an NSString
    // NSString *myString = [prefs stringForKey:@"userid"];
    
    NSString *deviceTokenString=[prefs stringForKey:@"deviceToken"];
    
   
    NSString *str=[NSString stringWithFormat:@"%@device_token.php",webserviceBaseUrl];
    NSString *paramDataString=[NSString stringWithFormat:@"user_id=%@&device_token=%@&type=0",ids,deviceTokenString];
    paramDataString=[self BuiltUrlRequesthavetokent:paramDataString];
    NSURL *url=[NSURL URLWithString:str];
    NSData *requestBody = [paramDataString dataUsingEncoding:NSUTF8StringEncoding];

    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[requestBody length]];
    
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60*5];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:requestBody];
    
    NSURLResponse *res;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&error];
    
    
    
    
    
    [self webserviceMethod:url];
}

-(NSArray*)rejectFriendRequestSent:(NSString*)senderId receiverId:(NSString*)receiverID
{
     NSString *str=[NSString stringWithFormat:@"%@reject_own_friend_request.php?sender_id=%@&receiver_id=%@",webserviceBaseUrl,senderId,receiverID];
     str=[self BuiltUrlRequesthavetokent:str];
     NSURL *url=[NSURL URLWithString:str];
     return [self webserviceMethod:url];
}

-(NSArray*) pushNotificationData:(NSString*)userId
{
   
    NSString *str=[NSString stringWithFormat:@"%@push_notification_data.php?user_id=%@",webserviceBaseUrl,userId];
    str=[self BuiltUrlRequesthavetokent:str];
     NSURL *url=[NSURL URLWithString:str];
    return [self webserviceMethod:url];
}


-(NSArray*)getFriendsPostsAndAnswers:(NSString*)FriendId andUserId:(NSString*)userID
{
    //http://54.69.127.235/question_app/getAllPostQuestionandAcceptedAnswer.php?user_id=155
  //  http://54.69.127.235/question_app/getAllPostQuestionandAcceptedAnswer.php?user_id=&login_id=
    NSString *str=[NSString stringWithFormat:@"%@getAllPostQuestionandAcceptedAnswer.php?user_id=%@&login_id=%@",webserviceBaseUrl,FriendId,userID];
    str=[self BuiltUrlRequesthavetokent:str];
    NSURL *url=[NSURL URLWithString:str];
   return [self webserviceMethod:url];
    
}

-(id)getUpdatesQuestion:(NSString*)friendID
{
   
    //http://54.69.127.235/question_app/recent_questions_answers.php?user_id=262
    
    NSString *str=[NSString stringWithFormat:@"%@recent_questions_answers.php?user_id=%@",webserviceBaseUrl,friendID];
    str=[self BuiltUrlRequesthavetokent:str];
    NSURL *url=[NSURL URLWithString:str];
    return [self webserviceMethod:url];
}

-(id)getPushNotificationByUserId:(NSString*)userID
{
    
    //http://54.69.127.235/question_app/recent_questions_answers.php?user_id=262
    NSString *str=[NSString stringWithFormat:@"%@getPushNotificationByUserId.php?userid=%@",webserviceBaseUrl,userID];
    str=[self BuiltUrlRequesthavetokent:str];
    NSURL *url=[NSURL URLWithString:str];
    return [self webserviceMethod:url];
}


-(NSArray*)flagAnswersQuestions:(NSString*)entityid entity:(NSString *)entity
{
    //54.69.127.235/question_app/answers_likes_dislikes.php?answer_id=%@&verdict=%@&user_id=
    //NSString *userId=[[[AppDelegate sharedDelegate]userDetail]valueForKey:@"id"];
    
    id userData=[[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil]objectAtIndex:0];
    
    NSString *userId=[userData valueForKey:@"id"];
    

    
    NSString *str=[NSString stringWithFormat:@"%@answers_questions_flag.php?userid=%@&entity=%@&entityid=%@",webserviceBaseUrl,userId,entity,entityid];
    str=[self BuiltUrlRequesthavetokent:str];
    NSURL *url=[NSURL URLWithString:str];
    
    return [self webserviceUrlMethod:url];
    
    
}

-(NSArray*)likeAndDislikeAnswers:(NSString *)answerId likeValue:(NSString*)value
{
    //54.69.127.235/question_app/answers_likes_dislikes.php?answer_id=%@&verdict=%@&user_id=
     NSArray *userData=[[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil]objectAtIndex:0];
    NSString *userId=[userData valueForKey:@"id"];
    NSString *str=[NSString stringWithFormat:@"%@answers_likes_dislikes.php?answer_id=%@&verdict=%@&user_id=%@",webserviceBaseUrl,answerId,value,userId];
     str=[self BuiltUrlRequesthavetokent:str];
    NSURL *url=[NSURL URLWithString:str];
    
    return [self webserviceUrlMethod:url];

    
}
-(NSArray*)likeAndDislikeQuestions:(NSString *)questionId andDislikeValue:(NSString*)value
{
    //54.69.127.235/question_app/questions_likes_dislikes.php?question_id=%@&verdict=%@&user_id=
    NSArray *userData=[[[NSArray alloc]initWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"],nil]objectAtIndex:0];
  
    NSString *userId=[userData valueForKey:@"id"];
    NSString *str=[NSString stringWithFormat:@"%@questions_likes_dislikes.php?question_id=%@&verdict=%@&user_id=%@",webserviceBaseUrl,questionId,value,userId];
    str=[self BuiltUrlRequesthavetokent:str];

    NSURL *url=[NSURL URLWithString:str];
    return [self webserviceUrlMethod:url];

    
}
-(void)flagAnswers:(NSString*)answersId
{
    
}

-(id)addFollowAccount:(NSString*)friendID andUserId:(NSString*)userId andStatus:(NSString*)status
{
    //tofollow means friendId
    //follower means loginId
    //Status 1
   // http://54.69.127.235/question_app/followers.php?tofollow=155&follower=28&status=1
    NSString *str=[NSString stringWithFormat:@"%@followers.php?tofollow=%@&follower=%@&status=%@",webserviceBaseUrl,friendID,userId,status];
    str=[self BuiltUrlRequesthavetokent:str];

    NSURL *url=[NSURL URLWithString:str];
    
   return  [self webserviceMethod:url];
}

//Hot Topics Webservice
-(id)getHotTopicsQuestions:(NSString*) categoriesId hashtag:(NSString*) hashtag rowget:(NSString*) rowget
{
    NSString *userId=[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"];
    NSString *token=[[NSUserDefaults standardUserDefaults]valueForKey:@"token"];
    NSString *userIdchecktoken=[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"];
    
    NSString *urlstring=[NSString stringWithFormat:@"%@hot_topics.php?user_id=%@&token=%@&userIdchecktoken=%@&categoriesId=%@&hashtag=%@&rowget=%@",webserviceBaseUrl,userId,token,userId,categoriesId,hashtag,rowget];
    
    NSString* encodedUrl = [urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    
    //http://54.69.127.235/question_app/hot_topics.php?user_id=155
    NSURL *url=[NSURL URLWithString:encodedUrl];
    
    id dic=[self webserviceUrlMethod:url];
    
    /*id userDetail=[dic objectForKey:@"userdata"];
    if ([[dic objectForKey:@"success"]boolValue])
    {
            [[NSUserDefaults standardUserDefaults]setObject:[[dic objectForKey:@"userdata"]valueForKey:@"id"] forKey:@"userid"];
            [[NSUserDefaults standardUserDefaults]setObject:[dic objectForKey:@"userdata"] forKey:@"userDetail"];
        
            [[NSUserDefaults standardUserDefaults]synchronize];
        
            [[AppDelegate sharedDelegate]setUserDetail:[dic objectForKey:@"userdata"]];
    }*/
    return  [self webserviceUrlMethod:url];
}



-(id)webserviceUrlMethod:(NSURL*)url
{
    NSURLResponse *res;
    NSError *error;
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60*5];
    NSData *responseData=[NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&error];
    if (!responseData)
    {
        UIAlertView *errorAlert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please check your internet connection" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [errorAlert show];
    }
    else
    {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NO error:&error];
        
        
      
        
        
        
        if (error)
        {
            
        }
        if (dic==nil)
        {
            
        }
        else
        {
            return dic;
//            NSArray *mainArray=[NSArray arrayWithObject:dic];
//            return mainArray;
        }
    }
    
    return nil;
 
}



-(id) webserviceMethod:(NSURL*)url
{
    NSURLResponse *res;
    NSError *error;
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60*5];
    
    NSLog(@"request.HTTPMethod = %@", request.HTTPMethod);
    
    NSData *responseData=[NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&error];
    if (!responseData)
    {
        UIAlertView *errorAlert=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please check your internet connection" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [errorAlert show];
    }
    else
    {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NO error:&error];
        if (error)
        {
            
        }
        if (dic==nil)
        {
            
        }
        else
        {
        NSArray *mainArray=[NSArray arrayWithObject:dic];
        return mainArray;
        }
    }
    
    return nil;
    
   

}







































@end
