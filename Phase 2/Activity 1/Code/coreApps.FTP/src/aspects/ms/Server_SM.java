package aspects.ms;

import universe.Conversation;
import universe.Protocol;
import universe.Role;
import utilities.statemachine.StateMachine;

public class Server_SM extends StateMachine {
	static {
		register(Server_SM.class, new Protocol("TimeLogger"),new Role("Server"));
	}

	public Server_SM(Conversation con) {
		super(con);
	}

	@Override
	public void buildTransitions() {
		addTransition("Initial", 'R', "FileTransferRequest","ReceiveFTPReq");
		addTransition("ReceiveFTPReq", 'S', "FileTransferResponse","SendFileTransferRes");
		addTransition("SendFileTransferRes", 'S', "FileTransferResponse","SendFileTransferRes");
	}

	public static Protocol getProtocol() {
		return getProtocolRole().getProtocol();
	}

	public static Role getRole() {
		return getProtocolRole().getRole();
	}
}
