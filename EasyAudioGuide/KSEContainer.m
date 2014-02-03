//
//  KSEContainer.m
//  EasyAudioGuide
//
//  Created by 김 은지 on 13. 5. 22..
//  Copyright (c) 2013년 EunjiKim. All rights reserved.
//

#import "KSEContainer.h"

@implementation KSEContainer

@synthesize     objectId;
@synthesize     addr;
@synthesize     latitude;
@synthesize     longitude;
@synthesize     name;
@synthesize     owner;
@synthesize     phone;
@synthesize     website;
@synthesize     createdAt;
@synthesize     updatedAt;
@synthesize     ACL;
@synthesize     distance;
@synthesize     file;
@synthesize     image;
@synthesize     intro;
@synthesize     contentProvider;
@synthesize     radiusForLock;

- (id) init
{
    if (self = [super init]) {
        objectId = NULL;
        addr = NULL;
        latitude = NULL;
        longitude = NULL;
        name = NULL;
        owner = NULL;
        phone = NULL;
        website = NULL;
        createdAt = NULL;
        updatedAt = NULL;
        ACL = NULL;
        distance = NULL;
        file = NULL;
        image = NULL;
        intro = NULL;
        contentProvider = NULL;
        radiusForLock = NULL;
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:objectId forKey:@"objectId"];
    [aCoder encodeObject:addr forKey:@"addr"];
    [aCoder encodeObject:latitude forKey:@"latitude"];
    [aCoder encodeObject:longitude forKey:@"longitude"];
    
    [aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:owner forKey:@"owner"];
    [aCoder encodeObject:phone forKey:@"phone"];
    [aCoder encodeObject:website forKey:@"website"];
    [aCoder encodeObject:createdAt forKey:@"createdAt"];
    [aCoder encodeObject:updatedAt forKey:@"updatedAt"];
    [aCoder encodeObject:ACL forKey:@"ACL"];
    [aCoder encodeInteger:distance forKey:@"distance"];
    [aCoder encodeObject:file forKey:@"file"];
    [aCoder encodeObject:image forKey:@"image"];
    [aCoder encodeObject:intro forKey:@"intro"];
    [aCoder encodeObject:contentProvider forKey:@"contentProvider"];
    [aCoder encodeInteger:radiusForLock forKey:@"radiusForLock"];
    
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [[KSEContainer alloc] init];
    if (self = [super init]) {
        objectId = [aDecoder decodeObjectForKey:@"objectId"];
        addr = [aDecoder decodeObjectForKey:@"addr"];
        latitude = [aDecoder decodeObjectForKey:@"latitude"];
        longitude = [aDecoder decodeObjectForKey:@"longitude"];
        
        name = [aDecoder decodeObjectForKey:@"name"];
        owner = [aDecoder decodeObjectForKey:@"owner"];
        phone = [aDecoder decodeObjectForKey:@"phone"];
        website = [aDecoder decodeObjectForKey:@"website"];
        createdAt = [aDecoder decodeObjectForKey:@"createdAt"];
        updatedAt = [aDecoder decodeObjectForKey:@"updatedAt"];
        ACL = [aDecoder decodeObjectForKey:@"ACL"];
        distance = [aDecoder decodeIntegerForKey:@"distance"];
        file = [aDecoder decodeObjectForKey:@"file"];
        image = [aDecoder decodeObjectForKey:@"image"];
        intro = [aDecoder decodeObjectForKey:@"intro"];
        contentProvider = [aDecoder decodeObjectForKey:@"contentProvider"];
        radiusForLock = [aDecoder decodeIntegerForKey:@"radiusForLock"];
        
    }
    return self;
}

@end
