//
//  MRFrameRenderer.m
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2014/02/07.
//  Copyright (c) 2014 Mobilica (Pty) Ltd. All rights reserved.
//

#import "MRFrameRenderer2.h"
#import "MRSettings.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface MRFrameRenderer2 ()

@property (nonatomic) MRTemplate *template;
@property (nonatomic) MRCompositor2 *compositor;
@property (nonatomic) NSInteger frameIndex;
@property (nonatomic) UIImage *composedImage;
@end

@implementation MRFrameRenderer2

-(id)initWithTemplate:(MRTemplate *)template compositor:(MRCompositor2 *)compositor frame:(NSInteger)frameIndex {
    if (self = [super init]) {
        _template = template;
        _compositor = compositor;
        _frameIndex = frameIndex;
    }
    return self;
}

-(UIImage *)renderedImage {
    return self.composedImage;
}

-(void)main {
    
    if(self.isCancelled)
    {
        return;
    }
    
    //NSLog(@"Rendering frame %d", self.frameIndex);
    int layerIndex = 0;
    for (MRLayer *layer in self.template.layers) {
        
        if(self.isCancelled)
        {
            return;
        }
        UIImage *layerImage = nil;
        
        int layerStartIndex = layer.inPoint;
        //        int layerEndIndex = layerStartIndex + layer.lengthInFrames;
        int layerEndIndex = layerStartIndex + layer.lengthInFrames - 1;
        
        //check if the layer is visible
        if(self.frameIndex >= layerStartIndex && self.frameIndex <= layerEndIndex)
        {
            if([layer.type isEqualToString:LAYER_TYPE_VIDEO_FILE]) {
                
                layerImage = [self.compositor nextVideoImageForLayer:layer.layerId];
            }
            else if([layer.type isEqualToString:LAYER_TYPE_RECORDED_LAYER]) {
                
                layerImage = [self.compositor nextVideoImageForLayer:layer.layerId];

            }
            else if([layer.type isEqualToString:LAYER_TYPE_STILL_IMAGE]) {
                
                layerImage = [self.compositor stillImageAtPath:layer.pathToSourceFile];
                
            }
            else if([layer.type isEqualToString:LAYER_TYPE_IMAGE_SEQUENCE]) {
                
                int sequenceNo = self.frameIndex - layerStartIndex;
                
                NSString *pathToFirstImage = [self.template.path stringByAppendingPathComponent:layer.pathToSourceFile];
                NSString *replaceStr = [NSString stringWithFormat:@"_%d.", sequenceNo];
                NSString *pathToCurrentImage = [pathToFirstImage stringByReplacingOccurrencesOfString:@"_0." withString:replaceStr];
                layerImage = [UIImage imageWithContentsOfFile:pathToCurrentImage];
                
            }
            else {
                NSLog(@"WARNING: UNSUPPORTED LAYER TYPE: %@", layer.type);
                assert(false);
            }
            
            //mask
            layerImage = [self applyMaskForLayer:layer withImage:layerImage];
            
            //transformations
            if (layer.anchorX)
            {
                //check if this layer does have transformations
                layerImage = [self applyTransformationsForLayer:layer withImage:layerImage];
            }
            
            
            //opacity
            // testing rendering speed
            
            layerImage = [self applyOpacityForLayer:layer withImage:layerImage];
            
            //crop still image - not sure
            if ([layer.type isEqualToString:LAYER_TYPE_STILL_IMAGE]) {
                CGImageRef stillCGImageCropped = CGImageCreateWithImageInRect([layerImage CGImage], CGRectMake(0, 0, 640, 360));
                layerImage = [UIImage imageWithCGImage:stillCGImageCropped];
            }
            
            //blend
            if (self.composedImage)
            {
                self.composedImage = [self applyBlendingForLayer:layer withLayerImage:layerImage composedImage:self.composedImage];
            }
            else {
                self.composedImage = layerImage;
            }
            
            if (DEBUG_FRAME_RENDERING) {
                [self debugSaveLayerImage:layerImage composedImage:self.composedImage layerIndex:layerIndex frameIndex:self.frameIndex];
            }
        }
        layerIndex++;
    }
    
    assert(self.composedImage);
    
}

-(void)debugSaveLayerImage:(UIImage *)layerImage composedImage:(UIImage *)composedImage layerIndex:(int)layerIndex frameIndex:(int)frameIndex {
    NSString *debugDir = [NSString stringWithFormat:@"%@/FrameRenderingDebug", NSTemporaryDirectory()];
    if (![[NSFileManager defaultManager] fileExistsAtPath:debugDir]) {
        NSLog(@"Creating debug directory");
        [[NSFileManager defaultManager] createDirectoryAtPath:debugDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *layerImageFile = [NSString stringWithFormat:@"%@/frame_%04d_layer_%02d.png", debugDir, frameIndex, layerIndex];
    NSString *composedImageFile = [NSString stringWithFormat:@"%@/frame_%04d_layer_%02d_composed.png", debugDir, frameIndex, layerIndex];
    
    NSData *layerImageData = UIImagePNGRepresentation(layerImage);
    NSData *composedImageData = UIImagePNGRepresentation(composedImage);
    
    [layerImageData writeToFile:layerImageFile atomically:NO];
    [composedImageData writeToFile:composedImageFile atomically:NO];
}

-(UIImage *)applyBlendingForLayer:(MRLayer *)layer withLayerImage:(UIImage *)layerImage composedImage:(UIImage *)composedImage {
    UIImage *resultImage = layerImage;
    
    CGBlendMode blendmode;
    
    if (layer.blendingMode) {
        
        if([layer.blendingMode isEqualToString:BLENDING_MODE_ADD]) {
            //TODO
            //blendmode = kCGBlendMode
            assert(false);
        }
        else if([layer.blendingMode isEqualToString:BLENDING_MODE_CLEAR]) {
            blendmode = kCGBlendModeClear;
        }
        else if([layer.blendingMode isEqualToString:BLENDING_MODE_DARKEN]) {
            blendmode = kCGBlendModeDarken;
        }
        else if([layer.blendingMode isEqualToString:BLENDING_MODE_DST]) {
            //TODO
            //blendmode = kCGBlendMode
            assert(false);
        }
        else if([layer.blendingMode isEqualToString:BLENDING_MODE_DST_ATOP]) {
            blendmode = kCGBlendModeDestinationAtop;
        }
        else if([layer.blendingMode isEqualToString:BLENDING_MODE_DST_IN]) {
            blendmode = kCGBlendModeDestinationIn;
        }
        else if([layer.blendingMode isEqualToString:BLENDING_MODE_DST_OUT]) {
            blendmode = kCGBlendModeDestinationOut;
        }
        else if([layer.blendingMode isEqualToString:BLENDING_MODE_DST_OVER]) {
            blendmode = kCGBlendModeDestinationOver;
        }
        else if([layer.blendingMode isEqualToString:BLENDING_MODE_LIGHTEN]) {
            blendmode = kCGBlendModeLighten;
        }
        else if([layer.blendingMode isEqualToString:BLENDING_MODE_MULTIPLY]) {
            blendmode = kCGBlendModeMultiply;
        }
        else if([layer.blendingMode isEqualToString:BLENDING_MODE_OVERLAY]) {
            blendmode = kCGBlendModeOverlay;
        }
        else if([layer.blendingMode isEqualToString:BLENDING_MODE_SCREEN]) {
            blendmode = kCGBlendModeScreen;
        }
        else if([layer.blendingMode isEqualToString:BLENDING_MODE_SRC]) {
            //TODO
            //blendmode = kCGBlendModeSourceAtop
            assert(false);
        }
        else if([layer.blendingMode isEqualToString:BLENDING_MODE_SRC_ATOP]) {
            blendmode = kCGBlendModeSourceAtop;
        }
        else if([layer.blendingMode isEqualToString:BLENDING_MODE_SRC_IN]) {
            blendmode = kCGBlendModeSourceIn;
        }
        else if([layer.blendingMode isEqualToString:BLENDING_MODE_SRC_OUT]) {
            blendmode = kCGBlendModeSourceOut;
        }
        else if([layer.blendingMode isEqualToString:BLENDING_MODE_SRC_OVER]) {
            //TODO
            //blendmode = kCGBlendModesour
            assert(false);
        }
        else if([layer.blendingMode isEqualToString:BLENDING_MODE_XOR]) {
            blendmode = kCGBlendModeXOR;
        }
        else {
            NSLog(@"WARNING: UNSUPPORTED BLENDING MODE: %@", layer.blendingMode);
            assert(false);
        }
        
    }
    else {
        //No blend mode specified. Use Normal blending (alpha blending)
        blendmode = kCGBlendModeNormal;
    }
    
    
    CGImageRef layerCGImageCropped = CGImageCreateWithImageInRect([layerImage CGImage], CGRectMake(0, 0, 640, 360));
    UIImage *layerImageCropped = [UIImage imageWithCGImage:layerCGImageCropped];
    CGImageRelease(layerCGImageCropped);
    
    resultImage = [self blendImagesSource:composedImage destination:layerImageCropped mode:blendmode];
    
    return resultImage;
}

-(UIImage *)applyMaskForLayer:(MRLayer *)layer withImage:(UIImage *)image {
    UIImage *resultImage = image;
    
    if (layer.mask) {
        
        UIImage *maskImage;
        
        if([layer.mask.type isEqualToString:LAYER_TYPE_IMAGE_SEQUENCE]) {
            int sequenceNo = self.frameIndex - layer.mask.inPoint;
            
            NSString *pathToFirstImage = [self.template.path stringByAppendingPathComponent:layer.mask.pathToSourceFile];
            NSString *replaceStr = [NSString stringWithFormat:@"_%d.", sequenceNo];
            NSString *pathToCurrentImage = [pathToFirstImage stringByReplacingOccurrencesOfString:@"_0." withString:replaceStr];
            //NSLog(@"%@", pathToCurrentImage);
            maskImage = [UIImage imageWithContentsOfFile:pathToCurrentImage];
        }
        else if([layer.mask.type isEqualToString:LAYER_TYPE_VIDEO_FILE]) {
            
            maskImage = [self.compositor nextMaskVideoImageForLayer:layer.layerId];
            assert(maskImage);            
            maskImage = [self alphaImageFromGrayscaleImage:maskImage];
        }
        else if([layer.mask.type isEqualToString:LAYER_TYPE_STILL_IMAGE]) {
            maskImage = [self.compositor maskImageAtPath:layer.mask.pathToSourceFile];
        }
        else {
            NSLog(@"Unknown mask type");
        }
        
        //assert(maskImage);
        
        resultImage = [self blendImagesSource:image destination:maskImage mode:kCGBlendModeDestinationOut];
        
    }
    
    return resultImage;
}


//67 seconds - Space Wars
-(UIImage*)alphaImageFromGrayscaleImage:(UIImage *)grayscaleImage {
    
    CGRect imageRect = CGRectMake(0, 0, grayscaleImage.size.width, grayscaleImage.size.height);
    
    //Pixel Buffer
    uint32_t* piPixels = (uint32_t*)malloc(imageRect.size.width * imageRect.size.height * sizeof(uint32_t));
    if (piPixels == NULL)
    {
        return nil;
    }
    memset(piPixels, 0, imageRect.size.width * imageRect.size.height * sizeof(uint32_t));
    
    //Drawing image in the buffer
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(piPixels, imageRect.size.width, imageRect.size.height, 8, sizeof(uint32_t) * imageRect.size.width, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    CGContextDrawImage(context, imageRect, grayscaleImage.CGImage);
    
    //Copying the red values to the alpha values of the image, leave the rest as is
    for (uint32_t y = 0; y < imageRect.size.height; y++)
    {
        for (uint32_t x = 0; x < imageRect.size.width; x++)
        {
            uint8_t* rgbaValues = (uint8_t*)&piPixels[y * (uint32_t)imageRect.size.width + x];
            
            //alpha = 0, red = 1, green = 2, blue = 3.
            rgbaValues[0] = rgbaValues[1];
        }
    }
    
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    UIImage* newImage = [[UIImage alloc] initWithCGImage:newCGImage];
    CGImageRelease(newCGImage);
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(piPixels);
    
    return newImage;
}



/*
  //78 seconds - Space Wars
-(UIImage*)alphaImageFromGrayscaleImage:(UIImage *)grayscaleImage {
     CIContext *context = [CIContext contextWithOptions:nil];
     CIImage *image = [CIImage imageWithCGImage:[grayscaleImage CGImage]];
     CIFilter *filter = [CIFilter filterWithName:@"CIMaskToAlpha"];
     [filter setValue:image forKey:kCIInputImageKey];
     CIImage *result = [filter valueForKey:kCIOutputImageKey];
     CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
     
     //UIImage *newImage = [UIImage imageWithCGImage:cgImage scale:[grayscaleImage scale] orientation:UIImageOrientationUp];
     UIImage *newImage = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
     return newImage;
 }
*/

/*
 //78 seconds - Space Wars
-(UIImage*)alphaImageFromGrayscaleImage:(UIImage *)grayscaleImage {
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *image = [CIImage imageWithCGImage:[grayscaleImage CGImage]];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorMatrix"];
    [filter setValue:image forKey:kCIInputImageKey];
    
    [filter setValue:[CIVector vectorWithX:0 Y:0 Z:0 W:0] forKey:@"inputRVector"];
    [filter setValue:[CIVector vectorWithX:0 Y:0 Z:0 W:0] forKey:@"inputGVector"];
    [filter setValue:[CIVector vectorWithX:0 Y:0 Z:0 W:0] forKey:@"inputBVector"];
    [filter setValue:[CIVector vectorWithX:1 Y:0 Z:0 W:0] forKey:@"inputAVector"];
    [filter setValue:[CIVector vectorWithX:0 Y:0 Z:0 W:0] forKey:@"inputBiasVector"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    
    //UIImage *newImage = [UIImage imageWithCGImage:cgImage scale:[grayscaleImage scale] orientation:UIImageOrientationUp];
    UIImage *newImage = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);    
    
    return newImage;
}
*/


-(UIImage *)applyTransformationsForLayer:(MRLayer *)layer withImage:(UIImage *)image {
    
    UIImage *transformedImage;
    
    float tx = 0;
    float ty = 0;;
    float anchorX = 0;
    float anchorY = 0;
    //float anchorXNorm = 0;
    //float anchorYNorm = 0;
    float scaleX = 0;
    float scaleY = 0;
    float rotation = 0;
    int index = self.frameIndex - layer.inPoint;
    
    //    NSLog(@"layer frameIndex %d, layerInPoint %d, lengthInFrames %d index %d", self.frameIndex, layer.inPoint, layer.lengthInFrames, index);
    if(layer.anchorX) {
        anchorX = [[layer.anchorX objectAtIndex:index] floatValue];
        //anchorXNorm = anchorX / width;
    }
    if(layer.anchorY) {
        anchorY = [[layer.anchorY objectAtIndex:index] floatValue];
        //anchorYNorm = anchorY / height;
    }
    
    if(layer.scaleX) {
        scaleX = [[layer.scaleX objectAtIndex:index] floatValue];
        scaleX = scaleX / 100;
    }
    if(layer.scaleY) {
        scaleY = [[layer.scaleY objectAtIndex:index] floatValue];
        scaleY = scaleY / 100;
    }
    if(layer.rotation) {
        rotation = [[layer.rotation objectAtIndex:index] floatValue];
        rotation = DEGREES_TO_RADIANS(rotation);
    }
    if(layer.transformX) {
        tx = [[layer.transformX objectAtIndex:index] floatValue];
        tx = (tx - anchorX);
    }
    if(layer.transformY) {
        ty = [[layer.transformY objectAtIndex:index] floatValue];
        ty = (ty - anchorY);
    }
    
    //Order of transformations: Scale, Rotate, Translate
    
    //pre scale around anchor
    CGAffineTransform scaleTransform = CGAffineTransformMakeTranslation(anchorX, anchorY);
    scaleTransform = CGAffineTransformScale(scaleTransform, scaleX, scaleY);
    scaleTransform = CGAffineTransformTranslate(scaleTransform, -anchorX, -anchorY);
    
    //pre rotate around anchor
    CGAffineTransform rotateTransform = CGAffineTransformMakeTranslation(anchorX, anchorY);
    rotateTransform = CGAffineTransformRotate(rotateTransform, rotation);
    rotateTransform = CGAffineTransformTranslate(rotateTransform, -anchorX, -anchorY);
    CGAffineTransform transform = CGAffineTransformConcat(rotateTransform, scaleTransform); //pre concatenate
    
    //post translate
    CGAffineTransform translateTransform = CGAffineTransformMakeTranslation(tx, ty);
    transform = CGAffineTransformConcat(transform, translateTransform); //post concat
    
    transformedImage = [self transformImage:image affineTransform:transform];
    
    return transformedImage;
}

-(UIImage *)transformImage:(UIImage *)image affineTransform:(CGAffineTransform)transform {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, transform);
    
    CGRect bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    [image drawInRect:bounds];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}


-(UIImage *)applyOpacityForLayer:(MRLayer *)layer withImage:(UIImage *)image {
    UIImage *resultImage = image;
    
    if(layer.opacity)
    {
        int index = self.frameIndex - layer.inPoint;
        float opacity = 1.0;
        
        opacity = [[layer.opacity objectAtIndex:index] floatValue];
        if (opacity == 0)
        {
            return nil;
        }
        opacity = opacity / 100;
        
        resultImage = [self changeOpacityForImage:image alpha:opacity];
    }
    
    return resultImage;
}


-(UIImage *)changeOpacityForImage:(UIImage *)image alpha:(float)alpha {
    UIGraphicsBeginImageContext(image.size);
    
    CGRect bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    [image drawInRect:bounds blendMode:kCGBlendModeNormal alpha:alpha];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

-(UIImage *)blendImagesSource:(UIImage *)src destination:(UIImage *)dst mode:(CGBlendMode)mode {
    
    //NSLog(@"Blending source: %fx%f destination: %fx%f", src.size.width, src.size.height, dst.size.width, dst.size.height);
    
    UIGraphicsBeginImageContext(src.size);
    CGRect bounds = CGRectMake(0, 0, src.size.width, src.size.height);
    CGRect dstBounds = CGRectMake(0, 0, dst.size.width, dst.size.height);
    
    [src drawInRect:bounds];
    [dst drawInRect:dstBounds blendMode:mode alpha:1.0];
    
    
    UIImage *blendedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return blendedImage;
}


@end
