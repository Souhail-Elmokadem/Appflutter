abstract class TourState {}

class TourStateInitializer extends TourState{}
class TourStateSuccess extends TourState{}
class TourStateLoading extends TourState{}
class TourStateFailure extends TourState{}