sealed class UiState<T> {
  const UiState();

  factory UiState.idle() => UiStateIdle<T>();
  factory UiState.loading() => UiStateLoading<T>();
  factory UiState.success(T data) => UiStateSuccess<T>(data);
  factory UiState.error(String message) => UiStateError<T>(message);

  get status => null;

  get error => null;
}

final class UiStateIdle<T> extends UiState<T> {
  const UiStateIdle();
}

final class UiStateLoading<T> extends UiState<T> {
  const UiStateLoading();
}

final class UiStateSuccess<T> extends UiState<T> {
  final T data;
  const UiStateSuccess(this.data);
}

final class UiStateError<T> extends UiState<T> {
  final String message;
  const UiStateError(this.message);
}