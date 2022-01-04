import 'package:socket_io/socket_io.dart';

import 'core/connection.dart';
import 'core/game.dart';
import 'utils/globals.dart';

void main() {
  io = new Server();

  io.on('connection', connection);

  io.listen(3000);

  startGame();
}
