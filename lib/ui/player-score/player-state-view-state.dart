sealed class ViewState {}

class LoadingViewState extends ViewState {}

class ScoreViewState extends ViewState {
  final bool buttonsEnabled;
  final List<int> scores;
  final int sum;
  final String name;

  ScoreViewState({
    required this.name,
    required this.scores,
    required this.sum,
    required this.buttonsEnabled,
  });
}
