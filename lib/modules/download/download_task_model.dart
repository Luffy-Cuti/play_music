class DownloadTaskModel {
  final String songId;
  final String url;
  final String? localPath;
  final String status;
  final int progress;
  final String? error;

  const DownloadTaskModel({
    required this.songId,
    required this.url,
    required this.status,
    required this.progress,
    this.localPath,
    this.error,
  });

  DownloadTaskModel copyWith({
    String? songId,
    String? url,
    String? localPath,
    String? status,
    int? progress,
    String? error,
  }) {
    return DownloadTaskModel(
      songId: songId ?? this.songId,
      url: url ?? this.url,
      localPath: localPath ?? this.localPath,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      error: error ?? this.error,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'songId': songId,
      'url': url,
      'localPath': localPath,
      'status': status,
      'progress': progress,
      'error': error,
    };
  }

  factory DownloadTaskModel.fromJson(Map<String, dynamic> json) {
    return DownloadTaskModel(
      songId: json['songId'] ?? '',
      url: json['url'] ?? '',
      localPath: json['localPath'],
      status: json['status'] ?? 'queued',
      progress: json['progress'] ?? 0,
      error: json['error'],
    );
  }
}