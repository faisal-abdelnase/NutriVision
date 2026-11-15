import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nutri_vision/core/widgets/content_container.dart';
import 'package:nutri_vision/core/widgets/state_message_view.dart';
import 'package:nutri_vision/features/meal_tracking/domain/entities/meal.dart';
import 'package:nutri_vision/features/meal_tracking/presentation/cubit/meal_cubit.dart';
import 'package:nutri_vision/features/meal_tracking/presentation/cubit/meal_state.dart';

import '../widgets/meal_history_day_header.dart';
import '../widgets/meal_history_tile.dart';

class MealHistoryScreen extends StatelessWidget {
  const MealHistoryScreen({super.key});

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
      create: (_) => GetIt.instance<MealCubit>()..getMealHistory(userId: userId),
      child: _MealHistoryView(userId: userId),
    );
  }
}

class _MealHistoryView extends StatefulWidget {
  const _MealHistoryView({required this.userId});
  final String userId;

  @override
  State<_MealHistoryView> createState() => _MealHistoryViewState();
}

class _MealHistoryViewState extends State<_MealHistoryView> {
  static const _pageSize = 20;

  final _scroll = ScrollController();
  final List<Meal> _meals = [];
  int _page = 0;
  bool _hasMore = true;
  bool _loaded = false;
  bool _loadingMore = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_loaded || _loadingMore || !_hasMore) return;
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 200) {
      setState(() => _loadingMore = true);
      context.read<MealCubit>().getMealHistory(
            userId: widget.userId,
            page: _page + 1,
            pageSize: _pageSize,
          );
    }
  }

  Future<void> _reload() {
    return context.read<MealCubit>().getMealHistory(
          userId: widget.userId,
          pageSize: _pageSize,
        );
  }

  Future<void> _confirmDelete(Meal meal) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete meal?'),
        content: Text('"${meal.name}" will be removed from your history.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      context
          .read<MealCubit>()
          .deleteMeal(mealId: meal.id, userId: widget.userId);
    }
  }

  /// Flattens meals into [DateTime] headers and [Meal] rows.
  List<Object> _buildItems() {
    final items = <Object>[];
    DateTime? lastDay;
    for (final meal in _meals) {
      final day =
          DateTime(meal.eatenAt.year, meal.eatenAt.month, meal.eatenAt.day);
      if (lastDay != day) {
        items.add(day);
        lastDay = day;
      }
      items.add(meal);
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: BlocConsumer<MealCubit, MealState>(
        listener: (context, state) {
          if (state is MealHistoryLoaded) {
            setState(() {
              if (state.page == 0) _meals.clear();
              _meals.addAll(state.meals);
              _page = state.page;
              _hasMore = state.hasMore;
              _loaded = true;
              _loadingMore = false;
              _error = null;
            });
          } else if (state is MealOperationSuccess) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
            _reload();
          } else if (state is MealError) {
            setState(() {
              _loadingMore = false;
              if (!_loaded) _error = state.message;
            });
            if (_loaded) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          }
        },
        builder: (context, state) {
          if (!_loaded && _error == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_error != null && _meals.isEmpty) {
            return StateMessageView(
              icon: Icons.error_outline,
              title: 'Could not load your meals',
              message: _error,
              actionLabel: 'Retry',
              onAction: () {
                setState(() => _error = null);
                _reload();
              },
            );
          }
          if (_meals.isEmpty) {
            return const StateMessageView(
              icon: Icons.restaurant_outlined,
              title: 'No meals yet',
              message: 'Meals you log will show up here.',
            );
          }

          final items = _buildItems();
          return ContentContainer(
            maxWidth: 800,
            child: RefreshIndicator(
              onRefresh: _reload,
              child: ListView.builder(
                controller: _scroll,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: items.length + (_loadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= items.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final item = items[index];
                  if (item is DateTime) return MealHistoryDayHeader(date: item);
                  final meal = item as Meal;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: MealHistoryTile(
                      meal: meal,
                      onDelete: () => _confirmDelete(meal),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
