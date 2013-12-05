package aspects.owr;
import org.apache.log4j.Logger;

import interactive.Client;
import interactive.Server;

public aspect SMInitialization extends baseaspects.communication.Initialization {
	Logger logger = Logger.getLogger(SMInitialization.class);

	@Override
	public void defineMappng() {
	}
}
 