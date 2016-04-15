/* File: i3_vim_focus.c
 *
 * Adapted from the script at
 * https://faq.i3wm.org/question/3042/change-the-focus-of-windows-within-vim-and-i3-with-the-same-keystroke/
 *
 */

#include <stdlib.h>
#include <stdio.h>

#include <xdo.h>
#include <sys/socket.h>
#include <sys/un.h>

#include "ipc.h"

char *root_atom_contents(const char *atomname);

int main(int argc, char *argv[]) {
	char cmd[30];

	unsigned char *class;
	unsigned char *host;
	Window window_ret;

	if(argc < 2) {
		fprintf(stderr, "Missing argument\n");
		return 1;
	}

	// Get the class and host of the active window
	xdo_t *xdo = xdo_new(NULL);
	xdo_get_active_window(xdo, &window_ret);

	xdo_get_window_property(xdo, window_ret, "WM_CLASS", &class, NULL, NULL, NULL);
	xdo_get_window_property(xdo, window_ret, "WM_CLIENT_MACHINE", &host, NULL, NULL, NULL);

	// Some debug output
	if( class ) {
		fprintf(stderr, "Class: \"%s\"\n", class);
	}
	else {
		fprintf(stderr, "Class: NULL\n");
	}
	if( host ) {
		fprintf(stderr, "Host: \"%s\"\n", host);
	}
	else {
		fprintf(stderr, "Host: NULL\n");
	}

	if( class && ( strcmp(class, "gvim") == 0 || strcmp(class, "gvimdiff") == 0 ) ) {
		// If it is vim, send a keystroke.
		fprintf(stderr, "VIM!\n", class);

		strcpy(cmd, "Escape");

		xdo_send_keysequence_window(xdo, window_ret, cmd, 0);

		strcpy(cmd, "g+w+");

		strcat(cmd, (argv[1][0] == 'l')? "h" :
				(argv[1][0] == 'd')? "j" :
				(argv[1][0] == 'u')? "k" :
				"l" );

		xdo_send_keysequence_window(xdo, window_ret, cmd, 0);
	}
	else {
		fprintf(stderr, "no VIM!\n", class);

		// Set up the command
		strcpy(cmd, "focus ");
		strcat(cmd, argv[1]);

		/* i3ipcConnection *conn = i3ipc_connection_new(NULL, NULL);

		if( conn ) {
			gchar *reply = i3ipc_connection_message(conn, I3IPC_MESSAGE_TYPE_COMMAND, cmd, NULL);
			g_free(reply);
			g_object_unref(conn);
		}
		else {
			fprintf(stderr, "no connection to i3!\n", class);
		} */

		uint32_t message_type = I3_IPC_MESSAGE_TYPE_COMMAND;

		// Find the correct socket
		char *socket_path = getenv("I3SOCK");
		if(socket_path == NULL) {
			socket_path = root_atom_contents("I3_SOCKET_PATH");
		}

		/* Fall back to the default socket path */
		if(socket_path == NULL) {
			socket_path = strdup("/tmp/i3-ipc.sock");
		}

		int sockfd = socket(AF_LOCAL, SOCK_STREAM, 0);
		if(sockfd == -1) {
			fprintf(stderr, "Could not create socket\n");
			return 1;
		}

		// Open the socket
		struct sockaddr_un addr;
		memset(&addr, 0, sizeof(struct sockaddr_un));
		addr.sun_family = AF_LOCAL;
		strncpy(addr.sun_path, socket_path, sizeof(addr.sun_path) - 1);

		if(connect(sockfd, (const struct sockaddr *)&addr, sizeof(struct sockaddr_un)) < 0) {
			fprintf(stderr, "Could not connect to i3 on socket \"%s\"\n", socket_path);
			return 1;
		}

		// Send it.
		if (ipc_send_message(sockfd, strlen(cmd), message_type, (uint8_t *)cmd) == -1) {
			fprintf(stderr, "IPC: write()\n");
			return 1;
		}

		free(socket_path);
	}

	free(class);
	free(host);
	return 0;
}
