//
//  KSEGuide.m
//  EasyAudioGuide
//
//  Created by 김 은지 on 13. 5. 22..
//  Copyright (c) 2013년 EunjiKim. All rights reserved.
//

#import "KSEGuide.h"
#import "KSEContainer.h"


@implementation KSEGuide

@synthesize objectId;
@synthesize name;
@synthesize parent;
@synthesize createdAt;
@synthesize updatedAt;
@synthesize ACL;
@synthesize image_file;


- (id) init
{
    if (self = [super init]) {
        objectId = NULL;
        name = NULL;
        parent = NULL;
        templates = NULL;
        createdAt = NULL;
        updatedAt = NULL;
        ACL = NULL;
        image_file = NULL;
        
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:objectId forKey:@"objectId"];
    [aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:parent forKey:@"parent"];
    [aCoder encodeObject:templates forKey:@"templates"];
    [aCoder encodeObject:createdAt forKey:@"createdAt"];
    [aCoder encodeObject:updatedAt forKey:@"updatedAt"];
    [aCoder encodeObject:ACL forKey:@"ACL"];
    [aCoder encodeObject:image_file forKey:@"image_file"];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [[KSEGuide alloc] init];
    if (self = [super init]) {
        objectId = [aDecoder decodeObjectForKey:@"objectId"];
        name = [aDecoder decodeObjectForKey:@"name"];
        parent = [aDecoder decodeObjectForKey:@"parent"];
        templates = [aDecoder decodeObjectForKey:@"templates"];
        createdAt = [aDecoder decodeObjectForKey:@"createdAt"];
        updatedAt = [aDecoder decodeObjectForKey:@"updatedAt"];
        ACL = [aDecoder decodeObjectForKey:@"ACL"];
        image_file = [aDecoder decodeObjectForKey:@"image_file"];
        
    }
    return self;
}


@end
