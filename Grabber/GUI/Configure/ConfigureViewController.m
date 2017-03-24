//
//  ConfigureViewController.m
//  Grabber
//
//  Created by World on 4/24/14.
//  Copyright (c) 2014 Algonyx. All rights reserved.
//

#import "ConfigureViewController.h"

@interface ConfigureViewController () <CBPeripheralDelegate>

@end

@implementation ConfigureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIDevice *currentDevice = [UIDevice currentDevice];
    if ([currentDevice.model rangeOfString:@"Simulator"].location == NSNotFound)
    {
        myCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    }
    devicesArray = [[NSMutableArray alloc] init];
    
    self.title = @"GRABBER";
    
    startButton = [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStyleBordered target:self action:@selector(searchDevices)];
    
    stopButton = [[UIBarButtonItem alloc] initWithTitle:@"Stop" style:UIBarButtonItemStyleBordered target:self action:@selector(stopSearching)];
    
    self.navigationItem.rightBarButtonItem = startButton;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (searching)
    {
        return devicesArray.count + 1;
    }
    
    return devicesArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    if (indexPath.row < devicesArray.count)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        CBPeripheral *device = [devicesArray objectAtIndex:indexPath.row];
        cell.textLabel.text = device.name;
    }
    else
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.textLabel.text = @"Searching...";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CBPeripheral *peripheral = [devicesArray objectAtIndex:indexPath.row];
    [peripheral discoverServices:nil];
    peripheral.delegate = self;
    
    for(int i = 0; i < peripheral.services.count; i++)
    {
        CBService *service = [peripheral.services objectAtIndex:i];
        
        for(int j = 0; j < service.characteristics.count; j++)
        {
            CBCharacteristic *chrctr = [service.characteristics objectAtIndex:j];
            for(int k = 0; k < chrctr.descriptors.count; k++)
            {
                CBDescriptor *des = [chrctr.descriptors objectAtIndex:k];
                
                [peripheral readValueForDescriptor:des];
            }
        }
    }
}

-(void)searchDevices
{
    if (myCentralManager.state == CBCentralManagerStatePoweredOn)
    {
        [devicesArray removeAllObjects];
        
        [myCentralManager scanForPeripheralsWithServices:nil options:nil];
        self.navigationItem.rightBarButtonItem = stopButton;
        searching = YES;
        [devicesTable reloadData];
        NSLog(@"Scanning started");
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed"
                                                        message:@"Bluetooth is OFF in your device"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)stopSearching
{
    if (myCentralManager.state == CBCentralManagerStatePoweredOn)
    {
        [myCentralManager stopScan];
        self.navigationItem.rightBarButtonItem = startButton;
        searching = NO;
        [devicesTable reloadData];
        
        NSLog(@"Scanning stopped");
    }
}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    NSLog(@"Discovered %@", peripheral.name);
    
    [devicesArray addObject:peripheral];
    [devicesTable reloadData];
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    NSLog(@"des val : %@",descriptor.value);
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"State: %d", central.state);
}

@end
