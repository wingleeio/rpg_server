import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'dart:ffi';
import 'dart:convert';
import 'dart:typed_data';
import 'package:socket_io/socket_io.dart';
import 'package:dart_native_compression/dart_native_compression.dart';

Map players = {};

double speed = 150.0;

var sprites = [
  "demon_swordsman.png",
  "great_sage.png",
  "high_priest.png",
  "mercenary.png",
  "monster_whisperer.png",
  "queen_dragoon.png",
  "time_witch.png",
  "wolf_bard.png",
];

void main() {
  var io = new Server();

  io.on('connection', (client) {
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
  });

  io.listen(3000);

  double lastTime = 0.0;
  double currentTime = 0.0;

  Timer game = Timer.periodic(Duration(microseconds: ((1000 / 5) * 1000).toInt()), (timer) {
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