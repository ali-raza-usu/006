package aspects.ms;

import universe.Conversation;
import universe.Protocol;
import universe.Role;
import utilities.statemachine.StateMachine;

public class FTPClient_SM extends StateMachine {
	static {
		register(FTPClient_SM.class, new Protocol("FileTransferPerformanceMonitor"), new Role("FTPClient"));
	}

	public FTPClient_SM(Conversation con) {
		super(con);
	}

	@Override
	public void buildTransitions() {

		addTransition("Initial", 'S', "FileTransferRequest","ClientSendRequest");
		addTransition("ClientSendRequest", 'R', "FileTransferResponse","FileTransferRspRcvd");
		addTransition("FileTransferRspRcvd", 'S', "FileTransferAck","FileTransferAckSend");
		
		//addTransition("Initial", 'R', "FileTransferResponse","ClientReceivedResponse");
		//addTransition("ClientReceivedResponse", 'S', "FileTransferAck","ClientSentFileTransferAck");
	}

	public static Protocol getProtocol() {
		return getProtocolRole().getProtocol();
	}

	public static Role getRole() {
		return getProtocolRole().getRole();
	}
}
