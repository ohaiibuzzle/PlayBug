//
//  DylibInfo.m
//  DebugInfo
//
//  Created by Venti on 09/03/2023.
//

#import <Foundation/Foundation.h>
#import <mach-o/dyld.h>
#import "DylibInfo.h"

@implementation DylibInfo

- (NSArray*) dylibInfo {
    int dylibs = _dyld_image_count();
    NSMutableArray *dylibArray = [NSMutableArray array];
    for (int i = 0; i < dylibs; i++) {
        const char *dylibName = _dyld_get_image_name(i);
        NSString *dylibNameString = [NSString stringWithUTF8String:dylibName];
        [dylibArray addObject:dylibNameString];
    }
    return dylibArray;
}

@end
