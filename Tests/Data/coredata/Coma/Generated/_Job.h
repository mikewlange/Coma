// ----------------------------------------
// _Job.h
// Generated by Coma 1.0.
// Do not edit this file - it is automatically generated and your changes will be overwritten.
// ----------------------------------------

@class Person;

@interface _Job : NSObject

/**
 Returns a list of NSStrings with the names of the properties in it.
 @return Array of property names.
 */

+ (NSArray*)propertyNames;

/**
 Returns a list of NSStrings with the names of the relationship properties in it.
 @return Array of relationship names.
 */

+ (NSArray*)relationshipNames;

/**
 Returns a list of NSStrings with the names of the attribute properties in it.
 @return Array of attribute names.
 */

+ (NSArray*)attributeNames;

@property (strong, nonatomic) NSString* name;

@property (strong, nonatomic) NSSet* staff;

- (void)primitiveAddStaffObject:(id)object;
- (void)primitiveRemoveStaffObject:(id)object;

/**
 Fake version of the CoreData init method. It actually just calls init.
 */

- (id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context;

@end