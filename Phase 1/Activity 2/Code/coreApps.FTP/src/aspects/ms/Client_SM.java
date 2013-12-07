package aspects.ms;

import universe.Conversation;
import universe.Protocol;
import universe.Role;
import utilities.statemachine.StateMachine;

public class Client_SM extends StateMachine {
	static {
		register(Client_SM.class, new Protocol("TimeLogger"), new Role("FTPClient_"));
	}

	public Client_SM(Conversation con) {
		super(con);
	}

	@Override
	public void buildTransitions() {
		addTransition("Initial", 'S', "FileTransferRequest","ClientSendRequest");
		addTransition("ClientSendRequest", 'R', "FileTransferRequest","FileTransferRcvd");
		addTransition("FileTransferRcvd", 'S', "FileTransferAck","FileTransferAckSent");
		//addTransition("Initial", 'R', "FileTransferRequest","HasListOfFiles");
		//addTransition("HasListOfFiles", 'S', "FileTransferRequest","FileTransferRequestSent");
		//addTransition("FileTransferRequestSent", 'R', "FileTransferResponse","WaitForChunk");
		//addTransition("WaitForChunk", 'S', "FileTransferAck","Terminate");
	}

	public static Protocol getProtocol() {
		return getProtocolRole().getProtocol();
	}

	public static Role getRole() {
		return getProtocolRole().getRole();
	}
}
