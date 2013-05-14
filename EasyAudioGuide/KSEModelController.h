//
//  KSEModelController.h
//  EasyAudioGuide
//
//  Created by 김 은지 on 13. 5. 15..
//  Copyright (c) 2013년 EunjiKim. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KSEDataViewController;

@interface KSEModelController : NSObject <UIPageViewControllerDataSource>

- (KSEDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(KSEDataViewController *)viewController;

@end
