package aspects.ms;
import application.FTPClient_;
//import application.FTPServer_;
import org.apache.log4j.Logger;

public aspect SMInitialization extends baseaspects.communication.Initialization {
	Logger logger = Logger.getLogger(SMInitialization.class);

	@Override
	public void defineMappng() {
		addMapping(FTPClient_.class, Client_SM.class);
		//addMapping(Server.class, Server_SM.class);
	}
}
 