import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haiku/cubits/author/author_profile_cubit.dart';
import 'package:haiku/cubits/talks/talks_cubit.dart';
import 'package:haiku/cubits/user/profile_cubit.dart';
import 'package:haiku/presentation/pages/add/add_post_page.dart';
import 'package:haiku/presentation/pages/author/author_profile_page.dart';
import 'package:haiku/presentation/pages/talks/talks_page.dart';

import '../../cubits/home/home_cubit.dart';
import '../../cubits/login/login_cubit.dart';
import '../../cubits/register/register_cubit.dart';
import '../../presentation/pages/home/home_page.dart';
import '../../presentation/pages/login/login_page.dart';
import '../../presentation/pages/register/register_page.dart';

class Pager {
  Pager._();

  static Widget get home => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeCubit()..getAllPosts(),
          ),
          BlocProvider(
            create: (context) => ProfileCubit()..loadProfile(),
          )
        ],
        child: const HomePage(),
      );

  static Widget get register => BlocProvider(
        create: (context) => RegisterCubit(),
        child: const RegisterPage(),
      );

  static Widget get login => BlocProvider(
        create: (context) => LoginCubit(),
        child: const LoginPage(),
      );

  static Widget get addPost => BlocProvider(
        create: (context) => ProfileCubit()..loadUserInfo(),
        child: const AddPostPage(),
      );

  static Widget talks({
    required String postId,
    required String posterId,
  }) =>
      BlocProvider(
        create: (context) => TalksCubit(
          postId: postId,
          posterId: posterId,
        )..getPostTalks(),
        child: const TalksPage(),
      );

  static Widget showAuthor({
    required String authorId,
  }) =>
      BlocProvider(
        create: (context) =>
            AuthorProfileCubit(authorId: authorId)..loadProfile(),
        child: const AuthorProfilePage(),
      );
}
