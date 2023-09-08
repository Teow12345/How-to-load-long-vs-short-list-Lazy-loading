import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LazyLoadingList(),
    );
  }
}

class LazyLoadingList extends StatefulWidget {
  @override
  _LazyLoadingListState createState() => _LazyLoadingListState();
}

class _LazyLoadingListState extends State<LazyLoadingList> {
  // Simulated data source (list of numbers).
  List<int> items = List.generate(20, (index) => index + 1);

  // The number of items to load in each batch.
  int batchSize = 10;

  // Tracking the current batch index.
  int currentBatchIndex = 1;

  // Controller for the ListView.
  ScrollController _scrollController = ScrollController();

  // Flag to indicate if new data is being loaded.
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // Add a listener to the scroll controller to detect when the user reaches the end of the list.
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // User has reached the end of the list, load more data.
      _loadMoreData();
    }
  }

  void _loadMoreData() {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      // Simulated delay to mimic fetching more data.
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          // Append the next batch of items to the list.
          final newItems = List.generate(batchSize, (index) => items.length + index + 1);
          items.addAll(newItems);
          currentBatchIndex++;
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lazy Loading List'),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: items.length + 1, // +1 for the loading indicator at the end.
        itemBuilder: (context, index) {
          if (index < items.length) {
            return ListTile(
              title: Text('Item ${items[index]}'),
            );
          } else {
            // Display a loading indicator when loading more data.
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
