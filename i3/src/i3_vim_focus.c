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
	Window window_ret;

	if(argc < 2) {
		fprintf(stderr, "Missing argument\n");
		return 1;
	}

	// Get the class of the active window
	xdo_t *xdo = xdo_new(NULL);
	int ret = xdo_get_active_window(xdo, &window_ret);

	if ( ret != XDO_ERROR ) {
		xdo_get_window_property(xdo, window_ret, "WM_CLASS", &class, NULL, NULL, NULL);
	}

	// Some debug output
	if( class ) {
		fprintf(stderr, "Class: \"%s\"\n", class);
	}
	else {
		fprintf(stderr, "Class: NULL\n");
	}

	if(
			(ret != XDO_ERROR )
			&&
			class
			&&
			( strcmp(class, "gvim") == 0 || strcmp(class, "gvimdiff") == 0 )
		) {
		// If it is vim, send a keystroke.
		fprintf(stderr, "VIM!\n");

		switch( argv[1][0] ) {
			case 'l':
				strcpy(cmd, "F16");
				break;
			case 'd':
				strcpy(cmd, "F17");
				break;
			case 'u':
				strcpy(cmd, "F18");
				break;
			case 'r':
				strcpy(cmd, "F19");
				break;
			default:
				strcpy(cmd, "");
				break;
		}

		xdo_send_keysequence_window(xdo, CURRENTWINDOW, cmd, 20000);
	}
	else {
		fprintf(stderr, "no VIM!\n");

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
	return 0;
}
