import 'package:either_dart/either.dart';
import 'package:taav_store/src/commons/models/failure.dart';
import 'package:taav_store/src/commons/services/base_repository.dart';
import 'package:taav_store/src/commons/services/network_service.dart';
import '../models/color_model.dart';
import '../models/tag_model.dart';

abstract class IMetadataRepository {
  Future<Either<Failure, List<ColorModel>>> getColors();
  Future<Either<Failure, List<TagModel>>> getTags();

  Future<Either<Failure, TagModel>> createNewTag(String tagName);
  Future<Either<Failure, ColorModel>> createNewColor(
    String name,
    String hexCode,
  );
}

class MetadataRepository extends BaseRepository implements IMetadataRepository {
  final NetworkService _network;

  MetadataRepository({required NetworkService network}) : _network = network;

  @override
  Future<Either<Failure, List<ColorModel>>> getColors() {
    return safeCall<List<ColorModel>>(
      request: () => _network.get('/colors'),
      fromJson: (json) {
        final list = (json as List).map((e) => ColorModel.fromJson(e)).toList();
        return list;
      },
    );
  }

  @override
  Future<Either<Failure, List<TagModel>>> getTags() {
    return safeCall<List<TagModel>>(
      request: () => _network.get('/tags'),
      fromJson: (json) {
        final list = (json as List).map((e) => TagModel.fromJson(e)).toList();
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
        return newTag;
      },
    );
  }

  @override
  Future<Either<Failure, ColorModel>> createNewColor(
    String name,
    String hexCode,
  ) {
    return safeCall<ColorModel>(
      request:
          () => _network.post('/colors', data: {'name': name, 'hex': hexCode}),
      fromJson: (json) {
        final newColor = ColorModel.fromJson(json);
        return newColor;
      },
    );
  }
}
