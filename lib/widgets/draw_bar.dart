import 'package:flutter/material.dart';
import 'package:painter/painter.dart';

import 'package:digit_recognizer/widgets/color_picker_button.dart';

class DrawBar extends StatelessWidget {
  final PainterController _controller;

  const DrawBar(
    this._controller, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double thickness = _controller.thickness;

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
              child: Slider(
            value: _controller.thickness,
            onChanged: (double value) => setState(() {
              _controller.thickness = value;
              thickness = value;
            }),
            min: 30.0,
            max: 60.0,
            activeColor: Colors.white,
          )),
          Text(thickness.toStringAsFixed(0),
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return RotatedBox(
                quarterTurns: _controller.eraseMode ? 2 : 0,
                child: IconButton(
                    icon: const Icon(
                      Icons.create,
                      color: Colors.white,
                    ),
                    tooltip: (_controller.eraseMode ? 'Disable' : 'Enable') +
                        ' eraser',
                    onPressed: () {
                      setState(() {
                        _controller.eraseMode = !_controller.eraseMode;
                      });
                    }));
          }),
          ColorPickerButton(_controller, false),
          ColorPickerButton(_controller, true),
        ],
      );
    });
  }
}
