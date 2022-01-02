import 'package:socket_io/socket_io.dart';

Map players = {};

void main() {
    var io = new Server();

    io.on('connection', (client) {
      players[client.id] = {};
      players[client.id]["id"] = client.id;
      players[client.id]["isMovingLeft"] = false;
      players[client.id]["isMovingRight"] = false;
      players[client.id]["isMovingUp"] = false;
      players[client.id]["isMovingDown"] = false;
      
      client.emit('initializePlayers', players);

      client.broadcast.emit("playerJoined", players[client.id]);

      client.on("moveLeft", (data) {
        players[client.id]["isMovingLeft"] = data["isMoving"];
        players[client.id]["direction"] = data["direction"];
        client.broadcast.emit("playerMoved", players[client.id]);
        client.emit("playerMoved", players[client.id]);
      });

      client.on("moveRight", (data) {
        players[client.id]["isMovingRight"] = data["isMoving"];
        players[client.id]["direction"] = data["direction"];
        client.broadcast.emit("playerMoved", players[client.id]);
        client.emit("playerMoved", players[client.id]);
      });

      client.on("moveUp", (data) {
        players[client.id]["isMovingUp"] = data["isMoving"];
        players[client.id]["direction"] = data["direction"];
        client.broadcast.emit("playerMoved", players[client.id]);
        client.emit("playerMoved", players[client.id]);
      });

      client.on("moveDown", (data) {
        players[client.id]["isMovingDown"] = data["isMoving"];
        players[client.id]["direction"] = data["direction"];
        client.broadcast.emit("playerMoved", players[client.id]);
        client.emit("playerMoved", players[client.id]);
      });

      client.on("disconnect", (reason) {
        players.remove(client.id);

        client.broadcast.emit("playerDisconnected", {
          "id": client.id,
        });
      });
    });

    io.listen(3000);
}