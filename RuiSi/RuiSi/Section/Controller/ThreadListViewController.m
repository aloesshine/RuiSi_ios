//
//  ThreadListViewController.m
//  RuiSi
//
//  Created by aloes on 2016/11/23.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import "ThreadListViewController.h"
#import "Post.h"
#import "HTMLNode.h"
#import "PostViewCell.h"
#import "HTMLParser.h"

@interface ThreadListViewController ()

@property (nonatomic,strong) NSArray *posts;

@end

@implementation ThreadListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置标题
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *titleDict = [defaults valueForKey:@"title"];
    self.navigationItem.title = titleDict[@"name"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.url = titleDict[@"url"];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _posts.count;
}


- (PostViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"thread" forIndexPath:indexPath];
    
    Post *post = _posts[indexPath.row];
    
    cell.titleLabel.text = post.title;
    cell.authorLabel.text = post.author;
    cell.reviewCountLabel.text = post.reviewCount;
    
    return cell;
}

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
                HTMLNode *node = [listNode findChildTag:@"span"];
                if ([[node getAttributeNamed:@"class"] isEqualToString:@"num"])
                {
                    
                    [numMutableArray addObject:[node contents]];
                }
            
        }
        [countMutableArray addObject:numMutableArray];
    }
    
     _posts = [NSArray arrayWithArray:countMutableArray];
    
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
