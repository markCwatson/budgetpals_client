import 'package:budgetpals_client/data/providers/auth/auth_provider.dart';
import 'package:budgetpals_client/data/providers/users/users_provider.dart';
import 'package:budgetpals_client/data/repositories/auth/auth_repository.dart';
import 'package:budgetpals_client/data/repositories/user/user_repository.dart';
import 'package:budgetpals_client/screens/add_budget/view/add_budget_page.dart';
import 'package:budgetpals_client/utilities/auth/bloc/auth_bloc.dart';
import 'package:budgetpals_client/screens/login/view/login_page.dart';
import 'package:budgetpals_client/screens/splash/view/splash_page.dart';
import 'package:budgetpals_client/theme.dart';
import 'package:budgetpals_client/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final url = Url.getUrl();

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
      theme: myTheme,
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
                  AddBudgetPage.route(),
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
