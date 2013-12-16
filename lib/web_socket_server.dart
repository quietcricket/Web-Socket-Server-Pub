library websocket_server;

import 'dart:async';
import 'dart:io';

/**
 * Every connection is represented by a [WebSocketConnection] instance
 * Extend this to store information like nick name, id etc.
 */
class WebSocketConnection{
}


/**
 * This class is based off Dart:io [HttpServer]
 * It convert/transforms an HttpServer into a WebSocketServer
 */
class WebSocketServer{
  /**
   * Default port number
   */
  static const int DEFAULT_PORT=8080;
  /**
   * Default listening IP address.
   * Listening to any IP address
   */
  static const String DEFAULT_IP="0.0.0.0";
  /**
   * A map for quick look up on which [WebSocketConnection] is using the [WebSocket] instance
   *
   */
  Map socketConnectionMap=new Map<WebSocket,WebSocketConnection>();

  /**
   * Construct an unsecured server
   * The parameters [address] and [port] are identical to [HttpServer]'s bind function
   */
  WebSocketServer.server({dynamic address:DEFAULT_IP, int port:DEFAULT_PORT}){
    HttpServer.bind(address, port).then(serverCreated, onError: (e)=>print(e));
  }

  /**
   * Shortcut to have a default unsecured server
   */
  WebSocketServer():this.server();

  /**
   * Construct an secure server
   * The parameters [address], [port], [certificateName] and [requestClientCertificate]
   * are identical as [HttpServer]'s bindSecure parameters
   */
  WebSocketServer.secureServer({dynamic address:DEFAULT_IP,
                              int port:DEFAULT_PORT,
                              String certificateName,
                              bool requestClientCertificate: false
                            }){
    HttpServer.bindSecure(address,
                          port,
                          certificateName: certificateName,
                          requestClientCertificate: requestClientCertificate
                          ).then(serverCreated,onError:(e)=>print(e));
    }

  /**
   * When the HttpServer is created, transform the server stream into WebSocketStream
   * and start listen to incoming connections
   */
  void serverCreated(HttpServer server){
    print("Server created: ${server.address.address}:${server.port}");
    server.transform(new WebSocketTransformer()).listen(connectionCreated);
  }


  /**
   * When a connection is established, start listening to [WebSocket] stream.
   *
   * NB: The Dart API should pass in the [WebSocket] as a parameter for [onData] and [onDone] event.
   * I have to rely on an inline function to get hold of the [WebSocket] instance.
   *
   */
  void connectionCreated(WebSocket ws){
    ws.listen(
        (String message){
          messageReceived(ws,message);
        },
        onError:(e)=>print(e),
        onDone:(){
          connectionClosed(ws);
        });
    addConnection(ws);
  }

  /**
   * Create a [WebSocketConnection] instance to link up with the [WebSocket]
   *
   * Called from [connectionCreated] function.
   * It is seprated out for override
   */
  void addConnection(WebSocket ws){
    WebSocketConnection con=new WebSocketConnection();
    socketConnectionMap[ws]=con;
  }

  /**
   * Handles incoming messages
   * You have to define your own convention of how the message is passed and prcessed.
   *
   * The old school way will be using "|" to separate commands
   * and parameters, e.g. "change_nick|StrongHands". The good thing about this method
   * is that you can map commands into numbers ("2" for change_nick). The message
   * can be simplified into "2|StrongHands". It's shorter which means faster.
   *
   * The "new school" way is to use JSON. The message may look like {"cmd":"change_nick","val":"StrongHands"}
   * It's clearer but at the cost of a bigger/longer message.
   *
   */
  void messageReceived(WebSocket ws,String message){

  }

  /**
   * Handles connection closed.
   * Remove the reference of the related [WebSocketConnection] instance
   */
  void connectionClosed(WebSocket ws){
    socketConnectionMap.remove(socketConnectionMap[ws]);
  }
}