import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class ButtonSingleComponent extends StatefulWidget {
  final String? buttonName;
  final String? comandOn;
  final Color? colorButton;
  final BluetoothConnection? connection;
  final int clientID;
  const ButtonSingleComponent(
      {Key? key,
      this.buttonName,
      this.comandOn,
      this.connection,
      required this.clientID,
      this.colorButton})
      : super(key: key);
  _ButtonState createState() => _ButtonState();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ButtonState extends State<ButtonSingleComponent> {
  bool buttonClicado = false;
  final TextEditingController textEditingController = TextEditingController();
  List<_Message> messages = <_Message>[];

  @override
  Widget build(BuildContext context) {
    return (SizedBox(
      height: 60,
      width: 80,
      child: TextButton(
        onPressed: () {
          _sendMessage(widget.comandOn!);
        },
        child: Text(
          widget.buttonName!,
          style: const TextStyle(color: Colors.white, fontSize: 25),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(widget.colorButton),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
        ),
      ),
    ));
  }

  _sendMessage(text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.length > 0) {
      try {
        widget.connection!.output
            .add(Uint8List.fromList(utf8.encode(text + "\r\n")));
        await widget.connection!.output.allSent;

        setState(() {
          messages.add(_Message(widget.clientID, text));
        });
      } catch (e) {
        setState(() {});
      }
    }
  }
}
