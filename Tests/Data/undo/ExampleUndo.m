// ----------------------------------------
// ExampleUndo.m
// Generated by Coma 1.0.
// Do not edit this file - it is automatically generated and your changes will be overwritten.
// ----------------------------------------

#import "ExampleUndo.h"

@implementation ExampleUndo

/**
 Set boolean to new value.
 @param value The new value for boolean.
*/

- (void)setBoolean:(BOOL)value {
    if (self.boolean != value) {
        [[self.undoManager prepareWithInvocationTarget:self] setBoolean:self.boolean];
        [self.undoManager setActionName:@"Set Boolean"];
        [super setBoolean:value];
    }
}

/**
 Set custom to new value.
 @param value The new value for custom.
*/

- (void)setCustom:(CustomClass*)value {
    if (self.custom != value) {
    if (![self isEqual:value]) {
            [self.undoManager registerUndoWithTarget:self selector:_cmd object:self.custom];
            [self.undoManager setActionName:@"Set Custom"];
            [super setCustom:value];
    }
    }
}

/**
 Set date to new value.
 @param value The new value for date.
*/

- (void)setDate:(NSDate*)value {
    if (self.date != value) {
    if (![self isEqual:value]) {
            [self.undoManager registerUndoWithTarget:self selector:_cmd object:self.date];
            [self.undoManager setActionName:@"Set Date"];
            [super setDate:value];
    }
    }
}

/**
 Set integer to new value.
 @param value The new value for integer.
*/

- (void)setInteger:(NSInteger)value {
    if (self.integer != value) {
        [[self.undoManager prepareWithInvocationTarget:self] setInteger:self.integer];
        [self.undoManager setActionName:@"Set Integer"];
        [super setInteger:value];
    }
}

/**
 Set point to new value.
 @param value The new value for point.
*/

/**
 Set point to new value.
 @param value The new value for point.
 */
- (void)setPoint:(NSPoint)value {
    if (!NSEqualPoints(self.point, value)) {
        [[self.undoManager prepareWithInvocationTarget:self]
                setPoint:self.point];
        [self.undoManager setActionName:@"Set Point"];
        [super setPoint:value];
    }
}

/**
 Set real to new value.
 @param value The new value for real.
*/

- (void)setReal:(CGFloat)value {
    if (self.real != value) {
        [[self.undoManager prepareWithInvocationTarget:self] setReal:self.real];
        [self.undoManager setActionName:@"Set Real"];
        [super setReal:value];
    }
}

/**
 Set rect to new value.
 @param value The new value for rect.
*/

/**
 Set rect to new value.
 @param value The new value for rect.
 */
- (void)setRect:(NSRect)value {
    if (!NSEqualRects(self.rect, value)) {
        [[self.undoManager prepareWithInvocationTarget:self]
                setRect:self.rect];
        [self.undoManager setActionName:@"Set Rect"];
        [super setRect:value];
    }
}

/**
 Set string to new value.
 @param value The new value for string.
*/

- (void)setString:(NSString*)value {
    if (self.string != value) {
    if (![self isEqual:value]) {
            [self.undoManager registerUndoWithTarget:self selector:_cmd object:self.string];
            [self.undoManager setActionName:@"Set String"];
            [super setString:value];
    }
    }
}

/**
 Set unsignedInteger to new value.
 @param value The new value for unsignedInteger.
*/

- (void)setUnsignedInteger:(NSUInteger)value {
    if (self.unsignedInteger != value) {
        [[self.undoManager prepareWithInvocationTarget:self] setUnsignedInteger:self.unsignedInteger];
        [self.undoManager setActionName:@"Set UInteger"];
        [super setUnsignedInteger:value];
    }
}

@end
