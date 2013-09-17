//
//  TwitterOauth2.m
//  oauth2-template
//
//  Created by Jacob on 9/10/13.
//  Copyright (c) 2013 Example. All rights reserved.
//

#import "TwitterOauth2.h"
#import "Base64.h"
#import "PDKeychainBindings.h"

@implementation TwitterOauth2

@synthesize responseData;
@synthesize trendsDelegate;

- (id)initWithDelegate:(id<TwitterOauth2Delgate>)delegate{
    
    self = [super init]; // or call the designated initalizer
    if (self) {
        //add any init here
        self.trendsDelegate=delegate;
    }
    
    return self;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)response
{
    [responseData appendData:response];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    //we deal only in json, so see if it successfully converts
    NSError *error = nil;
    id json = [NSJSONSerialization
               JSONObjectWithData:responseData
               options:0
               error:&error];
    
    if(error) { /* JSON was malformed, act appropriately here */
        NSLog(@"JSON Malformed, IE Strange response from twitter %@", error);
        NSLog(@"%@", [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding]);
        [trendsDelegate didReceiveError:error fromData:responseData];
    }
    
    NSDictionary *message;
    NSDictionary *jsonDictionary;
    NSDictionary *trends;
    NSString *token;
    
    @try{
        message = [json objectForKey:@"errors"];
    }@catch(NSException* ex){/*do nothing */}

    @try{
        token = [json objectForKey:@"access_token"];
    }@catch(NSException* ex){/*do nothing */}

    @try{
        jsonDictionary = [json objectAtIndex:0];
        trends = [jsonDictionary objectForKey:@"trends"];
    }@catch(NSException* ex){/*do nothing */}
        

    if(message){
        //what code should it be?
        [trendsDelegate didReceiveError:[NSError errorWithDomain:@"twitterOauth2" code:1 userInfo:message] fromData:responseData];
        
    }else if(token){
        PDKeychainBindings *bindings=[PDKeychainBindings sharedKeychainBindings];
        [bindings setObject:token forKey:@"Twitter-OAUTH2-Bearer"];
        
        [trendsDelegate didReceiveValidAppAuth];
        
    }else if(trends){
        [trendsDelegate didReceiveTrendsByWOEID:trends];
    }
    
    //TOOD send error if we dont know what it is?
}

//https://dev.twitter.com/docs/api/1.1/get/trends/place
- (void)retreiveTrendsByWOEID:(NSString*)WOEID{
    
    NSString *authURL = @"https://api.twitter.com/1.1/trends/place.json?id=";
    NSURL *url = [NSURL URLWithString:[authURL stringByAppendingFormat:@"%@", WOEID]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:10.0];
    
    [request setHTTPMethod:@"GET"];
    
    PDKeychainBindings *bindings=[PDKeychainBindings sharedKeychainBindings];
    
    NSString *auth = [@"Bearer " stringByAppendingString:[bindings objectForKey:@"Twitter-OAUTH2-Bearer"]];
    
    [request setValue:auth forHTTPHeaderField:@"Authorization"];
    
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
    if (connection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        //TODO throw did receive error if we got one here
        NSLog(@"Connection created");
        responseData = [[NSMutableData alloc] init];
    } else {
        NSLog(@"Connection failed");
    }
}

- (BOOL)appTokenExists{
    //just check if we have one local
    //if we end up bouncing an invalid token we can attempt to reauth it
    PDKeychainBindings *bindings=[PDKeychainBindings sharedKeychainBindings];
    if([bindings objectForKey:@"Twitter-OAUTH2-Bearer"]){
        return YES;
    }
    else{
        return NO;
    }
}

//Twitter doesnt support user authentication for oauth2
- (BOOL)isValidUser{
    return YES;
}

//https://dev.twitter.com/docs/auth/application-only-auth
- (void)authenticateApp{
    
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth2/token"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:10.0];
    
    [request setHTTPMethod:@"POST"];
    
    //Body
    NSString *args = @"grant_type=client_credentials";
    NSData *requestBody = [args dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:requestBody];
    
    //Header
    NSString *clientID = @"qW9BgkuCNZQAuAgZAVs1QQ";
    NSString *clientSecret = @"tBoHMxBxXWeazAPlmk7L7DF3T9X0uLkAOARrbyGa8";
    
    NSString *key = [clientID stringByAppendingFormat:@":%@", clientSecret];
    NSData *inputData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedString = [inputData base64EncodedString];
    NSString *auth = [@"Basic " stringByAppendingString:encodedString];
    [request setValue:auth forHTTPHeaderField:@"Authorization"];
    
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
    if (connection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        NSLog(@"Connection created");
        responseData = [[NSMutableData alloc] init];
    } else {
        NSLog(@"Connection failed");
    }
    
}

//Twitter doesnt support user authentication in oauth2
//just for example how to pop safari auth window with return to this app
- (void)authenticateUser{
    

}

+ (BOOL)isAppTokenValid{
    //do we even have one?
    PDKeychainBindings *bindings=[PDKeychainBindings sharedKeychainBindings];
    if([bindings objectForKey:@"Twitter-OAUTH2-Bearer"]){
        //
        return YES;
    }
    else{
        return NO;
    }
}


@end

