//
//  ProjectHelper.h
//  EventBustMaster
//
//  Created by Vakul on 23/09/14.
//  Copyright (c) 2014 iAppTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
#import <sys/socket.h>


/*
 
 // iPhone 4  size = CGSizeMake(320, 480)
 // iPhone 5  size = CGSizeMake(320, 568)
 // iPhone 6  size = CGSizeMake(375, 667)
 // iPhone 6+ size = CGSizeMake(414, 736)
 
 */

#define NO_INTERNET_CONNECTION_MESSAGE @"Please check your internet connection. It might be slow or disconnected."

#define BACKGROUND_IMAGE [UIImage imageNamed:@"background"]
#define CATEGORY_BACKGROUND_IMAGE [[UIImage imageNamed:@"congruent_pentagon.png"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile]

#define colorFromRGB(R,G,B,A)   [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define navigationBarThemeColor() colorFromRGB(211.0, 54.0, 43.0, 1.0)

typedef enum {
    
    iPHONE_4,
    iPHONE_5,
    
    iPHONE_6,
    iPHONE_6Plus
    
}DEVICE;


@interface ProjectHelper : NSObject

+(ProjectHelper *)shared;


/*
 * Screen size
 */
@property (nonatomic) CGSize screenSize;



/*
 * iOS version of current device
 */
@property (nonatomic) CGFloat iosVersion;



/*
 * current device type iPhone 4,5,6 OR 6+
 */
@property (nonatomic) DEVICE device;


/*
 * Check for internet is accessable or not
 */
+(BOOL)internetAvailable;


/*
 * Checking PhotoGallery Availabilty for current device
 */
+(BOOL)photoGalleryAvailable;


/*
 * Checking Camera Availabilty for current device
 */
+(BOOL)cameraAvailable;


/*
 * Application Common UIFont
 */
-(UIFont *)applicationFontWithSize:(CGFloat)fontSize bold:(BOOL)bold;

@end
