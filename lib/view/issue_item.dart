import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/view/common/image_widget.dart';
import '/view_model/issues_state.dart';

class IssueItem extends ConsumerWidget {
  const IssueItem(this.item, {Key? key}) : super(key: key);
  final IssueModel item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          // TODO:
        },
        child: Container(
          padding: const EdgeInsets.all(2),
          child: _buildLayout(context, ref),
        ),
      ),
    );
  }

  // 全体レイアウト
  Widget _buildLayout(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 60),
          child: _buildImage(context, ref),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(children: [
                    _buildNumber(context, ref),
                    _buildUpdateDate(context, ref),
                  ],),
                  Flexible(
                    child: _buildUsername(context, ref),
                  ),
                ],
              ),
              // Title
              _buildTitle(context, ref),
            ],
          ),
        ),
      ],
    );
  }

  // issue number
  Widget _buildNumber(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.zero,
      child: Text(
        '${item.number}',
        textAlign: TextAlign.right,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: AspectRatio(
        aspectRatio: 1,
        child: buildImage(
          item.user.avatar_url,
          border: const Radius.circular(8),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Text(
        item.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildUsername(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.fromLTRB(3, 0, 3, 0),
      padding: const EdgeInsets.fromLTRB(5, 1, 5, 2),
      decoration: BoxDecoration(
        color:Theme.of(context).colorScheme.primary.withAlpha(50),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Text(
        item.user.login,
        maxLines: 1,
        textAlign: TextAlign.end,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.black87,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildUpdateDate(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Text(
        '${item.updated_at.toString().substring(0, 16)}',
        style: const TextStyle(
          color: Colors.black54,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
