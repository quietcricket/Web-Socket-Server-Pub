part of web_socket_server;

class WebSocketChannel{
  static const DEFAULT_MAX_CONNECTIONS=100;
  /**
   * Maximum number of connections
   */
  int maxConnections;
  String id;
  List<WebSocketConnection> connections;

  WebSocketChannel(this.id,{this.maxConnections:DEFAULT_MAX_CONNECTIONS}){
    connections=new List<WebSocketConnection>();
  }

  /**
   * Join the channel
   * Will get a false if the channel has reached max users
   */
  bool join(WebSocketConnection con){
    if(connections.length==maxConnections){
      return false;
    }else{
      connections.add(con);
      return true;
    }

  }

  /**
   * Leave the channel
   * If the connection is not found, return false
   * If the connection is successfully remove, return true
   */
  bool leave(WebSocket ws){
    for(WebSocketConnection con in connections){
      if(con.ws==ws){
        connections.remove(con);
        return true;
      }
    }
    return false;
  }


}