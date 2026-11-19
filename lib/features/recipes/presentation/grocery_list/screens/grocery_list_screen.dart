import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nutri_vision/core/adaptive/adaptive_dialog.dart' as adaptive;
import 'package:nutri_vision/core/widgets/content_container.dart';
import 'package:nutri_vision/core/widgets/state_message_view.dart';
import 'package:nutri_vision/features/recipes/domain/entities/grocery_item.dart';
import 'package:nutri_vision/features/recipes/presentation/cubit/grocery_list_cubit.dart';
import 'package:nutri_vision/features/recipes/presentation/cubit/grocery_list_state.dart';

import '../widgets/add_grocery_item_sheet.dart';
import '../widgets/grocery_item_tile.dart';
import '../widgets/grocery_progress_header.dart';
import '../widgets/grocery_section_label.dart';

class GroceryListScreen extends StatelessWidget {
  const GroceryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return const Scaffold(
        body: StateMessageView(
          icon: Icons.lock_outline,
          title: 'Please sign in first',
        ),
      );
    }

    return BlocProvider(
      create: (_) => GetIt.instance<GroceryListCubit>()..load(userId: userId),
      child: _GroceryListView(userId: userId),
    );
  }
}

class _GroceryListView extends StatelessWidget {
  const _GroceryListView({required this.userId});
  final String userId;

  Future<void> _addItem(BuildContext context) async {
    final item = await adaptive.showAdaptiveDialog<GroceryItem>(
      context: context,
      builder: (_) => AddGroceryItemSheet(userId: userId),
    );
    if (item != null && context.mounted) {
      context.read<GroceryListCubit>().addItem(item: item);
    }
  }

  Future<void> _confirmClear(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear grocery list?'),
        content: const Text('All items will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      context.read<GroceryListCubit>().clear(userId: userId);
    }
  }

  Widget _body(BuildContext context, GroceryListState state) {
    final cubit = context.read<GroceryListCubit>();

    if (state is GroceryListError) {
      return StateMessageView(
        icon: Icons.error_outline,
        title: 'Could not load your list',
        message: state.message,
        actionLabel: 'Retry',
        onAction: () => cubit.load(userId: userId),
      );
    }

    if (state is! GroceryListLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    final items = state.groceryList.items;
    if (items.isEmpty) {
      return StateMessageView(
        icon: Icons.shopping_basket_outlined,
        title: 'Your list is empty',
        message: 'Add items manually or from a recipe.',
        actionLabel: 'Add item',
        onAction: () => _addItem(context),
      );
    }

    final pending = items.where((i) => !i.isChecked).toList();
    final done = items.where((i) => i.isChecked).toList();

    Widget tile(GroceryItem item) => GroceryItemTile(
          key: ValueKey(item.id),
          item: item,
          onToggle: () => cubit.updateItem(
            item: item.copyWith(isChecked: !item.isChecked),
          ),
          onDelete: () => cubit.removeItem(userId: userId, itemId: item.id),
        );

    return ContentContainer(
      maxWidth: 720,
      child: ListView(
        padding: const EdgeInsets.only(top: 16, bottom: 96),
        children: [
          GroceryProgressHeader(checked: done.length, total: items.length),
          if (pending.isNotEmpty) ...[
            const GrocerySectionLabel('To buy'),
            ...pending.map(tile),
          ],
          if (done.isNotEmpty) ...[
            const GrocerySectionLabel('In basket'),
            ...done.map(tile),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroceryListCubit, GroceryListState>(
      builder: (context, state) {
        final hasItems =
            state is GroceryListLoaded && state.groceryList.items.isNotEmpty;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Grocery List'),
            actions: [
              if (hasItems)
                PopupMenuButton<String>(
                  onSelected: (_) => _confirmClear(context),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'clear', child: Text('Clear list')),
                  ],
                ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _addItem(context),
            icon: const Icon(Icons.add),
            label: const Text('Add item'),
          ),
          body: _body(context, state),
        );
      },
    );
  }
}
