//
//  Entry.h
//  Reader
//
//  Created by Helen Ma on 1/12/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Feed;
@interface Entry : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * publishDate;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * snippet;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSManagedObject *feed;
@property (nonatomic, retain) NSSet *mediaGroups;

+ (Entry *)newEntryInFeed: (Feed *)feed;

@end

@interface Entry (CoreDataGeneratedAccessors)

- (void)addMediaGroupsObject:(NSManagedObject *)value;
- (void)removeMediaGroupsObject:(NSManagedObject *)value;
- (void)addMediaGroups:(NSSet *)values;
- (void)removeMediaGroups:(NSSet *)values;

@end
