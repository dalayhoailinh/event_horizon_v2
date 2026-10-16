import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/favorite/favorite_cubit.dart';
import '../blocs/favorite/favorite_state.dart';

/// Heart toggle. [onImage] draws it as a translucent circle for use over a
/// cover photo.
class FavoriteButton extends StatelessWidget {
  final bool onImage;
  const FavoriteButton({super.key, this.onImage = false});

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
        final icon = Icon(
          state.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: state.isFavorite
              ? scheme.error
              : (onImage ? Colors.white : null),
        );
        final tooltip = state.isFavorite ? 'Bỏ yêu thích' : 'Yêu thích';
        void toggle() => context.read<FavoriteCubit>().toggle();

        if (!onImage) {
          return IconButton.filledTonal(
            onPressed: toggle,
            icon: icon,
            tooltip: tooltip,
          );
        }
        return Material(
          color: Colors.black.withValues(alpha: 0.35),
          shape: const CircleBorder(),
          child: IconButton(onPressed: toggle, icon: icon, tooltip: tooltip),
        );
      },
    );
  }
}
