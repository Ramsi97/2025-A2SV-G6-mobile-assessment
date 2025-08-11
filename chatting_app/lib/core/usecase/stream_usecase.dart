abstract class StreamUsecase<Type, Params> {
  Stream<Type> call(Params params);
}
