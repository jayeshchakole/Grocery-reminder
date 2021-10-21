import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

enum SlidableAction { delete, edit }

class SlidableWidget extends StatelessWidget {
  final Widget child;
  final Function(SlidableAction action) onDismissed;

  const SlidableWidget({
    required this.child,
    required this.onDismissed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      child: child,
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: [
        IconSlideAction(
          icon: Icons.delete_forever,
          color: Colors.red,
          caption: 'Delete',
          onTap: () => onDismissed(SlidableAction.delete),
        ),
        IconSlideAction(
          icon: Icons.edit,
          color: Colors.blueGrey,
          caption: 'Edit',
          onTap: () => onDismissed(SlidableAction.edit),
        )
      ],
    );
  }
}
