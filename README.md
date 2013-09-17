oauth2-template
===============

This isn't so much an oauth2 library, as much as a collection of code you need in order to implement oauth2. An oauth2 'library' would be tough because a) oauth2 is way simpler than oauth1 and b) all providers want some small bit of data different in the body or in the header. 

The projects and functions needed to implement oauth2 included:
* keychain access using https://github.com/carlbrown/PDKeychainBindingsController to securely store tokens
* base64 encoding using https://github.com/nicklockwood/Base64 to encode tokens for transit
* json parsing using NSJSONSerialization to parse the response data from the server
* opening safari using openURL for user authentication
* url handling using handleOpenURL to handle the safari redirect for user authentication

I built the example functions around twitter because thats what I needed and its well documented. Test the Twitter implementation by filing for an client id and secret at https://dev.twitter.com/apps and inputting into the authenticateApplication function.
