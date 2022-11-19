enum LoadState {
  loading,
  loaded,
  error,
  moreLoading,
  moreLoadingError,
}

class ApiDataState<DataClass> {
  final LoadState state;
  final dynamic exception;
  final DataClass? data;
  final bool moreData;

  ApiDataState({
    required this.state,
    this.exception,
    this.data,
    this.moreData = true,
  });
}
