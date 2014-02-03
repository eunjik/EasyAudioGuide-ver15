//
//  KSEItem.h
//  EasyAudioGuide
//
//  Created by 김 은지 on 13. 5. 22..
//  Copyright (c) 2013년 EunjiKim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSEGuide.h"

@interface KSEItem : NSObject <NSCoding>
{
    NSString *objectId;
    NSString *audio_file;
    NSString *description;
    NSString *name;
    KSEGuide *parent;
    NSString *createdAt;
    NSString *updatedAt;
    NSString *ACL;
    NSNumber *number;
    NSString *latitude;
    NSString *longitude;
    PFFile *image_file;
    NSNumber *seq;
}

@property NSString *objectId;
@property NSString *audio_file;
@property NSString *description;
@property NSString *name;
@property KSEGuide *parent;
@property NSString *createdAt;
@property NSString *updatedAt;
@property NSString *ACL;
@property NSNumber *number;
@property NSString *latitude;
@property NSString *longitude;
@property PFFile *image_file;
@property NSNumber *seq;

-(id)init;
- (void) encodeWithCoder:(NSCoder *)aCoder;
- (id) initWithCoder:(NSCoder *)aDecoder;

@end
