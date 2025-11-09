import 'package:provider/provider.dart';
import '../data/datasources/auth_datasource.dart';
import '../data/datasources/cliente_datasource.dart';
import '../data/datasources/solicitacao_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/cliente_repository_impl.dart';
import '../data/repositories/solicitacao_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/cliente_repository.dart';
import '../domain/repositories/solicitacao_repository.dart';
import '../presentation/viewmodels/auth_viewmodel.dart';
import '../presentation/viewmodels/cliente_viewmodel.dart';
import '../presentation/viewmodels/solicitacao_viewmodel.dart';

/// Classe responsável pela configuração de Dependency Injection
/// Usa Provider para injetar dependências em toda a aplicação
class DependencyInjection {
  /// Configura todos os providers necessários para a aplicação
  static List<Provider> get providers {
    return [
      // DataSources
      Provider<AuthDataSource>(
        create: (_) => AuthDataSource(),
      ),
      Provider<ClienteDataSource>(
        create: (_) => ClienteDataSource(),
      ),
      Provider<SolicitacaoDataSource>(
        create: (_) => SolicitacaoDataSource(),
      ),

      // Repositories
      Provider<AuthRepository>(
        create: (context) => AuthRepositoryImpl(
          dataSource: context.read<AuthDataSource>(),
        ),
      ),
      Provider<ClienteRepository>(
        create: (context) => ClienteRepositoryImpl(
          dataSource: context.read<ClienteDataSource>(),
        ),
      ),
      Provider<SolicitacaoRepository>(
        create: (context) => SolicitacaoRepositoryImpl(
          dataSource: context.read<SolicitacaoDataSource>(),
        ),
      ),
    ];
  }

  /// Configura todos os ChangeNotifierProviders (ViewModels)
  static List<ChangeNotifierProvider> get changeNotifierProviders {
    return [
      // ViewModels
      ChangeNotifierProvider<AuthViewModel>(
        create: (context) => AuthViewModel(
          authRepository: context.read<AuthRepository>(),
        ),
      ),
      ChangeNotifierProvider<ClienteViewModel>(
        create: (context) => ClienteViewModel(
          clienteRepository: context.read<ClienteRepository>(),
        ),
      ),
      ChangeNotifierProvider<SolicitacaoViewModel>(
        create: (context) => SolicitacaoViewModel(
          solicitacaoRepository: context.read<SolicitacaoRepository>(),
          authRepository: context.read<AuthRepository>(),
        ),
      ),
    ];
  }
}
