import 'package:either_dart/either.dart';
import 'package:example/src/commons/models/failure.dart';
import 'package:example/src/commons/services/base_repository.dart';
import 'package:example/src/commons/services/network_service.dart';
import '../models/color_model.dart';
import '../models/tag_model.dart';

abstract class IMetadataRepository {
  Future<Either<Failure, List<ColorModel>>> getColors({bool forceRefresh = false});
  Future<Either<Failure, List<TagModel>>> getTags({bool forceRefresh = false});


  Future<Either<Failure, TagModel>> createNewTag(String tagName);
  Future<Either<Failure, ColorModel>> createNewColor(String name, String hexCode);
}

class MetadataRepository extends BaseRepository implements IMetadataRepository {
  final NetworkService _network;

  List<ColorModel>? _cachedColors;
  List<TagModel>? _cachedTags;

  MetadataRepository({required NetworkService network}) : _network = network;

  @override
  Future<Either<Failure, List<ColorModel>>> getColors({bool forceRefresh = false}) {
    if (!forceRefresh && _cachedColors != null) {
      return Future.value(Right(_cachedColors!));
    }

    return safeCall<List<ColorModel>>(
      request: () => _network.get('/colors'),
      fromJson: (json) {
        final list = (json as List).map((e) => ColorModel.fromJson(e)).toList();
        _cachedColors = list;
        return list;
      },
    );
  }

  @override
  Future<Either<Failure, List<TagModel>>> getTags({bool forceRefresh = false}) {
    if (!forceRefresh && _cachedTags != null) {
      return Future.value(Right(_cachedTags!));
    }

    return safeCall<List<TagModel>>(
      request: () => _network.get('/tags'),
      fromJson: (json) {
        final list = (json as List).map((e) => TagModel.fromJson(e)).toList();
        _cachedTags = list;
        return list;
      },
    );
  }

  @override
  Future<Either<Failure, TagModel>> createNewTag(String tagName) {
    return safeCall<TagModel>(
      request: () => _network.post('/tags', data: {'name': tagName}),
      fromJson: (json) {
        final newTag = TagModel.fromJson(json);
        _cachedTags?.add(newTag);
        return newTag;
      },
    );
  }

  @override
  Future<Either<Failure, ColorModel>> createNewColor(String name, String hexCode) {
    return safeCall<ColorModel>(
      request: () => _network.post('/colors', data: {
        'name': name,
        'hex': hexCode,
      }),
      fromJson: (json) {
        final newColor = ColorModel.fromJson(json);

        _cachedColors?.add(newColor);

        return newColor;
      },
    );
  }
}