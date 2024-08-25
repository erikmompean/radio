enum DataState {
  unInitialized,
  loading,
  loaded,
  error,
}

extension DataStateExtension on DataState {
  bool get isLoading => this == DataState.loading;
  bool get isLoaded => this == DataState.loaded;
  bool get isError => this == DataState.error;
  bool get isUnInitialized => this == DataState.unInitialized;
}