//
//  ACEViewController.m
//  ACEDrawingViewDemo
//
//  Created by Stefano Acerbetti on 1/6/13.
//  Copyright (c) 2013 Stefano Acerbetti. All rights reserved.
//

#import "ACEViewController.h"
#import "ACEDrawingView.h"

#import "KZColorPicker.h"

#import <QuartzCore/QuartzCore.h>
#import "PostQuestionViewController.h"
#import "PostQuestionDetailViewController.h"
#import "AppDelegate.h"

#define kActionSheetColor       100
#define kActionSheetTool        101

@interface ACEViewController ()<UIActionSheetDelegate, ACEDrawingViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>
{
    UIView *colorPickerView;
    UIImage *selectedImage;
    UIView *selectionView;
    KZColorPicker *picker ;
}

//Buttons
- (IBAction)penBtn:(id)sender;
- (IBAction)eraserBtn:(id)sender;
- (IBAction)colorPick:(id)sender;
- (IBAction)clearDrawing:(id)sender;
- (IBAction)saveBtn:(id)sender;
- (IBAction)cancelAction:(id)sender;
@end



@implementation ACEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set the delegate
    self.drawingView.delegate = self;
    
    // start with a black pen
    self.lineWidthSlider.value = self.drawingView.lineWidth;
    
    // init the preview image
    self.previewImageView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.previewImageView.layer.borderWidth = 2.0f;
    
    self.undoButton.width=0.0f;
    self.redoButton.width=0.0f;
    self.topToolBar.hidden=YES;
    self.bottomToolBar.hidden=YES;
    self.toolButton.width=0.0f;
    
    UITapGestureRecognizer *recognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeDrawingView:)];
    [self.drawingView addGestureRecognizer:recognizer];
    
    colorPickerView=[[UIView alloc]init];
    colorPickerView.frame =  CGRectMake(0,self.view.frame.size.height+20, 0, 0);
    colorPickerView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.7f];
    [self.view addSubview:colorPickerView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)removeDrawingView:(UITapGestureRecognizer*)recognizer
{
    [selectionView removeFromSuperview];
}


#pragma mark - Actions

- (void)updateButtonStatus
{
    self.undoButton.enabled = [self.drawingView canUndo];
    self.redoButton.enabled = [self.drawingView canRedo];
}

- (IBAction)takeScreenshot:(id)sender
{
    // show the preview image
    self.previewImageView.image = self.drawingView.image;
    self.previewImageView.hidden = NO;
    
    // close it after 3 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
        self.previewImageView.hidden = YES;
    });
}

- (IBAction)undo:(id)sender
{
    [self.drawingView undoLatestStep];
    [self updateButtonStatus];
}

- (IBAction)redo:(id)sender
{
    [self.drawingView redoLatestStep];
    [self updateButtonStatus];
}

- (IBAction)clear:(id)sender
{
    [self.drawingView clear];
    [self updateButtonStatus];
    
    [self updateViewConstraints];
    
    [self.drawingView clear];
}

- (IBAction)penBtn:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    selectionView=[[UIView alloc]initWithFrame:CGRectMake(btn.frame.origin.x+5, btn.frame.origin.y-100, btn.frame.size.width, 150)];
    NSArray *imageArray=[[NSArray alloc]initWithObjects:@"vector_thin",@"vector_medium",@"vector_thick", nil];
    NSArray *selectedImageArray=[[NSArray alloc]initWithObjects:@"vector_thin_selected",@"vector_medium_selected",@"vector_thick_selected", nil];
    CGRect btnFrame=CGRectMake(0, 0,25, 25);
    for (int i=0;i<[imageArray count];i++)
    {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:[imageArray objectAtIndex:i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[selectedImageArray objectAtIndex:i]] forState:UIControlStateSelected];
        btn.frame=btnFrame;
        btn.tag=i+1;
        [btn addTarget:self action:@selector(penSelectionBtn:) forControlEvents:UIControlEventTouchUpInside];
        btnFrame.origin.y+=30;
        [selectionView addSubview:btn];
    }
    [self.view addSubview:selectionView];
    
    self.drawingView.drawTool = ACEDrawingToolTypePen;
}

-(void)penSelectionBtn:(id)sender
{
    UIButton *penBtn=(UIButton*)sender;
    [penBtn.superview removeFromSuperview];
    if (penBtn.tag==1)
    {
        self.drawingView.lineWidth = 5;
    }
    else if (penBtn.tag==2)
    {
      self.drawingView.lineWidth = 30;
    }
    else if (penBtn.tag==3)
    {
      self.drawingView.lineWidth = 50;
    }
    else if (penBtn.tag==4)
    {
     self.drawingView.lineWidth=70;
    }
}
- (IBAction)eraserBtn:(id)sender
{
    self.drawingView.drawTool = ACEDrawingToolTypeEraser;
}
- (IBAction)colorPick:(id)sender
{
    
        [UIView animateWithDuration:0.25 animations:^{
            colorPickerView.frame =  CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
        }];
    
    
    UITapGestureRecognizer *gestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeColorPicker)];
   [colorPickerView addGestureRecognizer:gestureRecognizer];
    
    
    

    
    
    
    
    picker = [[KZColorPicker alloc] initWithFrame:CGRectMake(0,(self.view.frame.size.height-250)/2,100,100)];
    
    picker.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    picker.oldColor = [UIColor blackColor];
    [picker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:picker];
}

-(void)fadeInAnimation:(UIView *)aView {
    
    CATransition *transition = [CATransition animation];
    transition.type =kCATransitionFromBottom;
    transition.duration = 0.5f;
    transition.delegate = self;
    [aView.layer addAnimation:transition forKey:nil];
    
}

-(void)removeColorPicker
{
    [UIView animateWithDuration:0.25 animations:^{
        colorPickerView.frame =  CGRectMake(0, 480, 0, 0);
    }];
    [picker removeFromSuperview];
}
- (IBAction)clearDrawing:(id)sender
{
    
    [self.drawingView clear];
    [self updateButtonStatus];
}

-(IBAction)saveBtn:(id)sender
{
    
    
    
//    UIGraphicsBeginImageContextWithOptions(self.drawingView.bounds.size, self.drawingView.opaque, 0.0);
//    [self.drawingView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *img= UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);

    
    UIGraphicsBeginImageContext(CGSizeMake(320,480));
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.drawingView.layer drawInContext:context];
    selectedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Do you want to attach this image with question?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alertView.tag=100;
    [alertView show];
    //UIImageWriteToSavedPhotosAlbum(selectedImage, nil, nil, nil);
}
-(IBAction)cancelAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
//    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [imageView setImage:selectedImage];
//    [self.view addSubview:imageView];
   
}
- (void) pickerChanged:(KZColorPicker *)cp
{
    self.drawingView.lineColor=cp.selectedColor;
}

-(void)backAction:(id)sender
{
   
    //[colorPickerView removeFromSuperview];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100)
    {
        if (buttonIndex==0)
        {
          
        }
        else
        {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"Image attach with question" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertView show];
//            [[AppDelegate sharedDelegate]setPostedImage:selectedImage];
//            [self.navigationController popViewControllerAnimated:NO];
            
            
            //Post Image Value means image from post Answers View
            if (_postImageValue==2)
            {
//                PostQuestionDetailViewController *postQuestionView=[[PostQuestionDetailViewController alloc]init];
//                postQuestionView.postImage=selectedImage;
//                [self.navigationController pushViewController:postQuestionView animated:NO];
                
                [[AppDelegate sharedDelegate]setAnswersPostImage:selectedImage];
                [self.navigationController popViewControllerAnimated:NO];
            }
            //Image From Post New Question
            else
            {
                
                [[AppDelegate sharedDelegate]setPostedImage:selectedImage];
                [self.navigationController popViewControllerAnimated:NO];
//                PostQuestionDetailViewController *postDetailView=[[PostQuestionDetailViewController alloc]init];
//                postDetailView.postImage=selectedImage;
//                [self.navigationController pushViewController:postDetailView animated:NO];
               // postDetailView.
            }
           
        }
    }
}


#pragma mark - ACEDrawing View Delegate

- (void)drawingView:(ACEDrawingView *)view didEndDrawUsingTool:(id<ACEDrawingTool>)tool;
{
    [self updateButtonStatus];
}

//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//   
//}


#pragma mark - Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.cancelButtonIndex != buttonIndex) {
        if (actionSheet.tag == kActionSheetColor) {
            
            self.colorButton.title = [actionSheet buttonTitleAtIndex:buttonIndex];
            switch (buttonIndex) {
                case 0:
                    self.drawingView.lineColor = [UIColor blackColor];
                    break;
                    
                case 1:
                    self.drawingView.lineColor = [UIColor redColor];
                    break;
                    
                case 2:
                    self.drawingView.lineColor = [UIColor greenColor];
                    break;
                    
                case 3:
                    self.drawingView.lineColor = [UIColor blueColor];
                    break;
            }
            
        } else {
            
            self.toolButton.title = [actionSheet buttonTitleAtIndex:buttonIndex];
            switch (buttonIndex) {
                case 0:
                    self.drawingView.drawTool = ACEDrawingToolTypePen;
                    break;
                    
                case 1:
                    self.drawingView.drawTool = ACEDrawingToolTypeLine;
                    break;
                    
                case 2:
                    self.drawingView.drawTool = ACEDrawingToolTypeRectagleStroke;
                    break;
                    
                case 3:
                    self.drawingView.drawTool = ACEDrawingToolTypeRectagleFill;
                    break;
                    
                case 4:
                    self.drawingView.drawTool = ACEDrawingToolTypeEllipseStroke;
                    break;
                    
                case 5:
                    self.drawingView.drawTool = ACEDrawingToolTypeEllipseFill;
                    break;
                    
                case 6:
                    self.drawingView.drawTool = ACEDrawingToolTypeEraser;
                    break;
                    
                case 7:
                    self.drawingView.drawTool = ACEDrawingToolTypeText;
                    break;
            }
            
            // if eraser, disable color and alpha selection
            self.colorButton.enabled = self.alphaButton.enabled = buttonIndex != 6;
        }
    }
}

#pragma mark - Settings

- (IBAction)colorChange:(id)sender
{
//    CustomViewController *customView=[[CustomViewController alloc]init];
//    [self presentViewController:customView animated:NO completion:nil];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Selet a color"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Black", @"Red", @"Green", @"Blue", nil];
    
    [actionSheet setTag:kActionSheetColor];
    [actionSheet showInView:self.view];
}

- (IBAction)toolChange:(id)sender
{
    
     // self.drawingView.drawTool = ACEDrawingToolTypePen;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Selet a tool"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Pen", @"Line",
                                  @"Rect (Stroke)", @"Rect (Fill)",
                                  @"Ellipse (Stroke)", @"Ellipse (Fill)",
                                  @"Eraser", @"Text",
                                  nil];
    
    [actionSheet setTag:kActionSheetTool];
    [actionSheet showInView:self.view];
}

- (IBAction)toggleWidthSlider:(id)sender
{
    // toggle the slider
    self.lineWidthSlider.hidden = !self.lineWidthSlider.hidden;
    self.lineAlphaSlider.hidden = YES;
}


- (IBAction)widthChange:(UISlider *)sender
{
    self.drawingView.lineWidth = sender.value;
}

- (IBAction)toggleAlphaSlider:(id)sender
{
    // toggle the slider
    self.lineAlphaSlider.hidden = !self.lineAlphaSlider.hidden;
    self.lineWidthSlider.hidden = YES;
}

- (IBAction)alphaChange:(UISlider *)sender
{
    self.drawingView.lineAlpha = sender.value;
}

@end
