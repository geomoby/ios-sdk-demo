//
//  UIMapKit+UIMapKitPolygones.m
//  GEOMoby
//
//  Created by N.D. on 08/08/2018.
//  Copyright © 2018 N.D. All rights reserved.
//


#import "UIObjectsMapKit.h"


@interface UIMapKitBaseLayerObject:NSObject
@property (assign)  int Id;
@property (strong)  NSString* title;
@property (strong)  UIColor *colorBorder;
@property (strong)  UIColor *colorFill;
@property (strong)  NSMutableArray *points;
-(id) init;
@end

@implementation UIMapKitBaseLayerObject
-(id) init
{
    return [super init];
}
@end

@interface UIMapKitCircle:UIMapKitBaseLayerObject
@property (assign)  float Radius;
-(id) init;
@end

@implementation UIMapKitCircle
-(id) init
{
    return [super init];
}
@end

@interface UIMapKitBeacon:UIMapKitCircle
-(id) init;
@end

@implementation UIMapKitBeacon
-(id) init
{
    return [super init];
}
@end

@interface UIMapKitLine:UIMapKitBaseLayerObject
-(id) init;
@end

@implementation UIMapKitLine
-(id) init
{
    return [super init];
}
@end

@interface UIMapKitPolygone:UIMapKitBaseLayerObject
-(id) init;
@end

@implementation UIMapKitPolygone
-(id) init
{
    return [super init];
}
@end



@implementation UIObjectsMapKit{
    NSMutableArray *m_objects;
    NSMutableArray *m_google_polygones;
    BOOL m_drawPolygones;

}


-(void) InitVariables
{
    [super InitVariables];
    m_drawPolygones = YES;
    m_objects = NULL;
    m_google_polygones = NULL;
}

-(BOOL) AddObject:(UIObjectsMapKitType)_type :(int) _index
{
    if ([self IsContainObject:_index])
        return NO;
    if (!m_objects)
        m_objects = [NSMutableArray new];
    UIMapKitBaseLayerObject *object = NULL;
    if (_type == UIObjectsMapKitPolygon)
        object = [[UIMapKitPolygone alloc] init];
    if (_type == UIObjectsMapKitCircle)
        object = [[UIMapKitCircle alloc] init];
    if (_type == UIObjectsMapKitBeacon)
        object = [[UIMapKitBeacon alloc] init];
    if (_type == UIObjectsMapKitLine)
        object = [[UIMapKitLine alloc] init];
    
    object.Id = _index;
    object.colorBorder = [UIColor blackColor];
    object.colorFill = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
    object.points = [NSMutableArray new];
    [m_objects addObject:object];
    return YES;
}

-(NSObject*) GetObject:(int) _index
{
    for(UIMapKitBaseLayerObject *poly in [m_objects objectEnumerator])
    {
        if (poly.Id == _index)
            return  poly;
    }
    return NULL;
}

-(BOOL) IsContainObject:(int) _index
{
    if (!m_objects)
        return NO;
    
    if ([self GetObject:_index])
            return  YES;
    return NO;
}

-(BOOL) SetRadius:(int) _index :(float) _radius
{
    UIMapKitCircle *circle = (UIMapKitCircle *)[self GetObject:_index];
    if (circle)
    {
        circle.Radius = _radius;
        return YES;
    }
    return NO;
}

-(BOOL) SetColor:(int) _index :(UIColor*) _borderColor :(UIColor*) _fillColor
{
    UIMapKitBaseLayerObject *poly = (UIMapKitBaseLayerObject *)[self GetObject:_index];
    if (poly)
    {
        poly.colorBorder = _borderColor;
        poly.colorFill = _fillColor;
        return YES;
    }
    return NO;
}

-(BOOL) SetTitle:(int) _index :(NSString*) _title
{
    UIMapKitBaseLayerObject *poly = (UIMapKitBaseLayerObject *)[self GetObject:_index];
    if (poly)
    {
        poly.title = _title;
        return YES;
    }
    return NO;
}

-(BOOL) AddPoint:(int) _index :(CLLocation*) _location
{
    UIMapKitBaseLayerObject *poly = (UIMapKitBaseLayerObject *)[self GetObject:_index];
    if (poly)
    {
        [poly.points addObject:_location];
        return YES;
    }
    return NO;
}

-(BOOL) ClearPoints:(int) _index
{
    UIMapKitBaseLayerObject *poly = (UIMapKitBaseLayerObject *)[self GetObject:_index];
    if (poly)
    {
        [poly.points removeAllObjects];
        return YES;
    }
    return NO;
}

-(void) ClearObjects:(BOOL) _withMap
{
     if (m_objects)
         [m_objects removeAllObjects];
}

-(void) SetDrawObjects:(BOOL) _mode
{
    m_drawPolygones = _mode;
}

-(BOOL) GetDrawObjects
{
    return m_drawPolygones;
}

-(void) RemovePolygonesFromMap
{
    if (m_mapKit)
    {
        for(id<MKOverlay> poly in [m_mapKit.overlays objectEnumerator])
        {
            if ([poly isKindOfClass:[MKPolygon class]])
                [m_mapKit removeOverlay:poly];
        }
    }
    
    if (m_mapView)
    {
        if (m_google_polygones)
        {
            for(GMSPolygon *poly in [m_google_polygones objectEnumerator])
            {
                poly.map = NULL;
            }
            [m_google_polygones removeAllObjects];
        }
    }
}

-(void) GenerateObjects
{
    if (m_mode == UIMapKitModeAppleMaps)
        if (m_mapKit)
        {
            for(NSObject *object in [m_objects objectEnumerator])
            {
                if([object isKindOfClass:[UIMapKitBaseLayerObject class]])
                {
                    UIMapKitBaseLayerObject *poly = (UIMapKitBaseLayerObject*)object;
                    CLLocationCoordinate2D *pointsCoOrds = (CLLocationCoordinate2D*)malloc(sizeof(CLLocationCoordinate2D) * [poly.points count]);
                    int index = 0;
                    for(CLLocation *point in [poly.points objectEnumerator])
                    {
                        pointsCoOrds[index++] = point.coordinate;
                    }
                    
                    MKPolygon *mk_polygone = [MKPolygon polygonWithCoordinates:pointsCoOrds count:index];
                    
                    [mk_polygone setTitle:[NSString stringWithFormat:@"%d",poly.Id]];
                    [m_mapKit addOverlay:mk_polygone];
                }
            }
        }
    
    if (m_mode == UIMapKitModeGoogleMaps)
        if (m_mapView)
        {
            if (m_google_polygones)
            {
                for(GMSOverlay *overlay in [m_google_polygones objectEnumerator])
                {
                    overlay.map = NULL;
                }
                [m_google_polygones removeAllObjects];
            }
            else
                m_google_polygones = [NSMutableArray new];
            
            for(NSObject *object in [m_objects objectEnumerator])
            {
                if([object isKindOfClass:[UIMapKitPolygone class]])
                {
                    UIMapKitPolygone *poly = (UIMapKitPolygone*)object;
                    GMSPolygon *polygon = [[GMSPolygon alloc] init];
                    
                    GMSMutablePath *path = [GMSMutablePath path];
                    
                    for(CLLocation *point in [poly.points objectEnumerator])
                    {
                         [path addLatitude:point.coordinate.latitude longitude:point.coordinate.longitude];
                    }
                    
                    polygon.path = path;
                    
                    polygon.title = poly.title;
                    polygon.fillColor = poly.colorFill;
                    polygon.strokeColor = poly.colorBorder;
                    polygon.strokeWidth = 1;
                    polygon.tappable = YES;
                    polygon.map = m_mapView;
                    
                    [m_google_polygones addObject:polygon];
                  
                }
                
                if([object isKindOfClass:[UIMapKitCircle class]])
                {
                    UIMapKitCircle *poly = (UIMapKitCircle*)object;
                    GMSCircle *circle = [[GMSCircle alloc] init];
                    
                    for(CLLocation *point in [poly.points objectEnumerator])
                    {
                        circle.position = point.coordinate;
                    }
               
                    
                    circle.title = poly.title;
                    circle.fillColor = poly.colorFill;
                    circle.strokeColor = poly.colorBorder;
                    circle.strokeWidth = 1;
                    circle.tappable = YES;
                    circle.radius = poly.Radius;
                    circle.map = m_mapView;
                    
                    [m_google_polygones addObject:circle];
                }
                
                if([object isKindOfClass:[UIMapKitBeacon class]])
                {
                    UIMapKitBeacon *poly = (UIMapKitBeacon*)object;
                    GMSCircle *circle = [[GMSCircle alloc] init];
                    GMSMarker *m_beacon_marker = [[GMSMarker alloc] init];
                    for(CLLocation *point in [poly.points objectEnumerator])
                    {
                        circle.position = point.coordinate;
                        m_beacon_marker.position = point.coordinate;
                    }
                    
                    
                    circle.title = poly.title;
                    circle.fillColor = poly.colorFill;
                    circle.strokeColor = poly.colorBorder;
                    circle.strokeWidth = 1;
                    circle.tappable = NO;
                    circle.radius = poly.Radius;
                    circle.map = m_mapView;
                    
                    
                    
                  
                    m_beacon_marker.map = m_mapView;
                    m_beacon_marker.tappable = YES;
                    m_beacon_marker.title = poly.title;
                    m_beacon_marker.groundAnchor = CGPointMake(0.5, 0.5);
                    m_beacon_marker.icon = [UIImage imageNamed:@"beacon"];
                    
                    
                                      
                    [m_google_polygones addObject:circle];
                }
                
                if([object isKindOfClass:[UIMapKitLine class]])
                {
                    UIMapKitLine *poly = (UIMapKitLine*)object;
                  
                    
                    GMSMutablePath *path = [GMSMutablePath path];
                    
                    for(CLLocation *point in [poly.points objectEnumerator])
                    {
                        [path addCoordinate:point.coordinate];
                    }
                    
                    GMSPolyline *Polyline = [GMSPolyline polylineWithPath:path];
                    Polyline.title = poly.title;
                    Polyline.strokeColor = poly.colorBorder;
                    
                    Polyline.strokeWidth = 2;
                
                    Polyline.map = m_mapView;

                    [m_google_polygones addObject:Polyline];
                }
            }
            
        }
}

- (void)mapView:(GMSMapView *)mapView didTapOverlay:(GMSOverlay *)overlay {
    // When a polygon is tapped, randomly change its fill color to a new hue.
    
    if ([overlay isKindOfClass:[GMSPolygon class]]) {
     //   GMSPolygon *polygon = (GMSPolygon *)overlay;

    }
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{

}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
 
    if ([overlay isKindOfClass:[MKPolygon class]])
    {
        NSInteger index = [overlay.title intValue];
        UIMapKitBaseLayerObject *poly = (UIMapKitBaseLayerObject *)[self GetObject:(int)index];
        
        MKPolygonRenderer *renderer = [[MKPolygonRenderer alloc] initWithPolygon:overlay];
        
        renderer.fillColor   = poly.colorFill;
        renderer.strokeColor = poly.colorBorder;
        renderer.lineWidth   = 1;
        
        return renderer;
    }
    
    return nil;
}

@end
