//
//  KSEContainer.h
//  EasyAudioGuide
//
//  Created by 김 은지 on 13. 5. 22..
//  Copyright (c) 2013년 EunjiKim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface KSEContainer : NSObject <NSCoding>
{
    NSString    *objectId;
    NSString    *addr;
    NSString  *latitude;
    NSString  *longitude;
    NSString    *name;
    PFUser      *owner;
    NSString    *phone;
    NSString    *website;
    NSString    *createdAt;
    NSString    *updatedAt;
    NSString    *ACL;
    NSInteger   *distance;
    PFFile     *file;
    UIImage    *image;
    NSString   *intro;
    NSString   *contentProvider;
    NSInteger  *radiusForLock;
}

@property NSString    *objectId;
@property NSString    *addr;
@property NSString    *latitude;
@property NSString    *longitude;
@property NSString    *name;
@property PFUser      *owner;
@property NSString    *phone;
@property NSString    *website;
@property NSString    *createdAt;
@property NSString    *updatedAt;
@property NSString    *ACL;
@property NSInteger   *distance;
@property PFFile    *file;
@property UIImage    *image;
@property NSString   *intro;
@property NSString   *contentProvider;
@property NSInteger  *radiusForLock;

- (id) init;
- (void) encodeWithCoder:(NSCoder *)aCoder;
- (id) initWithCoder:(NSCoder *)aDecoder;

@end
