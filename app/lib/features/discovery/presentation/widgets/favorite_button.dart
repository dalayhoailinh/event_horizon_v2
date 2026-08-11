import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/favorite/favorite_cubit.dart';
import '../blocs/favorite/favorite_state.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavoriteCubit, FavoriteState>(
      listenWhen: (previous, current) => current.message != null,
      listener: (context, state) {
        final message = state.message;
        if (message == null) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
        context.read<FavoriteCubit>().messageShown();
      },
      builder: (context, state) {
        final scheme = Theme.of(context).colorScheme;
        return IconButton.filledTonal(
          onPressed: () => context.read<FavoriteCubit>().toggle(),
          icon: Icon(
            state.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: state.isFavorite ? scheme.error : null,
          ),
          tooltip: state.isFavorite ? 'Bỏ yêu thích' : 'Yêu thích',
        );
      },
    );
  }
}
