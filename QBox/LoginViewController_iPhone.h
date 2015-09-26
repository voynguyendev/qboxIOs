//
//  LoginViewController_iPhone.h
//  QBox
//
//  Created by iapp on 12/06/14.
//  Copyright (c) 2014 iapp. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LABELFONT [UIFont fontWithName:@"Avenir" size:15.0f]
#define TEXTFIELDFONT [UIFont fontWithName:@"Georgia" size:15.0f]
#define BORDERCOLOR [UIColor colorWithRed:178.0/255.0 green:178.0/255.0 blue:178.0/255.0 alpha:1.0f]
#define BUTTONCOLOR [UIColor colorWithRed:228.0f/255.0 green:0.0/255.0f blue:49.0f/255.0f alpha:1.0]
#define SHOW_NO_INTERNET_ALERT(_DELEGATE) [[[UIAlertView alloc] initWithTitle:@"" message:@"Please check your internet connection. It might be slow or disconnected." delegate:_DELEGATE cancelButtonTitle:@"OK" otherButtonTitles:nil] show]
#define TEXTCOLOR [UIColor colorWithRed:96.0f/255.0 green:96.0/255.0f blue:96.0f/255.0f alpha:1.0]

@interface LoginViewController_iPhone : UIViewController

@end
