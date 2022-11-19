import 'dart:core';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import '/client/web_client.dart';
import '/model/issue_model.dart';

final issuesRepository =
    Provider<IssuesRepository>((ref) => IssuesRepository(ref));

class IssuesRepository {
  IssuesRepository(this.ref);

  final Ref ref;

  Future<List<IssueModel>> load(int pageNum) async {
    final issues = <IssueModel>[];

    // github issue API
    var response = await ref.read(restApiClient).getOpenIssues(pageNum);
    for (var issue in response) {
      issues.add(IssueModel.fromJson(issue));
    }
    return issues;
  }
}
