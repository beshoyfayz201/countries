import 'package:countriesmms/core/errors/exceptions.dart';
import 'package:countriesmms/core/services/network_service/api_service.dart';
import 'package:countriesmms/core/services/network_service/endpoints.dart';
import 'package:countriesmms/features/home_countries/data/model/countries_list/countries_list.dart';
import 'package:dartz/dartz.dart';

class CountryRemoteDataSource {
  DioImpl dio=DioImpl() ;

  CountryRemoteDataSource();
   Future<Either<String,List<CountriesList>>> fetchCountries() async {
    try {
      final response = await dio.get(endPoint:  EndPoints.baseUrl);
      
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<CountriesList>countries=[];
         for (var element in data) {
          countries.add(CountriesList.fromJson(element));
        }
        return Right(countries);
      } else {
        return const Left('Failed to load countries');
      }
    } on PrimaryServerException catch (e) {
      return Left(e.message);
    }
  }
}