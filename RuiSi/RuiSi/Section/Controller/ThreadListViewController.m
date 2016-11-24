//
//  ThreadListViewController.m
//  RuiSi
//
//  Created by aloes on 2016/11/23.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "ThreadListViewController.h"
#import "Thread.h"
#import "HTMLNode.h"
#import "ThreadListCell.h"
#import "HTMLParser.h"

NSString *kThreadListCell = @"ThreadListCell";

@interface ThreadListViewController ()

@property (nonatomic,strong) NSArray *threads;

@end

@implementation ThreadListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置标题
    self.navigationItem.title = self.name;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // 解析xml
    [self setUpArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _threads.count;
}


- (ThreadListCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ThreadListCell *cell = [tableView dequeueReusableCellWithIdentifier:kThreadListCell forIndexPath:indexPath];
    
    Thread *thread = _threads[indexPath.row];
    
    cell.titleLabel.text = thread.title;
    cell.authorLabel.text = thread.author;
    cell.reviewCountLabel.text = thread.reviewCount;
    
    return cell;
}
*/
- (void) setUpArray
{
    
    NSMutableArray *countMutableArray = [[NSMutableArray alloc] init];
    
    NSURL *url = [NSURL URLWithString:self.url];
    
    NSError *error = nil;
    NSString *html = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    
    if (error)
    {
        NSLog(@"Error is %@",error);
        return;
    }
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    if (error)
    {
        NSLog(@"Error is %@",error);
    }
    
    HTMLNode *bodyNode = [parser body];
    NSArray *divNodes = [bodyNode findChildrenWithAttribute:@"class" matchingName:@"threadlist" allowPartial:NO];
    
    for(HTMLNode *divNode in divNodes)
    {
        NSArray *listNodes = [divNode findChildTags:@"li"];
        NSLog(@"%lu",(unsigned long)[listNodes count]);
        NSMutableArray *numMutableArray = [[NSMutableArray alloc] init];
#warning 解析没完成
        for (HTMLNode *listNode in listNodes)
        {
            Thread *thread = [[Thread alloc] init];
            thread.hasPic = false;
            HTMLNode *node = [listNode findChildTag:@"span"];
            if ([[node getAttributeNamed:@"class"] isEqualToString:@"num"])
            {
                thread.reviewCount = [node contents];
            }
            if ([[node getAttributeNamed:@"class"] isEqualToString:@"icon_tu"])
            {
                thread.hasPic = true;
            }
            node = [listNode findChildTag:@"a"];
            thread.titleURL = [node contents];
            
            
            [numMutableArray addObject: thread];
        }
        [countMutableArray addObject:numMutableArray];
    }
    
     _threads = [NSArray arrayWithArray:countMutableArray];
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
