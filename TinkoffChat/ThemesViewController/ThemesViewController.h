//
//  ThemesViewController.h
//  TinkoffChat
//
//  Created by comandante on 3/18/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemesViewControllerDelegate.h"
#import "Themes.h"

@interface ThemesViewController : UIViewController

@property (assign, getter = getDelegate, setter = setDelegate:) id<ThemesViewControllerDelegate> delegate;
@property (retain, getter = getModel, setter = setModel:) Themes* model;

- (void)dealloc;

@end

