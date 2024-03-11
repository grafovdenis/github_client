import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:github_client/modules/search/data/models/search_result_item.dart';
import 'package:github_client/modules/search/domain/search_use_case.dart';
import 'package:github_client/utils/debouncer.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final SearchUseCase _useCase;

  final _searchResults = ValueNotifier<List<SearchResultItem>?>(null);
  final _searchController = TextEditingController();
  final _debouncer = Debouncer();
  final _scrollController = ScrollController();

  var _isLoading = false;

  @override
  void initState() {
    super.initState();

    _useCase = context.read<SearchUseCase>();

    _searchController.addListener(() {
      _debouncer.call(() {
        _getFirstPage();
      });
    });

    _scrollController.addListener(() {
      final trigger = 0.8 * _scrollController.position.maxScrollExtent;

      log("${_scrollController.position.pixels}");
      log("${_scrollController.position.pixels > trigger}");

      if (_scrollController.position.pixels > trigger && !_isLoading) {
        _fetchNextPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(controller: _searchController),
      ),
      body: ValueListenableBuilder(
          valueListenable: _searchResults,
          builder: (_, items, __) {
            final values = items;

            if (values == null) {
              return const Center(
                child: Text('Start by typing the search query'),
              );
            } else if (values.isEmpty) {
              return const Center(
                child: Text('No results found'),
              );
            } else {
              return ListView(
                controller: _scrollController,
                children: values.map(
                  (e) {
                    final subtitle = e.description;

                    return ListTile(
                      key: ValueKey(e.id),
                      title: Text(e.fullName),
                      trailing: Text('${e.stars} ⭐'),
                      subtitle: subtitle != null ? Text(subtitle) : null,
                    );
                  },
                ).toList(),
              );
            }
          }),
    );
  }

  Future<void> _getFirstPage() async {
    final result = await _useCase.searchRepositories(
      query: _searchController.text,
    );

    _searchResults.value = result.items;
  }

  Future<void> _fetchNextPage() async {
    _isLoading = true;
    final prevValue = _searchResults.value;
    if (prevValue != null && prevValue.isNotEmpty) {
      final newResult = await _useCase.searchRepositories(
        query: _searchController.text,
      );

      _searchResults.value = [...prevValue, ...newResult.items];
    }
    _isLoading = false;
  }
}
