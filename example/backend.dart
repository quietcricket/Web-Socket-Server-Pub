import 'package:web_socket_server/web_socket_server.dart';

import "dart:io";

class MyConnection extends WebSocketConnection{

  static int counter=1;
  String id;
  MyConnection(){
    counter++;
    id="Guest $counter";
  }
}

class MyServer extends WebSocketServer{

  /**
   * Override the default function
   */

  void addConnection(WebSocket ws){
    MyConnection con=new MyConnection();
    socketConnectionMap[ws]=con;
  }

  /**
   * override default implementation, which is empty
   * broadcast incoming message to all connected clients
   */
  void messageReceived(WebSocket ws,String message){
    message="${socketConnectionMap[ws].id}: $message";
    socketConnectionMap.forEach((k,v)=>k.add(message));
  }

}

void main(){
  new MyServer();
}
