import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TermsOfUsePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('利用規約'),
      ),
      body: FutureBuilder(
          future: rootBundle.loadString('assets/terms_of_use.md'),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return Markdown(data: snapshot.data!);
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
