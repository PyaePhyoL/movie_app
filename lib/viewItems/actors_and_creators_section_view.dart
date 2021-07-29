import 'package:flutter/material.dart';
import 'package:movie_app/data/vos/base_actor_vo.dart';
import 'package:movie_app/resources/colors.dart';
import 'package:movie_app/resources/dimens.dart';
import 'package:movie_app/viewItems/actor_view.dart';
import 'package:movie_app/widgets/title_text_with_see_more_view.dart';

class ActorsAndCreatorsSectionView extends StatefulWidget {
  final String title;
  final String seeMoreTitle;
  final bool seeMoreButtonVisibility;
  final List<BaseActorVO> actorList;

  ActorsAndCreatorsSectionView(this.title, this.seeMoreTitle,
      {this.seeMoreButtonVisibility = true, this.actorList});

  @override
  _ActorsAndCreatorsSectionViewState createState() =>
      _ActorsAndCreatorsSectionViewState();
}

class _ActorsAndCreatorsSectionViewState
    extends State<ActorsAndCreatorsSectionView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: PRIMARY_COLOR,
      padding: EdgeInsets.only(top: MARGIN_MEDIUM_2, bottom: MARGIN_XXLARGE),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
            child: TitleTextWithSeeMoreView(
              widget.title,
              widget.seeMoreTitle,
              seeMoreButtonVisibility: widget.seeMoreButtonVisibility,
            ),
          ),
          SizedBox(
            height: MARGIN_MEDIUM_2,
          ),
          Container(
            height: 200,
            child: (widget.actorList != null)
                ? ListView(
                    padding: EdgeInsets.only(left: MARGIN_MEDIUM_2),
                    scrollDirection: Axis.horizontal,
                    children: widget.actorList
                        .map((actorList) => ActorView(
                              mActor: actorList,
                            ))
                        .take(5)
                        .toList(),
                  )
                : Center(
                    child: CircularProgressIndicator(
                      color: Colors.amber,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
