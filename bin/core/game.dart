import 'dart:async';

import '../entities/players.dart';
import '../utils/globals.dart';

void startGame() {
  double lastTime = 0.0;
  double currentTime = 0.0;

  Timer.periodic(Duration(microseconds: ((1000 / 10) * 1000).toInt()), (timer) {
    currentTime = DateTime.now().millisecondsSinceEpoch.toDouble();
    double dt = (currentTime - lastTime) / 1000;
    lastTime = currentTime;

    players.forEach((id, player) {
      if (player["IMU"]) {
        players[id]["x"] += 0;
        players[id]["y"] += dt * -speed;
      }

      if (player["IMD"]) {
        players[id]["x"] += 0;
        players[id]["y"] += dt * speed;
      }

      if (player["IML"]) {
        players[id]["x"] += dt * -speed;
        players[id]["y"] += 0;
      }

      if (player["IMR"]) {
        players[id]["x"] += dt * speed;
        players[id]["y"] += 0;
      }
    });

    final playerState =
        encodePlayerState(DateTime.now().millisecondsSinceEpoch);

    io.emit("playersUpdated", playerState.writeToBuffer());
  });
}
