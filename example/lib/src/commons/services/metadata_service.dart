import 'package:get/get.dart';
import 'package:example/src/pages/shared/models/color_model.dart';
import 'package:example/src/pages/shared/models/tag_model.dart';
import 'package:example/src/pages/shared/repositories/metadata_repository.dart';

class MetadataService extends GetxService {

  final IMetadataRepository repository;

  MetadataService({required this.repository});


  final RxList<ColorModel> colors = <ColorModel>[].obs;
  final RxList<TagModel> tags = <TagModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    refreshMetadata();
  }

  Future<void> refreshMetadata() async {
    final colorsResult = await repository.getColors();
    colorsResult.fold((l) {}, (data) => colors.assignAll(data));

    final tagsResult = await repository.getTags();
    tagsResult.fold((l) {}, (data) => tags.assignAll(data));
  }

  // افزودن تگ جدید (تمیز و استاندارد)
  Future<bool> addNewTag(String name) async {
    final result = await repository.createNewTag(name);
    return result.fold(
          (l) => false,
          (newTag) {
        tags.add(newTag);
        return true;
      },
    );
  }


  Future<bool> addNewColor(String name, String hex) async {
    final result = await repository.createNewColor(name, hex);
    return result.fold(
          (l) => false,
          (newColor) {
        colors.add(newColor);
        return true;
      },
    );
  }
}