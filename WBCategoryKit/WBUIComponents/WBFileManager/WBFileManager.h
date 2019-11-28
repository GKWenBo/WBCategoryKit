//
//  WB_FileManager.h
//  WB_FileManager
//
//  Created by WMB on 2017/5/16.
//  Copyright © 2017年 文波. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WBDirectoryType) {
    WBDirectoryDocumentType,    ///document
    WBDirectoryCacheType        ///cache
};

#define WB_FileManager [WBFileManager shareManager]

@interface WBFileManager : NSObject

/**
 *  类初始化方法
 */
+ (instancetype)shareManager;

// MARK:获取文件大小
/**
 *  获取缓存文件大小
 *
 *  @return 例如（2.4M）
 */
- (NSString *)wb_syncGetCacheFileSize;

/**
 *  获取指定路径文件大小
 *
 *  @param path 路径
 */
- (NSString *)wb_syncGetFileSizeWithFilePath:(NSString *)path;

/**
 获取磁盘可用空间

 @return Size 单位：MB
 */
- (NSInteger)wb_getDiskFreeSize;

// MARK:清理缓存 && 文件操作
/**
 *  异步清理cache缓存
 */
- (void)wb_asyncClearCacheDirFile;

/**
 *  异步清理指定路径文件夹文件
 *
 *  @param path 文件路径
 */
- (void)wb_asyncClearFileAtPath:(NSString *)path;

/**
 删除文件

 @param path 文件路径
 @return YES/NO.
 */
- (BOOL)wb_syncRemoveFileAtPath:(NSString *)path;

/**
 异步移除指定文件路径文件

 @param path 文件路径
 @param completed 回调
 */
- (void)wb_asycnRemoveFileAtPath:(NSString *)path
                       completed:(void (^) (BOOL success))completed;

/**
 复制文件

 @param filePath 源文件路径
 @param toPath 目标路径
 @return YES/NO.
 */
- (BOOL)wb_copyFilePath:(NSString *)filePath
                 toPath:(NSString *)toPath;

/**
 剪切文件

 @param file 源文件路径
 @param toPath 目标路径
 @return YES/NO.
 */
- (BOOL)wb_cutFile:(NSString *)file
            toPath:(NSString *)toPath;


// MARK:NSPropertyListSerialization
/**
 同步存储NSArray、NSDictionary数据(NSPropertyListBinaryFormat_v1_0)

 @param plist NSArray、NSDictionary
 @param fileName 文件名
 @param directoryType 目录类型
 */
- (void)wb_syncWritePlist:(id)plist
               toFileName:(NSString *)fileName
            directoryType:(WBDirectoryType)directoryType;

/**
 创建文件路径

 @param filePath 文件路径
 @return YES/NO.
 */
- (BOOL)wb_createFilePathIfNecessary:(NSString *)filePath;

/**
 异步存储NSArray、NSDictionary数据(NSPropertyListBinaryFormat_v1_0)，线程安全

 @param plist NSArray、NSDictionary
 @param fileName 文件名
 @param directoryType 目录类型
 @param completed 结果回调
 */
- (void)wb_asyncWritePlist:(id)plist
                toFileName:(NSString *)fileName
             directoryType:(WBDirectoryType)directoryType
                 completed:(void (^) (BOOL success))completed;

/**
 同步读取数据

 @param fileName 文件名
 @param directoryType 目录类型
 @return NSArray、NSDictionary
 */
- (id)wb_syncReadPlistWithFileName:(NSString *)fileName
                     directoryType:(WBDirectoryType)directoryType;

/**
 异步读取数据

 @param fileName 文件名
 @param directoryType 目录类型
 @param completed 完成回调
 */
- (void)wb_asyncReadPlistWithFileName:(NSString *)fileName
                      directoryType:(WBDirectoryType)directoryType
                          completed:(void (^) (id plist))completed;

// MARK:NSCoder
/**
 同步归档数据

 @param rootObject 模型对象
 @param fileName 文件名
 @param directoryType 目录
 @return YES/NO.
 */
- (BOOL)wb_syncArchiveRootObject:(id)rootObject
                      toFileName:(NSString *)fileName
                   directoryType:(WBDirectoryType)directoryType;
/**
 异步归档数据
 
 @param rootObject 模型对象
 @param fileName 文件名
 @param directoryType 目录
 @param completed 结果回调
 */
- (void)wb_asyncArchiveRootObject:(id)rootObject
                       toFileName:(NSString *)fileName
                    directoryType:(WBDirectoryType)directoryType
                        completed:(void (^) (BOOL success))completed;

/**
 同步解档数据

 @param fileName 文件名
 @param directoryType 目录
 */
- (id)wb_syncUnarchiveObjectWithFileName:(NSString *)fileName
                           directoryType:(WBDirectoryType)directoryType;

/**
 异步解档数据

 @param fileName 文件名
 @param directoryType 目录
 @param completed 完成回调
 */
- (void)wb_asyncUnarchiveObjectWithFileName:(NSString *)fileName
                              directoryType:(WBDirectoryType)directoryType
                                  completed:(void (^) (id rootObject))completed;

// MARK:文件判断
/**
 判断文件路径是否存在

 @param path 路径名称
 @return YES/NO
 */
- (BOOL)wb_isFileExistAtPath:(NSString *)path;

// MARK:获取文件路径
/**
 *  获取Document文件路径
 *  用来保存应由程序运行时生成的需要持久化的数据， iTunes会自动备份该目录（苹果公司建议将程序中创建的和浏览过的程序存放在这里，iTunes在备份和回复时会自动包含此目录）
 *  @return Document路径
 */
- (NSString *)wb_getDocumentDirPath;
/**
 *  获取Library/Caches文件路径
 *  用来存放缓存文件，iTunes不会备份此目录，此目录下的文件不会在程序退出后删除，一般存放体积比较大但又不太重要的文件。
 *  @return Library/Caches路径
 */
- (NSString *)wb_getCacheDirPath;

@end
