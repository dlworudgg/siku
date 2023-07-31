import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SharedListPage extends StatefulWidget {
  final String id;
  final bool isSavedList;

  const SharedListPage({Key? key,
    required this.id,
    required this.isSavedList  })
      : super(key: key);

  @override
  State<SharedListPage> createState() => _SharedListPageState();
}

class _SharedListPageState extends State<SharedListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Card List Page'),
      ),
      body: ListView.builder(
        itemCount: 10, // Change this for the desired number of cards
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text('${widget.id} - ${index + 1}'),
              trailing: widget.isSavedList ? const Icon(Icons.check) : const Icon(Icons.close),
            ),
          );
        },
      ),
    );
  }
}
