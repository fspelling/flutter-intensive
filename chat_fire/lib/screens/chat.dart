import 'dart:io';
import 'package:chat_fire/components/chat_message.dart';
import 'package:chat_fire/components/text_compose.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Chat extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  FirebaseUser auth;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.onAuthStateChanged
        .listen((user) => setState(() => auth = user));
  }

  Future<FirebaseUser> _getUser() async {
    if (auth != null) return auth;

    try {
      final googleSignAccount = await googleSignIn.signIn();
      final googleAccountAuthentication =
          await googleSignAccount.authentication;
      final googleCredential = GoogleAuthProvider.getCredential(
        idToken: googleAccountAuthentication.idToken,
        accessToken: googleAccountAuthentication.accessToken,
      );

      final user =
          await FirebaseAuth.instance.signInWithCredential(googleCredential);
      return user.user;
    } catch (error) {
      print('Erro ao realizar login: $error');
      return null;
    }
  }

  void _sendMessage({String message, File image}) async {
    final user = await _getUser();

    if (user == null) {
      final snackbar = SnackBar(
        content: Text('Nao foi possivel realizar o login'),
        backgroundColor: Colors.red,
      );

      scaffoldKey.currentState.showSnackBar(snackbar);
      return;
    }

    Map<String, dynamic> data = {
      'senderName': user.displayName,
      'senderPhotoUrl': user.photoUrl,
      'time': Timestamp.now(),
    };

    if (image != null) {
      setState(() => isLoading = true);

      final storage = FirebaseStorage.instance.ref();
      final storageTask = storage
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(image);

      final storageTaskSnapshot = await storageTask.onComplete;
      final imgUrl = await storageTaskSnapshot.ref.getDownloadURL();
      data['img'] = imgUrl;

      setState(() => isLoading = false);
    } else if (message.isNotEmpty) data['text'] = message;

    Firestore.instance.collection('messages').add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title:
            auth != null ? Text('Ola, ${auth.displayName}') : Text('Chat App'),
        centerTitle: true,
        actions: <Widget>[
          auth != null
              ? IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    setState(() {
                      FirebaseAuth.instance.signOut();
                      googleSignIn.signOut();
                    });
                  },
                )
              : Container(),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('messages')
                  .orderBy('time')
                  .snapshots(),
              builder: (contextStream, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  case ConnectionState.active:
                  case ConnectionState.done:
                    final documents = snapshot.data.documents.reversed.toList();

                    return ListView.builder(
                      itemCount: documents.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        return ChatMessage(
                          documents[index].data,
                          auth?.uid != documents[index].data['uid'],
                        );
                      },
                    );

                  default:
                    return Text('Erro Generico');
                }
              },
            ),
          ),
          isLoading ? LinearProgressIndicator() : Container(),
          TextCompose(
            onSubmitMessage: _sendMessage,
          ),
        ],
      ),
    );
  }
}
