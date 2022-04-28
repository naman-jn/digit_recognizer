import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:painter/painter.dart';

class ResultPage extends StatelessWidget {
  final PictureDetails picture;
  final String detectedValue;
  const ResultPage({
    Key? key,
    required this.picture,
    required this.detectedValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[600],
        elevation: 0,
        title: const Text('Result'),
      ),
      body: Container(
          color: Colors.indigoAccent[100]!.withOpacity(0.3),
          alignment: Alignment.center,
          child: FutureBuilder<Uint8List>(
            future: picture.toPNG(),
            builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'INPUT',
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.indigo[600],
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                  width: 150,
                                  height: 150,
                                  child: Image.memory(snapshot.data!)),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'RESULT',
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.indigo[600],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: 150,
                                height: 150,
                                color: Colors.white,
                                child: Center(
                                    child: Text(
                                  detectedValue,
                                  style: const TextStyle(
                                    fontSize: 90,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                default:
                  return FractionallySizedBox(
                    widthFactor: 0.1,
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: const SizedBox(),
                    ),
                    alignment: Alignment.center,
                  );
              }
            },
          )),
    );
  }
}
