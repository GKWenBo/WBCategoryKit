//
//  NSDictionary+WB_Additional.m
//  WB_NSDictionaryUtility
//
//  Created by WMB on 2017/6/18.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "NSDictionary+WBAdditional.h"
#import "NSString+WBPredicate.h"

@interface WB_XMLDictionaryParser : NSObject <NSXMLParserDelegate>

@end

@implementation WB_XMLDictionaryParser {
    NSMutableDictionary *_root;
    NSMutableArray *_stack;
    NSMutableString *_text;
}

- (instancetype)initWithData:(NSData *)data {
    self = super.init;
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    [parser parse];
    return self;
}

- (instancetype)initWithString:(NSString *)xml {
    NSData *data = [xml dataUsingEncoding:NSUTF8StringEncoding];
    return [self initWithData:data];
}

- (NSDictionary *)result {
    return _root;
}

#pragma mark --------  NSXMLParserDelegate  --------

#define XMLText @"_text"
#define XMLName @"_name"
#define XMLPref @"_"
- (void)textEnd {
    _text = _text.wb_trim.mutableCopy;
    if (_text.length) {
        NSMutableDictionary *top = _stack.lastObject;
        id existing = top[XMLText];
        if ([existing isKindOfClass:[NSArray class]]) {
            [existing addObject:_text];
        } else if (existing) {
            top[XMLText] = [@[existing, _text] mutableCopy];
        } else {
            top[XMLText] = _text;
        }
    }
    _text = nil;
}
- (void)parser:(__unused NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(__unused NSString *)namespaceURI qualifiedName:(__unused NSString *)qName attributes:(NSDictionary *)attributeDict {
    [self textEnd];
    
    NSMutableDictionary *node = [NSMutableDictionary new];
    if (!_root) node[XMLName] = elementName;
    if (attributeDict.count) [node addEntriesFromDictionary:attributeDict];
    
    if (_root) {
        NSMutableDictionary *top = _stack.lastObject;
        id existing = top[elementName];
        if ([existing isKindOfClass:[NSArray class]]) {
            [existing addObject:node];
        } else if (existing) {
            top[elementName] = [@[existing, node] mutableCopy];
        } else {
            top[elementName] = node;
        }
        [_stack addObject:node];
    } else {
        _root = node;
        _stack = [NSMutableArray arrayWithObject:node];
    }
}

- (void)parser:(__unused NSXMLParser *)parser didEndElement:(__unused NSString *)elementName namespaceURI:(__unused NSString *)namespaceURI qualifiedName:(__unused NSString *)qName {
    [self textEnd];
    
    NSMutableDictionary *top = _stack.lastObject;
    [_stack removeLastObject];
    
    NSMutableDictionary *left = top.mutableCopy;
    [left removeObjectsForKeys:@[XMLText, XMLName]];
    for (NSString *key in left.allKeys) {
        [left removeObjectForKey:key];
        if ([key hasPrefix:XMLPref]) {
            left[[key substringFromIndex:XMLPref.length]] = top[key];
        }
    }
    if (left.count) return;
    
    NSMutableDictionary *children = top.mutableCopy;
    [children removeObjectsForKeys:@[XMLText, XMLName]];
    for (NSString *key in children.allKeys) {
        if ([key hasPrefix:XMLPref]) {
            [children removeObjectForKey:key];
        }
    }
    if (children.count) return;
    
    NSMutableDictionary *topNew = _stack.lastObject;
    NSString *nodeName = top[XMLName];
    if (!nodeName) {
        for (NSString *name in topNew) {
            id object = topNew[name];
            if (object == top) {
                nodeName = name; break;
            } else if ([object isKindOfClass:[NSArray class]] && [object containsObject:top]) {
                nodeName = name; break;
            }
        }
    }
    if (!nodeName) return;
    
    id inner = top[XMLText];
    if ([inner isKindOfClass:[NSArray class]]) {
        inner = [inner componentsJoinedByString:@"\n"];
    }
    if (!inner) return;
    
    id parent = topNew[nodeName];
    if ([parent isKindOfClass:[NSArray class]]) {
        parent[[parent count] - 1] = inner;
    } else {
        topNew[nodeName] = inner;
    }
}

- (void)parser:(__unused NSXMLParser *)parser
foundCharacters:(NSString *)string {
    if (_text) [_text appendString:string];
    else _text = [NSMutableString stringWithString:string];
}

- (void)parser:(__unused NSXMLParser *)parser
    foundCDATA:(NSData *)CDATABlock {
    NSString *string = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    if (_text) [_text appendString:string];
    else _text = [NSMutableString stringWithString:string];
}

#undef XMLText
#undef XMLName
#undef XMLPref

@end

@implementation NSDictionary (WBAdditional)
+ (nullable NSDictionary *)wb_dictionaryWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSDictionary *dictionary = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListImmutable format:NULL error:NULL];
    if ([dictionary isKindOfClass:[NSDictionary class]]) return dictionary;
    return nil;
}

+ (nullable NSDictionary *)wb_dictionaryWithPlistString:(NSString *)plist {
    if (!plist) return nil;
    NSData* data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self wb_dictionaryWithPlistData:data];
}

- (nullable NSData *)wb_plistData {
    return [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListBinaryFormat_v1_0 options:kNilOptions error:NULL];
}

- (nullable NSString *)wb_plistString {
    NSData *xmlData = [NSPropertyListSerialization dataWithPropertyList:self format:NSPropertyListXMLFormat_v1_0 options:kNilOptions error:NULL];
    if (xmlData) return [self utf8StringWithData:xmlData];
    return nil;
}

- (NSString *)utf8StringWithData:(NSData *)data {
    if (data.length > 0) {
        return [[NSString alloc] initWithData:data
                                     encoding:NSUTF8StringEncoding];
    }
    return @"";
}

- (NSArray *)wb_allKeysSorted {
    return [[self allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

/**
 Returns a new array containing the dictionary's values sorted by keys.
 
 The order of the values in the array is defined by keys.
 The keys should be NSString, and they will be sorted ascending.
 
 @return A new array containing the dictionary's values sorted by keys,
 or an empty array if the dictionary has no entries.
 */
- (NSArray *)wb_allValuesSortedByKeys {
    NSArray *sortedKeys = [self wb_allKeysSorted];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (id key in sortedKeys) {
        [arr addObject:self[key]];
    }
    return arr;
}

- (BOOL)wb_containsObjectForKey:(id)key {
    if (!key) return NO;
    return self[key] != nil;
}

- (NSDictionary *)wb_entriesForKeys:(NSArray *)keys {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    for (id key in keys) {
        id value = self[key];
        if (value) dic[key] = value;
    }
    return dic;
}

- (nullable NSString *)wb_jsonStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    return nil;
}

- (nullable NSString *)wb_jsonPrettyStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    return nil;
}

+ (nullable NSDictionary *)wb_dictionaryWithXML:(id)xmlDataOrString {
    WB_XMLDictionaryParser * parser = nil;
    if ([xmlDataOrString isKindOfClass:[NSString class]]) {
        parser = [[WB_XMLDictionaryParser alloc] initWithString:xmlDataOrString];
    } else if ([xmlDataOrString isKindOfClass:[NSData class]]) {
        parser = [[WB_XMLDictionaryParser alloc] initWithData:xmlDataOrString];
    }
    return [parser result];
}

#pragma mark --------  Value Getter  --------
#pragma mark
/// Get a number value from 'id'.
static NSNumber *NSNumberFromID(id value) {
    static NSCharacterSet *dot;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dot = [NSCharacterSet characterSetWithRange:NSMakeRange('.', 1)];
    });
    if (!value || value == [NSNull null]) return nil;
    if ([value isKindOfClass:[NSNumber class]]) return value;
    if ([value isKindOfClass:[NSString class]]) {
        NSString *lower = ((NSString *)value).lowercaseString;
        if ([lower isEqualToString:@"true"] || [lower isEqualToString:@"yes"]) return @(YES);
        if ([lower isEqualToString:@"false"] || [lower isEqualToString:@"no"]) return @(NO);
        if ([lower isEqualToString:@"nil"] || [lower isEqualToString:@"null"]) return nil;
        if ([(NSString *)value rangeOfCharacterFromSet:dot].location != NSNotFound) {
            return @(((NSString *)value).doubleValue);
        } else {
            return @(((NSString *)value).longLongValue);
        }
    }
    return nil;
}

#define RETURN_VALUE(_type_)                                                     \
if (!key) return def;                                                            \
id value = self[key];                                                            \
if (!value || value == [NSNull null]) return def;                                \
if ([value isKindOfClass:[NSNumber class]]) return ((NSNumber *)value)._type_;   \
if ([value isKindOfClass:[NSString class]]) return NSNumberFromID(value)._type_; \
return def;

- (BOOL)wb_boolValueForKey:(NSString *)key
                   default:(BOOL)def {
    RETURN_VALUE(boolValue);
}

- (char)wb_charValueForKey:(NSString *)key
                   default:(char)def {
    RETURN_VALUE(charValue);
}

- (unsigned char)wb_unsignedCharValueForKey:(NSString *)key
                                    default:(unsigned char)def {
    RETURN_VALUE(unsignedCharValue);
}

- (short)wb_shortValueForKey:(NSString *)key
                     default:(short)def {
    RETURN_VALUE(shortValue);
}

- (unsigned short)wb_unsignedShortValueForKey:(NSString *)key default:(unsigned short)def {
    RETURN_VALUE(unsignedShortValue);
}

- (int)wb_intValueForKey:(NSString *)key
                 default:(int)def {
    RETURN_VALUE(intValue);
}

- (unsigned int)wb_unsignedIntValueForKey:(NSString *)key
                                  default:(unsigned int)def {
    RETURN_VALUE(unsignedIntValue);
}

- (long)wb_longValueForKey:(NSString *)key
                   default:(long)def {
    RETURN_VALUE(longValue);
}

- (unsigned long)wb_unsignedLongValueForKey:(NSString *)key
                                    default:(unsigned long)def {
    RETURN_VALUE(unsignedLongValue);
}

- (long long)wb_longLongValueForKey:(NSString *)key
                            default:(long long)def {
     RETURN_VALUE(longLongValue);
}

- (unsigned long long)wb_unsignedLongLongValueForKey:(NSString *)key
                                             default:(unsigned long long)def {
    RETURN_VALUE(unsignedLongLongValue);
}

- (float)wb_floatValueForKey:(NSString *)key
                     default:(float)def {
    RETURN_VALUE(floatValue);
}

- (double)wb_doubleValueForKey:(NSString *)key
                       default:(double)def {
    RETURN_VALUE(doubleValue);
}

- (NSInteger)wb_integerValueForKey:(NSString *)key
                           default:(NSInteger)def {
    RETURN_VALUE(integerValue);
}

- (NSUInteger)wb_unsignedIntegerValueForKey:(NSString *)key
                                    default:(NSUInteger)def {
    RETURN_VALUE(unsignedIntegerValue);
}

- (nullable NSNumber *)wb_numberValueForKey:(NSString *)key
                                    default:(nullable NSNumber *)def {
    if (!key) return def;
    id value = self[key];
    if (!value || value == [NSNull null]) return def;
    if ([value isKindOfClass:[NSNumber class]]) return value;
    if ([value isKindOfClass:[NSString class]]) return NSNumberFromID(value);
    return def;
}

- (nullable NSString *)wb_stringValueForKey:(NSString *)key
                                    default:(nullable NSString *)def {
    if (!key) return def;
    id value = self[key];
    if (!value || value == [NSNull null]) return def;
    if ([value isKindOfClass:[NSString class]]) return value;
    if ([value isKindOfClass:[NSNumber class]]) return ((NSNumber *)value).description;
    return def;
}
@end

@implementation NSMutableDictionary (WB_Additional)
+ (nullable NSMutableDictionary *)wb_dictionaryWithPlistData:(NSData *)plist {
    if (!plist) return nil;
    NSMutableDictionary *dictionary = [NSPropertyListSerialization propertyListWithData:plist options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    if ([dictionary isKindOfClass:[NSMutableDictionary class]]) return dictionary;
    return nil;
}

+ (nullable NSMutableDictionary *)wb_dictionaryWithPlistString:(NSString *)plist {
    if (!plist) return nil;
    NSData* data = [plist dataUsingEncoding:NSUTF8StringEncoding];
    return [self wb_dictionaryWithPlistData:data];
}

- (nullable id)wb_popObjectForKey:(id)aKey {
    if (!aKey) return nil;
    id value = self[aKey];
    [self removeObjectForKey:aKey];
    return value;
}

- (NSDictionary *)wb_popEntriesForKeys:(NSArray *)keys {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    for (id key in keys) {
        id value = self[key];
        if (value) {
            [self removeObjectForKey:key];
            dic[key] = value;
        }
    }
    return dic;
}

@end
