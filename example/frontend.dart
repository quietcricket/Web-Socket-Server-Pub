import 'dart:html';

void main() {
  /*
   * This WebSocket is different from the server WebSocket.
   * This one is in dart:html package
   * The server one is in dart:io package
   */
  var ws = new WebSocket('ws://127.0.0.1:8080');
  /**
   * Listen to different states
   */
  ws.onError.listen((socket)=>appendMessage('Failed to connect to the server'));
  ws.onOpen.listen((socket)=>appendMessage('Connection Established'));
  ws.onClose.listen((socket)=>appendMessage('Connection Closed'));
  ws.onMessage.listen((MessageEvent e)=>appendMessage(e.data.toString()));
  /**
   * Add keyboard listener
   * Auto send when enter key is pressed
   */
  querySelector('#message').onKeyDown.listen((e){
    if(e.keyCode==13){
      ws.send(e.target.value);
      e.target.value="";
    }
  });
  querySelector('#message').focus();
}

void appendMessage(String message){
  querySelector('#chat').appendHtml(message +'<br/>');
  querySelector('#chat').scrollByLines(100);
}