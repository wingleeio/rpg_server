import 'dart:async';

import 'package:socket_io/socket_io.dart';

import '../utils/constants.dart';

void startGame(Server io) {
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

    io.emit("playersUpdated", {
      "T": DateTime.now().millisecondsSinceEpoch,
      "P": players,
    });
  });
}
