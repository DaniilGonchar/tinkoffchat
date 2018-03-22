//
//  Themes.h
//  TinkoffChat
//
//  Created by comandante on 3/18/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Themes : NSObject

@property (retain, getter = getTheme1, setter = setTheme1:) UIColor* theme1;
@property (retain, getter = getTheme2, setter = setTheme2:) UIColor* theme2;
@property (retain, getter = getTheme3, setter = setTheme3:) UIColor* theme3;

- (instancetype)initWithColorOne: (UIColor *) colorOne ColorTwo: (UIColor *) colorTwo colorThree: (UIColor *) colorThree;

- (void)dealloc;

@end

