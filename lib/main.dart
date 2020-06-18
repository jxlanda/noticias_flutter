// Folders
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news/pages/pages.dart';
import 'package:news/repositories/repositories.dart';
import 'package:news/utils/utils.dart' as utils;
import 'package:path_provider/path_provider.dart';
import 'blocs/blocs.dart';
import 'models/models.dart';
import 'package:news/environment/environment.dart' as env;
// Plugins
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Base de datos
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(ArticleAdapter());
  Hive.registerAdapter(SourceAdapter());
  await Hive.openBox<Article>(env.favorites);
  // Settings database
  await Hive.openBox<bool>(env.settings);
  // Repositorio noticias
  final NewsRepository newsRepository = NewsRepository(
    newsApiClient: NewsApiClient(
      httpClient: http.Client(),
    ),
  );
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MyApp(newsRepository: newsRepository));
}
 
class MyApp extends StatelessWidget {
  final NewsRepository newsRepository;
  MyApp({Key key, @required this.newsRepository})
      : assert(newsRepository != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {

    // Establecemos una instancia de la base  de datos
    final Box<bool> settings = Hive.box<bool>(env.settings);
    // Obtenemos el valor de darkMode, si no existe se crea con valor por defecto
    final isDark = settings.get('darkMode', defaultValue: false);
    // Asignar color del systemNavigationBar
    utils.changeSystemNavBar(isDark);
    
    return BlocProvider<SettingsBloc>(
      create: (context) => SettingsBloc()..add(ThemeLoadStarted()),
      child: BlocBuilder<SettingsBloc, SettingsState> (
        builder: (context, themeState) => 
        MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Noticias',
          themeMode: themeState.themeMode,
          theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blue,
              disabledColor: Colors.grey,
              // Color bottomnavigationbar
              canvasColor: Colors.white,
              // AppBarTheme
              appBarTheme: AppBarTheme(
                color: Colors.grey[200],
                brightness: Brightness.dark,
                elevation: 0.0,
                textTheme: TextTheme(headline6: TextStyle(color: Colors.black, fontSize: 20.0))
              ),
              scaffoldBackgroundColor: Colors.grey[200]
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.blue,
              accentColor: Colors.blue,
              disabledColor: Colors.grey,
              dividerColor: Colors.white,
              toggleableActiveColor: Colors.blue,
              // Color bottomnavigationbar
              canvasColor: Colors.black,
              cardColor: Colors.grey[900],
              // AppBarTheme
              appBarTheme: AppBarTheme(
                color: Colors.black,
                brightness: Brightness.dark,
                elevation: 0.0,
                textTheme: TextTheme(headline6: TextStyle(color: Colors.white, fontSize: 20.0))
              ),
              scaffoldBackgroundColor: Colors.black
            ),
          home: BlocProvider<BottomNavigationBloc>(
            create: (context) => BottomNavigationBloc(
              firstPageRepository: FirstPageRepository(), 
              secondPageRepository: SecondPageRepository(),
              thirdPageRepository: ThirdPageRepository()
            )
              ..add(AppStarted()),
            child: BottomNavigationPage(newsRepository: newsRepository)
          )
        ),
      ),
    );
  }
}
