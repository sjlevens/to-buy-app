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
        : Row(
            children: <Widget>[
              FlatButton(
                child: Text(widget.toBuyText),
                onPressed: _toggleActive,
              ),
              _isActive
                  ? IconButton(icon: Icon(Icons.remove), onPressed: _delete)
                  : SizedBox.shrink()
            ],
          );
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

  void _changeInputText(newText) {
    setState(() {
      _inputText = newText;
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                              ? Colors.blue
                              : Colors.blueGrey),
                      FlatButton(
                          child: Text('SOON'),
                          onPressed: _setAddToSelect('soon'),
                          color: _addToSelect == 'soon'
                              ? Colors.blue
                              : Colors.blueGrey),
                      FlatButton(
                          child: Text('SOMETIME'),
                          onPressed: _setAddToSelect('sometime'),
                          color: _addToSelect == 'sometime'
                              ? Colors.blue
                              : Colors.blueGrey),
                    ],
                  )
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.all(32),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter something to buy"),
                        onChanged: _changeInputText,
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.add),
                        tooltip: 'Add now',
                        onPressed: _addTo()),
                  ],
                )),
            Container(
              child: Row(
                children: <Widget>[
                  _buildToBuyColumn(_now),
                  _buildToBuyColumn(_soon),
                  _buildToBuyColumn(_sometime)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildToBuyItem(item) {
    return Container(
        child: ToBuyItemWidget(
      toBuyText: item,
    ));
  }

  Widget _buildToBuyColumn(toBuyList) {
    return Column(
        children: toBuyList
            .map<Widget>((toBuy) => Container(
                  child: _buildToBuyItem(toBuy),
                ))
            .toList());
  }
}
