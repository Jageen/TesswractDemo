//
//  ViewController.m
//  TesswractDemo
//
//  Created by Jageen shukla on 30/03/15.
//  Copyright (c) 2015 Red. All rights reserved.
//

#import "ViewController.h"
#import <TesseractOCR/TesseractOCR.h>

@interface ViewController ()
{
    __weak IBOutlet UITextView *txtOutput;
    UIActivityIndicatorView *activityIndicator;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Called when user press on perform OCT button.
// Will took sample image from resource file and perform OCR.
- (IBAction)performOCR:(id)sender {
    UIImage *targetImage = [UIImage imageNamed:@"image"];
    txtOutput.text = [self getTextFromImage:targetImage];
}

// Utility method which accept image and return string from it using G8Tesseract.
-(NSString*) getTextFromImage:(UIImage*)image
{
    image = [self scaleImage:image withMaxDimension:640];
    G8Tesseract *tesseract = [[G8Tesseract alloc] init];
    tesseract.language = @"eng+fra";
    tesseract.engineMode = G8OCREngineModeTesseractCubeCombined;
    tesseract.pageSegmentationMode = G8PageSegmentationModeAuto;
    tesseract.maximumRecognitionTime = 60.0;
    
    tesseract.image = image.g8_blackAndWhite;
    [tesseract recognize];
    return [tesseract recognizedText];
}

// Utility method for scalling image.
-(UIImage*) scaleImage:(UIImage*)image withMaxDimension:(CGFloat)maxDimention
{
    CGSize scaledSize = CGSizeMake(maxDimention, maxDimention);
    CGFloat scaleFactor;
    
    if(image.size.width > image.size.height)
    {
        scaleFactor = image.size.height / image.size.width;
        scaledSize.width = maxDimention;
        scaledSize.height = scaledSize.width*scaleFactor;
    }
    else
    {
        scaleFactor = image.size.width/image.size.height;
        scaledSize.height = maxDimention;
        scaledSize.width = scaledSize.height * scaleFactor;
    }
    
    UIGraphicsBeginImageContext(scaledSize);
    [image drawInRect:CGRectMake(0, 0, scaledSize.width, scaledSize.height)];
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}
@end
