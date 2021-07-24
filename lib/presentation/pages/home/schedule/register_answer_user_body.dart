import 'package:flutter/material.dart';
import 'package:high_hat/domain/user/user.dart';
import 'package:high_hat/presentation/pages/home/schedule/register_answer_select_user_page.dart';
import 'package:high_hat/presentation/notifier/register_schedule_notifier.dart';
import 'package:provider/provider.dart';

class RegisterAnswerUserBody extends StatelessWidget {
  const RegisterAnswerUserBody({
    Key? key,
    required List<User> userList,
  })  : _userList = userList,
        super(key: key);

  final List<User> _userList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        child: SizedBox(
          //height: 96,
          child: Selector<RegisterScheduleNotifier, int>(
            selector: (context, model) => model.selectedUsers.length,
            builder: (context, length, child) {
              return ListTile(
                title: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('友達を追加'),
                ),
                subtitle: Row(
                  children: [
                    ...context
                        .read<RegisterScheduleNotifier>()
                        .selectedUsers
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.all(4),
                            child: CircleAvatar(
                              //radius: 16,
                              backgroundImage: NetworkImage(e.avatarUrl.value),
                            ),
                          ),
                        ),
                  ],
                ),
                leading: Icon(
                  Icons.account_circle,
                  size: 48,
                  color: Theme.of(context).accentColor,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ChangeNotifierProvider<
                          RegisterScheduleNotifier>.value(
                        value: context.read<RegisterScheduleNotifier>(),
                        child: RegisterAnswerSelectUserPage(
                          userList: _userList,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
