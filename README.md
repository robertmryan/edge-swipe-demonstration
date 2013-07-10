# Edge Swipe Demonstration

--

## Introduction

This is a sample implementation of a "swipe from the edge" gesture-based navigation, that not only allows you to swipe back to the previous scene, but also swipe forward back to the scene you just "popped" from. The idea is to illustrate some of the key concepts in such a navigation. This pre-dates iOS 7 UI (and thus doesn't mirror that UI entirely), but shares some common concepts. It doesn't actually provide the navigation bar user interface, so in this demo, I've just added navigation bars to the sample child view controllers (those listed in #5, below).

The key classes of this project include:

1. `EdgeSwipeGestureRecognizer` - A continuous gesture recognizer used to recognize panning gestures from the edge of the screen.

2. `EdgeSwipeSegue` - A custom segue that can be use for a push-like segue on a storyboard.

3. `ParentViewController` - A custom container view controller that provides the push, pop, and gesture navigation.

4. `ParentControllerDelegate` - A protocol that defines the public interface for the `ParentViewController`.

5. A series of sample view controllers, namely `FirstViewController`, `SecondViewController`, and `ChildViewController` (which is used for view controllers after the second one on the storyboard, but illustrates what you would do if your child controller has scroll view or something like that, which accepts gestures and goes right to the edge of the screen).

## Requirements

This was developed for iOS 6.1 using Xcode 4.6.3 and uses ARC. It should work fine in iOS 5, as well, but you cannot use the "container view" object in Interface Builder, and you would just replace that with a standard `UIView`, link that to the `containerView` of `ParentViewController.h`, and uncomment the code in `viewDidLoad` that manually loads the first child scene.

--

Robert M. Ryan

10 July 2013
