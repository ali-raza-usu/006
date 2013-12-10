package aspects.ms;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import joinpoints.communication.MultistepConversationJP;
import org.apache.log4j.Logger;
import utilities.Encoder;
import utilities.FileTransferResponse;
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
	}

	after(MultistepConversationJP _multiStepJP): ConversationEnd(_multiStepJP){
		
		endTime = getCurrentTime();	
     	Message msg =  (Message)Encoder.decode(_multiStepJP.getBytes());
     	if(msg.getClass().getSimpleName().equals(FileTransferResponse.class.getSimpleName())){
     		FileTransferResponse _response  = (FileTransferResponse)msg;
     		if(_response.isComplete()){
     			perfMeasure.updateRollingStatsWindow(calcTurnAroundTime(sendTime, endTime)); 
		     	String logString = perfMeasure.printCurrentStats();
				logger.debug(logString);
				System.out.println(logString);
     		}
     	}
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
