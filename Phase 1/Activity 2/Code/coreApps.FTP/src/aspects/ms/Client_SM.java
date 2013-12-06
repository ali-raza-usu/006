package aspects.ms;

import universe.Conversation;
import universe.Protocol;
import universe.Role;
import utilities.statemachine.StateMachine;

public class Client_SM extends StateMachine {
	static {
		register(Client_SM.class, new Protocol("TimeLogger"), new Role("Client"));
	}

	public Client_SM(Conversation con) {
		super(con);
	}

	@Override
	public void buildTransitions() {
		addTransition("Initial", 'S', "Message","WaitForConnection");
		addTransition("WaitForConnection", 'R', "Message","ConnectionOpen");
		addTransition("ConnectionOpen", 'S', "Message","WaitForListOfFiles");
		addTransition("WaitForListOfFiles", 'R', "Message","HasListOfFiles");
		addTransition("HasListOfFiles", 'S', "FileTransferRequest","WaitForChunk");
		addTransition("WaitForChunk", 'R', "FileTransferResponse","WaitForChunk");
		addTransition("WaitForChunk", 'S', "FileTransferAck","Terminate");
	}

	public static Protocol getProtocol() {
		return getProtocolRole().getProtocol();
	}

	public static Role getRole() {
		return getProtocolRole().getRole();
	}
}
