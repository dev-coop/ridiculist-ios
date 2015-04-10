//
//  ViewController.h
//  Ridiculist
//
//  Created by Ryan Kennedy on 4/9/15.
//  Copyright (c) 2015 RyanKennedy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSMutableDictionary* _items;
    Firebase* _myList;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceConstraint;

@end