//
//  Themes.h
//  TinkoffChat
//
//  Created by comandante on 3/18/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Themes : NSObject {
  UIColor *_theme1, *_theme2, *_theme3;
}

@property (nonatomic, retain) UIColor* theme1;
@property (nonatomic, retain) UIColor* theme2;
@property (nonatomic, retain) UIColor* theme3;

- (instancetype)initWithColorOne: (UIColor *) theme1 ColorTwo: (UIColor *) theme2 colorThree: (UIColor *) theme3;

- (void)dealloc;

@end

