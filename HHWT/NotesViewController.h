//
//  NotesViewController.h
//  
//
//  Created by sampath kumar on 28/03/16.
//
//

#import <UIKit/UIKit.h>

#define NOTES_STORYBOARD_ID @"NotesViewControllerSBID"

@interface NotesViewController : HHWTViewController
@property (weak, nonatomic) IBOutlet UITextView *txtNotes;
@property (weak, nonatomic) IBOutlet UIButton *btnImage;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
- (IBAction)actionEdit:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (nonatomic, retain) NSString *sno;
@end
