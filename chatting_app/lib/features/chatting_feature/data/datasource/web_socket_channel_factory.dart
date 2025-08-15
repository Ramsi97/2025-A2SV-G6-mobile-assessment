
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class WebSocketChannelFactory {
  WebSocketChannel create(String url);
}

class WebSocketChannelFactoryImpl implements WebSocketChannelFactory {
  @override
  WebSocketChannel create(String url) {
    return WebSocketChannel.connect(Uri.parse(url));
  }

}