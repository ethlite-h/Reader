//
//  NSManagedObjectContext-CocoaWithLove.h
//  HelloCoreData
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (CocoaWithLove)

- (NSArray *)fetchObjectsForEntityName:(NSString *)newEntityName sortDescriptor:(NSSortDescriptor *)sortDescriptor predicate:(id)stringOrPredicate, ...;

@end
