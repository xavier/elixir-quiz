$(function() {

  var ChatRoom = {
    people: [],
    nickname: "Troubadour2000",
    ui: {
      refreshRoster: function () {
        $('#roster-count').html(ChatRoom.people.length)
        $('#roster').html(ChatRoom.people)
      },
      appendMessage: function (nickname, msg) {
        var html = '[' + nickname + '] ' + msg + '<br>';
        $('#messages').append(html);
      }
    }
  }

  var socket = new Phoenix.Socket("/ws");

  socket.join("chat_room", "chat_room", {foo: "bar"}, function(channel) {

    channel.send("chat_room:join", {nickname: ChatRoom.nickname});

    channel.on("chat_room:joined", function(message) {
      ChatRoom.people.push(message.nickname)
      ChatRoom.ui.appendMessage(message.nickname, "*** Entered the room ***")
      ChatRoom.ui.refreshRoster();
    });

    channel.on("chat_room:left", function(message) {
      ChatRoom.ui.appendMessage(message.nickname, "*** Left the room ***")
      ChatRoom.ui.refreshRoster();
    });

    channel.on("chat_room:message", function(message) {
      ChatRoom.ui.appendMessage(message.nickname, message.message)
    });

    $('#leave-room-button').click(function() {
      channel.send("chat_room:leave", {nickname: ChatRoom.nickname});
    });

    sendMessage = function () {
      var message = $('#message').val();
      channel.send("chat_room:message", {nickname: ChatRoom.nickname, message: message});
      $('#message').val('');
    }

    $('#message').keypress(function (event) {
      if (event.charCode == 13) {
        sendMessage()
      }
    });

    $('#send-message-button').click(sendMessage)

  });

});