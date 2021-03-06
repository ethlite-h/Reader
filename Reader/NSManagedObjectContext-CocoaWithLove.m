#import "NSManagedObjectContext-CocoaWithLove.h"

@implementation NSManagedObjectContext (CocoaWithLove)

// Convenience method to fetch the array of objects for a given Entity
// name in the context, optionally limiting by a predicate or by a predicate
// made from a format NSString and variable arguments.
//
- (NSArray *)fetchObjectsForEntityName:(NSString *)newEntityName sortDescriptor:(NSSortDescriptor *)sortDescriptor predicate:(id)stringOrPredicate, ... {
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:newEntityName inManagedObjectContext:self];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:entity];
        
    if (sortDescriptor)
        [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];

    if (nil != stringOrPredicate) {
        
        NSPredicate *predicate;
        
        if ([stringOrPredicate isKindOfClass:[NSString class]]) {
            
            va_list variadicArguments;
            va_start(variadicArguments, stringOrPredicate);
            predicate = [NSPredicate predicateWithFormat:stringOrPredicate arguments:variadicArguments];
            va_end(variadicArguments);
            
        } else {
            
            NSAssert2([stringOrPredicate isKindOfClass:[NSPredicate class]], @"Second parameter passed to %s is of unexpected class %@", sel_getName(_cmd), [stringOrPredicate class]);
            
            predicate = (NSPredicate *)stringOrPredicate;
        }
        
        [request setPredicate:predicate];
        
    } // if (nil != stringOrPredicate)
    
    NSError *error = nil;
    NSArray *results = [self executeFetchRequest:request error:&error];
    
    if (error != nil) {
        
        [NSException raise:NSGenericException format:@"%@", [error description]];
        
    } // if (error != nil)
    
//    return [NSSet setWithArray:results];
    
    return results;
    
}

@end
