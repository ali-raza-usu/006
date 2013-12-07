package aspects.ms;

import org.apache.log4j.Logger;

import baseaspects.communication.Initialization;
import exp.ftp.FTPClient;
import exp.ftp.FTPServer;

public aspect CommJInitialization extends Initialization {
	Logger logger = Logger.getLogger(CommJInitialization.class);

	@Override
	public void defineMappng() {
		addMapping(FTPClient.class, FTPClient_SM.class);
		//addMapping(FTPServer.class, FTPServer_SM.class);
	}
}
