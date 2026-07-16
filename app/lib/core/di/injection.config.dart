// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:cloud_functions/cloud_functions.dart' as _i809;
import 'package:event_horizon/core/di/firebase_module.dart' as _i354;
import 'package:event_horizon/core/env/build_info_service.dart' as _i229;
import 'package:event_horizon/core/router/app_router.dart' as _i157;
import 'package:event_horizon/features/auth/data/datasources/auth_datasource.dart'
    as _i555;
import 'package:event_horizon/features/auth/data/repositories/auth_repository_impl.dart'
    as _i835;
import 'package:event_horizon/features/auth/domain/repositories/auth_repository.dart'
    as _i911;
import 'package:event_horizon/features/auth/presentation/blocs/auth/auth_bloc.dart'
    as _i523;
import 'package:event_horizon/features/auth/presentation/blocs/login/login_cubit.dart'
    as _i486;
import 'package:event_horizon/features/auth/presentation/blocs/register/register_cubit.dart'
    as _i115;
import 'package:event_horizon/features/auth/presentation/blocs/verify_email/verify_email_cubit.dart'
    as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final firebaseModule = _$FirebaseModule();
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.auth);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => firebaseModule.firestore);
    gh.lazySingleton<_i809.FirebaseFunctions>(() => firebaseModule.functions);
    gh.lazySingleton<_i229.BuildInfoService>(
      () => const _i229.BuildInfoService(),
    );
    gh.lazySingleton<_i555.AuthDatasource>(
      () => _i555.AuthDatasourceImpl(gh<_i59.FirebaseAuth>()),
    );
    gh.lazySingleton<_i911.AuthRepository>(
      () => _i835.AuthRepositoryImpl(gh<_i555.AuthDatasource>()),
    );
    gh.lazySingleton<_i523.AuthBloc>(
      () => _i523.AuthBloc(gh<_i911.AuthRepository>()),
    );
    gh.factory<_i486.LoginCubit>(
      () => _i486.LoginCubit(gh<_i911.AuthRepository>()),
    );
    gh.factory<_i115.RegisterCubit>(
      () => _i115.RegisterCubit(gh<_i911.AuthRepository>()),
    );
    gh.factory<_i974.VerifyEmailCubit>(
      () => _i974.VerifyEmailCubit(gh<_i911.AuthRepository>()),
    );
    gh.lazySingleton<_i157.AppRouter>(
      () => _i157.AppRouter(gh<_i523.AuthBloc>()),
    );
    return this;
  }
}

class _$FirebaseModule extends _i354.FirebaseModule {}
