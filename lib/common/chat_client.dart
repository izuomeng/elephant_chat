import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'package:elephant_chat/entities/chat_message.dart';
import 'package:elephant_chat/entities/chat_session.dart';
import 'package:elephant_chat/entities/socket_message.dart';
import 'package:elephant_chat/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sqflite_manager/flutter_sqflite_manager.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:web_socket_channel/io.dart';

enum ChatOrder { desc, asc }

class ChatClient {
  Database _db;
  IOWebSocketChannel _channel;
  final List<void Function(ChatMessage)> _messageEventHooks = [];

  ChatClient() {
    _channel = IOWebSocketChannel.connect('ws://localhost:3001?uid=klmklm2');
    _channel.stream.listen((message) async {
      Map<String, dynamic> map = json.decode(message);
      SocketMessage socketMessage = SocketMessage.fromJson(map);
      if (socketMessage.type == 101) {
        ChatMessage chatMessage = ChatMessage.fromJson(socketMessage.content);
        await chatClient.insertMessage(chatMessage);
        _messageEventHooks.forEach((hook) {
          hook(chatMessage);
        });
      }
    });
  }

  void registerMessageHook(void Function(ChatMessage) hook) {
    _messageEventHooks.add(hook);
  }

  void unregisterMessageHook(void Function(ChatMessage) hook) {
    _messageEventHooks.retainWhere((item) => item != hook);
  }

  void sendMessage(SocketMessage message) {
    String messageJson = json.encode(message);
    _channel.sink.add(messageJson);
  }

  Future<Database> _getDb() async {
    if (_db is Database) {
      return _db;
    }
    String dbPath = join(await getDatabasesPath(), 'elephant_chat.db');
    // await deleteDatabase(dbPath);
    _db = await openDatabase(
      dbPath,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE messages(id TEXT PRIMARY KEY, text TEXT, type INTEGER, image TEXT, sender TEXT, receiverId TEXT, time INTEGER, haveRead TEXT)",
        );
      },
      version: 1,
    );
    return _db;
  }

  Future<void> insertMessage(ChatMessage message) async {
    Database _database = await _getDb();
    Map<String, dynamic> messageMap = message.toJson();
    messageMap['sender'] = json.encode(messageMap['sender']);
    await _database.insert(
      'messages',
      messageMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ChatMessage>> getMessages(
      {String receiverId,
      String senderId,
      ChatOrder order = ChatOrder.asc}) async {
    Database _database = await _getDb();
    String where;
    List<String> whereArgs;

    if ((receiverId is String) && (senderId is String)) {
      where = 'receiverId = ? and sender like ?';
      whereArgs = [receiverId, '%"id":"$senderId"%'];
    } else if (receiverId is String) {
      where = 'receiverId = ?';
      whereArgs = [receiverId];
    } else if (senderId is String) {
      where = 'sender like ?';
      whereArgs = ['%"id":"$senderId"%'];
    } else {
      where = '';
      whereArgs = [];
    }

    final List<Map<String, dynamic>> maps = await _database.query('messages',
        where: where,
        whereArgs: whereArgs,
        orderBy: 'time ${order.toString().substring(10)}');

    return List.generate(maps.length, (i) {
      Map<String, dynamic> messageMap = maps[i];
      return ChatMessage.fromJson(
          {...messageMap, 'sender': json.decode(messageMap['sender'])});
    });
  }

  Future<List<ChatMessage>> getRelatedMessages(String uid,
      {ChatOrder order = ChatOrder.asc, int limit}) async {
    Database _database = await _getDb();

    final List<Map<String, dynamic>> maps = await _database.query('messages',
        where: 'receiverId = ? or sender like ?',
        whereArgs: [uid, '%"id":"$uid"%'],
        orderBy: 'time ${order.toString().substring(10)}',
        limit: limit);
    return List.generate(maps.length, (i) {
      Map<String, dynamic> messageMap = maps[i];
      return ChatMessage.fromJson(
          {...messageMap, 'sender': json.decode(messageMap['sender'])});
    });
  }

  Future<ChatMessage> getNewestRelatedMessage(String uid) async {
    List<ChatMessage> messageList =
        await getRelatedMessages(uid, order: ChatOrder.desc, limit: 1);
    return messageList.first;
  }

  Future<void> insertMockData() async {
    List.generate(10, (index) => index).forEach((id) {
      insertMessage(ChatMessage(
          id: id.toString(),
          type: 1,
          text: "Hello",
          sender: User(
              id: 'user$id',
              avatar:
                  'https://img.alicdn.com/tfs/TB1U0jFmCR26e4jSZFEXXbwuXXa-320-319.jpg',
              name: 'XXX'),
          receiverId: "klmklm2",
          time: 1602757698732,
          haveRead: "n"));
    });
  }

  Future<User> getUserById(String uid) async {
    return User(
        id: uid,
        avatar:
            'https://gw.alicdn.com/tfs/TB1Bo0ooDM11u4jSZPxXXahcXXa-300-300.jpg',
        name: 'Michael Landis');
  }

  Future<List<ChatSession>> getConversationList(String userId) async {
    final List<ChatMessage> receiveList = await getMessages(receiverId: userId);
    final List<ChatMessage> sendList = await getMessages(senderId: userId);
    final List<ChatSession> chatSessionList = [];
    final Set<String> allchaters = Set()
      ..addAll(receiveList.map((item) => item.sender.id))
      ..addAll(sendList.map((item) => item.receiverId));

    // 并行
    Iterable<Future<void>> futures = allchaters.map((chaterId) async {
      List<ChatMessage> conversations = await getRelatedMessages(chaterId);
      ChatMessage newestMessage = conversations.last;
      // senderChatList可能为空，为空表示对方没说过话
      List<ChatMessage> senderChatList =
          List.from(conversations.where((item) => item.sender.id == chaterId));
      int unreadCnt;
      User sender;

      if (senderChatList.isEmpty) {
        unreadCnt = 0;
        sender = await getUserById(chaterId);
      } else {
        unreadCnt = senderChatList.where((item) => item.haveRead == 'n').length;

        sender = senderChatList.last.sender;
      }

      chatSessionList.add(ChatSession(
          id: sender.id,
          userName: sender.name,
          userAvatar: sender.avatar,
          lastMessageType: newestMessage.type,
          lastMessageContent: newestMessage.text,
          lastMessageTime: newestMessage.time,
          unreadCnt: unreadCnt));
    });

    await Future.wait(futures);

    return chatSessionList;
  }

  Future<Widget> buildDatabaseUI() async {
    Database _database = await _getDb();
    return SqfliteManager(
      database: _database,
      child: Text(''),
      rowsPerPage: 8,
    );
  }
}

ChatClient chatClient = ChatClient();
