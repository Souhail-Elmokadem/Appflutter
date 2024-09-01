import 'dart:io';

abstract class TourState {}

class TourStateInitializer extends TourState{}
class TourStateSuccess extends TourState{}
class TourStateLoading extends TourState{}
class TourStateFailure extends TourState{}
class TourImagesUpdated extends TourState{
  final List<File> images;

  TourImagesUpdated(this.images);
}
class TourImagesFailedSize extends TourState{
   final String error;

   TourImagesFailedSize(this.error);
}