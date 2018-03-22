//
//  Themes.m
//  TinkoffChat
//
//  Created by comandante on 3/18/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

#import "Themes.h"

@implementation Themes

- (instancetype)initWithColorOne: (UIColor *) colorOne ColorTwo: (UIColor *) colorTwo colorThree: (UIColor *) colorThree {
  
  self = [super init];
  
  if(self) {
    _theme1 = colorOne;
    _theme2 = colorTwo;
    _theme3 = colorThree;
  }
  
  return self;
}

- (void)dealloc {
  [_theme1 release];
  [_theme2 release];
  [_theme3 release];
  
  [super dealloc];
}

@end

