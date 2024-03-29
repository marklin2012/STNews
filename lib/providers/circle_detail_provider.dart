import 'package:flutter/material.dart';
import 'package:stnews/models/moment_comment_model.dart';
import 'package:stnews/models/moment_model.dart';
import 'package:stnews/models/user_model.dart';
import 'package:stnews/pages/common/easy_refresh/news_refresh_result.dart';
import 'package:stnews/pages/common/news_perpage.dart';
import 'package:stnews/service/api.dart';
import 'package:stnews/service/result_data.dart';
import 'package:stnews/utils/list+.dart';

class CircleDetailProvider extends ChangeNotifier {
  MomentModel _moment = MomentModel();
  set moment(MomentModel? model) {
    if (model != null) {
      _moment = model;
    }
  }

  int _totalCounts = 0;
  int get totalCounts => _totalCounts;

  List<MomentCommentModel> _comments = [];
  List<MomentCommentModel> get comments => _comments;

  int _page = 1;
  int _perpage = NewsPerpage.finalPerPage;
  bool _hasMore = true;

  Future getMomentDetail() async {
    ResultData result = await Api.getMomentDetail(id: _moment.id ?? '');
    if (result.success) {
      moment = MomentModel.fromJson(result.data);
      notifyListeners();
    }
  }

  /// 查询是否关注了该用户
  Future<bool> getFavouritedUser() async {
    ResultData result = await Api.getUserFavouriteList();
    bool _isFavouritedUser = false;
    if (result.success) {
      List _temp = result.data['favourites'];
      List<UserModel> _favouritedLists =
          _temp.map((e) => UserModel.fromJson(e)).toList();
      for (UserModel user in _favouritedLists) {
        if (user.id == _moment.user?.id) {
          _isFavouritedUser = true;
          break;
        }
      }
    }
    return Future.value(_isFavouritedUser);
  }

  /// 关注或取消关注该用户
  Future<bool> favouritedUser({
    bool? isFaved,
  }) async {
    bool _isFaved = isFaved ?? false;
    ResultData result = await Api.changeUserFavourite(
        followeduserid: _moment.user!.id, status: !_isFaved);
    if (result.success) {
      _isFaved = !_isFaved;
      notifyListeners();
    }
    return Future.value(_isFaved);
  }

  /// 获取是否点赞圈子
  Future<bool> getMomentThumbup() async {
    if (_moment.id == null) return Future.value(false);
    ResultData result = await Api.getMomentThumbup(moment: _moment.id!);
    bool _isThumbup = false;
    if (result.success) {
      _isThumbup = result.data['isThumbup'] as bool;
    }
    return Future.value(_isThumbup);
  }

  /// 获取是否收藏圈子
  Future<bool> getMomentFavourited() async {
    if (_moment.id == null) return Future.value(false);
    ResultData result = await Api.getMomentFavourite(moment: _moment.id!);
    bool _isFavourited = false;
    if (result.success) {
      _isFavourited = result.data['isFavourite'] as bool;
    }
    return Future.value(_isFavourited);
  }

  /// 收藏或取消收藏圈子
  Future<bool> favouritedMoment(bool isFav) async {
    bool _isFav = isFav;
    ResultData result =
        await Api.changeMomentFavourite(moment: _moment.id!, status: !_isFav);
    if (result.success) {
      _isFav = !_isFav;
    }
    return Future.value(_isFav);
  }

  /// 点赞或取消点赞圈子
  Future<bool> thumbupMoment(bool isThumbup) async {
    bool _isThumbup = isThumbup;
    ResultData result =
        await Api.changeMomentThumbup(moment: _moment.id!, status: !_isThumbup);
    if (result.success) {
      _isThumbup = !_isThumbup;
    }
    return Future.value(_isThumbup);
  }

  /// 发布评论
  Future<bool> addComment(
    String content, {
    String? reference,
    String? comment,
  }) async {
    ResultData result = await Api.addCommentMoment(
      moment: _moment.id!,
      content: content,
      reference: reference,
      comment: comment,
    );
    if (result.success) {
      Map<String, dynamic> _comment = result.data['comment'];
      MomentCommentModel? _model = MomentCommentModel.fromJson(_comment);
      if (reference != null) {
        initComments();
      } else {
        _comments.add(_model);
        _totalCounts += 1;
        notifyListeners();
      }
      return true;
    }
    return false;
  }

  /// 点赞评论
  Future commentFavourite({
    required String commentid,
    required bool status,
  }) async {
    ResultData result = await Api.changeCommentMomentFavourite(
        commentID: commentid, status: !status);
    if (result.success) {
      for (int index = 0; index < _comments.length; index++) {
        MomentCommentModel _model = _comments[index];
        bool _isFinded = false;
        _isFinded = _changeUserFavAndCount(
            commentID: commentid, commentModel: _model, status: status);
        if (_isFinded) {
          break;
        }
      }
      notifyListeners();
    }
  }

  bool _changeUserFavAndCount({
    required String commentID,
    required MomentCommentModel commentModel,
    required bool status,
  }) {
    if (commentID == commentModel.id) {
      commentModel.isUserFavourite = !status;
      if (commentModel.isUserFavourite!) {
        commentModel.favouriteCount = (commentModel.favouriteCount ?? 0) + 1;
      } else {
        commentModel.favouriteCount = (commentModel.favouriteCount ?? 1) - 1;
      }
      return true;
    } else {
      if (commentModel.references != null &&
          commentModel.references!.isNotEmpty) {
        bool _isFinded = false;
        for (int i = 0; i < commentModel.references!.length; i++) {
          MomentCommentModel subComM = commentModel.references![i];
          _isFinded = _changeUserFavAndCount(
              commentID: commentID, commentModel: subComM, status: status);
          if (_isFinded) {
            break;
          }
        }
      }
    }
    return false;
  }

  Future<bool> initComments() async {
    _page = 1;
    ResultData result = await Api.getCommentMomentList(
        page: _page, perpage: _perpage, moment: _moment.id!);
    if (result.success) {
      _totalCounts = result.data['totalCounts'] as int;
      final _temps = result.data['comments'] as List;
      _hasMore = STList.hasMore(_temps);
      _comments = _temps.map((e) => MomentCommentModel.fromJson(e)).toList();
      notifyListeners();
      return Future.value(true);
    }
    return Future.value(false);
  }

  Future<ResultRefreshData> loadMore() async {
    ResultRefreshData data;
    if (!_hasMore) return Future.value(ResultRefreshData.noMore());
    _page++;
    ResultData result = await Api.getCommentMomentList(
        page: _page, perpage: _perpage, moment: _moment.id!);
    if (result.success) {
      final _temps = result.data['comments'] as List;
      _hasMore = STList.hasMore(_temps);
      for (Map<String, dynamic> item in _temps) {
        final _temp = MomentCommentModel.fromJson(item);
        _comments.add(_temp);
      }
      data = ResultRefreshData(success: true, hasMore: _hasMore);
    } else {
      data = ResultRefreshData.error();
    }
    notifyListeners();
    return Future.value(data);
  }
}
