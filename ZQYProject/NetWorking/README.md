#  https://github.com/yuantiku/YTKNetwork

网络框架用猿题库iOS团队封装的框架，GitHub star 6k+。理解起来也好理解，适用场景也还不错。

baseRequest  改动：
1.移除请求结束 block delegate 置nil（即：去掉打破自动打破循环，block需要weakself），
添加 <YTKRequestParamsDatasource> paramsDatasource;用于传入参
      <YTKForBatchRequestDelegate> forBatchRequestdelegate;用于batchRequest监听请求结束与失败，替换使用delegate监听       
      <YTKRequestHUDDelegate> showHUDdelegate;用于通知隐藏显示HUD。
      <YTKRequestPageAbleDelegate> pageAbledelegate;用于通知上下拉刷新成功失败翻页。
2.
batch Request 改动
添加 <YTKBatchRequestHUDDelegate> showHUDdelegate;用于通知隐藏显示HUD。
        <YTKBatchRequestPageAbleDelegate> pageAbledelegate;用于通知上下拉刷新成功失败翻页。
3.实现showHUDdelegate管理HUD相关逻辑，实现pageAbledelegate  管理上下拉刷新翻页相关逻辑。
