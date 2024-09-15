import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guidanclyflutter/cubit/tour/tour_cubit.dart';
import 'package:guidanclyflutter/cubit/tour/tour_state.dart';
import 'package:guidanclyflutter/environnement/environnement.prod.dart';
import 'package:guidanclyflutter/models/tour_model.dart';
import 'package:guidanclyflutter/models/tour_model_receive.dart';
import 'package:guidanclyflutter/services/tour_service.dart';
import 'package:guidanclyflutter/shared/constants/colors.dart';

class ListTour extends StatefulWidget {
  const ListTour({super.key});

  @override
  State<ListTour> createState() => _ListTourState();
}

class _ListTourState extends State<ListTour> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchNode = FocusNode();


  int currentPage = 0;
  bool isLoadingMore = false;

  bool showCancel = false;
  @override
  void initState() {
    super.initState();
    _searchNode.addListener(() => setState(() {}));
    context.read<TourCubit>().getTours(); // Ajoutez un log ici
    print("Initial tours fetched");

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !isLoadingMore) {
        currentPage++;
        isLoadingMore = true;
        print("Fetching more tours for page $currentPage");
        context.read<TourCubit>().getTours(page: currentPage, search: _searchController.text);
        isLoadingMore = false;
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onChangedText(String value) {
    // Reset pagination and load tours based on the search query
    currentPage = 0;
    context.read<TourCubit>().getTours(page: currentPage, search: value);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TourCubit, TourState>(
      builder: (context, state) {
        return Scaffold(
          body: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(10, 25, 10, 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(25)),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 13,
                          color: fourColor,
                        ),
                      ),
                    ),
                    const Text("Search",
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'sf-ui',
                            fontWeight: FontWeight.bold)),
                    IconButton(
                      onPressed: () {



                      },
                      icon: Text(showCancel?"Cancel":"",style: const TextStyle(fontFamily: 'sf-ui',color: Colors.red,fontSize: 16),),
                    ),
                  ],
                ),


              ),
              _buildSearchBar(),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Search Places",
                      style: TextStyle(
                          fontFamily: 'sf-ui',
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10,),
              _buildTourGrid(),
            ],
          ),
        );
      },
      listener: (context, state) {
        if (state is TourStateFailure) {
          // Handle failure state (e.g., show an error message)
        }
      },
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: _searchController,
        focusNode: _searchNode,
        onChanged: _onChangedText,
        onTap: (){
          if(_searchNode.hasFocus){
            setState(() {
              showCancel = true;

            });
          }
          print("-----------");
        },
        decoration: InputDecoration(
          hintText: "search",
          filled: true,
          prefixIcon: Icon(Icons.search),
          fillColor: _searchNode.hasFocus ? const Color(0xffEBEBFF) : const Color(0xfff7f7f9),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
      ),
    );
  }

  Widget _buildTourGrid() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: context.read<TourCubit>().listTours.isNotEmpty
            ? GridView.builder(
          controller: _scrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10.0,
            childAspectRatio: 3 / 4,
            mainAxisExtent: 290,
          ),
          itemCount: context.read<TourCubit>().listTours.length,
          itemBuilder: (context, index) {
            if (index >= context.read<TourCubit>().listTours.length) {
              print('Index $index out of bounds for listTours with length ${context.read<TourCubit>().listTours.length}');
              return const SizedBox.shrink(); // Safe fallback
            }
            final tour = context.read<TourCubit>().listTours[index];
            return _buildTourCard(tour);

          },
        )
            : const Center(
          child: Text("No tours found."),
        ),
      ),
    );
  }




  Widget _buildTourCard(TourModelReceive tour) {
    // Ensure the images list is not empty and handle cases where it might be null
    final images = tour.images;
    final imageUrl = (images != null && images.isNotEmpty)
        ? images[0].replaceAll("localhost", domain)
        : 'assets/img/default_image.png'; // Fallback image

    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black45, BlendMode.multiply),
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tour.tourTitle ?? "No title available",
              style: const TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                SvgPicture.asset("assets/img/locationIcon2.svg",
                    width: 15, height: 15, color: Colors.grey[400]),
                const SizedBox(width: 8),
                FutureBuilder<String>(
                  future: TourService().getCity(tour.depart?.location?.point ?? LatLng(0, 0)),
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.data ?? "Loading...",
                      style: TextStyle(fontSize: 15, color: Colors.grey[400]),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.attach_money, size: 22, color: Colors.blueAccent),
                Text(
                  tour.price?.toString() ?? "N/A",
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text("/person", style: TextStyle(color: Colors.grey[400])),
              ],
            ),
          ],
        ),
      ),
    );
  }






}

