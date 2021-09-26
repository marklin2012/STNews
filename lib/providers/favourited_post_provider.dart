import 'package:flutter/material.dart';
import 'package:stnews/models/post_model.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/service/result_data.dart';

class FavouritedPostProvider extends ChangeNotifier {
  List<PostModel> _posts = [];
  List<PostModel> get posts => _posts;
  set posts(List<PostModel>? postModels) {
    if (postModels != null) {
      _posts = postModels;
      notifyListeners();
    }
  }

  Future getFavouritedPostsData() async {
    ResultData result = await Api.getUserFavouritePost();
    if (result.success) {
      List _temps = result.data['favourites'];
      posts = _temps.map((e) => PostModel.fromJson(e)).toList();
    }
  }

  Future unFavouritedPosts({List<String>? postIDs}) async {
    if (postIDs == null || postIDs.isEmpty) return;
    for (String postID in postIDs) {
      ResultData result = await Api.favoritePost(postid: postID, status: false);
      if (result.success) {
        for (int i = 0; i < _posts.length; i++) {
          PostModel post = _posts[i];
          if (post.id == postID) {
            _posts.removeAt(i);
            i--;
            break;
          }
        }
      }
      notifyListeners();
    }
  }
}
