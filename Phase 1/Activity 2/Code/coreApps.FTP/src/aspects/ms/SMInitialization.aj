package aspects.ms;
import application.FTPClient;
//import application.FTPServer_;
import org.apache.log4j.Logger;

public aspect SMInitialization extends baseaspects.communication.Initialization {
	Logger logger = Logger.getLogger(SMInitialization.class);

	@Override
	public void defineMappng() {
		addMapping(FTPClient.class, Client_SM.class);
//		addMapping(FTPServer_.class, Server_SM.class);
	}
}
 