import 'package:flutter/material.dart';
import 'package:high_hat/domain/user/user.dart';
import 'package:high_hat/domain/user/value/user_profile_id.dart';
import 'package:high_hat/presentation/notifier/user_notifier.dart';
import 'package:high_hat/presentation/widget/user/user_card.dart';
import 'package:provider/provider.dart';

// 友達検索ページ
class SearchFriendPage extends StatefulWidget {
  @override
  _SearchFriendPageState createState() => _SearchFriendPageState();
}

class _SearchFriendPageState extends State<SearchFriendPage> {
  final _textEditingController = TextEditingController(text: '');

  bool _executeSearch = false;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final currentScope = FocusScope.of(context);
        if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            '友達を追加',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  autofocus: false,
                  controller: _textEditingController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  onFieldSubmitted: (value) {
                    setState(() {
                      _executeSearch = true;
                      print(_textEditingController.text);
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'ユーザーIDで検索',
                    contentPadding: const EdgeInsets.fromLTRB(24, 16, 4, 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    suffixIcon: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_textEditingController.text.isNotEmpty)
                          IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            onPressed: () {
                              setState(() {
                                _executeSearch = false;
                                _textEditingController.clear();
                              });
                            },
                            icon: const Icon(Icons.cancel),
                          ),
                        IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          onPressed: () {
                            setState(() {
                              _executeSearch = true;
                              print(_textEditingController.text);
                            });
                          },
                          icon: const Icon(Icons.search),
                        ),
                      ],
                    ),
                  ),
                  onChanged: (text) {
                    setState(() {
                      _executeSearch = false;
                      print(text);
                    });
                  },
                ),
              ),
              Expanded(
                child: _executeSearch &&
                        6 < _textEditingController.text.length &&
                        _textEditingController.text.length < 10
                    ? FutureBuilder(
                        future:
                            context.read<UserNotifier>().searchByUserProfileId(
                                  UserProfileId(_textEditingController.text),
                                ),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<User>> snapshot) {
                          if (snapshot.hasError || !snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final data = snapshot.data!;

                          if (data.isEmpty) {
                            return const Text('該当するユーザーが見つかりませんでした。');
                          }

                          return ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return UserCardAsSearchResult(
                                user: data[index],
                              );
                            },
                          );
                        },
                      )
                    : _executeSearch
                        ? const Text('該当するユーザーが見つかりませんでした。')
                        : const Text(''),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
