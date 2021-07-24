import 'package:flutter/material.dart';
import 'package:high_hat/presentation/notifier/user_notifier.dart';
import 'package:provider/provider.dart';

class SettingUserNamePage extends StatefulWidget {
  const SettingUserNamePage({Key? key}) : super(key: key);

  @override
  _SettingUserNamePageState createState() => _SettingUserNamePageState();
}

class _SettingUserNamePageState extends State<SettingUserNamePage> {
  final _userNameController = TextEditingController(text: '');

  @override
  void dispose() {
    _userNameController.dispose();
    super.dispose();
  }

  Future<void> _applyChange(BuildContext context) async {
    try {
      final notifier = context.read<UserNotifier>();
      final currentUser = notifier.loggedInUser!;

      // ユーザーIDを更新する
      await notifier.updateMyAccount(
        userId: currentUser.id.value,
        name: _userNameController.text,
        userProfileId: currentUser.userProfileId.value,
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
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'ユーザー名変更',
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
                '現在のユーザー名',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              Text(
                context.read<UserNotifier>().loggedInUser!.userName.value,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                '新しいユーザー名',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              TextFormField(
                autofocus: false,
                controller: _userNameController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                maxLength: 30,
                onFieldSubmitted: (value) async {
                  await _applyChange(context);
                  setState(() {
                    print(value);
                  });
                },
                decoration: InputDecoration(
                  hintText: 'ユーザー名',
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
                        onPressed: () async {
                          await _applyChange(context);
                          setState(() {
                            print('${_userNameController.text}');
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
    );
  }
}
