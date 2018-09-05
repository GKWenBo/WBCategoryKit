//
//  UIControl+WBSound.m
//  WBCategories
//
//  Created by Admin on 2018/2/9.
//  Copyright © 2018年 WENBO. All rights reserved.
//

#import "UIControl+WBSound.h"
#import <AVFoundation/AVFoundation.h>

#import <objc/runtime.h>
static const void *kWBSoundKey = &kWBSoundKey;

@implementation UIControl (WBSound)

- (void)wb_playSoundWithFileName:(NSString *)fileName forControlEvent:(UIControlEvents)forControlEvent {
    // Remove the old UI sound.
    NSString *oldSoundKey = [NSString stringWithFormat:@"%lu", (unsigned long)forControlEvent];
    AVAudioPlayer *oldSound = [self wb_sounds][oldSoundKey];
    [self removeTarget:oldSound action:@selector(play) forControlEvents:forControlEvent];
    
    // Set appropriate category for UI sounds.
    // Do not mute other playing audio.
    [[AVAudioSession sharedInstance] setCategory:@"AVAudioSessionCategoryAmbient" error:nil];
    
    // Find the sound file.
    NSString *file = [fileName stringByDeletingPathExtension];
    NSString *extension = [fileName pathExtension];
    NSURL *soundFileURL = [[NSBundle mainBundle] URLForResource:file withExtension:extension];
    
    NSError *error = nil;
    
    // Create and prepare the sound.
    AVAudioPlayer *tapSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:&error];
    NSString *controlEventKey = [NSString stringWithFormat:@"%lu", (unsigned long)forControlEvent];
    NSMutableDictionary *sounds = [self wb_sounds];
    [sounds setObject:tapSound forKey:controlEventKey];
    [tapSound prepareToPlay];
    if (!tapSound) {
        NSLog(@"Couldn't add sound - error: %@", error);
        return;
    }
    
    // Play the sound for the control event.
    [self addTarget:tapSound action:@selector(play) forControlEvents:forControlEvent];
}

#pragma mark ------ < Getter && Setter > ------
- (NSMutableDictionary *)wb_sounds {
    NSMutableDictionary *sounds = objc_getAssociatedObject(self, kWBSoundKey);
    if (!sounds) {
        sounds = [[NSMutableDictionary alloc]initWithCapacity:2];
        [self wb_setSounds:sounds];
    }
    return sounds;
}

- (void)wb_setSounds:(NSMutableDictionary *)sounds {
    objc_setAssociatedObject(self, kWBSoundKey, sounds, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
