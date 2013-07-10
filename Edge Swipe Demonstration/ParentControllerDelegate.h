//
//  ParentControllerDelegate.h
//  deleteme4
//
//  Created by Robert Ryan on 6/13/13.
//  Copyright (c) 2013 Robert Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Protocol used for "pushing" and "popping" scenes.
 */

@protocol ParentControllerDelegate <NSObject>

/*********************************************
 * @name Methods
 *********************************************/

/** Push child view controller onto stack.
 
 @param newChildController The view controller to which you are pushing.
 */

- (void)pushChildViewController:(UIViewController *)newChildController;

/** Pop child view controller onto stack.
 
 @warning Note, while this visually appears to pop the child off the stack, it actually doesn't pop it off, but rather keeps it on the stack so that we can swipe back to it if we need.

 */

- (void)popChildViewController;

/** Iterate through the gestures for the subviews of a scene's main view, making sure that we configure of those gestures to require the edge swipe gesture to fail. This ensures that the edge swipe gesture takes precencence.
 
 @param childView The view for whom we'll iterate through its subviews, making sure that any gesture recognizers they have will
 
 @note Calling this method is generally not needed, but if the scene has a scroll view or web view, this avoids ambiguity as to when the edge swipe gesture will take place.
 
 @warning Note, if this is used in conjunction with text view, entering and exiting edit mode will cause gestures to be removed and added, and you might need to call this method again as the text view changes modes.
 */

- (void)requireEdgeGesturesToFailForView:(UIView *)childView;

@end
