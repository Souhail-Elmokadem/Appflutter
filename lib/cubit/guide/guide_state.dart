import 'package:guidanclyflutter/models/tour_model_receive.dart';

abstract class GuideState {}

class GuideStateInit extends GuideState{}
class GuideStateLoading extends GuideState{}
class GuideStateSuccess extends GuideState{
  List<TourModelReceive> tours;
  GuideStateSuccess(this.tours);
}
class GuideStateFailed extends GuideState{}
class WorkTourLoading extends GuideState{}
class WorkTourSuccessful extends GuideState{}
class WorkTourSuccess extends GuideState{
  TourModelReceive tourModelReceive;
  WorkTourSuccess(this.tourModelReceive);
}
class WorkTourFailed extends GuideState{}