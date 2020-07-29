import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextCompose extends StatefulWidget {
  final Function({String message, File image}) onSubmitMessage;

  TextCompose({@required this.onSubmitMessage});

  @override
  State<StatefulWidget> createState() => _TextComposeState();
}

class _TextComposeState extends State<TextCompose> {
  final TextEditingController _controller = TextEditingController();
  File _file;
  bool _isTextCompusing = false;

  void _submit() async {
    widget.onSubmitMessage(message: _controller.text, image: _file);

    setState(() {
      _isTextCompusing = false;
      _file = null;
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () async {
              _file = File(
                (await ImagePicker().getImage(source: ImageSource.camera)).path,
              );

              if (_file != null) _submit();
            },
            icon: Icon(Icons.camera_alt),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration:
                  InputDecoration.collapsed(hintText: 'Escreva sua mensagem'),
              onChanged: (text) {
                setState(() => _isTextCompusing = text.isNotEmpty);
              },
              onSubmitted: (text) => _submit(),
            ),
          ),
          IconButton(
            onPressed: _isTextCompusing ? () => _submit() : null,
            icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
