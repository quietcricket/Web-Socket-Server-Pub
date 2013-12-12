part of web_socket_server;


class WebSocketConnection{
  /**
   * Give a random string id to identify each connection
   */
  String id;
  /**
   * The [WebSocket] the connection is using
   */
  WebSocket ws;

  WebSocketConnection(this.ws){

  }


}