//
//  KSEGuide.h
//  EasyAudioGuide
//
//  Created by 김 은지 on 13. 5. 22..
//  Copyright (c) 2013년 EunjiKim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSEContainer.h"

@interface KSEGuide : NSObject <NSCoding>
{
    NSString *objectId;
    NSString *name;
    KSEContainer *parent;
    NSArray  *templates;
    NSString *createdAt;
    NSString *updatedAt;
    NSString *ACL;
    PFFile   *image_file;
}

@property NSString *objectId;
@property NSString *name;
@property KSEContainer *parent;
@property NSArray  *templates;
@property NSString *createdAt;
@property NSString *updatedAt;
@property NSString *ACL;
@property PFFile   *image_file;


- (id) init;
- (void) encodeWithCoder:(NSCoder *)aCoder;
- (id) initWithCoder:(NSCoder *)aDecoder;

@end
