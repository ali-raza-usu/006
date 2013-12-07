package aspects.ms;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import joinpoints.communication.MultistepConversationJP;

import org.apache.log4j.Logger;

import baseaspects.communication.MultistepConversationAspect;

public aspect MeasurePerformanceAspect extends MultistepConversationAspect {

	private Logger logger = Logger.getLogger(MeasurePerformanceAspect.class);

	private static PerformanceMeasure performanceMeasure = new PerformanceMeasure();
	private static long startTime = 0;

	Object around(MultistepConversationJP _multiStepJP): ConversationBegin(_multiStepJP){
		logger.debug("MeasurePerformanceAspect : ConversationBegin(rrjp)");
		String trgtClass = getTargetClass();
		if(startTime == 0){
			startTime = System.currentTimeMillis();
			System.out.println(trgtClass + " : start time "+ startTime);
		}
		return proceed(_multiStepJP);
	}

	Object around(MultistepConversationJP _multiStepJP): ConversationEnd(_multiStepJP){
		logger.debug("MeasurePerformanceAspect : ConversationEnd(rrjp)");
		Object obj = proceed(_multiStepJP);
		String trgtClass = getTargetClass();
		long endTime = System.currentTimeMillis();
		System.out.println(trgtClass + " : "+endTime + " start time :"+ startTime);
		long totalTurnAroundTime = (endTime - startTime) / 10;
		performanceMeasure.updateRollingStatsWindow(totalTurnAroundTime);
		logger.debug(performanceMeasure.printCurrentStats());
		System.out.println("multistep:\n "+performanceMeasure.printCurrentStats());
		return obj;
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