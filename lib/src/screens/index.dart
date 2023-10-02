import 'package:agora_flutter/src/screens/call.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  final _channelController = TextEditingController();
  bool _validateError = false;
  ClientRole _role = ClientRole.Broadcaster;

  @override
  void dispose() {
    super.dispose();
    _channelController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Agora With Flutter",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                  "https://img.freepik.com/free-vector/adult-talking-cell-phone-concept-illustration_114360-9555.jpg?w=2000"),
              TextField(
                controller: _channelController,
                decoration: InputDecoration(
                    hintText: "Channel Name",
                    errorText:
                        _validateError ? "Channel Name Must Be Provide" : null),
              ),
              RadioListTile(
                  title: const Text("Broadcaster"),
                  value: ClientRole.Broadcaster,
                  groupValue: _role,
                  onChanged: (ClientRole? val) {
                    setState(() {
                      _role = val!;
                    });
                  }),
              RadioListTile(
                  title: const Text("Audience"),
                  value: ClientRole.Audience,
                  groupValue: _role,
                  onChanged: (ClientRole? val) {
                    setState(() {
                      _role = val!;
                    });
                  }),
              FilledButton(onPressed: onCall, child: const Text("Start Call"))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onCall() async {
    setState(() {
      _channelController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    if (_channelController.text.isNotEmpty) {
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone).then((value) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CallScreen(channelName: _channelController.text, role: _role),
            ));
      });
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status.toString());
  }
}
