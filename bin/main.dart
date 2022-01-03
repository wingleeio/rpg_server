import 'dart:async';
import 'dart:math';
import 'package:socket_io/socket_io.dart';

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
    players[client.id]["isMovingLeft"] = false;
    players[client.id]["isMovingRight"] = false;
    players[client.id]["isMovingUp"] = false;
    players[client.id]["isMovingDown"] = false;
    players[client.id]["x"] = 50;
    players[client.id]["y"] = 50;
    players[client.id]["direction"] = "Direction.down";
    players[client.id]["sprite"] = sprites[Random().nextInt(sprites.length - 1)];
    
    client.emit('initializePlayers', players);

    client.broadcast.emit("playerJoined", players[client.id]);

    client.on("moveLeft", (data) {
      players[client.id]["isMovingLeft"] = data["isMoving"];
      players[client.id]["direction"] = data["direction"];
    });

    client.on("moveRight", (data) {
      players[client.id]["isMovingRight"] = data["isMoving"];
      players[client.id]["direction"] = data["direction"];
    });

    client.on("moveUp", (data) {
      players[client.id]["isMovingUp"] = data["isMoving"];
      players[client.id]["direction"] = data["direction"];
    });

    client.on("moveDown", (data) {
      players[client.id]["isMovingDown"] = data["isMoving"];
      players[client.id]["direction"] = data["direction"];
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

  Timer game = Timer.periodic(Duration(microseconds: ((1000 / 60) * 1000).toInt()), (timer) {
    currentTime = DateTime.now().millisecondsSinceEpoch.toDouble();
    double dt = (currentTime - lastTime) / 1000;
    lastTime = currentTime;
    bool stateChanged = false;

    players.forEach((id, player) {
      if (player["isMovingUp"]) {
        players[id]["x"] += 0;
        players[id]["y"] += dt * -speed;
        stateChanged = true;
      }

      if (player["isMovingDown"]) {
        players[id]["x"] += 0;
        players[id]["y"] += dt * speed;
        stateChanged = true;
      }

      if (player["isMovingLeft"]) {
        players[id]["x"] += dt * -speed;
        players[id]["y"] += 0;
        stateChanged = true;
      }

      if (player["isMovingRight"]) {
        players[id]["x"] += dt * speed;
        players[id]["y"] += 0;
        stateChanged = true;
      }
    });

    if(stateChanged) {
      io.emit("playersUpdated", players);
    }
  });
}