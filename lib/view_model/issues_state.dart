import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/repository/issues_repository.dart';
import '/model/api_data_state.dart';
import '/model/issue_model.dart';
export '/model/api_data_state.dart';
export '/model/issue_model.dart';

final issuesProvider =
    StateNotifierProvider<IssuesNotifier, ApiDataState<List<IssueModel>>>(
        (ref) => IssuesNotifier(ref)..firstLoad());

class IssuesNotifier extends StateNotifier<ApiDataState<List<IssueModel>>> {
  IssuesNotifier(this.ref)
      : super(ApiDataState<List<IssueModel>>(state: LoadState.loading));

  final Ref ref;
  int currentPage = 1;

  // 初回ロード
  Future<void> firstLoad() async {
    currentPage = 1;
    // 初回ロード
    state = ApiDataState<List<IssueModel>>(state: LoadState.loading);
    ref.read(issuesRepository).load(1).then((issues) {
      debugPrint('firstLoad ok=$issues');
      state = ApiDataState<List<IssueModel>>(
        state: LoadState.loaded,
        data: issues,
        moreData: issues.length < 20 ? false : true,
      );
    }).onError((error, stackTrace) {
      debugPrint('firstLoad onError=$error');
      state = ApiDataState<List<IssueModel>>(
        state: LoadState.error,
        exception: error,
      );
    });
  }

  // 続きのロード
  Future<void> moreLoad() async {
    switch (state.state) {
      case LoadState.loading:
      case LoadState.moreLoading:
        // ロード中は何もしないようにしておき重複してロード処理しないようにしておく
        return;
      default:
        break;
    }
    final oldData = state.data;
    if (oldData == null) {
      // 既存データない場合も何もしないようにしておく
      return;
    }
    final nextPage = currentPage + 1;

    // ローディング状態にしておく
    state = ApiDataState<List<IssueModel>>(
      state: LoadState.moreLoading,
      data: oldData,
      moreData: true,
    );

    // 追加ロード
    ref.read(issuesRepository).load(nextPage).then((issues) {
      currentPage = nextPage;
      state = ApiDataState<List<IssueModel>>(
        state: LoadState.loaded,
        data: [...oldData, ...issues],
        moreData: issues.length < 20 ? false : true,
      );
    }).onError((error, stackTrace) {
      debugPrint('moreLoad onError=$error');
      state = ApiDataState<List<IssueModel>>(
        state: LoadState.moreLoadingError,
        data: oldData, // エラーでもロード済みデータは表示できるよう残しておく
        moreData: state.moreData,
        exception: error,
      );
    });
  }
}
