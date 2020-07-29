import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool mine;

  ChatMessage(this.data, this.mine);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        !mine
            ? Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(data['senderPhotoUrl']),
                ),
              )
            : Container(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment:
                  mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                data['img'] != null
                    ? Image.network(data['img'], width: 240)
                    : Text(
                        data['text'],
                        style: TextStyle(fontSize: 16),
                        textAlign: mine ? TextAlign.end : TextAlign.start,
                      ),
                Text(
                  data['senderName'],
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ),
        mine
            ? Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(data['senderPhotoUrl']),
                ),
              )
            : Container(),
      ],
    );
  }
}
