import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../utils/app_constants.dart';

class DownloadService {
  final Dio _dio;
  
  DownloadService({Dio? dio}) : _dio = dio ?? Dio();
  
  Future<String> getDownloadPath(String fileName) async {
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        // Create the directory if it doesn't exist
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = await getDownloadsDirectory();
      }
    } catch (e) {
      directory = await getTemporaryDirectory();
    }
    
    return '${directory!.path}/$fileName';
  }
  
  Future<DownloadResult> downloadFile({
    required String url,
    required String fileName,
    String? customPath,
    Map<String, dynamic>? headers,
    ValueChanged<DownloadProgress>? onProgress,
    bool overwrite = false,
  }) async {
    try {
      // Determine the save path
      final savePath = customPath ?? await getDownloadPath(fileName);
      
      // Check if file already exists
      final file = File(savePath);
      if (await file.exists() && !overwrite) {
        return DownloadResult(
          success: true,
          filePath: savePath,
          message: 'File already exists',
        );
      }
      
      // Create parent directory if it doesn't exist
      final dir = Directory(file.parent.path);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      
      // Start download
      await _dio.download(
        url,
        savePath,
        options: Options(
          headers: headers,
          receiveTimeout: const Duration(milliseconds: AppConstants.downloadTimeout),
        ),
        onReceiveProgress: (received, total) {
          if (total != -1 && onProgress != null) {
            onProgress(DownloadProgress(
              received: received,
              total: total,
              progress: received / total,
            ));
          }
        },
      );
      
      return DownloadResult(
        success: true,
        filePath: savePath,
        message: 'Download completed successfully',
      );
    } on DioException catch (e) {
      return DownloadResult(
        success: false,
        message: _getErrorMessage(e),
        error: e,
      );
    } catch (e) {
      return DownloadResult(
        success: false,
        message: e.toString(),
        error: e,
      );
    }
  }
  
  Future<DownloadResult> downloadMultipleFiles({
    required List<DownloadItem> items,
    ValueChanged<MultiDownloadProgress>? onProgress,
  }) async {
    final results = <DownloadItemResult>[];
    int completed = 0;
    
    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      
      try {
        final result = await downloadFile(
          url: item.url,
          fileName: item.fileName,
          customPath: item.customPath,
          headers: item.headers,
          onProgress: (progress) {
            if (onProgress != null) {
              onProgress(MultiDownloadProgress(
                currentItemIndex: i,
                currentItem: item,
                currentProgress: progress,
                totalItems: items.length,
                completedItems: completed,
                itemResults: results,
              ));
            }
          },
          overwrite: item.overwrite,
        );
        
        results.add(DownloadItemResult(
          item: item,
          success: result.success,
          filePath: result.filePath,
          message: result.message,
          error: result.error,
        ));
        
        if (result.success) completed++;
      } catch (e) {
        results.add(DownloadItemResult(
          item: item,
          success: false,
          message: e.toString(),
          error: e,
        ));
      }
    }
    
    final allSuccessful = results.every((result) => result.success);
    
    return DownloadResult(
      success: allSuccessful,
      message: allSuccessful 
          ? 'All downloads completed successfully' 
          : 'Some downloads failed',
      itemResults: results,
    );
  }
  
  String _getErrorMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 20000.toString();
      case DioExceptionType.badResponse:
        return 'Server error: ${e.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Download was cancelled';
      case DioExceptionType.connectionError:
        return AppConstants.connectionError;
      default:
        return e.message ?? AppConstants.unknownError;
    }
  }
  
  void cancelDownloads() {
    _dio.close(force: true);
  }
}

class DownloadProgress {
  final int received;
  final int total;
  final double progress;
  
  DownloadProgress({
    required this.received,
    required this.total,
    required this.progress,
  });
}

class MultiDownloadProgress {
  final int currentItemIndex;
  final DownloadItem currentItem;
  final DownloadProgress currentProgress;
  final int totalItems;
  final int completedItems;
  final List<DownloadItemResult> itemResults;
  
  MultiDownloadProgress({
    required this.currentItemIndex,
    required this.currentItem,
    required this.currentProgress,
    required this.totalItems,
    required this.completedItems,
    required this.itemResults,
  });
  
  double get overallProgress {
    if (totalItems == 0) return 0.0;
    return (completedItems + currentProgress.progress) / totalItems;
  }
}

class DownloadItem {
  final String url;
  final String fileName;
  final String? customPath;
  final Map<String, dynamic>? headers;
  final bool overwrite;
  
  DownloadItem({
    required this.url,
    required this.fileName,
    this.customPath,
    this.headers,
    this.overwrite = false,
  });
}

class DownloadItemResult {
  final DownloadItem item;
  final bool success;
  final String? filePath;
  final String? message;
  final dynamic error;
  
  DownloadItemResult({
    required this.item,
    required this.success,
    this.filePath,
    this.message,
    this.error,
  });
}

class DownloadResult {
  final bool success;
  final String? filePath;
  final String? message;
  final dynamic error;
  final List<DownloadItemResult>? itemResults;
  
  DownloadResult({
    required this.success,
    this.filePath,
    this.message,
    this.error,
    this.itemResults,
  });
}