import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/blocs/events/settings_event.dart';
import 'package:news/blocs/states/settings_state.dart';
import 'package:news/environment/environment.dart' as env;
import 'package:news/utils/utils.dart' as utils;
// Hive
import 'package:hive/hive.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  
  static final Box<bool> settings = Hive.box<bool>(env.settings);

  @override
  SettingsState get initialState => SettingsState(ThemeMode.light);

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is ThemeLoadStarted) {
      yield* _mapThemeLoadStartedToState();
    } else if (event is ThemeChanged) {
      yield* _mapThemeChangedToState(event.value);
    }
  }

  Stream<SettingsState> _mapThemeLoadStartedToState() async* {

    final darkMode = settings.get('darkMode', defaultValue: false);
    // No puede ser nulo por que se asigna en void main
    ThemeMode themeMode = darkMode ? ThemeMode.dark : ThemeMode.light;
    yield SettingsState(themeMode);
  }

  Stream<SettingsState> _mapThemeChangedToState(bool value) async* {
    
    final darkMode = settings.get('darkMode', defaultValue: false);

    if (value && !darkMode) {
      settings.put('darkMode', true);
      yield SettingsState(ThemeMode.dark);
    } else if (!value && darkMode) {
      settings.put('darkMode', false);
      yield SettingsState(ThemeMode.light);
    }
    // Al final cambiamos el systemNavBar
    utils.changeSystemNavBar(!darkMode);
  }
}