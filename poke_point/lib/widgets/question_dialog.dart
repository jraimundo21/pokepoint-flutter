import 'package:flutter/material.dart';

class QuestionDialog extends StatefulWidget {
  final bool isCheckIn;
  final Function() yesCallback;
  final Function() noCallback;

  QuestionDialog({Key key, this.isCheckIn, this.yesCallback, this.noCallback})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _QuestionDialog(this.isCheckIn, this.yesCallback, this.noCallback);
}

class _QuestionDialog extends State<QuestionDialog> {
  final bool isCheckIn;
  final Function() yesCallback;
  final Function() noCallback;

  _QuestionDialog(this.isCheckIn, this.yesCallback, this.noCallback);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text("Do you want to Check-${this.isCheckIn ? 'in' : 'out'}?"),
      actions: <Widget>[
        FlatButton(
          child: Text("YES"),
          onPressed: () {
            this.yesCallback();
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("NO"),
          onPressed: () {
            this.noCallback();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
