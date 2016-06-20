//
//  Constants.h
//  Paramedic
//
//  Created by Asad Tkxel on 29/01/2015.
//
//

#ifndef Paramedic_Constants_h
#define Paramedic_Constants_h



#define kTableViewRowHeight 85.0
#define kTableViewNumberOfRows 2
#define kTableViewNumberOfSections 1


#define kTextviewtag 100
#define kImageViewTag 200
#define kCornerRadiusPoints 10
#define kTextViewFontSize 22.0
#define kiPadTextViewFontSize 41.0
#define kDosingFlipAnimationDuration 1.0
#define kCardiologyFlipAnimationDuration 0.80
#define kSwipAnimationDuration 0.5
#define kOrientationChangingDuration 0.2


#define kUrlForSharing @"www.code3-apps.com"

#define kAddToBookMarkText @"Add to Bookmarks"
#define kUnbookmarkText @"Unbookmark"
#define kExplanationText @"Explanation:"
#define kHintText @"Hint:"
#define kEquationText @"Equation:"
#define kAnswerText @"Answer:"
#define kDosingNaviagtionBarTitle @"Dosing"
#define kCardiologyNanigationBarTitle @"Cardiology"
#define kBookmarkNavigationBarTitle @"Bookmarks"


#define kCellReuseableIdentifier @"mainQuizCell"
#define kCellNibName @"CustomMainViewCell"
#define kDosingQuestionControllerNibName @"DosingQuestionsViewController"
#define kCardiologyNibName @"CardiologyQuestionsViewController"
#define kCardiologyExplanationControllerNibName @"CardiologyExplanationVieControllerViewController"
#define kScenarioImageControllerNibName @"SceneImageViewController"
#define kiPadDosingControllerNibName @"DosingViewController-iPad"
#define kiPadDosingQuestionControllerNibName @"DosingQuestionsViewController-iPad"
#define kiPadCardiologyControllerNibName @"CardiologyViewController-iPad"
#define kiPadCardiologyQuestionControllerNibName @"CardiologyQuestionViewController-iPad"
#define kiPadCardiologyExplanationControllerNibName @"CardiologyExplanationViewController-iPad"
#define kiPadScenarioImageControllerNibName @"SceneImageViewController-iPad"


#define kDosingBookmarkedQuestionsKey @"Dosing_Bookmarked_Questions"
#define kCardiologyBookmarkedQuestionsKey @"Cardiology_Bookmarked_Questions"
#define kTempCardiologyBookmarkedQuestionsKey @"Temp_Cardiology_Bookmarked_Questions"
#define kDeviceOrientationKey @"orientation"
#define kFlipAnimationKey @"View Flip"
#define kSavedDosingCardIndexKey @"Dosing_Card_Index"
#define kSavedCardiologyCardIndexKey @"Cardiology_Card_Index"


#define kQuitCardTitle @"Quit Cards"
#define kQuitCardMessage @"Do you want to save this cards to continue at a later time?"
#define kShowCardMessage @"Do you want to continue where you left off, or delete and start over?"
#define kQuitCardCancelButtonTitle @"YES"
#define kQuitCardOtherButtonTitle @"NO"
#define kShowCardCancelButtonTitle @"Delete"
#define kShowCardOtherButtonTitle @"Continue"


#define kFacebookFollowLink @"http://www.facebook.com/pages/Code-3-Apps/180948875248863"
#define kTwitterFollowLink @"http://twitter.com/#!/Code3Apps"
#define kBlogFollowLink @"http://code3-apps.com/"
#define kFireFighterFollowLink @"http://itunes.apple.com/us/app/firefighter-pocketbook/id483659354?mt=8"



typedef enum {
    SwipeDirectionLeft,
    SwipeDirectionRight,
    SwipeDirectionNone,
}SwipeDirection;

#endif
