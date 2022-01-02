import 'dart:async';
import 'package:socket_io/socket_io.dart';

Map players = {};

double speed = 150.0;

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

    players.forEach((id, player) {
      if (player["isMovingUp"]) {
        players[id]["x"] += 0;
        players[id]["y"] += dt * -speed;
      }

      if (player["isMovingDown"]) {
        players[id]["x"] += 0;
        players[id]["y"] += dt * speed;
      }

      if (player["isMovingLeft"]) {
        players[id]["x"] += dt * -speed;
        players[id]["y"] += 0;
      }

      if (player["isMovingRight"]) {
        players[id]["x"] += dt * speed;
        players[id]["y"] += 0;
      }
    });

    io.emit("playersUpdated", players);
  });
}