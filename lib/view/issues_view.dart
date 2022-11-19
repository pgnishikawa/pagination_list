import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/view_model/issues_state.dart';
import '/view/issue_item.dart';

class IssuesView extends ConsumerWidget {
  const IssuesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('flutter github issues'),
        elevation: 2,
        actions: [
          IconButton(
            onPressed: () {
              ref.read(issuesProvider.notifier).firstLoad();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _buildBody(context, ref),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref) {
    final dataState = ref.watch(issuesProvider).state;
    double opacity = 1;
    switch (dataState) {
      case LoadState.loading:
        opacity = 0;
        break;
      case LoadState.moreLoading:
        opacity = 0.6;
        break;
      default:
        opacity = 1;
        break;
    }
    return Column(
      children: [
        Expanded(
          child: AnimatedOpacity(
            opacity: opacity,
            duration: const Duration(milliseconds: 350),
            child: _buildList(context, ref),
          ),
        ),
      ],
    );
  }

  Widget _buildList(BuildContext context, WidgetRef ref) {
    final data = ref.watch(issuesProvider);
    switch (data.state) {
      case LoadState.loaded:
      case LoadState.moreLoading:
      case LoadState.moreLoadingError:
        return _buildListBody(context, ref);
      case LoadState.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case LoadState.error:
        return Center(
          child: Text('${data.exception}'),
        );
    }
  }

  Widget _buildListBody(BuildContext context, WidgetRef ref) {
    final issues = ref.watch(issuesProvider);
    return RefreshIndicator(
      onRefresh: () async {
        // pull to refresh
        ref.read(issuesProvider.notifier).firstLoad();
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8),
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        // moreがある場合は+1
        itemCount:
            issues.moreData ? issues.data!.length + 1 : issues.data!.length,
        itemBuilder: (context, index) {
          // moreデータある場合はLoadingインジケータを末尾に置く
          if (index >= issues.data!.length) {
            if (issues.state == LoadState.moreLoadingError) {
              // moreLoad失敗時はエラー内容とリトライ用ボタンを表示する
              return Container(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, color: Colors.redAccent),
                      Text('${issues.exception}'),
                      IconButton(
                        onPressed: () {
                          // Retry more load
                          ref.read(issuesProvider.notifier).moreLoad();
                        },
                        icon: const Icon(Icons.refresh),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.read(issuesProvider.notifier).moreLoad();
              });
              // more読み込み中のインジケーター
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: const Center(child: CircularProgressIndicator()),
              );
            }
          }
          return IssueItem(issues.data![index]);
        },
      ),
    );
  }
}
