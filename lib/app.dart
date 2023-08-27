import 'package:api/api.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:budgetpals_client/auth/auth.dart';
import 'package:budgetpals_client/budget/view/budget_page.dart';
import 'package:budgetpals_client/login/login.dart';
import 'package:budgetpals_client/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthRepository _authRepository;
  late final UserRepository _userRepository;

  late final UserDataProvider _userDataProvider;
  late final AuthDataProvider _authDataProvider;

  @override
  void initState() {
    const url = String.fromEnvironment('API_URL');
    if (url.isEmpty) {
      throw Exception('API_URL environment variable is not set');
    }

    super.initState();

    _authDataProvider = AuthDataProvider(baseUrl: url);
    _authRepository = AuthRepository(dataProvider: _authDataProvider);

    _userDataProvider = UserDataProvider(baseUrl: url);
    _userRepository = UserRepository(dataProvider: _userDataProvider);
  }

  @override
  void dispose() {
    _authRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authRepository,
      child: RepositoryProvider(
        // provide _userRepository to account creation page
        create: (context) => _userRepository,
        child: BlocProvider(
          create: (_) => AuthBloc(
            authRepository: _authRepository,
            userRepository: _userRepository,
          ),
          child: const AppView(),
        ),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'budgetpals',
      theme: ThemeData(
        // \todo: doesn't seem to be working properly? Why is it blue?
        brightness: Brightness.light,
        primaryColor: Colors.black45,
        fontFamily: 'Georgia',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 18, fontStyle: FontStyle.normal),
          bodyMedium: TextStyle(fontSize: 10, fontFamily: 'Hind'),
        ),
      ),
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            switch (state.token) {
              case '':
                _navigator.pushAndRemoveUntil<void>(
                  LoginPage.route(),
                  (route) => false,
                );
              default:
                _navigator.pushAndRemoveUntil<void>(
                  BudgetPage.route(),
                  (route) => false,
                );
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
