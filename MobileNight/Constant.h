//
//  Constant.h
//  MobileNight
//

#import "AppDelegate.h"

#ifndef MobileNight_Constant_h
#define MobileNight_Constant_h

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define IS_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0)
#define kAPP_DELEGATE (AppDelegate *)[[UIApplication sharedApplication] delegate]

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define iOs7   (IOS_VERSION >= 7.0)
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define screenHeight [UIScreen mainScreen].bounds.size.height
#define screenWidth [UIScreen mainScreen].bounds.size.width

#define kBASE_URL [NSURL URLWithString:@"http://54.67.118.119:8280/WebServices/mobin/"]
//#define kBASE_URL [NSURL URLWithString:@"http://192.168.1.101:8280/WebServices/mobin/"]

#define kDISTANCE 10

#define admin @"0"
#define VISITOR @"1"
#define BaRTENDER @"2"
#define BOUNCER @"3"

#define kFONT_HELVETICANEUE_MEDIUM @"HelveticaNeue-Medium"
#define kFONT_HELVETICANEUE_LIGHT  @"HelveticaNeue-Light"

#define kCLCOORDINATES_EQUAL( coord1, coord2 ) (coord1.latitude == coord2.latitude && coord1.longitude == coord2.longitude)

//Messages
#define NOT_FOUND @"Results not found. Please adjust your filter criteria"
#define internet_not_available @"Internet Unavailable. Try again later"
#define comment_blanks @"Please enter a comment"
#define request_timeout @"Request Timedout. Please try again"
#define profileData_not_available @"User data not available"
#define favorited_success @"Added to Favorites"
#define unfavorited_success @"Removed from Favorites"
#define favorite_failed @"Failed adding to Favorites"
#define unfavorite_failed @"Failed removing from Favorites"
#define searchText_blank @"Enter search text"
#define firstNM_blank @"Please enter your First name"
#define lastNM_blank @"Please enter your Last name"
#define pwd_blank @"Please enter your password"

#define email_blank @"Please enter your Email address"
#define Forgot_valid_email @"Email provided not recognized"
#define valid_email @"Please enter valid email address."
#define profile_update_success @"Your Profile was updated successfully"
#define incorrect_email @"Incorrect email address"
#define forgot_password @"Your password has been sent to your email address"
#define profileUpdate_success @"Profile updated successfully"
#define profileUpdate_failed @"Update Failed. Please try again"

#define m_check_termsprivacy @"Please read Terms of Use and Privacy Policy"

#define Place_not_found @"No places found"
#define openWeb_error @"Unable to open website"
#define image_not_available @"Image not available"
#define enter_Password @"A Password is required"
#define quickbloxID_not_available @"Unable to login into Chat. Please login or create a new account"
#define InvalidUser @"The email or password you entered is incorrect"
#define information_not_available @"Information not available"
#define favorite_not_available @"No favorited homes found"
#define newsfeed_information_not_available @"Enter a Keyword or Geographic Region of Interest into the Search Text Box"
#define flaged_Confirmation @"Are you sure you want to Report this Post for further review?"
#define Comment_flaged_Confirmation @"Are you sure you want to Report this Comment for further review?"

#define chat_ID_Blank @"Realtor unavailable to chat"
#define followed_success @"You are Following this Realtor"
#define follow_failed @"Follow Request Failed.  Please try again"
#define unfollow_success @"You are Unfollowing this Realtor"
#define unfollow_failed @"Unfollow Request Failed.  Please try again"

#define m_handleremote_notification_error @"Error"
#define m_oldpass_blank @"Old password is required"
#define m_newpass_blank @"New password is required"
#define m_valid_pass @"Passwords are required to be a minimum of 8 characters in length"
#define m_passchange_success @"Password Updated!"
#define m_passchange_failed @"Please enter correct details"

#define m_comingsoon @"Coming soon"
#define m_comment_delete @"Are you sure you want to delete the comment?"

#define m_username_blank @"Username required"
#define m_pass_blank @"Password is required"
#define m_city_blank @"City is required"
#define m_state_blank @"State is required"
#define m_password_blank @"Passwortd is required"
#define m_password_not_match @"Your password entries do not match"

#define m_home_not_available @"No Listings available"

#define m_address_blank @"Address is required"
#define m_zipcode_blank @"Zip code is required"
#define m_valid_zipcode @"Please provide a valid Zip code"

#define m_homevalue_not_found @"Unfortunately, we could not get the value of this home at this time. Please try again later"

#define m_call_agent @"Call Listing Agent?"
#define m_call_error @"Unable to make phone call at this time"

#define m_logout_conform @"Are you sure you want to Logout?"
#define m_check_login @"Login is required"
#define m_fb_login_error @"Your current session is no longer valid. Please login again"

#define m_myprofiledata_not_available @"Post not found"

#define m_GPS_not_available @"Please enable 'Location Services' to get nearby listings"
#define m_TWSharing_cancel @"Sharing with Twitter is canceled"
#define m_FBSharing_Cancel @"Sharing with Facebook is canceled"
#define m_images_add_success @"Image posted successfully on your wall"
#define m_fbaccount_not_available @"There are no Facebook accounts configured. You can add or create a Facebook account in Settings"
#define m_twitteraccount_not_available @"There area no Twitter accounts configured. You can add or create a Twitter account in Settings"
#define m_searchtag_delete_error @"Fail to delete tag"

#define m_username_not_available @"Email is currently in use"
#define m_registration_success @"Your User Account has been successfully created"
#define m_network_lost @"The network connection was lost"

#define m_chatstatus_not_change @"Chat Status Error"
#define m_agent_delete @"Do you want to delete this real estate agent?"
#define m_uesr_call_not_answer @"User isn't answering. Please try again"
#define m_uesr_call_reject @"User has rejected your call"

#define m_record_save @"Record saved successfully"
#define m_location_start @"Please start your location service"

#define m_UnregisterForDetail @"Agent is not registered with Realstir"

#define m_ContactAgentFailed @"We are unable to sent message. Please try again"

#define m_Suggetion_success @"Your suggestions have been sent"

#define m_Suggetion_faild @"Failed to send your suggestions. Please try again"

#define m_agent_not_registered @"This Realtor has not claimed this listing yet, Realstir will notify them of your pending inquiry, however, a response is not guaranteed"
#define m_agent_offline @"Your message has been delivered, but the Realtor's status is currently unavailable"
#define m_unableToCall @"Unable to make phone call at this time"

#define m_facebook_share_link @"http://www.apple.com/itunes"
#define m_have_suggestions_link @"info@realstir.com"
#define m_IsRatingAvailable @"NO" //YES
#define m_APP_ID @"541367070"  //541367070
#define m_FBShareLine @"https://fb.me/1595011414049078"
#endif
