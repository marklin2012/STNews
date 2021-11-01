import 'package:flutter/material.dart';
import 'package:stnews/models/comment_model.dart';
import 'package:stnews/models/post_model.dart';
import 'package:stnews/models/user_model.dart';
import 'package:stnews/pages/common/easy_refresh/news_refresh_result.dart';
import 'package:stnews/pages/common/news_perpage.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/service/result_data.dart';
import 'package:stnews/utils/list+.dart';

class PostDetailProvider extends ChangeNotifier {
  PostModel _postModel = PostModel();
  PostModel get postModel => _postModel;
  set postModel(PostModel? model) {
    if (model != null) _postModel = model;
  }

  List<CommentModel> _comments = [];
  List<CommentModel> get comments => _comments;

  int _page = 1;
  int _perpage = NewsPerpage.finalPerPage;
  bool _hasMore = true;

  bool _isFavouritedUser = false;
  bool get isFavouritedUser => _isFavouritedUser;

  List<UserModel> _favouritedLists = [];

  Future<bool> initComments() async {
    _page = 1;
    ResultData result = await Api.getCommentList(
        page: _page, perpage: _perpage, postid: postModel.id);
    if (result.success) {
      final _temps = result.data['comments'] as List;
      _hasMore = STList.hasMore(_temps);
      _comments = _temps.map((e) => CommentModel.fromJson(e)).toList();
      notifyListeners();
      return Future.value(true);
    }
    return Future.value(false);
  }

  Future<ResultRefreshData> loadMore() async {
    ResultRefreshData data;
    if (!_hasMore) return Future.value(ResultRefreshData.noMore());
    _page++;
    ResultData result = await Api.getCommentList(
        page: _page, perpage: _perpage, postid: postModel.id);
    if (result.success) {
      final _temps = result.data['comments'] as List;
      _hasMore = STList.hasMore(_temps);
      for (Map<String, dynamic> item in _temps) {
        final _temp = CommentModel.fromJson(item);
        _comments.add(_temp);
      }
      data = ResultRefreshData(success: true, hasMore: _hasMore);
    } else {
      data = ResultRefreshData.error();
    }
    notifyListeners();
    return Future.value(data);
  }

  /// 查询是否关注了该用户
  Future<bool> getFavouritedUser() async {
    ResultData result = await Api.getUserFavouriteList();
    if (result.success) {
      List _temp = result.data['favourites'];
      _favouritedLists = _temp.map((e) => UserModel.fromJson(e)).toList();
      _isFavouritedUser = false;
      for (UserModel user in _favouritedLists) {
        if (user.id == postModel.author?.id) {
          _isFavouritedUser = true;
          break;
        }
      }
      // notifyListeners();
    }
    return Future.value(_isFavouritedUser);
  }

  /// 关注或取消关注该用户
  Future favouritedUser() async {
    ResultData result = await Api.changeUserFavourite(
        followeduserid: postModel.author?.id, status: !_isFavouritedUser);
    if (result.success) {
      _isFavouritedUser = !_isFavouritedUser;
      notifyListeners();
    }
  }

  /// 获取是否收藏或者点赞了该文章
  Future getPostFavouritedAndLiked() async {
    // notifyListeners();
  }

  Future<bool> getPostLiked() async {
    if (postModel.id == null) return Future.value(false);
    ResultData result1 = await Api.getThumpubPost(id: postModel.id);
    bool _isLikedPost = false;
    if (result1.success) {
      _isLikedPost = result1.data['isThumbup'] as bool;
    }
    return Future.value(_isLikedPost);
  }

  Future<bool> getPostFavourited() async {
    if (postModel.id == null) return Future.value(false);
    ResultData result2 = await Api.getFavouritePost(id: postModel.id);
    bool _isFavouritedPost = false;
    if (result2.success) {
      _isFavouritedPost = result2.data['isFavourite'] as bool;
    }
    return Future.value(_isFavouritedPost);
  }

  /// 发布评论
  Future<bool> addComment(String content) async {
    ResultData result =
        await Api.addComment(postid: postModel.id, content: content);
    if (result.success) {
      Map<String, dynamic> _comment = result.data['comment'];
      CommentModel? _model = CommentModel.fromJson(_comment);
      comments.add(_model);
      notifyListeners();
      return true;
    }
    return false;
  }

  /// 收藏或取消收藏该文章
  Future<bool> favouritedPost(bool isFav) async {
    bool _isFav = isFav;
    ResultData result =
        await Api.favoritePost(postid: postModel.id, status: !_isFav);
    if (result.success) {
      _isFav = !_isFav;
    }
    return Future.value(_isFav);
  }

  /// 点赞或取消点赞该文章
  Future<bool> likedPost(bool isLiked) async {
    bool _isLiked = isLiked;
    ResultData result =
        await Api.thumbupPost(post: postModel.id, status: !_isLiked);
    if (result.success) {
      _isLiked = !_isLiked;
    }
    return Future.value(_isLiked);
  }

  /// 点赞评论
  Future commentLiked(String commentid, bool status) async {
    ResultData result =
        await Api.commentFavourite(comment: commentid, status: !status);
    if (result.success) {
      for (int index = 0; index < _comments.length; index++) {
        CommentModel _model = _comments[index];
        if (_model.id == commentid) {
          _model.isUserFavourite = !status;
          if (_model.isUserFavourite!) {
            _model.favouriteCount = (_model.favouriteCount ?? 0) + 1;
          } else {
            _model.favouriteCount = (_model.favouriteCount ?? 1) - 1;
          }
          _comments[index] = _model;
          break;
        }
      }
      notifyListeners();
    }
  }

  /// 接收在用户详情点击关注或取消关注
  void userHomeChangeStatus({String? userID, required bool status}) {
    if (userID == null) return;
    if (userID != _postModel.author?.id) return;
    _isFavouritedUser = status;
    notifyListeners();
  }
}
