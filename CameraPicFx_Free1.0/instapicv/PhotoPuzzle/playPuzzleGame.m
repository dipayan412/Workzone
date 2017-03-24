//
//  playPuzzleGame.m
//  PhotoPuzzle
//
//  Created by Synergy Computers on 6/27/12.
//  Copyright (c) 2012 Swengg-Co. All rights reserved.
//

#import "playPuzzleGame.h"
#import "singletonClass.h"
#import "AppDelegate.h"
#import "CWLSynthesizeSingleton.h"
@implementation playPuzzleGame
@synthesize RealImage;
@synthesize totalImages;
@synthesize alreadyDoneRects;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    [[singletonClass sharedsingletonClass].pool drain];
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    //playPuzzleGame.m
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    // Do any additional setup after loading the view from its nib.
    touchedObjectNumber=0;
    imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 416)];
    imageView.image=RealImage;
    [self.view addSubview:imageView];
    imageView.image=[self changetoimage1];
    imageView.image=[self imageWithImage:imageView.image convertToSize:CGSizeMake(320, 416)];
    //NSLog(@"%@",NSStringFromCGSize(imageView.image.size));
    imagePieces=[[NSMutableArray alloc]init];
    imageRects=[[NSMutableArray alloc]init];
    x=0;
    y=0;
    if(totalImages==8)
    {
        x=2;
        y=4;
        [self easyPuzzle];
    }
    else if(totalImages==15)
    {
        x=3;
        y=5;
        [self mediumPuzzle];
    }
    else if(totalImages==30)
    {
        x=5;
        y=6;
        [self hardPuzzle];
    }
    UIButton *editButton=[UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame=CGRectMake(0, 6, 51, 31);
    //    editButton.backgroundColor=[UIColor clearColor];
    editButton.tintColor=nil;
    [editButton setBackgroundImage:[UIImage imageNamed:@"back.2.png"] forState:UIButtonTypeCustom];
    [editButton addTarget:self action:@selector(nameOfSomeMethod:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithCustomView:editButton] autorelease];
    imageView.hidden=YES;
//    int k;
//    for (k=0; k<[alreadyDoneRects count]; k++) {
//        if(k!=[[alreadyDoneRects objectAtIndex:k] intValue])
//        { 
//            break;
//        }
//    }
//    if(k==[alreadyDoneRects count])
//    {
//        imageView.hidden=NO;
//    }
 
}
-(IBAction)nameOfSomeMethod:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [imagePieces release];
    imagePieces=nil;
    [imageRects release];
    imageRects=nil;
    [RealImage release];
    [imageView release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (UIImage*)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    UIImage *img = [UIImage imageWithCGImage:imageRef]; 
    CGImageRelease(imageRef);
    
    //Note: this is autoreleased
    return img;
}
- (UIImage *)imageWithImage:(UIImage *)image1 convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image1 drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return destImage;
}
- (UIImage*) maskImage:(UIImage *)image1 withMask:(UIImage *)maskImage {
    
	CGImageRef maskRef = maskImage.CGImage; 
    
	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
	CGImageRef masked = CGImageCreateWithMask([image1 CGImage], mask);
	return [UIImage imageWithCGImage:masked];
    
}
- (UIImage *) changetoimage:(UIImageView *)EditView
{
    CGSize sss=EditView.frame.size;
    
    UIGraphicsBeginImageContext(sss);
    [EditView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *getimage;
    getimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return getimage;
}
- (UIImage *) changetoimage1
{
    CGSize sss=CGSizeMake(imageView.frame.size.width, imageView.frame.size.height);
    
    UIGraphicsBeginImageContext(sss);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *getimage;
    getimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return getimage;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(imageView.hidden==YES)
    {
        UITouch *touch = [[touches objectEnumerator] nextObject];
        location1 = [touch locationInView:self.view];
        for (int i=[imagePieces count]-1; i>=0; i--) {
            UIImageView *tempImage=[imagePieces objectAtIndex:i];
            if(CGRectContainsPoint(tempImage.frame, location1))
            {
                touchedObjectNumber=i;
                [tempImage setFrame:CGRectMake(location1.x-tempImage.frame.size.width/2, location1.y-tempImage.frame.size.height/2, tempImage.frame.size.width, tempImage.frame.size.height)];
                [self.view bringSubviewToFront:tempImage];
                tempImage=nil;
                break;
            }
        }
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches objectEnumerator] nextObject];
    CGPoint location2 = [touch locationInView:self.view];
    if(imageView.hidden==YES)
    {
        UIImageView *tempImage=[imagePieces objectAtIndex:touchedObjectNumber];
        [tempImage setFrame:CGRectMake(location2.x-tempImage.frame.size.width/2, location2.y-tempImage.frame.size.height/2, tempImage.frame.size.width, tempImage.frame.size.height)];
        tempImage=nil;
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches objectEnumerator] nextObject];
    CGPoint location2 = [touch locationInView:self.view];
    if(imageView.hidden==YES)
    {
        int i;
        for (i=0; i<(x*y); i++) {
            CGRect holeRect=[[imageRects objectAtIndex:i] CGRectValue];
            if(CGRectContainsPoint(holeRect, location2))
            { 
                int replace=[[alreadyDoneRects objectAtIndex:i] intValue];
                int replace1=[[alreadyDoneRects objectAtIndex:touchedObjectNumber] intValue];
                [alreadyDoneRects replaceObjectAtIndex:touchedObjectNumber withObject:[NSNumber numberWithInt:replace]];
                [alreadyDoneRects replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:replace1]];
                break;
            }
        }
        if(totalImages==8)
        {
            x=2;
            y=4;
            [self easyPuzzlePlay:touchedObjectNumber:i];
        }
        else if(totalImages==15)
        {
            x=3;
            y=5;
            [self mediumPuzzlePlay:touchedObjectNumber:i];
        }
        else if(totalImages==30)
        {
            x=5;
            y=6;
            [self hardPuzzlePlay:touchedObjectNumber:i];
        }
        for (i=0; i<[alreadyDoneRects count]; i++) {
            if(i!=[[alreadyDoneRects objectAtIndex:i] intValue])
            { 
                break;
            }
        }
        if(i==[alreadyDoneRects count])
        {
            imageView.hidden=NO;
            UIAlertView *congrats=[[UIAlertView alloc]initWithTitle:@"Congratulation's" message:@"You have successfully completed the Puzzle." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,  nil];
            [congrats show];
            [congrats release];
        }
    }
}
#pragma mark-
#pragma mark- Easy Puzzle
-(void)easyPuzzle
{
    x=2;
    y=4;
    for (int i=0; i<y; i++) {
        for (int j=0; j<x; j++) {
            int r = [[alreadyDoneRects objectAtIndex:j+(2*i)] intValue];
            UIImageView *maskFrame=[[[UIImageView alloc]init]autorelease];;
            [maskFrame setBackgroundColor:[UIColor whiteColor]];
            UIImage *maskImage=[UIImage imageNamed:[NSString stringWithFormat:@"mask_easy_%d.png",r+1]];
            int jj=r%2;
            int ii=r/2;
            CGRect rect=CGRectMake(j*160-0.5, i*104, maskImage.size.width+1, maskImage.size.height+1);
            CGRect rect1=CGRectMake(jj*160, ii*104, maskImage.size.width+1, maskImage.size.height+1);
            if(r==2||r==5)
            {
                rect=CGRectMake(j*160-0.5, i*104-36, maskImage.size.width+1, maskImage.size.height+1);
                rect1=CGRectMake(rect1.origin.x, rect1.origin.y-36, maskImage.size.width+1, maskImage.size.height+1);
            }
            else if(r==3||r==7)
            {
                rect=CGRectMake(j*160-55-0.5, i*104, maskImage.size.width+1, maskImage.size.height+1);
                rect1=CGRectMake(rect1.origin.x-55, rect1.origin.y, maskImage.size.width+1, maskImage.size.height+1);
            }
            [maskFrame setFrame:CGRectMake(0, 0, rect.size.width+2, rect.size.height+2)];
            [maskFrame setImage:maskImage];
            maskImage=[self changetoimage:maskFrame];
            UIImage *cropimage=[self imageByCropping:imageView.image toRect:rect1];
            [maskFrame setFrame:rect];
            [maskFrame setImage:[self maskImage:cropimage withMask:maskImage]];
            [maskFrame setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:maskFrame];
            [imagePieces addObject:maskFrame];
            [imageRects addObject:[NSValue valueWithCGRect:rect]];
        }
    }
}
-(void)easyPuzzlePlay:(int)firstNumber :(int)secondNumber
{
    if(secondNumber==(x*y))
    {
        UIImageView *tempImage=[imagePieces objectAtIndex:firstNumber];
        [tempImage setFrame:[[imageRects objectAtIndex:firstNumber] CGRectValue]];
    }
    else
    {
        UIImageView *maskFrame=[imagePieces objectAtIndex:firstNumber];
        UIImageView *maskFrame1=[imagePieces objectAtIndex:secondNumber];
        int r = [[alreadyDoneRects objectAtIndex:secondNumber] intValue];
        int j=secondNumber%2;
        int i=secondNumber/2;
        CGRect rect=CGRectMake(j*160-0.5, i*104, maskFrame.frame.size.width, maskFrame.frame.size.height);
        if(r==2||r==5)
        {
            rect=CGRectMake(j*160-0.5, i*104-36, maskFrame.frame.size.width, maskFrame.frame.size.height);
        }
        else if(r==3||r==7)
        {
            rect=CGRectMake(j*160-55-0.5, i*104, maskFrame.frame.size.width, maskFrame.frame.size.height);
        }
        [maskFrame setFrame:rect];
        [maskFrame setBackgroundColor:[UIColor clearColor]];
        [imagePieces replaceObjectAtIndex:j+(2*i) withObject:maskFrame];
        [imageRects replaceObjectAtIndex:j+(2*i) withObject:[NSValue valueWithCGRect:rect]];
        r = [[alreadyDoneRects objectAtIndex:firstNumber] intValue];
        j=firstNumber%2;
        i=firstNumber/2;
        rect=CGRectMake(j*160-0.5, i*104, maskFrame1.frame.size.width, maskFrame1.frame.size.height);
        
        if(r==2||r==5)
        {
            rect=CGRectMake(j*160-0.5, i*104-36, maskFrame1.frame.size.width, maskFrame1.frame.size.height);
        }
        else if(r==3||r==7)
        {
            rect=CGRectMake(j*160-55-0.5, i*104, maskFrame1.frame.size.width, maskFrame1.frame.size.height);
        }
        [maskFrame1 setFrame:rect];
        [maskFrame1 setBackgroundColor:[UIColor clearColor]];
        [imagePieces replaceObjectAtIndex:j+(2*i) withObject:maskFrame1];
        [imageRects replaceObjectAtIndex:j+(2*i) withObject:[NSValue valueWithCGRect:rect]];
    }
}
#pragma mark-
#pragma mark- Medium Puzzle
-(void)mediumPuzzle
{
    x=3;
    y=5;
    for (int i=0; i<y; i++) {
        for (int j=0; j<x; j++) {
            int r = [[alreadyDoneRects objectAtIndex:j+(3*i)] intValue];
            UIImageView *maskFrame=[[[UIImageView alloc]init]autorelease];;
            [maskFrame setBackgroundColor:[UIColor whiteColor]];
            UIImage *maskImage=[UIImage imageNamed:[NSString stringWithFormat:@"mask_medium_%d.png",r+1]];
            int jj=r%3;
            int ii=r/3;
            CGRect rect=CGRectMake(j*106.66, i*83.33, maskImage.size.width+1, maskImage.size.height+1);
            CGRect rect1=CGRectMake(jj*106.66, ii*83.33, maskImage.size.width+1, maskImage.size.height+1);
            if(r==2||r==8||r==10)
            {
                rect=CGRectMake(j*106.66-37, i*83.33, maskImage.size.width+1, maskImage.size.height+1);
                rect1=CGRectMake(rect1.origin.x-37, rect1.origin.y, maskImage.size.width+1, maskImage.size.height+1);
            }
            else if(r==4||r==5||r==7||r==9||r==11||r==12)
            {
                rect=CGRectMake(j*106.66, i*83.33-29.5, maskImage.size.width+1, maskImage.size.height+1);
                rect1=CGRectMake(rect1.origin.x, rect1.origin.y-29, maskImage.size.width+1, maskImage.size.height+1);
            }
            else if(r==13)
            {
                rect=CGRectMake(j*106.66-37, i*83.33-29.5, maskImage.size.width+1, maskImage.size.height+1);
                rect1=CGRectMake(rect1.origin.x-37, rect1.origin.y-29, maskImage.size.width+1, maskImage.size.height+1);
            }
            [maskFrame setFrame:CGRectMake(0, 0, rect.size.width+2, rect.size.height+2)];
            [maskFrame setImage:maskImage];
            maskImage=[self changetoimage:maskFrame];
            UIImage *cropimage=[self imageByCropping:imageView.image toRect:rect1];
            //NSLog(@"%@",NSStringFromCGRect(rect));
            [maskFrame setFrame:rect];
            [maskFrame setImage:[self maskImage:cropimage withMask:maskImage]];
            [maskFrame setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:maskFrame];
            [imagePieces addObject:maskFrame];
            [imageRects addObject:[NSValue valueWithCGRect:rect]];
        }
    }
}
-(void)mediumPuzzlePlay:(int)firstNumber :(int)secondNumber
{
    if(secondNumber==(x*y))
    {
        UIImageView *tempImage=[imagePieces objectAtIndex:firstNumber];
        [tempImage setFrame:[[imageRects objectAtIndex:firstNumber] CGRectValue]];
    }
    else
    {
        UIImageView *maskFrame=[imagePieces objectAtIndex:firstNumber];
        UIImageView *maskFrame1=[imagePieces objectAtIndex:secondNumber];
        int r = [[alreadyDoneRects objectAtIndex:secondNumber] intValue];
        int j=secondNumber%3;
        int i=secondNumber/3;
        CGRect rect=CGRectMake(j*106.66, i*83.33, maskFrame.frame.size.width, maskFrame.frame.size.height);
        if(r==2||r==8||r==10)
        {
            rect=CGRectMake(j*106.66-37, i*83.33, maskFrame.frame.size.width, maskFrame.frame.size.height);
        }
        else if(r==4||r==5||r==7||r==9||r==11||r==12)
        {
            rect=CGRectMake(j*106.66, i*83.33-29.5, maskFrame.frame.size.width, maskFrame.frame.size.height);
        }
        else if(r==13)
        {
            rect=CGRectMake(j*106.66-37, i*83.33-29.5, maskFrame.frame.size.width+1, maskFrame.frame.size.height);
        }
        [maskFrame setFrame:rect];
        [maskFrame setBackgroundColor:[UIColor clearColor]];
        [imagePieces replaceObjectAtIndex:j+(3*i) withObject:maskFrame];
        [imageRects replaceObjectAtIndex:j+(3*i) withObject:[NSValue valueWithCGRect:rect]];
        r = [[alreadyDoneRects objectAtIndex:firstNumber] intValue];
        j=firstNumber%3;
        i=firstNumber/3;
        rect=CGRectMake(j*106.66, i*83.33, maskFrame1.frame.size.width, maskFrame1.frame.size.height);
        if(r==2||r==8||r==10)
        {
            rect=CGRectMake(j*106.66-37, i*83.33, maskFrame1.frame.size.width, maskFrame1.frame.size.height);
        }
        else if(r==4||r==5||r==7||r==9||r==11||r==12)
        {
            rect=CGRectMake(j*106.66, i*83.33-29.5, maskFrame1.frame.size.width, maskFrame1.frame.size.height);
        }
        else if(r==13)
        {
            rect=CGRectMake(j*106.66-37, i*83.33-29.5, maskFrame1.frame.size.width, maskFrame1.frame.size.height);
        }
        [maskFrame1 setFrame:rect];
        [maskFrame1 setBackgroundColor:[UIColor clearColor]];
        [imagePieces replaceObjectAtIndex:j+(3*i) withObject:maskFrame1];
        [imageRects replaceObjectAtIndex:j+(3*i) withObject:[NSValue valueWithCGRect:rect]];
    }
}
#pragma mark- Hard Puzzle
-(void)hardPuzzle
{
    x=5;
    y=6;
    for (int i=0; i<y; i++) {
        for (int j=0; j<x; j++) {
            int r = [[alreadyDoneRects objectAtIndex:j+(5*i)] intValue];
            UIImageView *maskFrame=[[[UIImageView alloc]init]autorelease];;
            [maskFrame setBackgroundColor:[UIColor whiteColor]];
            UIImage *maskImage=[UIImage imageNamed:[NSString stringWithFormat:@"mask_hard_%d.png",r+1]];
            int jj=r%5;
            int ii=r/5;
            CGRect rect=CGRectMake(j*64, i*69.33, maskImage.size.width+1, maskImage.size.height+1);
            CGRect rect1=CGRectMake(jj*64, ii*69.33, maskImage.size.width+1, maskImage.size.height+1);
            if(r==1||r==3||r==7||r==9||r==11||r==17||r==19||r==21||r==23||r==29)
            {
                rect=CGRectMake(j*64-22, i*69.33, maskImage.size.width+1, maskImage.size.height+1);
                rect1=CGRectMake(rect1.origin.x-22, rect1.origin.y, maskImage.size.width+1, maskImage.size.height+1);
            }
            else if(r==6||r==8||r==10||r==12||r==16||r==18||r==20||r==22||r==24||r==26)
            {
                rect=CGRectMake(j*64, i*69.33-23.67, maskImage.size.width+1, maskImage.size.height+1);
                rect1=CGRectMake(rect1.origin.x, rect1.origin.y-23.67, maskImage.size.width+1, maskImage.size.height+1);
            }
            else if(r==13||r==27)
            {
                rect=CGRectMake(j*64-22, i*69.33-23.67, maskImage.size.width+1, maskImage.size.height+1);
                rect1=CGRectMake(rect1.origin.x-22, rect1.origin.y-23.67, maskImage.size.width+1, maskImage.size.height+1);
            }
            [maskFrame setFrame:CGRectMake(0, 0, rect.size.width+2, rect.size.height+2)];
            [maskFrame setImage:maskImage];
            maskImage=[self changetoimage:maskFrame];
            UIImage *cropimage=[self imageByCropping:imageView.image toRect:rect1];
            //NSLog(@"%@",NSStringFromCGRect(rect));
            [maskFrame setFrame:rect];
            [maskFrame setImage:[self maskImage:cropimage withMask:maskImage]];
            [maskFrame setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:maskFrame];
            [imagePieces addObject:maskFrame];
            [imageRects addObject:[NSValue valueWithCGRect:rect]];
        }
    }
}

-(void)hardPuzzlePlay:(int)firstNumber :(int)secondNumber
{
    if(secondNumber==(x*y))
    {
        UIImageView *tempImage=[imagePieces objectAtIndex:firstNumber];
        [tempImage setFrame:[[imageRects objectAtIndex:firstNumber] CGRectValue]];
    }
    else
    {
        UIImageView *maskFrame=[imagePieces objectAtIndex:firstNumber];
        UIImageView *maskFrame1=[imagePieces objectAtIndex:secondNumber];
        int r = [[alreadyDoneRects objectAtIndex:secondNumber] intValue];
        int j=secondNumber%5;
        int i=secondNumber/5;
        CGRect rect=CGRectMake(j*64, i*69.33, maskFrame.frame.size.width, maskFrame.frame.size.height);
        if(r==1||r==3||r==7||r==9||r==11||r==17||r==19||r==21||r==23||r==29)
        {
            rect=CGRectMake(j*64-22, i*69.33, maskFrame.frame.size.width, maskFrame.frame.size.height);
        }
        else if(r==6||r==8||r==10||r==12||r==16||r==18||r==20||r==22||r==24||r==26)
        {
            rect=CGRectMake(j*64, i*69.33-23.67, maskFrame.frame.size.width, maskFrame.frame.size.height);
        }
        else if(r==13||r==27)
        {
            rect=CGRectMake(j*64-22, i*69.33-23.67, maskFrame.frame.size.width, maskFrame.frame.size.height);
        }
        [maskFrame setFrame:rect];
        [maskFrame setBackgroundColor:[UIColor clearColor]];
        [imagePieces replaceObjectAtIndex:j+(5*i) withObject:maskFrame];
        [imageRects replaceObjectAtIndex:j+(5*i) withObject:[NSValue valueWithCGRect:rect]];
        r = [[alreadyDoneRects objectAtIndex:firstNumber] intValue];
        j=firstNumber%5;
        i=firstNumber/5;
        rect=CGRectMake(j*64, i*69.33, maskFrame1.frame.size.width, maskFrame1.frame.size.height);
        if(r==1||r==3||r==7||r==9||r==11||r==17||r==19||r==21||r==23||r==29)
        {
            rect=CGRectMake(j*64-22, i*69.33, maskFrame1.frame.size.width, maskFrame1.frame.size.height);
        }
        else if(r==6||r==8||r==10||r==12||r==16||r==18||r==20||r==22||r==24||r==26)
        {
            rect=CGRectMake(j*64, i*69.33-23.67, maskFrame1.frame.size.width, maskFrame1.frame.size.height);
        }
        else if(r==13||r==27)
        {
            rect=CGRectMake(j*64-22, i*69.33-23.67, maskFrame1.frame.size.width, maskFrame1.frame.size.height);
        }
        [maskFrame1 setFrame:rect];
        [maskFrame1 setBackgroundColor:[UIColor clearColor]];
        [imagePieces replaceObjectAtIndex:j+(5*i) withObject:maskFrame1];
        [imageRects replaceObjectAtIndex:j+(5*i) withObject:[NSValue valueWithCGRect:rect]];
    }
}
#pragma mark- iphone 5 Customization
-(void)viewWillLayoutSubviews
{
    self.view.frame = self.view.bounds;
    [super viewWillLayoutSubviews];
}
@end
