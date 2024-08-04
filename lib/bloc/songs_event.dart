part of 'songs_bloc.dart';

@immutable
sealed class SongsEvent {}

class LoadingSongsEvent extends SongsEvent {}
