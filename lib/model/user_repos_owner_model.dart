import 'package:json_annotation/json_annotation.dart';

part 'user_repos_owner_model.g.dart';

@JsonSerializable()
class UserReposOwnerModel {
  String? login;
  int? id;
  String? nodeId;
  String? avatarUrl;
  String? gravatarId;
  String? url;
  String? htmlUrl;
  String? followersUrl;
  String? followingUrl;
  String? gistsUrl;
  String? starredUrl;
  String? subscriptionsUrl;
  String? organizationsUrl;
  String? reposUrl;
  String? eventsUrl;
  String? receivedEventsUrl;
  String? type;
  String? userViewType;
  bool? siteAdmin;

  UserReposOwnerModel(
      {this.login,
      this.id,
      this.nodeId,
      this.avatarUrl,
      this.gravatarId,
      this.url,
      this.htmlUrl,
      this.followersUrl,
      this.followingUrl,
      this.gistsUrl,
      this.starredUrl,
      this.subscriptionsUrl,
      this.organizationsUrl,
      this.reposUrl,
      this.eventsUrl,
      this.receivedEventsUrl,
      this.type,
      this.userViewType,
      this.siteAdmin});

  factory UserReposOwnerModel.fromJson(Map<String, dynamic> json) =>
      _$UserReposOwnerModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserReposOwnerModelToJson(this);
}
