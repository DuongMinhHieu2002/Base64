
import 'dart:convert' show utf8, base64;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '';
class History{
  late final String input;
  late final String output;

  History({required this.input, required this.output});
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Base64 Encoder/Decoder',
      theme: ThemeData(primarySwatch: Colors.green,
          primaryColor: Colors.green[900]),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum Page {
  Encode,
  Decode,
}

class _MyHomePageState extends State<MyHomePage> {
  String _inputTextencode = '';
  String _outputTextendoe = '';
  String _inputTextdecode = '';
  String _outputTextdendoe = '';
  final TextEditingController _inputencodeController = TextEditingController();
  final TextEditingController _outputencodeController = TextEditingController();
  final TextEditingController _inputdecodeController = TextEditingController();
  final TextEditingController _outputdecodeController = TextEditingController();
  List<History> _historyListencode = [];
  List<History> _historyListdecode = [];

  int _currentPageIndex = 0;

  void _encode() {

      setState(() {
        _outputTextendoe = base64.encode(utf8.encode(_inputTextencode));
        _outputencodeController.text = _outputTextendoe;
        if (_inputTextencode.isNotEmpty) _addToHistoryencode(new History(input: _inputTextencode, output: _outputTextendoe));
      });

  }

  void _decode() {
    setState(() {
      try {
        _outputTextdendoe = utf8.decode(base64.decode(_inputTextdecode));
        _outputdecodeController.text = _outputTextdendoe;
        if (_inputTextdecode.isNotEmpty) _addToHistorydecode(new History(input: _inputTextdecode, output: _outputTextdendoe));
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Error"),
            content: Text("Invalid input! Please enter a valid Base64 string."),
            actions: [
              ElevatedButton(
                child: Text("OK"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
        _outputTextdendoe = "";
        _outputdecodeController.text = _outputTextdendoe;
      }
    });
  }

  void _clearInputencode() {
    setState(() {
      _inputTextencode = '';
      _inputencodeController.clear();
    });
  }
  void _clearInputdecode() {
    setState(() {
      _inputTextencode = '';
      _inputdecodeController.clear();
    });
  }

  void _copyToClipboardencode() {
    Clipboard.setData(ClipboardData(text: _outputTextendoe));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 1),
      ),
    );
  }
  void _copyToClipboarddecode() {
    Clipboard.setData(ClipboardData(text: _outputTextdendoe));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 1),
      ),
    );
  }
  void _addToHistoryencode(History entry) {
    setState(() {
      _historyListencode.add(entry);
    });
  }
  void _addToHistorydecode(History entry) {
    setState(() {
      _historyListdecode.add(entry);
    });
  }
  void _clearHistoryencode() {
    setState(() {
      _historyListencode.clear();
    });
  }
  void _clearHistorydecode() {
    setState(() {
      _historyListdecode.clear();
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Base64 Encoder/Decoder'),

      ),
      body: IndexedStack(
        index: _currentPageIndex,
        children: [
          _buildEncodePage(),
          _buildDecodePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: _onPageChanged,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.code),
            label: 'Encode',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.code_off),
            label: 'Decode',
          ),
        ],
      ),
    );
  }

  Widget _buildEncodePage() {
    return Container(
      // color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    maxLines: 6,
                    onChanged: (text) => _inputTextencode = text,
                    controller: _inputencodeController,
                    decoration: InputDecoration(
                      labelText: 'Enter text to encode',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear,),
                        onPressed: _clearInputencode,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Encode'),
              onPressed: _encode,
            ),
            SizedBox(height: 16),
            TextField(
              readOnly: true,
              maxLines: 6,
              controller: _outputencodeController,
              decoration: InputDecoration(
                labelText: 'Encoded Result',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.copy),
                  onPressed: _copyToClipboardencode,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'History encoder:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _historyListencode.length,
              itemBuilder: (context, index) {
                final history = _historyListencode[index];
                return ListTile(
                  title: Text('Input: ${history.input}'),
                  subtitle: Text('Output: ${history.output}'),
                );
              },
            ),
            SizedBox(height: 16,),
            ElevatedButton(
              child: Text('Clear History Encode'),
              onPressed: _clearHistoryencode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDecodePage() {
    return Container(
      // color: Colors.orange,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    maxLines: 6,
                    onChanged: (text) => _inputTextdecode = text,
                    controller: _inputdecodeController,
                    decoration: InputDecoration(
                      labelText: 'Enter text to decode',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear,),
                        onPressed: _clearInputdecode,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Decode'),
              onPressed: _decode,
            ),
            SizedBox(height: 16),
            TextField(
              readOnly: true,
              maxLines: 6,
              controller: _outputdecodeController,
              decoration: InputDecoration(
                labelText: 'Decoded Result',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.copy),
                  onPressed: _copyToClipboarddecode,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'History decoder:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _historyListdecode.length,
              itemBuilder: (context, index) {
                final history = _historyListdecode[index];
                return ListTile(
                  title: Text('Input: ${history.input}'),
                  subtitle: Text('Output: ${history.output}'),
                );
              },
            ),
            SizedBox(height: 16,),
            ElevatedButton(
              child: Text('Clear History Decode'),
              onPressed: _clearHistorydecode,
            ),


          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
