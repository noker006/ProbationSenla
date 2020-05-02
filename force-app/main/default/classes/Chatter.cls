public with sharing class Chatter {
    public void copyTrackedChangeFeedItem(Id sourceId, Id targetId) {
        List<FeedItem>  feedItems = [SELECT ID,Body,ParentId,Title FROM FeedItem WHERE Type='TrackedChange' AND ParentId =: sourceId];
        List<FeedItem> textPostFeedItems = new List<FeedItem>();
        for (FeedItem feedItem : feedItems) {
            FeedItem bufferFeedItem = new FeedItem(Type='TextPost');
            bufferFeedItem.Body = feedItem.Body;
            bufferFeedItem.Title = feedItem.Title;
            bufferFeedItem.ParentId = targetId;
            textPostFeedItems.add(bufferFeedItem);
        }
        insert textPostFeedItems;
    }
}
