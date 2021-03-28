import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:high_hat/widgets/date_time_form_widget.dart';
import 'package:state_notifier/state_notifier.dart';

part 'schedule_view_notifier.freezed.dart';

@freezed
class ScheduleViewState with _$ScheduleViewState {
  const factory ScheduleViewState({
    @Default(<Widget>[]) List<Widget> dialogItems,
  }) = _ScheduleViewState;
}

class ScheduleViewNotifier extends StateNotifier<ScheduleViewState>
    with LocatorMixin {
  ScheduleViewNotifier({required this.context})
      : super(const ScheduleViewState());

  final BuildContext context;

  @override
  void dispose() {
    print('dispose');
    super.dispose();
  }

  @override
  void initState() {}

  void initDialogItems() {
    print('initDialogItems');
    final items = <Widget>[
      TextFormField(
        decoration: InputDecoration(
          labelText: '題名',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      DateTimeFormWidget(),
      TextButton(
        onPressed: _addItem,
        child: const Text('候補日を追加'),
      ),
    ];
    state = state.copyWith(dialogItems: items);
  }

  void _addItem() {
    state.dialogItems.add(DateTimeFormWidget());
    print('item added');
    print('dialogItems length: ${state.dialogItems.length}');
  }

  Widget _buildListView() {
    return Builder(builder: (BuildContext context) {
      return SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.3,
        child: ListView.builder(
          itemCount: state.dialogItems.length,
          itemBuilder: (context, index) {
            return state.dialogItems[index];
          },
        ),
      );
    });
  }

  void showPopupForm() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return Builder(builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('予定を作成'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 24,
            ),
            children: [
              _buildListView(),
            ],
          );
        });
      },
    );
  }
}
