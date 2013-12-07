package aspects;

import universe.Conversation;
import universe.Protocol;
import universe.Role;
import utilities.statemachine.StateMachine;

public class Client_SM extends StateMachine {
	static {
		register(Client_SM.class, new Protocol("Performancer"), new Role("Client"));
	}

	public Client_SM(Conversation con) {
		super(con);
	}

	@Override
	public void buildTransitions() {
		addTransition("Initial", 'S', "FileTransferRequest","ClientSendRequest");
		addTransition("ClientSendRequest", 'R', "FileTransferResponse","FileTransferRspRcvd");
		addTransition("FileTransferRspRcvd", 'S', "FileTransferAck","FileTransferAckSend");
	}

	public static Protocol getProtocol() {
		return getProtocolRole().getProtocol();
	}

	public static Role getRole() {
		return getProtocolRole().getRole();
	}
}