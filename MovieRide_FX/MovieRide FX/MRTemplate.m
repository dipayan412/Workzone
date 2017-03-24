//
//  MRTemplate.m
//  MovieRide FX
//
//  Created by Ferdie Danzfuss on 2014/01/11.
//  Copyright (c) 2014 Mobilica (Pty) Ltd. All rights reserved.
//

#import "MRTemplate.h"
#import "RXMLElement.h"
#import "MRUtil.h"

@implementation MRTemplate

+(MRTemplate *)templateFromPath:(NSString *)templatePath {
    
    NSString *templateXMLFile = [templatePath stringByAppendingPathComponent:@"template.xml"];
    NSError *error;
    NSString *xmlStr = [NSString stringWithContentsOfFile:templateXMLFile encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"%@", error.description);
        [MRUtil showErrorMessage:@"Could not load the template."];
    }
    
    NSLog(@"Parsing template from XML");
    
    MRTemplate *template = [[MRTemplate alloc] init];
    template.path = templatePath;
    
    RXMLElement *rootEl = [RXMLElement elementFromXMLString:xmlStr encoding:NSUTF8StringEncoding];
    RXMLElement *sequenceEl = [rootEl child:@"Sequence"];
    template.sequence = [self parseSequence:sequenceEl];
    
    RXMLElement *layersEl = [rootEl child:@"Layers"];
    template.layers = [self parseLayers:layersEl];

    return template;
}

+(MRSequence *)parseSequence:(RXMLElement *)sequenceEl {
    MRSequence *sequence = [[MRSequence alloc] init];
    
    sequence.width = [[sequenceEl attribute:@"width"] intValue];
    sequence.height = [[sequenceEl attribute:@"height"] intValue];
    sequence.frameRate = [[sequenceEl attribute:@"frameRate"] intValue];
    sequence.lengthInFrames = [[sequenceEl attribute:@"lengthInFrames"] intValue];
    sequence.thumbnailFrame = [[sequenceEl attribute:@"thumbnailFrame"] intValue];
    
    sequence.recWidth = [[sequenceEl attribute:@"recWidth"] intValue];
    sequence.recHeight = [[sequenceEl attribute:@"recHeight"] intValue];
    sequence.recLengthInFrames = [[sequenceEl attribute:@"recLengthInFrames"] intValue];
    
    sequence.audioChannels = [[sequenceEl attribute:@"audiochannels"] intValue];
    sequence.pathToSoundFile = [sequenceEl attribute:@"pathToSoundFile"];
    
    sequence.pathToOverlayStart = [sequenceEl attribute:@"pathToOverlayStart"];
    sequence.pathToOverlayEnd = [sequenceEl attribute:@"pathToOverlayEnd"];
    sequence.filenamePrefix = [sequenceEl attribute:@"filenamePrefix"];
    sequence.compressionFormat = [sequenceEl attribute:@"compressionFormat"];
    sequence.compressionKbpsMultiplier = [[sequenceEl attribute:@"compressionKbpsMultiplier"] intValue];

    return sequence;
}

+(NSArray *)parseLayers:(RXMLElement *)layersEl {
    NSArray *layerArr = [layersEl children:@"layer"];
    NSMutableArray *layers = [NSMutableArray arrayWithCapacity:[layerArr count]];
    
    int layerIndex = 0;
    for (RXMLElement *layerEl in layerArr) {
        MRLayer *layer = [self parseLayer:layerEl];
        layer.layerId = [NSNumber numberWithInteger:layerIndex];
        
        [layers addObject:layer];
        layerIndex++;
    }
    return layers;
}

+(MRLayer *)parseLayer:(RXMLElement *)layerEl {
    MRLayer *layer = [[MRLayer alloc] init];
    
    layer.type = [layerEl attribute:@"type"];
    layer.inPoint = [[layerEl attribute:@"inPoint"] intValue];
    layer.lengthInFrames = [[layerEl attribute:@"lengthInFrames"] intValue];
    layer.blendingMode = [layerEl attribute:@"blendingMode"];
    layer.pathToSourceFile = [layerEl attribute:@"pathToSourceFile"];
    
    RXMLElement *maskEl = [layerEl child:@"mask"];
    if (maskEl) {
        layer.mask = [self parseLayer:maskEl];
    }
    
    RXMLElement *transformsEl = [layerEl child:@"transforms"];
    if (transformsEl) {
        layer.transformX = [self parseArrayValuesForElement:[transformsEl child:@"transformX"]];
        layer.transformY = [self parseArrayValuesForElement:[transformsEl child:@"transformY"]];
        layer.anchorX = [self parseArrayValuesForElement:[transformsEl child:@"anchorX"]];
        layer.anchorY = [self parseArrayValuesForElement:[transformsEl child:@"anchorY"]];
        layer.scaleX = [self parseArrayValuesForElement:[transformsEl child:@"scaleX"]];
        layer.scaleY = [self parseArrayValuesForElement:[transformsEl child:@"scaleY"]];
        layer.rotation = [self parseArrayValuesForElement:[transformsEl child:@"rotation"]];
    }
    
    layer.opacity = [self parseArrayValuesForElement:[layerEl child:@"opacity"]];
    
    return layer;
}

+(NSArray *)parseArrayValuesForElement:(RXMLElement *)element {
    NSMutableArray *arrayValues;
    if (element) {
        NSString *arrayValuesStr = [element attribute:@"arrayValues"];
        if (arrayValuesStr) {
           NSArray *arrayValuesOfStrings = [arrayValuesStr componentsSeparatedByString:@","];
            
            //convert the values from string to float
            arrayValues = [NSMutableArray arrayWithCapacity:[arrayValuesOfStrings count]];
            for (NSString *value in arrayValuesOfStrings) {
                float floatValue = [value floatValue];
                NSNumber *number = [NSNumber numberWithFloat:floatValue];
                [arrayValues addObject:number];
            }
            
        }
    }
    
    return arrayValues;
}

@end
