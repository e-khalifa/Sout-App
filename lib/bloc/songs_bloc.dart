import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/song.dart';
import '../repository/songs_repository.dart';

part 'songs_event.dart';
part 'songs_state.dart';

class SongsBloc extends Bloc<SongsEvent, SongsState> {
  final SongsRepository _songsRepository;
  SongsBloc(this._songsRepository) : super(LoadingSongsState()) {
    on<LoadingSongsEvent>(onLoadingSongs);
  }
  Future<void> onLoadingSongs(
      LoadingSongsEvent event, Emitter<SongsState> emit) async {
    emit(LoadingSongsState());

    // Fetch songs from the repository
    try {
      final songs = await _songsRepository.getSongs();
      // Emit loaded state with the fetched songs
      emit(LoadedSongsState(songs));
    } catch (error) {
      // Emit error state if something goes wrong
      emit(ErrorState(error.toString()));
    }
  }
}
