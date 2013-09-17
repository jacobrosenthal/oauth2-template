oauth2-template
===============

Oauth2 template for ios, but basically should work on Mac with tweaking. Includes Twitter example


This isn't so much an oauth2 library, as much as a collection of code you need in order to implement oauth2 including:
*keychain access using https://github.com/carlbrown/PDKeychainBindingsController to securely store tokens
*base64 encoding using https://github.com/nicklockwood/Base64 to encode tokens for transit
*json parsing using NSJSONSerialization to parse the response data from the server
*opening safari using openURL for user authentication
*url handling using handleOpenURL to handle the safari redirect for user authentication


An oauth2 library would be a) very small because oauth2 is way simpler and b) seem to be tough as all providers want some small bit of data different in the body or in the header. Thus I just have 2 function for you to copy and alter to your liking. I built the example functions around twitter because thats what I needed and its well documented. If you create an implementation for someone else let me know and Ill add it (pull requests accepted)


For now theres a Twitter implementation where you need to replace my client and secret with yours from https://dev.twitter.com/apps . 
