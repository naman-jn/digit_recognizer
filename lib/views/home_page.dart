import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:painter/painter.dart';
import 'package:digit_recognizer/widgets/draw_bar.dart';
import 'package:digit_recognizer/views/result_page.dart';
import 'package:digit_recognizer/widgets/custom_button.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _finished = false;
  PainterController _controller = _newController();
  late String detectedValue;
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  static PainterController _newController() {
    PainterController controller = PainterController();
    controller.thickness = 30.0;
    controller.backgroundColor = Colors.white;
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions;
    if (_finished) {
      actions = <Widget>[
        IconButton(
          icon: const Icon(Icons.content_copy),
          tooltip: 'New Painting',
          onPressed: () => setState(() {
            _finished = false;
            _controller = _newController();
          }),
        ),
      ];
    } else {
      actions = <Widget>[
        IconButton(
            icon: const Icon(
              Icons.undo,
            ),
            tooltip: 'Undo',
            onPressed: () {
              if (_controller.isEmpty) {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) =>
                        const Text('Nothing to undo'));
              } else {
                _controller.undo();
              }
            }),
        IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Clear',
            onPressed: _controller.clear),
        // new IconButton(
        //     icon: new Icon(Icons.check),
        //     onPressed: () => _show(_controller.finish(), context)),
      ];
    }
    return Opacity(
      opacity: loading ? 0.5 : 1,
      child: IgnorePointer(
        ignoring: loading,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              backgroundColor: Colors.indigo[600],
              elevation: 0,
              title: const Text('Digit Recognizer'),
              actions: actions,
              bottom: PreferredSize(
                child: DrawBar(_controller),
                preferredSize: Size(MediaQuery.of(context).size.width, 30.0),
              )),
          body: Container(
            color: Colors.indigoAccent[100]!.withOpacity(0.3),
            child: Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AspectRatio(
                  aspectRatio: 1.0,
                  child: Painter(
                    _controller,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                CustomButton(
                    buttonText: 'Analyze',
                    onTap: () => _show(_controller.finish(), context))
              ],
            )),
          ),
        ),
      ),
    );
  }

  Future<void> _show(PictureDetails picture, BuildContext context) async {
    setState(() {
      loading = true;
    });
    if (!await Permission.storage.request().isGranted) {
      Map<Permission, PermissionStatus> statuses =
          await [Permission.storage].request();
      print(statuses[Permission.storage]);
    }
    try {
      await _postImage(picture, context);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return ResultPage(
          picture: picture,
          detectedValue: detectedValue,
        );
      }));
    } on HttpException catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message.toString(),
          ),
          duration: const Duration(milliseconds: 450),
        ),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Some error occurred"),
          duration: Duration(milliseconds: 450),
        ),
      );
    }

    setState(() {
      _controller = _newController();
      _finished = false;
      loading = false;
    });
  }

  Future<void> _postImage(PictureDetails picture, BuildContext context) async {
    var result = await ImageGallerySaver.saveImage(await picture.toPNG());
    String base64Image = base64Encode(await picture.toPNG());
    var url = Uri.https('digit-recoginition.herokuapp.com', '/predict/');
    print(url);
    var res = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Charset': 'utf-8',
      },
      body: json.encode({'base64': base64Image}),
    );

    // await http.post(url, body: json.encode({"base64code": base64Image}));
    // await http.get(url);
    print("response receieved");
    var body = res.body;
    var statusCode = res.statusCode;
    print(body);
    detectedValue = '${json.decode(res.body)['result'][0]}';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('The recognized value is $detectedValue'),
        duration: const Duration(seconds: 3)));
    print('Code=>$statusCode');
  }
}
