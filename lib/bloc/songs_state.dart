part of 'songs_bloc.dart';

@immutable
sealed class SongsState {}

final class LoadingSongsState extends SongsState {}

final class LoadedSongsState extends SongsState {
  final List<Song> songs;
  LoadedSongsState(this.songs);
}

final class ErrorState extends SongsState {
  final String error;
  ErrorState(this.error);
}
