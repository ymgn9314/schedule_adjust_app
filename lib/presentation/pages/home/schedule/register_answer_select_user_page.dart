import 'package:flutter/material.dart';
import 'package:high_hat/domain/user/user.dart';
import 'package:high_hat/presentation/notifier/register_schedule_notifier.dart';
import 'package:provider/provider.dart';

class RegisterAnswerSelectUserPage extends StatelessWidget {
  const RegisterAnswerSelectUserPage({Key? key, required List<User> userList})
      : _userList = userList,
        super(key: key);

  final List<User> _userList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '友達を追加する',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _userList.isEmpty
          ? const Center(
              child: Text(
                'まだ友達がいません。\n友達画面から検索して追加して下さい。',
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: _userList.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  elevation: 4,
                  child: ListTile(
                    title: Text(_userList[index].userName.value),
                    subtitle: Text(_userList[index].userProfileId.value),
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(_userList[index].avatarUrl.value),
                    ),
                    trailing: Selector<RegisterScheduleNotifier, int>(
                      selector: (context, notifier) =>
                          notifier.selectedUsers.length,
                      builder: (context, _, child) {
                        return Checkbox(
                          value: context
                              .read<RegisterScheduleNotifier>()
                              .selectedUsers
                              .contains(_userList[index]),
                          onChanged: (newValue) {},
                        );
                      },
                    ),
                    onTap: () {
                      context
                          .read<RegisterScheduleNotifier>()
                          .onUserSelected(_userList[index]);
                    },
                  ),
                );
              },
            ),
    );
  }
}
