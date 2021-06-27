import 'package:flutter/material.dart';
import 'package:high_hat/presentation/notifier/user_notifier.dart';
import 'package:provider/provider.dart';

class SettingUserIdPage extends StatefulWidget {
  const SettingUserIdPage({Key? key}) : super(key: key);

  @override
  _SettingUserIdPageState createState() => _SettingUserIdPageState();
}

class _SettingUserIdPageState extends State<SettingUserIdPage> {
  final _userIdController = TextEditingController(text: '');

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }

  Future<void> _applyChange(BuildContext context) async {
    try {
      final notifier = context.read<UserNotifier>();
      final currentUser = notifier.loggedInUser!;

      // ユーザーIDを更新する
      await notifier.updateMyAccount(
        userId: currentUser.id.value,
        name: currentUser.userName.value,
        userProfileId: _userIdController.text,
      );
    } on Exception catch (e) {
      print(e);
    }
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
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'ユーザーID変更',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '現在のユーザーID',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  context
                      .read<UserNotifier>()
                      .loggedInUser!
                      .userProfileId
                      .value,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  '新しいユーザーID',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                TextFormField(
                  autofocus: false,
                  controller: _userIdController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  maxLength: 30,
                  onFieldSubmitted: (value) {
                    setState(() {
                      _applyChange(context);
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'ユーザーID',
                    contentPadding: const EdgeInsets.fromLTRB(24, 16, 4, 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    suffixIcon: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          onPressed: () {
                            setState(() {
                              _applyChange(context);
                            });
                          },
                          icon: const Icon(Icons.edit),
                        ),
                      ],
                    ),
                  ),
                  onChanged: (text) {
                    setState(() {
                      print(text);
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
