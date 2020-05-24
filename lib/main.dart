import 'package:flutter/material.dart';

void main() {
  runApp(ToBuyTracker());
}

class ToBuyTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Buy App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'To Buy Home Page'),
    );
  }
}

class ToBuyItemWidget extends StatefulWidget {
  ToBuyItemWidget({Key key, this.toBuyText}) : super(key: key);

  final String toBuyText;

  @override
  _ToBuyItemWidgetState createState() => _ToBuyItemWidgetState();
}

class _ToBuyItemWidgetState extends State<ToBuyItemWidget> {
  bool _isActive = false;
  bool _isDeleted = false;

  void _delete() {
    setState(() {
      _isDeleted = true;
    });
  }

  void _toggleActive() {
    setState(() {
      _isActive = !_isActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isDeleted
        ? SizedBox.shrink()
        : Container(
            height: 50,
            child: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                GestureDetector(
                  onTap: _toggleActive,
                  child: Chip(label: Text(widget.toBuyText)),
                ),
                Positioned(
                    top: 0,
                    right: 0,
                    child: Opacity(
                        opacity: _isActive ? 1 : 0,
                        child: SizedBox(
                            width: 20,
                            height: 20,
                            child: IconButton(
                                icon: Icon(Icons.remove_circle, size: 16),
                                onPressed: _delete))))
              ],
            ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _inputText = "";
  var _now = [];
  var _soon = [];
  var _sometime = [];
  var _addToSelect = 'now';

  void _updateInputText(text) {
    setState(() {
      _inputText = text;
    });
  }

  void _addToNow() {
    setState(() {
      _now.add(_inputText);
    });
  }

  void _addToSoon() {
    setState(() {
      _soon.add(_inputText);
    });
  }

  void _addToSometime() {
    setState(() {
      _sometime.add(_inputText);
    });
  }

  Function _addTo() {
    return _addToSelect == 'now'
        ? _addToNow
        : _addToSelect == 'soon' ? _addToSoon : _addToSometime;
  }

  Function _setAddToSelect(select) {
    return () {
      setState(() {
        _addToSelect = select;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                          child: Text('NOW'),
                          onPressed: _setAddToSelect('now'),
                          color: _addToSelect == 'now'
                              ? Colors.green
                              : Colors.blueGrey),
                      FlatButton(
                          child: Text('SOON'),
                          onPressed: _setAddToSelect('soon'),
                          color: _addToSelect == 'soon'
                              ? Colors.green
                              : Colors.blueGrey),
                      FlatButton(
                          child: Text('SOMETIME'),
                          onPressed: _setAddToSelect('sometime'),
                          color: _addToSelect == 'sometime'
                              ? Colors.green
                              : Colors.blueGrey),
                    ],
                  )
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.all(32),
                child: TextField(
                  onChanged: _updateInputText,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter something to buy",
                      suffixIcon: IconButton(
                          icon: Icon(Icons.add),
                          tooltip: 'Add now',
                          onPressed: _inputText.length >= 1 ? _addTo() : null)),
                )),
            Container(
              padding: const EdgeInsets.all(32),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: _buildToBuyColumn(_now, 'Now')),
                  Expanded(child: _buildToBuyColumn(_soon, 'Soon')),
                  Expanded(child: _buildToBuyColumn(_sometime, 'Sometime'))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildToBuyColumn(toBuyList, title) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        verticalDirection: VerticalDirection.down,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          ...toBuyList
              .map<Widget>((toBuy) => ToBuyItemWidget(toBuyText: toBuy))
              .toList()
        ]);
  }
}
