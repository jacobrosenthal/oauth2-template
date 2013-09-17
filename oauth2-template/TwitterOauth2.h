//
//  TwitterOauth2.h
//  oauth2-template
//
//  Created by Jacob on 9/10/13.
//  Copyright (c) 2013 Example. All rights reserved.
//

#import <Foundation/Foundation.h>

/****************************************************************************/
/*							UI protocols									*/
/****************************************************************************/
@protocol TwitterOauth2Delgate <NSObject>
- (void) didReceiveTrendsByWOEID:(NSDictionary *)trends;
- (void) didReceiveValidAppAuth;
- (void) didReceiveError:(NSError *)error fromData:(NSData *)data;
@end

@interface TwitterOauth2 : NSArray <NSURLConnectionDelegate>

/****************************************************************************/
/*								UI controls									*/
/****************************************************************************/
@property (nonatomic, weak) id<TwitterOauth2Delgate>           trendsDelegate;
@property (strong, nonatomic) NSMutableData *responseData;

/****************************************************************************/
/*								Actions										*/
/****************************************************************************/
- (id)initWithDelegate:(id<TwitterOauth2Delgate>)delegate;
- (void)retreiveTrendsByWOEID:(NSString*)WOEID;
    
+ (BOOL)isAppTokenValid;
+ (void)authenticateUser;
@end
