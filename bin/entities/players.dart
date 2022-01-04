import '../schema/players.pb.dart';
import '../utils/globals.dart';
import 'package:fixnum/fixnum.dart';

PlayerState encodePlayerState(time) {
  PlayerState playerState = PlayerState();

  playerState.time = Int64(time);

  players.forEach((key, p) {
    Player player = Player();

    player.id = p["id"];
    player.isMovingLeft = p["IML"];
    player.isMovingRight = p["IMR"];
    player.isMovingUp = p["IMU"];
    player.isMovingDown = p["IMD"];
    player.x = p["x"].toDouble();
    player.y = p["y"].toDouble();
    player.direction = p["D"];
    player.sprite = p["S"];

    playerState.players.add(player);
  });

  return playerState;
}
