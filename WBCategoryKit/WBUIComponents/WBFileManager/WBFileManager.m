//
//  WB_FileManager.m
//  WB_FileManager
//
//  Created by WMB on 2017/5/16.
//  Copyright © 2017年 文波. All rights reserved.
//

#import "WBFileManager.h"

static WBFileManager *_manager = nil;
/** < 异步队列：处理文件操作 > */
static dispatch_queue_t _concurrentQueue;

@implementation WBFileManager

+ (instancetype)shareManager {
    if (!_manager) {
        _manager = [[WBFileManager alloc]init];
    }
    return _manager;
}

#pragma mark ------ < 获取文件大小 > ------
- (NSString *)wb_syncGetCacheFileSize {
    return [self wb_syncGetFileSizeWithFilePath:[self wb_getCacheDirPath]];
}

- (NSString *)wb_syncGetFileSizeWithFilePath:(NSString *)path {
    // 获取“path”文件夹下的所有文件
    NSArray *subPathArr = [[NSFileManager defaultManager] subpathsAtPath:path];
    
    NSString *filePath  = nil;
    NSInteger totleSize = 0;
    for (NSString *subPath in subPathArr){
        // 1. 拼接每一个文件的全路径
        filePath =[path stringByAppendingPathComponent:subPath];
        // 2. 是否是文件夹，默认不是
        BOOL isDirectory = NO;
        // 3. 判断文件是否存在
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath
                                                            isDirectory:&isDirectory];
        // 4. 以上判断目的是忽略不需要计算的文件
        if (!isExist || isDirectory || [filePath containsString:@".DS"]){
            // 过滤: 1. 文件夹不存在  2. 过滤文件夹  3. 隐藏文件
            continue;
        }
        // 5. 指定路径，获取这个路径的属性
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath
                                                                              error:nil];
        /**
         attributesOfItemAtPath: 文件夹路径
         该方法只能获取文件的属性, 无法获取文件夹属性, 所以也是需要遍历文件夹的每一个文件的原因
         */
        // 6. 获取每一个文件的大小
        NSInteger size = [dict[@"NSFileSize"] integerValue];
        
        // 7. 计算总大小
        totleSize += size;
    }
    
    //8. 将文件夹大小转换为 M/KB/B
    NSString *totleStr = nil;
    if (totleSize > 1000 * 1000) {
        totleStr = [NSString stringWithFormat:@"%.2fM",totleSize / 1000.00f / 1000.00f];
    }else if (totleSize > 1000) {
        totleStr = [NSString stringWithFormat:@"%.2fKB",totleSize / 1000.00f ];
    }else {
        totleStr = [NSString stringWithFormat:@"%.2fB",totleSize / 1.00f];
    }
    return totleStr;
}

- (NSInteger)wb_getDiskFreeSize {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSDictionary *dict = [fileManager attributesOfItemAtPath:NSHomeDirectory() error:&error];
    NSString *freeSizeStr = [NSString stringWithFormat:@"%@",[dict objectForKey:NSFileSystemFreeSize]];
    return (NSInteger)([freeSizeStr longLongValue] / 1000 * 1000);
}

/** < 清理缓存 && 文件操作 > */
- (void)wb_asyncClearCacheDirFile {
    return [self wb_asyncClearFileAtPath:[self wb_getCacheDirPath]];
}

- (BOOL)wb_syncRemoveFileAtPath:(NSString *)path {
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) return NO;
    return [[NSFileManager defaultManager] removeItemAtPath:path
                                                      error:nil];
}

- (void)wb_asyncClearFileAtPath:(NSString *)path {
    if (!path) return;
    
    /** < 获取文件夹下所有文件 > */
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path
                                                                              error:NULL];
    dispatch_async([self concurrentQueue], ^{
        NSString * filePath = nil;
        NSError * error = nil;
        for (NSString * subPath in subPathArr) {
            filePath = [path stringByAppendingPathComponent:subPath];
            /** 删除子文件夹 */
            if ([[NSFileManager defaultManager] removeItemAtPath:filePath error:&error]) {
                NSLog(@"文件删除成功=%@",filePath);
            }else {
                NSLog(@"删除文件失败=%@",error);
            }
        }
    });
}

- (void)wb_asycnRemoveFileAtPath:(NSString *)path
                       completed:(void (^) (BOOL success))completed {
    if (!path) return;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    __block NSError *error;
    if ([self wb_isFileExistAtPath:path]) {
        dispatch_async([self concurrentQueue], ^{
           BOOL res = [fileManager removeItemAtPath:path
                                              error:&error];
            completed(res);
            if (!res) {
                NSLog(@"删除文件%@--错误：%@",path,error);
            }
        });
    }else {
        NSLog(@"文件不存在");
    }
}

- (BOOL)wb_copyFilePath:(NSString *)filePath
                 toPath:(NSString *)toPath {
    if (![self wb_isFileExistAtPath:filePath]) return NO;
    return [[NSFileManager defaultManager] copyItemAtPath:filePath
                                                   toPath:toPath
                                                    error:nil];
}

- (BOOL)wb_cutFile:(NSString *)file
            toPath:(NSString *)toPath {
    if (![self wb_isFileExistAtPath:file]) return NO;
    return [[NSFileManager defaultManager] moveItemAtPath:file
                                                   toPath:toPath
                                                    error:nil];
}

- (BOOL)wb_createFilePathIfNecessary:(NSString *)filePath {
    if (![self wb_isFileExistAtPath:filePath]) {
        return [[NSFileManager defaultManager] createFileAtPath:filePath
                                                       contents:nil
                                                     attributes:nil];
    }
    return YES;
}

#pragma mark -- 获取文件路径
- (NSString *)wb_getDocumentDirPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

- (NSString *)wb_getCacheDirPath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

// MARK: 文件存储
- (void)wb_syncWritePlist:(id)plist
               toFileName:(NSString *)fileName
            directoryType:(WBDirectoryType)directoryType {
    if (![NSPropertyListSerialization propertyList:plist isValidForFormat:NSPropertyListBinaryFormat_v1_0]) {
        NSLog(@"不能转为二进制数据，请检查数据");
        return;
    }
    
    NSError *error;
    NSData *data = [NSPropertyListSerialization dataWithPropertyList:plist
                                                              format:NSPropertyListBinaryFormat_v1_0
                                                             options:0
                                                               error:&error];
    
    if (!data) {
        NSLog (@"error serializing to xml: %@", error);
        return;
    }
    
    NSString *filePath = [[self wb_getDirPath:directoryType]
                          stringByAppendingPathComponent:fileName];
    
    dispatch_barrier_sync([self concurrentQueue], ^{
       BOOL res = [data writeToFile:filePath
                         atomically:YES];
        if (!res) {
            NSLog (@"error writing to file: %@", error);
            return;
        }
    });
}

- (void)wb_asyncWritePlist:(id)plist
                toFileName:(NSString *)fileName
             directoryType:(WBDirectoryType)directoryType
                 completed:(void (^) (BOOL success))completed {
    if (![NSPropertyListSerialization propertyList:plist isValidForFormat:NSPropertyListBinaryFormat_v1_0]) {
        NSLog(@"不能转为二进制数据，请检查数据");
        return;
    }
    
    NSError *error;
    NSData *data = [NSPropertyListSerialization dataWithPropertyList:plist
                                                              format:NSPropertyListBinaryFormat_v1_0
                                                             options:0
                                                               error:&error];
    
    if (!data) {
        NSLog (@"error serializing to xml: %@", error);
        return;
    }
    
    NSString *filePath = [[self wb_getDirPath:directoryType] stringByAppendingPathComponent:fileName];
    dispatch_barrier_async([self concurrentQueue], ^{
        BOOL res = [data writeToFile:filePath
                          atomically:YES];
        
        if (completed) {
            completed(res);
        }
    });
}

- (id)wb_syncReadPlistWithFileName:(NSString *)fileName
                     directoryType:(WBDirectoryType)directoryType {
    NSString *filePath = [[self wb_getDirPath:directoryType] stringByAppendingPathComponent:fileName];
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:filePath
                                          options:NSDataReadingMappedIfSafe
                                            error:&error];
    if (!data) {
        NSLog(@"error reading %@: %@", filePath, error);
        return nil;
    }
    
    id plist = [NSPropertyListSerialization propertyListWithData:data
                                                         options:0
                                                          format:NULL
                                                           error:&error];
    if (!plist) {
        NSLog (@"could not deserialize %@: %@", filePath, error);
    }
    return plist;
}

- (void)wb_asyncReadPlistWithFileName:(NSString *)fileName
                        directoryType:(WBDirectoryType)directoryType
                            completed:(void (^) (id plist))completed {
    NSString *filePath = [[self wb_getDirPath:directoryType] stringByAppendingPathComponent:fileName];
    
    __block NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:filePath
                                          options:NSDataReadingMappedIfSafe
                                            error:&error];
    if (!data) {
        NSLog(@"error reading %@: %@", filePath, error);
        return ;
    }
    
    dispatch_async([self concurrentQueue], ^{
        id plist = [NSPropertyListSerialization propertyListWithData:data
                                                             options:0
                                                              format:NULL
                                                               error:&error];
        if (completed) {
            completed(plist);
        }
    });
}

// MARK:NSCoder
- (BOOL)wb_syncArchiveRootObject:(id)rootObject
                      toFileName:(NSString *)fileName
                   directoryType:(WBDirectoryType)directoryType {
    if (!rootObject) return NO;
    NSString *filePath = [[[self wb_getDirPath:directoryType] stringByAppendingPathComponent:fileName] stringByAppendingString:@".archive"];
    
    __block BOOL res = NO;
    dispatch_barrier_sync([self concurrentQueue], ^{
       res = [NSKeyedArchiver archiveRootObject:rootObject
                                         toFile:filePath];
    });
    return res;
}

- (void)wb_asyncArchiveRootObject:(id)rootObject
                       toFileName:(NSString *)fileName
                    directoryType:(WBDirectoryType)directoryType
                        completed:(void (^) (BOOL success))completed; {
    if (!rootObject) return ;
    NSString *filePath = [[[self wb_getDirPath:directoryType] stringByAppendingPathComponent:fileName] stringByAppendingString:@".archive"];
    dispatch_barrier_async([self concurrentQueue], ^{
        BOOL res = [NSKeyedArchiver archiveRootObject:rootObject
                                               toFile:filePath];
        if (completed) {
            completed(res);
        }
    });
}

- (id)wb_syncUnarchiveObjectWithFileName:(NSString *)fileName
                           directoryType:(WBDirectoryType)directoryType {
    NSString *filePath = [[[self wb_getDirPath:directoryType] stringByAppendingPathComponent:fileName] stringByAppendingString:@".archive"];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

- (void)wb_asyncUnarchiveObjectWithFileName:(NSString *)fileName
                              directoryType:(WBDirectoryType)directoryType
                                  completed:(void (^) (id rootObject))completed {
    dispatch_async([self concurrentQueue], ^{
       id rootObject = [self wb_syncUnarchiveObjectWithFileName:fileName
                                                  directoryType:directoryType];
        if (completed) {
            completed(rootObject);
        }
    });
}

// MARK:文件判断
- (BOOL)wb_isFileExistAtPath:(NSString *)path {
    NSFileManager *fileNanager = [NSFileManager defaultManager];
    return [fileNanager fileExistsAtPath:path];
}

// MARK:Private Method
- (NSString *)wb_getDirPath:(WBDirectoryType)type {
    switch (type) {
        case WBDirectoryCacheType:
            return [self wb_getCacheDirPath];
            break;
        default:
            return [self wb_getDocumentDirPath];
            break;
    }
}

// MARK:Getter
- (dispatch_queue_t)concurrentQueue {
    if (!_concurrentQueue) {
        _concurrentQueue = dispatch_queue_create("com.wbfilemanagerconcurrentQueue.info", DISPATCH_QUEUE_CONCURRENT);
    }
    return _concurrentQueue;
}

@end
