//
//  KSEItem.m
//  EasyAudioGuide
//
//  Created by 김 은지 on 13. 5. 22..
//  Copyright (c) 2013년 EunjiKim. All rights reserved.
//

#import "KSEItem.h"

@implementation KSEItem

@synthesize objectId;
@synthesize audio_file;
@synthesize description;
@synthesize name;
@synthesize parent;
@synthesize createdAt;
@synthesize updatedAt;
@synthesize ACL;
@synthesize number;
@synthesize latitude;
@synthesize longitude;
@synthesize image_file;
@synthesize seq;

- (id) init
{
    if (self = [super init]) {
        objectId = NULL;
        audio_file = NULL;
        description = NULL;
        name = NULL;
        parent = NULL;
        createdAt = NULL;
        updatedAt = NULL;
        ACL = NULL;
        number = NULL;
        latitude = NULL;
        longitude = NULL;
        image_file = NULL;
        seq = NULL;
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:objectId forKey:@"objectId"];
    [aCoder encodeObject:audio_file forKey:@"audio_file"];
    [aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:description forKey:@"description"];
    [aCoder encodeObject:parent forKey:@"parent"];
    [aCoder encodeObject:createdAt forKey:@"createdAt"];
    [aCoder encodeObject:updatedAt forKey:@"updatedAt"];
    [aCoder encodeObject:ACL forKey:@"ACL"];
    [aCoder encodeObject:number forKey:@"number"];
    [aCoder encodeObject:latitude forKey:@"latitude"];
    [aCoder encodeObject:longitude forKey:@"longitude"];
    [aCoder encodeObject:image_file forKey:@"image_file"];
    [aCoder encodeObject:seq forKey:@"seq"];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [[KSEItem alloc] init];
    if (self = [super init]) {
        objectId = [aDecoder decodeObjectForKey:@"objectId"];
        audio_file = [aDecoder decodeObjectForKey:@"audio_file"];
        name = [aDecoder decodeObjectForKey:@"name"];
        description = [aDecoder decodeObjectForKey:@"description"];
        parent = [aDecoder decodeObjectForKey:@"parent"];
        createdAt = [aDecoder decodeObjectForKey:@"createdAt"];
        updatedAt = [aDecoder decodeObjectForKey:@"updatedAt"];
        ACL = [aDecoder decodeObjectForKey:@"ACL"];
        number = [aDecoder decodeObjectForKey:@"number"];
        latitude = [aDecoder decodeObjectForKey:@"latitude"];
        longitude = [aDecoder decodeObjectForKey:@"longitude"];
        image_file = [aDecoder decodeObjectForKey:@"image_file"];
        seq = [aDecoder decodeObjectForKey:@"seq"];
    }
    return self;
}

@end
