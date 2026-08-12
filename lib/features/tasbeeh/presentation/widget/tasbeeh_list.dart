import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../logic/cubit/tasbeeh_cubit.dart';
import '../../logic/cubit/tasbeeh_state.dart';
import 'tasbeeh_item.dart';

class TasbeehList extends StatelessWidget {
  const TasbeehList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasbeehCubit, TasbeehState>(
      buildWhen: (previous, current) {
        return current is TasbeehUpdated;
      },
      builder: (context, state) {
        if (state is! TasbeehUpdated) {
          return const SizedBox();
        }
        return SizedBox(
          height: 48.h,
          child: ListView.separated(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: state.tasbeehList.length,
            separatorBuilder: (_, _) {
              return const SizedBox(width: 10);
            },
            itemBuilder: (context, index) {
              final tasbeeh = state.tasbeehList[index];
              return TasbeehItem(
                tasbeeh: tasbeeh,
                isSelected: index == state.selectedIndex,
                onTap: () {
                  context.read<TasbeehCubit>().selectTasbeeh(index);
                },
              );
            },
          ),
        );
      },
    );
  }
}
