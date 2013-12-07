package aspects;

import java.util.Date;
import java.util.HashMap;

import joinpoints.communication.RequestReplyConversationJP;
import baseaspects.communication.RRConversationAspect;

public aspect PerformanceTimeAspectRR  extends RRConversationAspect{
	
	private PerformanceMeasure pm = new PerformanceMeasure();
	HashMap<Integer, Long> conversationMap = new HashMap<Integer, Long>();

	Object around(RequestReplyConversationJP _requestReplyJp): ConversationBegin(_requestReplyJp){
//		conversationMap.put(_requestReplyJp.getMessageId(), new Date().getTime());
     	return proceed(_requestReplyJp);
	}
	
	Object around(RequestReplyConversationJP _requestReplyJp): ConversationEnd(_requestReplyJp){	
//		long convStartTime = conversationMap.get(_requestReplyJp.getMessageId());
//
//		long convEndTime = new Date().getTime();
//		pm.updateRollingStatsWindow((double) (convEndTime - convStartTime));
//		System.out.println(pm.printCurrentStats());
		return proceed(_requestReplyJp);
	}

	//easiest solution

	//public aspect PerformanceTimeAspectRR  extends RRConversationAspect{
//		private PerformanceMeasure pm = new PerformanceMeasure();
	//
//		long startTime;
//		Object around(RequestReplyConversationJP _requestReplyJp): ConversationBegin(_requestReplyJp){
//			startTime =  new Date().getTime();
//	     	return proceed(_requestReplyJp);
//		}
	//	
//		Object around(RequestReplyConversationJP _requestReplyJp): ConversationEnd(_requestReplyJp){	
//			//long convStartTime = conversationMap.get(_requestReplyJp.getMessageId());
	//
//			long convEndTime = new Date().getTime();
//			pm.updateRollingStatsWindow((double) (convEndTime - startTime));
//			System.out.println(pm.printCurrentStats());
//			return proceed(_requestReplyJp);
//		}
	//}
	

}

			


