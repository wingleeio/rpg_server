import 'dart:math';

import '../utils/constants.dart';

void connection(client) {
  players[client.id] = {};
  players[client.id]["id"] = client.id;
  players[client.id]["IML"] = false;
  players[client.id]["IMR"] = false;
  players[client.id]["IMU"] = false;
  players[client.id]["IMD"] = false;
  players[client.id]["x"] = 50;
  players[client.id]["y"] = 50;
  players[client.id]["D"] = "Direction.down";
  players[client.id]["S"] = sprites[Random().nextInt(sprites.length - 1)];

  client.on("moveLeft", (data) {
    players[client.id]["IML"] = data["isMoving"];
    players[client.id]["D"] = data["direction"];
  });

  client.on("moveRight", (data) {
    players[client.id]["IMR"] = data["isMoving"];
    players[client.id]["D"] = data["direction"];
  });

  client.on("moveUp", (data) {
    players[client.id]["IMU"] = data["isMoving"];
    players[client.id]["D"] = data["direction"];
  });

  client.on("moveDown", (data) {
    players[client.id]["IMD"] = data["isMoving"];
    players[client.id]["D"] = data["direction"];
  });

  client.on("disconnect", (reason) {
    players.remove(client.id);

    client.broadcast.emit("playerDisconnected", {
      "id": client.id,
    });
  });
}
