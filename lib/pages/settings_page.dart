import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/blocs/blocs.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) => 
      Scaffold(
        appBar: PreferredSize(
        preferredSize: Size.fromHeight(42.0),
        child: AppBar(
            title: Text("Configuración"),
            centerTitle: true,
        ),
        ),
      body: Container(
        color: Theme.of(context).cardColor,
        child: ListTile(
              title: Text("Modo oscuro"),
              trailing: Switch(
                value: state.themeMode == ThemeMode.dark? true : false,
                onChanged: (value){
                  BlocProvider.of<SettingsBloc>(context).add(ThemeChanged(value));
                }
              )
            ),
      )
      )
    );
  }
}