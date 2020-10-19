import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'package:elephant_chat/entities/chat_message.dart';
import 'package:elephant_chat/entities/chat_session.dart';
import 'package:elephant_chat/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sqflite_manager/flutter_sqflite_manager.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:web_socket_channel/io.dart';

class ChatClient {
  Database _db;
  final channel = IOWebSocketChannel.connect('ws://localhost:3001');

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

  Future<List<ChatMessage>> getMessages({String receiverId}) async {
    Database _database = await _getDb();
    final List<Map<String, dynamic>> maps = await _database
        .query('messages', where: 'receiverId = ?', whereArgs: [receiverId]);

    return List.generate(maps.length, (i) {
      Map<String, dynamic> messageMap = maps[i];
      // messageMap['sender'] = json.decode(messageMap['sender']);
      return ChatMessage.fromJson(
          {...messageMap, 'sender': json.decode(messageMap['sender'])});
    });
  }

  Future<void> insertMockData() async {
    String genId() => int.parse(Random().nextDouble().toString().substring(2))
        .toRadixString(35);
    List.generate(10, (index) => genId()).forEach((id) {
      insertMessage(ChatMessage(
          id: id,
          type: 1,
          text: "I miss you so much",
          sender: User(
              id: genId(),
              avatar:
                  'https://img.alicdn.com/tfs/TB1U0jFmCR26e4jSZFEXXbwuXXa-320-319.jpg',
              name: 'XXX'),
          receiverId: "klmklm",
          time: 1602757396232,
          haveRead: "n"));
    });
  }

  Future<List<ChatSession>> getConversationList(String userId) async {
    final List<ChatMessage> chatMessageList =
        await getMessages(receiverId: userId);
    final List<ChatSession> chatSessionList = [];
    final Map<String, List<ChatMessage>> midMap = {};

    for (ChatMessage chatMessage in chatMessageList) {
      if (midMap.containsKey(chatMessage.sender.id)) {
        midMap[chatMessage.sender.id].add(chatMessage);
      } else {
        midMap[chatMessage.sender.id] = [chatMessage];
      }
    }

    midMap.forEach((senderId, conversations) {
      conversations.sort((left, right) => left.time - right.time);
      ChatMessage newestMessage = conversations.last;
      int unreadCnt =
          conversations.where((item) => item.haveRead == 'n').length;
      User sender = newestMessage.sender;

      chatSessionList.add(ChatSession(
          id: sender.id,
          userName: sender.name,
          userAvatar: sender.avatar,
          lastMessageType: newestMessage.type,
          lastMessageContent: newestMessage.text,
          unreadCnt: unreadCnt));
    });

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
