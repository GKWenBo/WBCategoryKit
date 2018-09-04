//
//  NSArray+WBAdditional.h
//  WB_ArrayUtility
//
//  Created by WMB on 2017/6/17.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface NSArray (WBAdditional)

/**
 Creates and returns an array from a specified property list data.
 
 @param plist   A property list data whose root object is an array.
 @return A new array created from the plist data, or nil if an error occurs.
 */
+ (nullable NSArray *)wb_arrayWithPlistData:(NSData *)plist;

/**
 Creates and returns an array from a specified property list xml string.
 
 @param plist   A property list xml string whose root object is an array.
 @return A new array created from the plist string, or nil if an error occurs.
 */
+ (nullable NSArray *)wb_arrayWithPlistString:(NSString *)plist;
/**
 Serialize the array to a binary property list data.
 
 @return A bplist data, or nil if an error occurs.
 */
- (nullable NSData *)wb_plistData;

/**
 Serialize the array to a xml property list string.
 
 @return A plist xml string, or nil if an error occurs.
 */
- (nullable NSString *)wb_plistString;

/**
 Returns the object located at a random index.
 
 @return The object in the array with a random index value.
 If the array is empty, returns nil.
 */
- (nullable id)wb_randomObject;
/**
 Returns the object located at index, or return nil when out of bounds.
 It's similar to `objectAtIndex:`, but it never throw exception.
 
 @param index The object located at index.
 */
- (nullable id)wb_objectOrNilAtIndex:(NSUInteger)index;

/**
 Convert object to json string. return nil if an error occurs.
 NSString/NSNumber/NSDictionary/NSArray
 */
- (nullable NSString *)wb_jsonStringEncoded;

/**
 Convert object to json string formatted. return nil if an error occurs.
 */
- (nullable NSString *)wb_jsonPrettyStringEncoded;

/**
 数组第一个元素

 @return 第一个元素
 */
- (id)wb_firstObject;

/**
 打乱数组顺序

 @return 乱序后的数组
 */
- (NSArray *)wb_shuffledArray;

/**
 数组倒序

 @return 倒序后的数组
 */
- (NSArray *)wb_reversedArray;

/**
 去除数组相同的元素

 @return 去除后的数组
 */
- (NSArray *)wb_uniqueArray;

/**
 数组排序

 @param parameters 排序关键词
 @param ascending 降序升序
 @return 排序后的数组
 */
- (NSArray *)wb_arraySorting:(NSString *)parameters
                   ascending:(BOOL)ascending;

/**
 通过Plist名取到Plist文件中的数组

 @param name plist文件名
 @return 数组
 */
+ (NSArray *)wb_arrayFromPlistFileName:(NSString *)name;

@end

#pragma mark --------  可变数组  --------
@interface NSMutableArray (WB_Additionalb)
/**
 Creates and returns an array from a specified property list data.
 
 @param plist   A property list data whose root object is an array.
 @return A new array created from the plist data, or nil if an error occurs.
 */
+ (nullable NSMutableArray *)wb_arrayWithPlistData:(NSData *)plist;

/**
 Creates and returns an array from a specified property list xml string.
 
 @param plist   A property list xml string whose root object is an array.
 @return A new array created from the plist string, or nil if an error occurs.
 */
+ (nullable NSMutableArray *)wb_arrayWithPlistString:(NSString *)plist;

/**
 Removes the object with the lowest-valued index in the array.
 If the array is empty, this method has no effect.
 
 @discussion Apple has implemented this method, but did not make it public.
 Override for safe.
 */
- (void)wb_removeFirstObject;

/**
 Removes the object with the highest-valued index in the array.
 If the array is empty, this method has no effect.
 
 @discussion Apple's implementation said it raises an NSRangeException if the
 array is empty, but in fact nothing will happen. Override for safe.
 */
- (void)wb_removeLastObject;

/**
 Removes and returns the object with the lowest-valued index in the array.
 If the array is empty, it just returns nil.
 
 @return The first object, or nil.
 */
- (nullable id)wb_popFirstObject;

/**
 Removes and returns the object with the highest-valued index in the array.
 If the array is empty, it just returns nil.
 
 @return The first object, or nil.
 */
- (nullable id)wb_popLastObject;

/**
 Inserts a given object at the end of the array.
 
 @param anObject The object to add to the end of the array's content.
 This value must not be nil. Raises an NSInvalidArgumentException if anObject is nil.
 */
- (void)wb_appendObject:(id)anObject;

/**
 Inserts a given object at the beginning of the array.
 
 @param anObject The object to add to the end of the array's content.
 This value must not be nil. Raises an NSInvalidArgumentException if anObject is nil.
 */
- (void)wb_prependObject:(id)anObject;

/**
 Adds the objects contained in another given array to the end of the receiving
 array's content.
 
 @param objects An array of objects to add to the end of the receiving array's
 content. If the objects is empty or nil, this method has no effect.
 */
- (void)wb_appendObjects:(NSArray *)objects;
/**
 Adds the objects contained in another given array to the beginnin of the receiving
 array's content.
 
 @param objects An array of objects to add to the beginning of the receiving array's
 content. If the objects is empty or nil, this method has no effect.
 */
- (void)wb_prependObjects:(NSArray *)objects;

/**
 Adds the objects contained in another given array at the index of the receiving
 array's content.
 
 @param objects An array of objects to add to the receiving array's
 content. If the objects is empty or nil, this method has no effect.
 
 @param index The index in the array at which to insert objects. This value must
 not be greater than the count of elements in the array. Raises an
 NSRangeException if index is greater than the number of elements in the array.
 */
- (void)wb_insertObjects:(NSArray *)objects
                 atIndex:(NSUInteger)index;
/**
 Reverse the index of object in this array.
 Example: Before @[ @1, @2, @3 ], After @[ @3, @2, @1 ].
 */
- (void)wb_reverse;

/**
 Sort the object in this array randomly.
 */
- (void)wb_shuffle;

@end
NS_ASSUME_NONNULL_END
