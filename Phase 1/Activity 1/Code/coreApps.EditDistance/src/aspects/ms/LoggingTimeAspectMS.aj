package aspects.ms;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import joinpoints.communication.MultistepConversationJP;
import org.apache.log4j.Logger;
import utilities.Encoder;
import utilities.Message;
import baseaspects.communication.MultistepConversationAspect;

import utilities.PerformanceMeasure;

public aspect LoggingTimeAspectMS extends MultistepConversationAspect {

	private Logger logger = Logger.getLogger(LoggingTimeAspectMS.class);
	static String timingInfo = "";
	private String sendTime = "";
	private String endTime = "";	
	static PerformanceMeasure perfMeasure = new PerformanceMeasure();

	before(MultistepConversationJP _multiStepJP): ConversationBegin(_multiStepJP){
		
		sendTime = getCurrentTime();
     	Message msg =  (Message)Encoder.decode(_multiStepJP.getBytes());
     	String logString = null;
     	if(_multiStepJP.getConversation() == null)
     		logString = "Multistep : MS Sender: "+getTargetClass() + " - Message "+ msg.getClass().getSimpleName() + " [ID = " +_multiStepJP.getConversation()+"] at time "+ sendTime;
     	else
     		logString = "Multistep: MS Sender: "+getTargetClass() + " - Message "+ msg.getClass().getSimpleName() + " [ID = " +_multiStepJP.getConversation().getId().toString()+"] at time "+ sendTime;
		logger.debug(logString);		
		System.out.println(logString);
	}

	after(MultistepConversationJP _multiStepJP): ConversationEnd(_multiStepJP){
		
		endTime = getCurrentTime();	
     	Message msg =  (Message)Encoder.decode(_multiStepJP.getBytes());
     	String logString = " Multistep: MS Receiver: "+getTargetClass() + " - Message "+ msg.getClass().getSimpleName() + " [ID = " +_multiStepJP.getConversation().getId().toString()+"] at time "+ endTime;
     	logString += getRoundTripTime();
     	System.out.println(logString);
		
     	perfMeasure.updateRollingStatsWindow(calcTurnAroundTime(sendTime, endTime)); 
     	logString += perfMeasure.printCurrentStats();
		logger.debug(logString);		
		
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
	
	private String getRoundTripTime()
	{
		DateFormat dateFormat = new SimpleDateFormat("HH:mm:ss");
		Date st = null;
		Date et = null;
	    try {
			st = dateFormat.parse(sendTime);
			et = dateFormat.parse(endTime);
		} catch (ParseException e) {
			e.printStackTrace();
		}
	    
		long diff = et.getTime() - st.getTime();
		long diffSeconds = diff / 1000 % 60;
		long diffMinutes = diff / (60 * 1000) % 60;         
		long diffHours = diff / (60 * 60 * 1000);           
		
		String logString = "\nRound trip time is " + diffHours + ":" + diffMinutes + ":" + diffSeconds;
		return logString;
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
