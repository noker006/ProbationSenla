public class ChatterService  {
    public static List<FeedItem> copyTrackedChangeFeedItem(Id sourceId, Id targetId) {
        List<FeedItem>  feedItems = [SELECT ID,Body,ParentId,Title,
		(SELECT ID, FieldName, OldValue, NewValue,FeedItemId
		FROM FeedTrackedChanges ORDER BY ID DESC)
		FROM FeedItem WHERE Type='TrackedChange' AND ParentId =: sourceId];
        List<FeedItem> textPostFeedItems = new List<FeedItem>();
        for (FeedItem feedItem : feedItems) {
		String lineTrackedChange = '';
		FeedItem bufferFeedItem = new FeedItem(Type='TextPost');
		lineTrackedChange += feedItem.Body +' '+ feedItem.Title +' ';
		for(FeedTrackedChange feedTC : feedItem.FeedTrackedChanges){
			lineTrackedChange += feedTC.FeedItemId +' '+ feedTC.FieldName 
			+' '+ feedTC.Id +' '+ feedTC.NewValue +' '+ feedTC.OldValue;
		}
		bufferFeedItem.Body = lineTrackedChange;
           	bufferFeedItem.ParentId = targetId;
            	textPostFeedItems.add(bufferFeedItem);
        }
        insert textPostFeedItems;
        return textPostFeedItems;
    }
}
