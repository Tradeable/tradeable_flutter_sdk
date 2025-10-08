import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class AsyncBuilder<T> extends StatefulWidget {
  final Future<T> Function() request;
  final Widget? loadingWidget;
  final Widget Function(BuildContext context, T data)? builder;
  final Widget Function(BuildContext context, String error, VoidCallback retry)?
      errorBuilder;
  final Widget Function(BuildContext context)? loadingBuilder;

  const AsyncBuilder({
    super.key,
    required this.request,
    this.builder,
    this.loadingWidget,
    this.errorBuilder,
    this.loadingBuilder,
  });

  @override
  State<AsyncBuilder<T>> createState() => _AsyncBuilderState<T>();
}

class _AsyncBuilderState<T> extends State<AsyncBuilder<T>> {
  late Future<T> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.request();
  }

  void _retry() {
    setState(() {
      _future = widget.request();
    });
  }

  Widget _buildDefaultLoading(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildDefaultError(
      BuildContext context, String error, VoidCallback retry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: retry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultSuccess(BuildContext context, T data) {
    return Center(
      child: Text('Data loaded: ${data.toString()}'),
    );
  }

  String _extractErrorMessage(Object error) {
    if (error is DioException) {
      if (error.response != null) {
        // Try to extract error message from response
        final data = error.response?.data;
        if (data is Map && data.containsKey('message')) {
          return data['message'].toString();
        }
        if (data is Map && data.containsKey('error')) {
          return data['error'].toString();
        }
        return 'Server error: ${error.response?.statusCode}';
      }

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return 'Connection timeout. Please check your internet connection.';
        case DioExceptionType.sendTimeout:
          return 'Send timeout. Please try again.';
        case DioExceptionType.receiveTimeout:
          return 'Receive timeout. Please try again.';
        case DioExceptionType.connectionError:
          return 'Connection error. Please check your internet connection.';
        case DioExceptionType.cancel:
          return 'Request cancelled.';
        default:
          return error.message ?? 'An error occurred';
      }
    }
    return error.toString();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Loading state
          if (widget.loadingWidget != null) {
            return widget.loadingWidget!;
          } else if (widget.loadingBuilder != null) {
            return widget.loadingBuilder!(context);
          } else {
            return _buildDefaultLoading(context);
          }
        } else if (snapshot.hasError) {
          // Error state
          final errorMessage = _extractErrorMessage(snapshot.error!);
          if (widget.errorBuilder != null) {
            return widget.errorBuilder!(context, errorMessage, _retry);
          } else {
            return _buildDefaultError(context, errorMessage, _retry);
          }
        } else if (snapshot.hasData) {
          // Success state
          if (widget.builder != null) {
            return widget.builder!(context, snapshot.data as T);
          } else {
            return _buildDefaultSuccess(context, snapshot.data as T);
          }
        } else {
          // Empty state (no data)
          return const Center(
            child: Text('No data available'),
          );
        }
      },
    );
  }
}
