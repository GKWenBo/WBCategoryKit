//
//  NSDictionary+WB_Additional.h
//  WB_NSDictionaryUtility
//
//  Created by WMB on 2017/6/18.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface NSDictionary (WBAdditional)

#pragma mark --------  Convert  --------
#pragma mark
/**
 Creates and returns a dictionary from a specified property list data.
 
 @param plist   A property list data whose root object is a dictionary.
 @return A new dictionary created from the plist data, or nil if an error occurs.
 */
+ (nullable NSDictionary *)wb_dictionaryWithPlistData:(NSData *)plist;
/**
 Creates and returns a dictionary from a specified property list xml string.
 
 @param plist   A property list xml string whose root object is a dictionary.
 @return A new dictionary created from the plist string, or nil if an error occurs.
 
 @discussion Apple has implemented this method, but did not make it public.
 */
+ (nullable NSDictionary *)wb_dictionaryWithPlistString:(NSString *)plist;
/**
 Serialize the dictionary to a binary property list data.
 
 @return A bplist data, or nil if an error occurs.
 
 @discussion Apple has implemented this method, but did not make it public.
 */
- (nullable NSData *)wb_plistData;

/**
 Serialize the dictionary to a xml property list string.
 
 @return A plist xml string, or nil if an error occurs.
 */
- (nullable NSString *)wb_plistString;

/**
 Returns a new array containing the dictionary's keys sorted.
 The keys should be NSString, and they will be sorted ascending.
 
 @return A new array containing the dictionary's keys,
 or an empty array if the dictionary has no entries.
 */
- (NSArray *)wb_allKeysSorted;

/**
 Returns a new array containing the dictionary's values sorted by keys.
 
 The order of the values in the array is defined by keys.
 The keys should be NSString, and they will be sorted ascending.
 
 @return A new array containing the dictionary's values sorted by keys,
 or an empty array if the dictionary has no entries.
 */
- (NSArray *)wb_allValuesSortedByKeys;

/**
 Returns a BOOL value tells if the dictionary has an object for key.
 
 @param key The key.
 */
- (BOOL)wb_containsObjectForKey:(id)key;

/**
 Returns a new dictionary containing the entries for keys.
 If the keys is empty or nil, it just returns an empty dictionary.
 
 @param keys The keys.
 @return The entries for the keys.
 */
- (NSDictionary *)wb_entriesForKeys:(NSArray *)keys;

/**
 Convert dictionary to json string. return nil if an error occurs.
 */
- (nullable NSString *)wb_jsonStringEncoded;

/**
 Convert dictionary to json string formatted. return nil if an error occurs.
 */
- (nullable NSString *)wb_jsonPrettyStringEncoded;

/**
 Try to parse an XML and wrap it into a dictionary.
 If you just want to get some value from a small xml, try this.
 
 example XML: "<config><a href="test.com">link</a></config>"
 example Return: @{@"_name":@"config", @"a":{@"_text":@"link",@"href":@"test.com"}}
 
 @param xmlDataOrString XML in NSData or NSString format.
 @return Return a new dictionary, or nil if an error occurs.
 */
+ (nullable NSDictionary *)wb_dictionaryWithXML:(id)xmlDataOrString;

#pragma mark --------  Value Getter  --------
#pragma mark
- (BOOL)wb_boolValueForKey:(NSString *)key
                   default:(BOOL)def;
- (char)wb_charValueForKey:(NSString *)key
                   default:(char)def;
- (unsigned char)wb_unsignedCharValueForKey:(NSString *)key
                                    default:(unsigned char)def;
- (short)wb_shortValueForKey:(NSString *)key
                     default:(short)def;
- (unsigned short)wb_unsignedShortValueForKey:(NSString *)key
                                      default:(unsigned short)def;
- (int)wb_intValueForKey:(NSString *)key
                 default:(int)def;
- (unsigned int)wb_unsignedIntValueForKey:(NSString *)key
                                  default:(unsigned int)def;
- (long)wb_longValueForKey:(NSString *)key
                   default:(long)def;
- (unsigned long)wb_unsignedLongValueForKey:(NSString *)key
                                    default:(unsigned long)def;
- (long long)wb_longLongValueForKey:(NSString *)key
                            default:(long long)def;
- (unsigned long long)wb_unsignedLongLongValueForKey:(NSString *)key
                                             default:(unsigned long long)def;
- (float)wb_floatValueForKey:(NSString *)key
                     default:(float)def;
- (double)wb_doubleValueForKey:(NSString *)key
                       default:(double)def;
- (NSInteger)wb_integerValueForKey:(NSString *)key
                           default:(NSInteger)def;
- (NSUInteger)wb_unsignedIntegerValueForKey:(NSString *)key
                                    default:(NSUInteger)def;
- (nullable NSNumber *)wb_numberValueForKey:(NSString *)key
                                    default:(nullable NSNumber *)def;
- (nullable NSString *)wb_stringValueForKey:(NSString *)key
                                    default:(nullable NSString *)def;

@end


#pragma mark --------  可变字典  --------
#pragma mark
@interface NSMutableDictionary (WB_Additional)
/**
 Creates and returns a dictionary from a specified property list data.
 
 @param plist   A property list data whose root object is a dictionary.
 @return A new dictionary created from the plist data, or nil if an error occurs.
 
 @discussion Apple has implemented this method, but did not make it public.
 */
+ (nullable NSMutableDictionary *)wb_dictionaryWithPlistData:(NSData *)plist;
/**
 Creates and returns a dictionary from a specified property list xml string.
 
 @param plist   A property list xml string whose root object is a dictionary.
 @return A new dictionary created from the plist string, or nil if an error occurs.
 */
+ (nullable NSMutableDictionary *)wb_dictionaryWithPlistString:(NSString *)plist;
/**
 Removes and returns the value associated with a given key.
 
 @param aKey The key for which to return and remove the corresponding value.
 @return The value associated with aKey, or nil if no value is associated with aKey.
 */
- (nullable id)wb_popObjectForKey:(id)aKey;

/**
 Returns a new dictionary containing the entries for keys, and remove these
 entries from reciever. If the keys is empty or nil, it just returns an
 empty dictionary.
 
 @param keys The keys.
 @return The entries for the keys.
 */
- (NSDictionary *)wb_popEntriesForKeys:(NSArray *)keys;

@end

NS_ASSUME_NONNULL_END
