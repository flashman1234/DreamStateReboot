//
// Created by Michal Thompson on 26/11/14.
// Copyright (c) 2014 Michal Thompson. All rights reserved.
//

#import <Canvas/UINavigationBar+TCCustomFont.h>
#import "DSNavigationBar.h"
#import "UIView+BorderHelper.h"


@implementation DSNavigationBar

// For Storyboard
- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setTitleTextAttributes:@{
                NSForegroundColorAttributeName : [UIColor whiteColor],
                NSFontAttributeName : [UIFont fontWithName:@"Solari" size:20.0f],
                NSShadowAttributeName : [NSShadow new]
        }];

        self.tintColor =  [UIColor whiteColor];
    }

    return self;
}

@end