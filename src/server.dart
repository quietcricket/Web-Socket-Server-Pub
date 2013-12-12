part of web_socket_server;

class WebSocketServer{
  /**
   * This class is based off Dart:io [HttpServer]
   * It convert/transforms an HttpServer into a SocketServer
   */

  static const int DEFAULT_PORT=8080;
  static const String DEFAULT_IP="0.0.0.0";

  List<WebSocketChannel> channels;

  /**
   * Construct an unsecured server
   * The parameters [address] and [port] are identical to [HttpServer]'s bind function
   */
  WebSocketServer.server({dynamic address:DEFAULT_IP, int port:DEFAULT_PORT}){
    HttpServer.bind(address, port).then(serverCreated, onError: serverError);
  }

  /**
   * Construct an secure server
   * The parameters [address], [port], [certificateName] and [requestClientCertificate]
   * are itentical as [HttpServer]'s bindSecure parameters
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
                          ).then(serverCreated,onError:serverError);
    }

  void serverCreated(HttpServer server){
    server.transform(new WebSocketTransformer()).listen(socketCreated,onError:serverError);
    channels=new List<WebSocketChannel>();
  }

  void addChannel(String channelName){
    MirrorSystem mirrors = currentMirrorSystem();
    LibraryMirror lm = mirrors.findLibrary(new Symbol(libraryName));
    ClassMirror cm=lm.declarations[new Symbol(channelClassName)] as ClassMirror;
    InstanceMirror im=cm.newInstance(const Symbol(''), [channelName]);
    channels.add(im.reflectee);
  }

  void serverError(Error e){
    print(e);
  }

  void socketCreated(WebSocket ws){
    WebSocketConnection con=new WebSocketconnection
  }

}

void main(){
  WebSocketServer s=new WebSocketServer.server();
  s.addChannel('Default Channel');
}