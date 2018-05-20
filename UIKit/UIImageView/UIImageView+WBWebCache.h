//
//  UIImageView+WBWebCache.h
//  WBCategories
//
//  Created by Admin on 2018/2/9.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>

NS_ASSUME_NONNULL_BEGIN
@interface UIImageView (WBWebCache)

/**
 * Set the imageView `image` with an `url` string and a placeholder.
 *
 * The download is asynchronous and cached.
 *
 * @param url         The url string for the image.
 * @param placeholder The image url string to be set initially, until the image request finishes.
 * @see sd_setImageWithURL:placeholderImage:options:
 */
- (void)wb_setImageWithURL:(NSString *)url
          placeholderImage:(NSString *)placeholder;

/**
 * Set the imageView `image` with an `url` string, placeholder.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url string for the image.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrieved from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)wb_setImageWithURL:(NSString *)url
          placeholderImage:(NSString *)placeholder
                 completed:(SDExternalCompletionBlock)completedBlock;

/**
 Set imageView image with animaton type kCATransitionFade. default duration is 6.0f.

 @param url image url string.
 @param placeholder placeholder string.
 */
- (void)wb_setImageWithFadeAnimation:(NSString *)url
                    placeholderImage:(NSString *)placeholder;

/**
 Set imageView image with animaton type kCATransitionFade.
 
 @param url image url string.
 @param placeholder placeholder string.
 @param duration animated time.
 */
- (void)wb_setImageWithFadeAnimation:(NSString *)url
                    placeholderImage:(NSString *)placeholder
                            duration:(CGFloat)duration;

/**
 * Set the imageView `image` with an `url` string, placeholder and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url string for the image.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param options        The options to use when downloading the image. @see SDWebImageOptions for the possible values.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrieved from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)wb_setImageWithURL:(NSString *)url
          placeholderImage:(NSString *)placeholder
                   options:(SDWebImageOptions)options
                 completed:(SDExternalCompletionBlock)completedBlock;

@end

NS_ASSUME_NONNULL_END
