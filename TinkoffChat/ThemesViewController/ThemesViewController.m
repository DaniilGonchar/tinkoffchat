//
//  ThemesViewController.m
//  TinkoffChat
//
//  Created by comandante on 3/18/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

#import "ThemesViewController.h"


@interface ThemesViewController ()
@end


@implementation ThemesViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIColor *lightThemeColor = [[UIColor alloc] initWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0];
  UIColor *darkThemeColor = [[UIColor alloc] initWithRed:75.0f/255.0f green:75.0f/255.0f blue:75.0f/255.0f alpha:1.0];
  UIColor *champagneThemeColor = [[UIColor alloc] initWithRed:197.0f/255.0f green:179.0f/255.0f blue:88.0f/255.0f alpha:1.0];
  
  Themes *model = [[Themes alloc] initWithColorOne: lightThemeColor ColorTwo: darkThemeColor colorThree: champagneThemeColor];
  [self setModel:model];
  [model release];
}

- (IBAction)changeThemeAction:(UIButton*)sender {
  
  NSString *titleOfButton = sender.titleLabel.text;
  
  if ([titleOfButton isEqualToString:@"Light"]) {
    
    UIColor *themeOne = [[self getModel] getTheme1];
    [self.delegate themesViewController:self didSelectTheme: themeOne];
    self.view.backgroundColor = themeOne;
    
  } else if ([titleOfButton isEqualToString:@"Dark"]) {
    
    UIColor *themeTwo = [[self getModel] getTheme2];
    [self.delegate themesViewController:self didSelectTheme: themeTwo];
    self.view.backgroundColor = themeTwo;
    
  } else if ([titleOfButton isEqualToString:@"Champagne"]) {
    
    UIColor *themeThree = [[self getModel] getTheme3];
    [self.delegate themesViewController:self didSelectTheme: themeThree];
    self.view.backgroundColor = themeThree;
    
  }
  
}

- (IBAction)dismissAction:(id)sender {
  [self dismissViewControllerAnimated: true completion: nil];
}

-(void)dealloc {
  [_model release];
  [super dealloc];
}

@end

