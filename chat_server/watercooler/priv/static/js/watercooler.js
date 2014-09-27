(function () {

  R = React.DOM;

  var Watercooler = {}

  Watercooler.Roster = React.createClass({
    displayName: 'Roster',
    render: function() {
      var renderUser = function(user) {
        return R.li(null, user.nickname);
      };
      return R.div({className: "roster"},
        R.h4(null, "Roster ("+this.props.users.length+")"),
        R.ul(null, this.props.users.map(renderUser))
      );
    }
  });

  Watercooler.Message = React.createClass({
    displayName: 'Message',
    render: function() {
      return R.div({className: (this.props.message.system ? "system-message" : "message")},
        R.strong(null, "[" + this.props.message.nickname + "] "),
        R.span(null, this.props.message.text)
      )
    }
  });

  Watercooler.MessageList = React.createClass({
    displayName: "MessageList",
    render: function(){
      var renderMessage = function(message) {
        return Watercooler.Message({message: message})
      }
      return R.div({className: "messages"}, this.props.messages.map(renderMessage));
    }
  });

  Watercooler.CommandPanel = React.createClass({
    displayName: "CommandPanel",

    getInitialState: function () {
      return {text: ""};
    },

    textUpdated: function (e) {
      this.setState({text: e.target.value});
    },

    clearText: function () {
      this.setState({text: ""});
    },

    joinRoom: function (e) {
      e.preventDefault();
      this.props.onJoin(this.state.text);
      this.clearText()
    },

    leaveRoom: function(e) {
      e.preventDefault();
      this.props.onLeave();
      this.clearText()
    },

    sendMessage: function (e) {
      e.preventDefault();
      this.props.onMessage(this.state.text);
      this.clearText()
    },

    renderJoinRoomForm: function () {
      return R.div({className: "row"},
          R.div({className: "col-md-3"}),
          R.div({className: "col-md-9"},
            R.form({onSubmit: this.joinRoom},
              R.input({onChange: this.textUpdated, value: this.state.text, placeholder: "nickname"}),
              R.button(null, "Join room")
            )
          )
        );
    },

    renderSendMessageForm: function () {
      return R.div({className: "row"},
          R.div({className: "col-md-3"},
            R.button({onClick: this.leaveRoom}, "Leave room")
          ),
          R.div({className: "col-md-6"},
            R.form({onSubmit: this.sendMessage},
              R.input({onChange: this.textUpdated, value: this.state.text})
            )
          )
        );
    },

    render: function(){
      if (this.props.user.nickname) {
        return this.renderSendMessageForm();
      } else {
        return this.renderJoinRoomForm();
      }
    }
  });


  var socket = new Phoenix.Socket("/ws");

  // FIXME the app is completely reinitialized when the channel is reset
  socket.join("chat_room", "chat_room", {}, function(channel) {

    Watercooler.App = React.createClass({
      displayName: 'Watercooler',

      getInitialState: function() {

        channel.on("chat_room:joined", this.userJoined)
        channel.on("chat_room:left", this.userLeft)
        channel.on("chat_room:message", this.messageReceived)

        return {
          users: [],
          user: {nickname: null},
          messages: []
        };
      },

      appendMessage: function(nickname, text, system) {
        msg = {nickname: nickname, text: text, system: system}
        this.state.messages.push(msg)
        this.setState({messages: this.state.messages})
      },

      userJoined: function (e) {
        this.setState({users: e.users});
        this.appendMessage(e.nickname, "*** Joined the room ***", true);
      },

      userLeft: function (e) {
        this.setState({users: e.users});
        this.appendMessage(e.nickname, "*** Left the room ***", true);
      },

      messageReceived: function(e) {
        this.appendMessage(e.nickname, e.message)
      },

      joinRoom: function (nickname) {
        this.setState({user: {nickname: nickname}});
        channel.send("chat_room:join", {nickname: nickname});
      },

      leaveRoom: function (nickname) {
        channel.send("chat_room:leave", {nickname: this.state.user.nickname});
        this.setState({user: {nickname: null}});
      },

      sendMessage: function(message) {
        payload = {
          nickname: this.state.user.nickname,
          message: message
        }
        channel.send("chat_room:message", payload);
      },

      render: function() {
        return R.div(null,
          R.div({className: "row"},
            R.div({className: "col-md-3"}, Watercooler.Roster({users: this.state.users})),
            R.div({className: "col-md-9"}, Watercooler.MessageList({messages: this.state.messages}))
          ),
          Watercooler.CommandPanel({user: this.state.user, onJoin: this.joinRoom, onLeave: this.leaveRoom, onMessage: this.sendMessage})
          //, R.pre(null, JSON.stringify(this.state))
        );
      }

    });

    //window.onload = function() {
      React.renderComponent(Watercooler.App(null), document.getElementById('watercooler'));
    //};

  });


})();