//
//  ViewController.m
//  Ridiculist
//
//  Created by Ryan Kennedy on 4/9/15.
//  Copyright (c) 2015 RyanKennedy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _myList = [[[Firebase alloc] initWithUrl:@"https://blazing-torch-8548.firebaseio.com"] childByAppendingPath:@"lists/abcdefg"];
    
    [_myList observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSDictionary* dict = (NSDictionary*)snapshot.value;
        _items = dict[@"List"];
        dispatch_async(dispatch_get_main_queue(), ^{
           self.navigationItem.title = dict[@"Name"];
           [_tableView reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addItem:(NSString*)item {
    
    [_items setObject:@(0) forKey:item];
    [[_myList childByAppendingPath:@"List"] setValue:_items];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.allKeys.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MyTableViewCellIdentifier"];
    
    cell.textLabel.text = _items.allKeys[indexPath.row];
    
    return cell;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self addItem:textField.text];
    textField.text = @"";
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Keyboard Events

//Handle Keybaord Visible Event
- (void)keyboardWillShow:(NSNotification *)aNotification {
    NSDictionary *userInfo = aNotification.userInfo;
    
    // Get keyboard animation.
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    
    NSValue* keyboardFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keybaordFrame = keyboardFrameValue.CGRectValue;
    
    // Begin Animation
    [UIView animateWithDuration:animationDuration delay:0 options:(animationCurve << 16) animations:^{
        _bottomSpaceConstraint.constant = keybaordFrame.size.height;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

//Handle Keybaord Hidden Event
- (void)keyboardWillHide:(NSNotification *)aNotification {
    NSDictionary *userInfo = aNotification.userInfo;
    
    // Get keyboard animation.
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    
    // Begin Animation
    [UIView animateWithDuration:animationDuration delay:0 options:(animationCurve << 16) animations:^{
        _bottomSpaceConstraint.constant = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

@end