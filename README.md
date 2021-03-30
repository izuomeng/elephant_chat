# elephant_chat

首先启动elephant_node：
```shell
# 启动ts编译服务
npm run dev
# 启动node服务
npm start
```

然后安装项目依赖
```shell
flutter pub get
```

最后打开vscode的debug面板，点击Start

附：初始sql
```sql
create table user_friend
(
    id       TEXT
        primary key,
    from_uid TEXT,
    to_uid   TEXT,
    agreed   TEXT,
    time     INTEGER
);

INSERT INTO user_friend (id, from_uid, to_uid, agreed, time) VALUES ('0f67z21qymik', 'user2', 'user3', 'n', 1604569586409);
INSERT INTO user_friend (id, from_uid, to_uid, agreed, time) VALUES ('9vfaslka2d5', 'user3', 'user4', 'n', 1604569605796);

create table user
(
    id     TEXT
        primary key,
    name   TEXT,
    avatar TEXT,
    phone  TEXT
);

INSERT INTO user (id, name, avatar, phone) VALUES ('user4', '克拉默', 'https://img.alicdn.com/tfs/TB1Iawfl6MZ7e4jSZFOXXX7epXa-300-300.jpg', '13121210168');
INSERT INTO user (id, name, avatar, phone) VALUES ('user3', 'Robert Junior', 'https://gw.alicdn.com/tfs/TB1Iawfl6MZ7e4jSZFOXXX7epXa-300-300.jpg', '12345698834');
INSERT INTO user (id, name, avatar, phone) VALUES ('user2', 'Tom', 'https://gw.alicdn.com/tfs/TB1K.u9i_M11u4jSZPxXXahcXXa-800-800.jpg', '11111111111');


create table message
(
    id         TEXT
        primary key,
    text       TEXT,
    type       INTEGER,
    image      TEXT,
    sender     TEXT,
    receiverId TEXT,
    time       INTEGER,
    haveRead   TEXT
);

INSERT INTO message (id, text, type, image, sender, receiverId, time, haveRead) VALUES ('9he1szfpb03', 'hi there ', 1, null, '{"id":"klmklm2","avatar":"https://img.alicdn.com/tfs/TB1S7v7Y4v1gK0jSZFFXXb0sXXa-190-183.jpg","name":"克拉默","phone":"11122233344"}', 'user3', 1604482966286, 'n');
```