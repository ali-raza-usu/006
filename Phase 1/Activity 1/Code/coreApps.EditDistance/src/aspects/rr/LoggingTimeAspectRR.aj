package aspects.rr;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import joinpoints.communication.RequestReplyConversationJP;
import org.apache.log4j.Logger;
import baseaspects.communication.RRConversationAspect;
import utilities.Encoder;
import utilities.Message;
import utilities.PerformanceMeasure;

public aspect LoggingTimeAspectRR  extends RRConversationAspect{
	private Logger logger = Logger.getLogger(LoggingTimeAspectRR.class);	
	private String sendTime = "";
	private String endTime = "";	
	static PerformanceMeasure perfMeasure = new PerformanceMeasure();


	Object around(RequestReplyConversationJP _requestReplyJp): ConversationBegin(_requestReplyJp){
		sendTime = getCurrentTime();
     	return proceed(_requestReplyJp);
	}
	
	Object around(RequestReplyConversationJP _requestReplyJp): ConversationEnd(_requestReplyJp){	
		endTime = getCurrentTime();	
     	Message msg =  (Message)Encoder.decode(_requestReplyJp.getSendJp().getBytes());
     	String logString = "Receiver: "+getTargetClass() + " - Message "+ msg.getClass().getSimpleName() + " [ID = " +_requestReplyJp.getConversation().getId().toString()+"] at time "+ endTime;
		System.out.println(logString);
		
     	perfMeasure.updateRollingStatsWindow(calcTurnAroundTime(sendTime, endTime)); 
     	logString += perfMeasure.printCurrentStats();
		logger.debug(logString);		
		System.out.println(logString);
		return proceed(_requestReplyJp);
	}
	
	private double calcTurnAroundTime(String sd, String ed){
		double result = -1;
		
		Date sendTime = convertToTime(sd);
		Date endTime = convertToTime(ed);
		
		result = (endTime.getTime() - sendTime.getTime()) / 1000;
		
		return result;
	}
	
	private Date convertToTime(String date){
		Date result = null;
		
		DateFormat dateFormat = new SimpleDateFormat("HH:mm:ss");
		try {
			result = dateFormat.parse(date);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	private String getCurrentTime(){
		DateFormat dateFormat = new SimpleDateFormat("HH:mm:ss");
		Date date = new Date();
		return dateFormat.format(date);
	}
	
	public static String getTargetClass() {
		StackTraceElement[] elements = Thread.currentThread().getStackTrace();
		String[] classes = elements[elements.length - 1].getClassName().split("\\.");
		return classes[classes.length - 1];
	}
}

			


