// ----------------------------------------
// ExampleBasic.m
// Generated by Coma 1.0.
// Do not edit this file - it is automatically generated and your changes will be overwritten.
// ----------------------------------------

#import "ExampleBasic.h"
#import "CustomClass.h"

@implementation ExampleBasic


#pragma mark - Introspection

/**
 Some static arrays containing lists of properties. These are populated once at +initialize time.
 */

static NSArray* sExampleProperties = nil;
static NSArray* sExampleRelationships = nil;
static NSArray* sExampleAttributes = nil;


/**
 Returns a list of NSStrings with the names of the properties in it.
 @return Array of property names.
 */

+ (NSArray*)propertyNames {
    if (!sExampleProperties) {
        sExampleProperties = @[
                             @"string",
                             @"integer",
                             @"custom",
                             @"point",
                             @"unsignedInteger",
                             @"rect",
                             @"date",
                             @"boolean",
                             @"real",
              ];

        if ([super respondsToSelector:@selector(propertyNames)])
            sExampleProperties = [sExampleProperties arrayByAddingObjectsFromArray:[super performSelector:@selector(propertyNames)]];
    }

    return sExampleProperties;
}


/**
 Returns a list of NSStrings with the names of the relationship properties in it.
 @return Array of relationship names.
 */

+ (NSArray*)relationshipNames {
    if (!sExampleRelationships) {
        sExampleRelationships = @[
              ];

        if ([super respondsToSelector:@selector(relationshipNames)])
            sExampleRelationships = [sExampleRelationships arrayByAddingObjectsFromArray:[super performSelector:@selector(relationshipNames)]];
    }

    return sExampleProperties;
}


/**
 Returns a list of NSStrings with the names of the attribute properties in it.
 @return Array of attribute names.
 */

+ (NSArray*)attributeNames {
    if (!sExampleAttributes) {
        sExampleAttributes = @[
                             @"string",
                             @"integer",
                             @"custom",
                             @"point",
                             @"unsignedInteger",
                             @"rect",
                             @"date",
                             @"boolean",
                             @"real",
              ];

        if ([super respondsToSelector:@selector(attributeNames)])
            sExampleAttributes = [sExampleAttributes arrayByAddingObjectsFromArray:[super performSelector:@selector(attributeNames)]];
    }

    return sExampleProperties;
}


#pragma mark - NSCoder

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.string forKey:@"string"];
    [coder encodeObject:@(self.integer) forKey:@"integer"];
    [coder encodeObject:self.custom forKey:@"custom"];
    [coder encodeObject:NSStringFromPoint(self.point) forKey:@"point"];
    [coder encodeObject:@(self.unsignedInteger) forKey:@"unsignedInteger"];
    [coder encodeObject:NSStringFromRect(self.rect) forKey:@"rect"];
    [coder encodeObject:self.date forKey:@"date"];
    [coder encodeObject:@(self.boolean) forKey:@"boolean"];
    [coder encodeObject:@(self.real) forKey:@"real"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _string = [coder decodeObjectForKey:@"string"];
        [[coder decodeObjectForKey:@"integer"] getValue:&_integer];
        _custom = [coder decodeObjectForKey:@"custom"];
        _point = NSPointFromString([coder decodeObjectForKey:@"point"]);
        [[coder decodeObjectForKey:@"unsignedInteger"] getValue:&_unsignedInteger];
        _rect = NSRectFromString([coder decodeObjectForKey:@"rect"]);
        _date = [coder decodeObjectForKey:@"date"];
        [[coder decodeObjectForKey:@"boolean"] getValue:&_boolean];
        [[coder decodeObjectForKey:@"real"] getValue:&_real];
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    ExampleBasic* copy = [super copyWithZone:zone];

    copy.string = [self.string copyWithZone:zone];
    copy.integer = self.integer;
    copy.custom = [self.custom deepCopyWithZone:zone];
    copy.point = self.point;
    copy.unsignedInteger = self.unsignedInteger;
    copy.rect = self.rect;
    copy.date = [self.date copyWithZone:zone];
    copy.boolean = self.boolean;
    copy.real = self.real;

    return copy;
}

@end
