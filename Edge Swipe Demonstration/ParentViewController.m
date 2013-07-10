//
//  ParentViewController.m
//  Edge Swipe Demonstration
//
//  Created by Robert Ryan on 7/9/13.
//  Copyright (c) 2013 Robert Ryan. All rights reserved.
//

#import "ParentViewController.h"
#import "EdgeSwipeGestureRecognizer.h"
#import <QuartzCore/QuartzCore.h>

@interface ParentViewController ()

@property (nonatomic) NSInteger currentChildIndex;
@property (nonatomic, strong) NSMutableArray *edgeGestureRecognizers;

@end

@implementation ParentViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        EdgeSwipeGestureRecognizer *gesture;
        _edgeGestureRecognizers = [[NSMutableArray alloc] init];
        
        gesture = [[EdgeSwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        gesture.side = kEdgeSwipeGestureRecognizerLeft;
        [_edgeGestureRecognizers addObject:gesture];
        
        gesture = [[EdgeSwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        gesture.side = kEdgeSwipeGestureRecognizerRight;
        [_edgeGestureRecognizers addObject:gesture];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (EdgeSwipeGestureRecognizer *gesture in self.edgeGestureRecognizers)
    {
        [self.view addGestureRecognizer:gesture];
    }
    
    // if targeting iOS 6 and later, you could use a "container view" in Interface Builder. But
    // if using iOS version prior to 6, you can't use the "container view", but rather have to create
    // the child yourself manually like this:
    
    // UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Child"];
    // [self addChildViewController:controller];
    // controller.view.frame = self.containerView.frame;
    // [self.containerView addSubview:controller.view];
    // [controller didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ParentControllerDelegate

- (void)pushChildViewController:(UIViewController *)newChildController
{
    // remove any other children that we've popped off, but are still lingering about
    
    for (NSInteger index = [self.childViewControllers count] - 1; index > self.currentChildIndex; index--)
    {
        UIViewController *childController = self.childViewControllers[index];
        [childController willMoveToParentViewController:nil];
        [childController.view removeFromSuperview];
        [childController removeFromParentViewController];
    }
    
    // get reference to the current child controller
    
    UIViewController *currentChildController = self.childViewControllers[self.currentChildIndex];
    
    // set new child to be off to the right
    
    CGRect frame = self.containerView.bounds;
    frame.origin.x += frame.size.width;
    newChildController.view.frame = frame;
    
    // add the new child
    
    [self addChildViewController:newChildController];
    [self.containerView addSubview:newChildController.view];
    [self addShadow:newChildController.view];
    [newChildController didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:0
                     animations:^{
                         CGRect frame = self.containerView.bounds;
                         newChildController.view.frame = frame;
                         frame.origin.x -= frame.size.width;
                         currentChildController.view.frame = frame;
                     }
                     completion:^(BOOL finished){
                         [self removeShadow:newChildController.view];
                     }];
    
    self.currentChildIndex++;
}

- (void)popChildViewController
{
    if (self.currentChildIndex == 0)
        return;
    
    UIViewController *currentChildController = self.childViewControllers[self.currentChildIndex];
    self.currentChildIndex--;
    UIViewController *previousChildController = self.childViewControllers[self.currentChildIndex];
    
    CGRect onScreenFrame = self.containerView.bounds;
    
    CGRect offToTheRightFrame = self.containerView.bounds;
    offToTheRightFrame.origin.x += offToTheRightFrame.size.width;
    
    [self addShadow:previousChildController.view];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:0
                     animations:^{
                         currentChildController.view.frame = offToTheRightFrame;
                         previousChildController.view.frame = onScreenFrame;
                     }
                     completion:^(BOOL finished) {
                         [self removeShadow:previousChildController.view];
                     }];
}

- (void)requireEdgeGesturesToFailForView:(UIView *)childView
{
    for (UIView *subview in childView.subviews)
    {
        for (UIGestureRecognizer *gesture in subview.gestureRecognizers)
        {
            for (UIGestureRecognizer *edgeGesture in self.edgeGestureRecognizers)
            {
                [gesture requireGestureRecognizerToFail:edgeGesture];
            }
        }
    }
    
}

#pragma mark - Gesture handler

- (void)handlePan:(EdgeSwipeGestureRecognizer *)gesture
{
    static UIView *currentView;
    static UIView *previousView;
    static UIView *nextView;
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        // identify previous view (if any)
        
        if (self.currentChildIndex > 0)
        {
            UIViewController *previous = self.childViewControllers[self.currentChildIndex - 1];
            previousView = previous.view;
        }
        else
        {
            previousView = nil;
        }
        
        // identify next view (if any)
        
        if (self.currentChildIndex < ([self.childViewControllers count] - 1))
        {
            UIViewController *next = self.childViewControllers[self.currentChildIndex + 1];
            nextView = next.view;
        }
        else
        {
            nextView = nil;
        }
        
        // identify current view
        
        UIViewController *current = self.childViewControllers[self.currentChildIndex];
        currentView = current.view;
        [self addShadow:currentView];
    }
    
    // if we're in the middle of a pan, let's adjust the center of the views accordingly
    
    CGPoint translation = [gesture translationInView:gesture.view];
    
    previousView.transform = CGAffineTransformMakeTranslation(translation.x, 0.0);
    currentView.transform = CGAffineTransformMakeTranslation(translation.x, 0.0);
    nextView.transform = CGAffineTransformMakeTranslation(translation.x, 0.0);
    
    // if we're all done, let's animate the completion (or if we didn't move far enough,
    // the reversal) of the pan gesture
    
    if (gesture.state == UIGestureRecognizerStateEnded ||
        gesture.state == UIGestureRecognizerStateCancelled ||
        gesture.state == UIGestureRecognizerStateFailed)
    {
        
        CGPoint center = currentView.center;
        CGPoint currentCenter = CGPointMake(center.x + translation.x, center.y);
        CGPoint offRight = CGPointMake(center.x + currentView.frame.size.width, center.y);
        CGPoint offLeft = CGPointMake(center.x - currentView.frame.size.width, center.y);
        
        CGPoint velocity = [gesture velocityInView:gesture.view.superview];
        
        if ((translation.x + velocity.x * 0.5) < (-self.containerView.frame.size.width / 2.0) && nextView)
        {
            // if we finished pan to left, reset transforms
            
            previousView.transform = CGAffineTransformIdentity;
            currentView.transform = CGAffineTransformIdentity;
            nextView.transform = CGAffineTransformIdentity;
            
            // set the starting point of the animation to pick up from where
            // we had previously transformed the views
            
            CGPoint nextCenter = CGPointMake(nextView.center.x + translation.x, nextView.center.y);
            currentView.center = currentCenter;
            nextView.center = nextCenter;
            
            // and animate the moving of the views to their final resting points,
            // adjusting the currentChildIndex appropriately
            
            [UIView animateWithDuration:0.25
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 currentView.center = offLeft;
                                 nextView.center = center;
                                 self.currentChildIndex++;
                             }
                             completion:^(BOOL finished){
                                 [self removeShadow:currentView];
                             }];
        }
        else if ((translation.x + velocity.x * 0.5) > (self.containerView.frame.size.width / 2.0) && previousView)
        {
            // if we finished pan to right, reset transforms
            
            previousView.transform = CGAffineTransformIdentity;
            currentView.transform = CGAffineTransformIdentity;
            nextView.transform = CGAffineTransformIdentity;
            
            // set the starting point of the animation to pick up from where
            // we had previously transformed the views
            
            CGPoint previousCenter = CGPointMake(previousView.center.x + translation.x, previousView.center.y);
            currentView.center = currentCenter;
            previousView.center = previousCenter;
            
            // and animate the moving of the views to their final resting points,
            // adjusting the currentChildIndex appropriately
            
            [UIView animateWithDuration:0.25
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 currentView.center = offRight;
                                 previousView.center = center;
                                 self.currentChildIndex--;
                             }
                             completion:^(BOOL finished){
                                 [self removeShadow:currentView];
                             }];
        }
        else
        {
            [UIView animateWithDuration:0.25
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 previousView.transform = CGAffineTransformIdentity;
                                 currentView.transform = CGAffineTransformIdentity;
                                 nextView.transform = CGAffineTransformIdentity;
                             }
                             completion:^(BOOL finished){
                                 [self removeShadow:currentView];
                             }];
        }
    }
}

#pragma mark - Shadow utility methods

- (void)addShadow:(UIView *)view
{
    view.layer.shadowColor = [[UIColor blackColor] CGColor];
    view.layer.shadowOpacity = 0.5;
    view.layer.shadowRadius = 10.0;
    [view.layer setShouldRasterize:YES];
    [view.superview bringSubviewToFront:view];
}

- (void)removeShadow:(UIView *)view
{
    view.layer.shadowRadius = 0.0;
    view.layer.shadowOpacity = 0.0;
    view.layer.shadowColor = [[UIColor clearColor] CGColor];
    [view.layer setShouldRasterize:NO];
}

@end
