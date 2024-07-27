import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guidanclyflutter/cubit/layout/layout_cubit.dart';
import 'package:guidanclyflutter/cubit/layout/layout_state.dart';
import 'package:guidanclyflutter/shared/constants/colors.dart';
import 'package:guidanclyflutter/shared/shared_preferences/sharedNatwork.dart';

class Home extends StatelessWidget {
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutState>(
        listener: (context, state) {
          if (state is LayoutSuccess) {}
        },
        builder: (context, state) {
          final cubit = BlocProvider.of<LayoutCubit>(context);
           if (state is LayoutSuccess) {
            return Scaffold(
              body: SafeArea(
                child: Container(
                  margin: const EdgeInsets.only(top: 100,left: 20),
                  child: Column(

                    children: [
                      Text(
                          'Hi ${state.user.firstName?.toUpperCase() ?? "No first name"} !',style: const TextStyle(fontSize: 40,fontFamily: 'sf-ui',color: Colors.black45),),

                    ],
                  ),
                ),
              ),
            );
          } else if (state is LayoutFailure) {
            return Center(
                child: Text('Failed to load user data: ${state.message}'));
          } else {return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<LayoutCubit>(context).getUserData();
                  },

                  child: Text("Load User Data"),
                ),
              ),
            );
          }

        });
  }
}
